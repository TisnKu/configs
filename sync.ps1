$configs = @{
  "configs\nvim\vimrc" = ".vimrc"
  "configs\nvim\" = "AppData\Local\nvim"
  "configs\wezterm.lua" = ".wezterm.lua"
}

foreach ($config in $configs.GetEnumerator()) {
  $source = Join-Path -Path $env:USERPROFILE -ChildPath $config.Key
  $destination = Join-Path -Path $env:USERPROFILE -ChildPath $config.Value
  New-Item -Path $destination -ItemType SymbolicLink -Value $source -Force
}