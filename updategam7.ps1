# Just like the script for GAMADV-XTD3, this is not my script originally.
# It was created by Chris River (on request by Gabriel Clifton) and amended by Paul Ogier.
# That process can be seen here.
# https://groups.google.com/g/google-apps-manager/c/k2JEsdT6jcs/m/DdrLY_GcBQAJ

# I updated the script to make it possible to run the script regardless of where the user is, and also to run it automatically.
# This script does no longer need to be run as an administrator. I'm not sure why. :-)

# Check the version of GAM7 and update if new version exists
## There's now an ARM version for Windows, so code needed one more variable.

# Set this to $false if you do not want to see the change log output
$ShowChangeLog = $true

# If GAM's installation location cannot be automatically located, then this variable MUST be adjusted to match your system.
# Where is GAM7 installed?
$dir = ""

# Try to automatically find the install location for GAM
Write-Progress -Activity "GAM Update" -Status "Getting the install location for GAM"
Write-Host "Getting the install location for GAM" -ForegroundColor Green

$gamInstall = Get-Command gam -ErrorAction SilentlyContinue
if (-not $gamInstall -or -not $gamInstall.Source) {
  if ($dir -and -not (Test-Path $dir -PathType Container)) {
    throw "$dir not found or is not a valid folder path. Edit this script located at $PSCommandPath to manually set the `$dir variable value to an existing folder path"
  }
  elseif (-not $dir) {
    throw "Unable to automatically locate GAM installation location. Manually (re)install GAM, or edit this script located at $PSCommandPath to manually set the `$dir variable value"
  }
}
else {
  $dir = Split-Path $gamInstall.Source -Parent
}

# Automatically determine which Windows architecture version to download
# If no architecture version is found, uncomment and adjust $winversion accordingly
#$winversion = "windows-x86_64.zip"

# Also, if the auto-detect fails, you need to comment this entire section

# from here...
# Try to get the RuntimeInformation type
Write-Progress -Activity "GAM Update" -Status "Getting the CPU/OS Architecture of your system"
Write-Host "Getting the CPU/OS Architecture of your system" -ForegroundColor Green

$runtimeInfoType = [Type]::GetType('System.Runtime.InteropServices.RuntimeInformation')
if ($runtimeInfoType) {
  # PowerShell Core (.NET Core)
  $architecture = $runtimeInfoType::OSArchitecture.ToString()
  # Write-Output "PS Core $architecture"
}
else {
  # Windows PowerShell (.NET Framework)
  $architecture = $env:PROCESSOR_ARCHITECTURE
  # Write-Output "ENV $architecture"
}

Write-Progress -Activity "GAM Update" -Status "Detected CPU/OS Architecture: $architecture"
Write-Host "Detected CPU/OS Architecture: $architecture"

# Map architecture to download file
$winversion = switch ($architecture.ToUpper()) {
  "X64" { "windows-x86_64.zip" }
  "AMD64" { "windows-x86_64.zip" }
  "X86" { "windows-x86_64.zip" }
  "ARM" { "windows-arm64.zip" }
  "ARM64" { "windows-arm64.zip" }
  Default { throw "Unknown Windows architecture. Please set `$winversion manually." }
}
# ...to here.

# HERE BE DRAGONS!
# Do not change anything below.
# Create a new variable pointing directly to the gam binary.
$gam = $gamInstall.Source
Write-Host "I found gam here $gam with the following information."

# Print currently installed version.
$currentversion = & $gam --% version
Write-Progress -Activity "GAM Update" -Status "Current version: $currentversion"
Write-Host "$currentversion" -ForegroundColor Blue -BackgroundColor White

# Check if there is a new version.
$version = &$gam --% version checkrc

# If the last exit code is 1, GAM7 is not up-to-date.
if ($lastexitcode -eq 1) {
  
  # Get the latest release from the GAM7 repository on GitHub.
  $releases = curl "https://api.github.com/repos/GAM-team/GAM/releases" | ConvertFrom-Json
  $release = $releases[0].assets | where { $_.name -like "*$winversion" }
  if ( -not ($release).tag_name  ) { $latest = ($release).name } else { $latest = ($release).tag_name }  
  $latest = ($latest + " " + ($release).updated_at).Replace("-$winversion", "")
  
  # Display a message saying that there is an update available and that it will be updated. Disable if script is to run automatically.
  Write-Progress -Activity "GAM Update" -Status "Preparing download of $latest"
  Write-Host "GAM7 will be updated to $latest" -ForegroundColor Green
  
  # Get the download URL for the latest release.
  $dlurl = ($release).browser_download_url
  
  # Download the latest release.
  Write-Progress -Activity "GAM Update" -Status "Downloading $latest" -PercentComplete 0
  (New-Object System.Net.WebClient).DownloadFile($dlurl, "$dir\gam7-latest-$winversion")
    Write-Progress -Activity "GAM Update" -Status "Download complete" -PercentComplete 100 
  Write-Host "Downloaded this file $dlurl"
 
  # Save the number of lines in the current change log. Disable if script is to run automatically.
  $oldchangeloglinescount = (Get-Content $dir\GamUpdate.txt | Select-String .*).count
  
  # Extract the contents of the zip file to a temporary directory.
  Write-Progress -Activity "GAM Update" -Status "Unpacking $dir\gam7-latest-$winversion" -PercentComplete 0
  Expand-Archive "$dir\gam7-latest-$winversion" "$dir\" -Force
  
  # Copy the extracted files to the current location.
  # The \gam7 path is included in the zip and may have to be adjusted if it's changed in the future.
  Copy-Item "$dir\gam7\*" "$dir\" -Force -Recurse
  Write-Progress -Activity "GAM Update" -Status "Unpacking completed" -PercentComplete 100

  # Clean up
  Write-Progress -Activity "GAM Update" -Status "Removing temporary files" -PercentComplete 0
  # Remove the temporary directory.
  rm "$dir\gam7" -Force -Recurse
  # Remove the downloaded zip.
  rm "$dir\gam7-latest-$winversion"
  # Clean up completed
  Write-Progress -Activity "GAM Update" -Status "Cleanup completed" -PercentComplete 0
  
  if ($ShowChangeLog -eq $true) {
    # Save the number of lines in the updated change log.
    $newchangeloglinescount = (Get-Content $dir\GamUpdate.txt | Select-String .*).count
    # Get and display the new lines in the change log.
    Write-Host "Latest Changes in GAM7" -ForegroundColor Blue -BackgroundColor White
    Get-Content $dir\GamUpdate.txt -Head ($newchangeloglinescount - $oldchangeloglinescount)
  }

  # Display a message saying that GAM7 has been updated, then pause. Disable if script is to run automatically.
  Write-Host "GAM7 has been updated to $latest" -ForegroundColor Green -BackgroundColor White
}
else {
  # Display a message saying GAM7 is already up-to-date, then pause. Disable if script is to run automatically.
  Write-Host "GAM7 is already up-to-date" -ForegroundColor Green

}
# If the script is to be run automatically, disable the Pause.
# You may also consider whether to disable all Write-Host lines, as you don't need that, since nobody is going to see them.
# Nor do you need the lines getting and showing the GamUpdate.txt file.
Pause
