# This is not my script. It was created by Chris River (on request by Gabriel Clifton) and amended by Paul Ogier.
# That process can be seen here.
# https://groups.google.com/g/google-apps-manager/c/k2JEsdT6jcs/m/DdrLY_GcBQAJ

# Do note that the user has to be in the gamadv-xtd3 directory when running the script, or else the script will not work.
# Yes, this should totally be adjusted, to make it possible to run the script regardless of where the user is, and also to run it automatically.

# Check the version of GAMADV-XTD3 and update if new version exists
$version = gam version checkrc

# If the last exit code is 1, GAMADV-XTD3 is not up-to-date
if ($lastexitcode -eq 1) {
  # Display a message saying that there is an update available and that it will be updates. 
  Write-Host "GAMADV-XTD3 will be updated" -ForegroundColor Red -BackgroundColor White
  # Get the latest release from the GAMADV-XTD3 repository on GitHub
  $releases = curl "https://api.github.com/repos/taers232c/GAMADV-XTD3/releases" | ConvertFrom-Json
  # Get the download URL for the latest release
  $dlurl = ($releases[0].assets | where {$_.name -like "*windows*64.zip"}).browser_download_url
  # Get the current location
  $dir = (Get-Location).Path
  # Download the latest release
  (new-object System.Net.WebClient).DownloadFile($dlurl, "$dir\gamadv-xtd3-latest-windows-x86_64.zip")
  # Save the number of lines in the change log
  $oldchangeloglinescount=(Get-Content $dir\GamUpdate.txt | Select-String .*).count
  # Extract the contents of the zip file
  Expand-Archive "$dir\gamadv-xtd3-latest-windows-x86_64.zip" "$dir\" -Force
  # Move the extracted files to the current location
  mv "$dir\gamadv-xtd3\*" "$dir\" -Force
  # Remove the empty gamadv-xtd3 directory
  rm "$dir\gamadv-xtd3\"
  # Save the number of lines in the updated change log
  $newchangeloglinescount=(Get-Content $dir\GamUpdate.txt | Select-String .*).count
  # Get the new lines in the change log
  Write-Host "Latest Changes in GAMADV-XTD3" -ForegroundColor Red -BackgroundColor White
  Get-Content $dir\GamUpdate.txt -Head ($newchangeloglinescount-$oldchangeloglinescount)

  # Display a message saying that it has been updated. 
  Write-Host "GAMADV-XTD3 has been updated" -ForegroundColor Red -BackgroundColor White
} else {
  # GAM is already up-to-date
    Write-Host "GAMADV-XTD3 is already up-to-date" -ForegroundColor Green

}

Pause
