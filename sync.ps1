New-Item -Path $env:USERPROFILE\.vimrc -ItemType SymbolicLink -Value $env:USERPROFILE\configs\nvim\.vimrc
New-Item -Path $env:USERPROFILE\AppData\Local\nvim -ItemType SymbolicLink -Value $env:USERPROFILE\configs\nvim\
