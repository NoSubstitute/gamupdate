# This is not my script originally. It was created by Chris River (on request by Gabriel Clifton) and amended by Paul Ogier.
# That process can be seen here.
# https://groups.google.com/g/google-apps-manager/c/k2JEsdT6jcs/m/DdrLY_GcBQAJ

# I updated the script to make it possible to run the script regardless of where the user is, and also to run it automatically.

# Check the version of GAMADV-XTD3 and update if new version exists

# This variable MUST be adjusted to match your system.
# Where is GAMADV-XTD3 installed?
$dir = "D:\gamadv-xtd3"

# HERE BE DRAGONS!
# Do not change anything below.
# Create a new variable pointing directly to the gam binary.
$gam = "$dir\gam.exe"

# Check if there is a new version.
$version = &$gam --% version checkrc

# If the last exit code is 1, GAMADV-XTD3 is not up-to-date.
if ($lastexitcode -eq 1) {
  # Display a message saying that there is an update available and that it will be updated. Disable if script is to run automatically.
  Write-Host "GAMADV-XTD3 will be updated" -ForegroundColor Red -BackgroundColor White
  # Get the latest release from the GAMADV-XTD3 repository on GitHub.
  $releases = curl "https://api.github.com/repos/taers232c/GAMADV-XTD3/releases" | ConvertFrom-Json
  # Get the download URL for the latest release.
  $dlurl = ($releases[0].assets | where {$_.name -like "*windows*64.zip"}).browser_download_url
  # Download the latest release.
  (new-object System.Net.WebClient).DownloadFile($dlurl, "$dir\gamadv-xtd3-latest-windows-x86_64.zip")
  # Save the number of lines in the current change log. Disable if script is to run automatically.
  $oldchangeloglinescount=(Get-Content $dir\GamUpdate.txt | Select-String .*).count
  # Extract the contents of the zip file to a temporary directory.
  # The \gamadv-xtd3 path is included in the zip and may have to be adjusted if Ross changes this in the future.
  Expand-Archive "$dir\gamadv-xtd3-latest-windows-x86_64.zip" "$dir\" -Force
  # Move the extracted files to the current location.
  mv "$dir\gamadv-xtd3\*" "$dir\" -Force
  # Remove the empty temporary directory.
  rm "$dir\gamadv-xtd3\"
  # Save the number of lines in the updated change log. Disable if script is to run automatically.
  $newchangeloglinescount=(Get-Content $dir\GamUpdate.txt | Select-String .*).count
  # Get and display the new lines in the change log. Disable if script is to run automatically.
  Write-Host "Latest Changes in GAMADV-XTD3" -ForegroundColor Red -BackgroundColor White
  Get-Content $dir\GamUpdate.txt -Head ($newchangeloglinescount-$oldchangeloglinescount)

  # Display a message saying that GAMADV-XTD3 has been updated, then pause.  Disable if script is to run automatically.
  Write-Host "GAMADV-XTD3 has been updated" -ForegroundColor Red -BackgroundColor White
} else {
  # Display a message saying GAMADV-XTD3 is already up-to-date, then pause.  Disable if script is to run automatically.
    Write-Host "GAMADV-XTD3 is already up-to-date" -ForegroundColor Green

}
# If the script is to be run automatically, disable the Pause.
# You may also consider whether to disable all Wite-Host lines, as you don't need that, since nobody is going to see them.
# Nor do you need lines getting and showing the GamUpdate.txt file.
Pause
