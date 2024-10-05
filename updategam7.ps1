# Check the version of GAM7 and update if new version exists
# Where is GAM7 installed? This needs to be set up here, as it may be different for different users.
$dir = "D:\gam7"

# Create a new variable pointing directly to the gam binary.
$gam = "$dir\gam"

# This seems to give the same exit code 1 regardless of what the current version is.
#$version = "$gam version checkrc"

# Using a hard-coded path works, but then there are two variables that needs to be adjusted.
$version = d:\gam7\gam version checkrc

# If the last exit code is 1, GAM7 is not up-to-date
if ($lastexitcode -eq 1) {
  # Display a message saying that there is an update available and that it will be updates. 
  Write-Host "GAM7 will be updated" -ForegroundColor Red -BackgroundColor White
  # Get the latest release from the GAM7 repository on GitHub
  $releases = curl "https://api.github.com/repos/GAM-team/GAM/releases" | ConvertFrom-Json
  # Get the download URL for the latest release
  $dlurl = ($releases[0].assets | where {$_.name -like "*windows*64.zip"}).browser_download_url
  ## Get the current location
  ## Can't be used if script is to be run automatically, nor if the user isn't inside the actual gam7 dir, which shouldn't be a requirement.
  #$dir = (Get-Location).Path
  # Download the latest release
  (new-object System.Net.WebClient).DownloadFile($dlurl, "$dir\gam7-latest-windows-x86_64.zip")
  # Save the number of lines in the change log
  $oldchangeloglinescount=(Get-Content $dir\GamUpdate.txt | Select-String .*).count
  # Extract the contents of the zip file
  Expand-Archive "$dir\gam7-latest-windows-x86_64.zip" "$dir\" -Force
  # Move the extracted files to the current location
  mv "$dir\gam7\*" "$dir\" -Force
  # Remove the empty gam7 directory
  rm "$dir\gam7\"
  # Save the number of lines in the updated change log
  $newchangeloglinescount=(Get-Content $dir\GamUpdate.txt | Select-String .*).count
  # Get the new lines in the change log
  Write-Host "Latest Changes in GAM7" -ForegroundColor Red -BackgroundColor White
  Get-Content $dir\GamUpdate.txt -Head ($newchangeloglinescount-$oldchangeloglinescount)

  # Display a message saying that it has been updated. 
  Write-Host "GAM7 has been updated" -ForegroundColor Red -BackgroundColor White
} else {
  # GAM is already up-to-date
    Write-Host "GAM7 is already up-to-date" -ForegroundColor Green

}

Pause
