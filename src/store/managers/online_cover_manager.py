import logging
from pathlib import Path

import requests
from gi.repository import Gio, GdkPixbuf
from requests.exceptions import HTTPError, SSLError
from PIL import Image

from src import shared
from src.game import Game
from src.store.managers.local_cover_manager import LocalCoverManager
from src.store.managers.manager import Manager
from src.utils.save_cover import resize_cover, save_cover


class OnlineCoverManager(Manager):
    """Manager that downloads game covers from URLs"""

    run_after = (LocalCoverManager,)
    retryable_on = (HTTPError, SSLError)

    def save_composited_cover(
        self,
        game: Game,
        image_file: Gio.File,
        original_width: int,
        original_height: int,
        target_width: int,
        target_height: int,
    ) -> None:
        """Save the image composited with a background blur to fit the cover size"""

        logging.debug(
            "Compositing image for %s (%s) %dx%d -> %dx%d",
            game.name,
            game.game_id,
            original_width,
            original_height,
            target_width,
            target_height,
        )

        # Load game image
        image = GdkPixbuf.Pixbuf.new_from_stream(image_file.read())

        # Create background blur of the size of the cover
        cover = image.scale_simple(2, 2, GdkPixbuf.InterpType.BILINEAR).scale_simple(
            target_width, target_height, GdkPixbuf.InterpType.BILINEAR
        )

        # Center the image above the blurred background
        scale = min(target_width / original_width, target_height / original_height)
        left_padding = (target_width - original_width * scale) / 2
        top_padding = (target_height - original_height * scale) / 2
        image.composite(
            cover,
            # Top left of overwritten area on the destination
            left_padding,
            top_padding,
            # Size of the overwritten area on the destination
            original_width * scale,
            original_height * scale,
            # Offset
            left_padding,
            top_padding,
            # Scale to apply to the resized image
            scale,
            scale,
            # Compositing stuff
            GdkPixbuf.InterpType.BILINEAR,
            255,
        )

        # Resize and save the cover
        save_cover(game.game_id, resize_cover(pixbuf=cover))

    def manager_logic(self, game: Game, additional_data: dict) -> None:
        # Ensure that we have a cover to download
        cover_url = additional_data.get("online_cover_url")
        if not cover_url:
            return

        # Download cover
        image_file = Gio.File.new_tmp()[0]
        image_path = Path(image_file.get_path())
        with requests.get(cover_url, timeout=5) as cover:
            cover.raise_for_status()
            image_path.write_bytes(cover.content)

        # Get image size
        cover_width, cover_height = shared.image_size
        with Image.open(image_path) as pil_image:
            width, height = pil_image.size

        # Composite the image if its aspect ratio differs too much
        # (allow the side that is smaller to be stretched by a small percentage)
        max_diff_proportion = 0.12
        scale = min(cover_width / width, cover_height / height)
        width_diff = (cover_width - (width * scale)) / cover_width
        height_diff = (cover_height - (height * scale)) / cover_height
        diff = width_diff + height_diff
        if diff < max_diff_proportion:
            save_cover(game.game_id, resize_cover(image_path))
        else:
            self.save_composited_cover(
                game, image_file, width, height, cover_width, cover_height
            )
