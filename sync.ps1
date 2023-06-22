New-Item -Path $env:USERPROFILE\.vimrc -ItemType SymbolicLink -Value $env:USERPROFILE\configs\nvim\vimrc
New-Item -Path $env:USERPROFILE\AppData\Local\nvim -ItemType SymbolicLink -Value $env:USERPROFILE\configs\nvim\
New-Item -Path $env:USERPROFILE\.wezterm.lua -ItemType SymbolicLink -Value $env:USERPROFILE\configs\wezterm.lua
New-Item -Path "$env:AppData\Microsoft\Windows\Start Menu\Programs\Startup\appLaunchers.ahk" -ItemType HardLink -Value $env:USERPROFILE\Scripts\ahk\appLaunchers.ahk