# Just like the script for GAMADV-XTD3, this is not my script originally.
# It was created by Chris River (on request by Gabriel Clifton) and amended by Paul Ogier.
# That process can be seen here.
# https://groups.google.com/g/google-apps-manager/c/k2JEsdT6jcs/m/DdrLY_GcBQAJ

# I updated the script to make it possible to run the script regardless of where the user is, and also to run it automatically.
# Here's my version for GAM7.
# https://github.com/NoSubstitute/gamupdate/blob/main/updategam.ps1

# Check the version of GAM7 and update if new version exists

# This variable MUST be adjusted to match your system.
# Where is GAM7 installed?
$dir = "D:\gam7"
# Disable this line to make the script work after adjusting the $dir variable above.
Write-Host 'You must adjust the $dir variable. Then disable this line.'; Exit

# HERE BE DRAGONS!
# Do not change anything below.
# Create a new variable pointing directly to the gam binary.
$gam = "$dir\gam.exe"

# Check if there is a new version.
$version = &$gam --% version checkrc

# If the last exit code is 1, GAM7 is not up-to-date.
if ($lastexitcode -eq 1) {
  # Display a message saying that there is an update available and that it will be updated. Disable if script is to run automatically.
  Write-Host "GAM7 will be updated" -ForegroundColor Red -BackgroundColor White
  
  # Get the latest release from the GAM7 repository on GitHub.
  $releases = curl "https://api.github.com/repos/GAM-team/GAM/releases" | ConvertFrom-Json
  # Get the download URL for the latest release.
  $dlurl = ($releases[0].assets | where {$_.name -like "*windows*64.zip"}).browser_download_url
  # Download the latest release.
  (new-object System.Net.WebClient).DownloadFile($dlurl, "$dir\gam7-latest-windows-x86_64.zip")
  
  # Save the number of lines in the current change log. Disable if script is to run automatically.
  $oldchangeloglinescount=(Get-Content $dir\GamUpdate.txt | Select-String .*).count
  
  # Extract the contents of the zip file to a temporary directory.
  # The \gam7 path is included in the zip and may have to be adjusted if it's changed in the future.
  Expand-Archive "$dir\gam7-latest-windows-x86_64.zip" "$dir\" -Force
  # Move the extracted files to the current location.
  mv "$dir\gam7\*" "$dir\" -Force
  # Remove the empty temporary directory.
  rm "$dir\gam7\"
  
  # Save the number of lines in the updated change log. Disable if script is to run automatically.
  $newchangeloglinescount=(Get-Content $dir\GamUpdate.txt | Select-String .*).count
  # Get and display the new lines in the change log. Disable if script is to run automatically.
  Write-Host "Latest Changes in GGAM7" -ForegroundColor Red -BackgroundColor White
  Get-Content $dir\GamUpdate.txt -Head ($newchangeloglinescount-$oldchangeloglinescount)

  # Display a message saying that GAM7 has been updated, then pause. Disable if script is to run automatically.
  Write-Host "GAM7 has been updated" -ForegroundColor Red -BackgroundColor White
} else {
  # Display a message saying GAM7 is already up-to-date, then pause. Disable if script is to run automatically.
    Write-Host "GAM7 is already up-to-date" -ForegroundColor Green

}
# If the script is to be run automatically, disable the Pause.
# You may also consider whether to disable all Write-Host lines, as you don't need that, since nobody is going to see them.
# Nor do you need the lines getting and showing the GamUpdate.txt file.
Pause
