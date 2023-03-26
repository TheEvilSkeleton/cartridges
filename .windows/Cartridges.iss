#define MyAppName "Cartridges"
#define MyAppVersion "1.1"
#define MyAppPublisher "kramo"
#define MyAppURL "https://github.com/kra-mo/cartridges"
#define MyAppExeName "pythonw.exe"

[Setup]
AppId={{BC3F8D32-4BDC-4715-B149-D79F589CD7F0}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL=https://github.com/kra-mo/cartridges/issues
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
LicenseFile=..\LICENSE
PrivilegesRequiredOverridesAllowed=dialog
OutputBaseFilename=Cartridges Setup
SetupIconFile=icon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "D:\a\_temp\msys64\ucrt64\bin\cartridges"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "D:\a\_temp\msys64\ucrt64\bin\pythonw.exe"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "D:\a\_temp\msys64\ucrt64\bin\python.exe"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "D:\a\_temp\msys64\ucrt64\bin\gdbus.exe"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "D:\a\_temp\msys64\ucrt64\bin\*.dll"; DestDir: "{app}\bin"; Flags: recursesubdirs ignoreversion

Source: "D:\a\_temp\msys64\ucrt64\etc\ssl\*"; DestDir: "{app}\etc\ssl"; Flags: recursesubdirs ignoreversion

Source: "D:\a\_temp\msys64\ucrt64\lib\gdk-pixbuf-2.0\*"; DestDir: "{app}\lib\gdk-pixbuf-2.0"; Flags: recursesubdirs ignoreversion   
Source: "D:\a\_temp\msys64\ucrt64\lib\girepository-1.0\*"; DestDir: "{app}\lib\girepository-1.0"; Flags: recursesubdirs ignoreversion 
Source: "D:\a\_temp\msys64\ucrt64\lib\python3.10\*"; DestDir: "{app}\lib\python3.10"; Excludes: "__pycache__"; Flags: recursesubdirs ignoreversion

Source: "D:\a\_temp\msys64\ucrt64\share\cartridges\*"; DestDir: "{app}\share\cartridges"; Excludes: "__pycache__"; Flags: recursesubdirs ignoreversion
Source: "D:\a\_temp\msys64\ucrt64\share\icons\*"; DestDir: "{app}\share\icons"; Excludes: "cursors\*"; Flags: recursesubdirs ignoreversion
Source: "D:\a\_temp\msys64\ucrt64\share\glib-2.0\*"; DestDir: "{app}\share\glib-2.0"; Flags: recursesubdirs ignoreversion
Source: "D:\a\_temp\msys64\ucrt64\share\gtk-4.0\*"; DestDir: "{app}\share\gtk-4.0"; Flags: recursesubdirs ignoreversion

Source: "icon.ico"; DestDir: "{app}"; Flags: recursesubdirs ignoreversion

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\bin\{#MyAppExeName}"; Parameters: """{app}\bin\cartridges"""; IconFilename: "{app}\icon.ico"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\bin\{#MyAppExeName}"; Parameters: """{app}\bin\cartridges"""; IconFilename: "{app}\icon.ico"; Tasks: desktopicon

[Run]
Filename: "{app}\bin\{#MyAppExeName}"; Parameters: """{app}\bin\cartridges"""; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall
