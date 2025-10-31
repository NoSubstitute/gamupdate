# Just like the script for GAMADV-XTD3, this is not my script originally.
# It was created by Chris River (on request by Gabriel Clifton) and amended by Paul Ogier.
# That process can be seen here.
# https://groups.google.com/g/google-apps-manager/c/k2JEsdT6jcs/m/DdrLY_GcBQAJ

# I updated the script to make it possible to run the script regardless of where the user is, and also to run it automatically.
# This script must be run as an administrator

# Check the version of GAM7 and update if new version exists
## There's now an ARM version for Windows, so code needed one more variable.

# Set this to $false if you do not want to see the change log output
$ShowChangeLog = $true

# If GAM's installation location cannot be automatically located, then this variable MUST be adjusted to match your system.
# Where is GAM7 installed?
$dir = Get-Location

# Try to chex location for GAM in current dir
$filePath = "$dir\gam.exe"
if (Test-Path -Path $filePath -PathType Leaf) {
    Write-Host "Gam located in currentndir" -ForegroundColor Green
    $gam = Get-Command $filePath -ErrorAction SilentlyContinue
} else {
    # Try to automatically find the install location for GAM
    Write-Host "Getting the install location for GAM " -ForegroundColor Green
    $gam = Get-Command gam -ErrorAction SilentlyContinue
}

if (-not $gam -or -not $gam.Source) {
  if ($dir -and -not (Test-Path $dir -PathType Container)) {
    throw "$dir not found or is not a valid folder path. Edit this script located at $PSCommandPath to manually set the `$dir variable value to an existing folder path"
  } elseif (-not $dir) {
    throw "Unable to automatically locate GAM installation location. Manually (re)install GAM, or edit this script located at $PSCommandPath to manually set the `$dir variable value"
  }
} else {
  $dir = Split-Path $gam.Source -Parent
}

# Automatically determine which Windows architecture version to download
$architecture = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture
$winversion = switch ($architecture) {
    "X64"  { "windows-x86_64.zip" }
    "X86"  { "windows-x86_64.zip" }
    "Arm"  { "windows-arm64.zip" }
    "Arm64" { "windows-arm64.zip" }
    Default { throw "Unknown Windows architecture. You may need to manually specify the `$winversion variable in $PSCommandPath" }
}

# HERE BE DRAGONS!
# Do not change anything below.
# Create a new variable pointing directly to the gam binary.
$gam = "$dir\gam.exe"

# Check if there is a new version.
$version = &$gam --% version checkrc

# If the last exit code is 1, GAM7 is not up-to-date.
if ($lastexitcode -eq 1) {
  # Display a message saying that there is an update available and that it will be updated. Disable if script is to run automatically.
  Write-Host "GAM7 will be updated to $latest" -ForegroundColor Red -BackgroundColor White
 
  # Get the latest release from the GAM7 repository on GitHub.
  $releases = curl "https://api.github.com/repos/GAM-team/GAM/releases" | ConvertFrom-Json
  $release = $releases[0].assets | where {$_.name -like "*$winversion"}

  # Get the download URL for the latest release.
  $dlurl = ($release).browser_download_url

  if ( -not ($release).tag_name  ) { $latest = ($release).name } else { $latest = ($release).tag_name }  

  $latest = ($latest  +" " + ($release).updated_at).Replace("-$winversion","")
  # Download the latest release.
  (New-Object System.Net.WebClient).DownloadFile($dlurl, "$dir\gam7-latest-$winversion")
 
    # Save the number of lines in the current change log. Disable if script is to run automatically.
  $oldchangeloglinescount=(Get-Content $dir\GamUpdate.txt | Select-String .*).count
 
  # Extract the contents of the zip file to a temporary directory.
  # The \gam7 path is included in the zip and may have to be adjusted if it's changed in the future.
  Expand-Archive "$dir\gam7-latest-$winversion" "$dir\" -Force
  
  # Copy the extracted files to the current location.
  Copy-Item "$dir\gam7\*" "$dir\" -Force -Recurse
  
  # Remove the temporary directory.
  rm "$dir\gam7" -Force -Recurse
 
  if ($ShowChangeLog -eq $true) {
    # Save the number of lines in the updated change log.
    $newchangeloglinescount=(Get-Content $dir\GamUpdate.txt | Select-String .*).count
  
    # Get and display the new lines in the change log.
    Write-Host "Latest Changes in GAM7" -ForegroundColor Red -BackgroundColor White
    Get-Content $dir\GamUpdate.txt -Head ($newchangeloglinescount-$oldchangeloglinescount)
  }

  # Display a message saying that GAM7 has been updated, then pause. Disable if script is to run automatically.
  Write-Host "GAM7 has been updated" -ForegroundColor Blue -BackgroundColor White
  (Write-output  $version  )| Write-Host  -ForegroundColor Blue -BackgroundColor White

} else {
  # Display a message saying GAM7 is already up-to-date, then pause. Disable if script is to run automatically.
  Write-Host "GAM7 is already up-to-date" -ForegroundColor Green
  (Write-output  $version  )| Write-Host  -ForegroundColor Green

}

# If the script is to be run automatically, disable the Pause.
# You may also consider whether to disable all Write-Host lines, as you don't need that, since nobody is going to see them.
# Nor do you need the lines getting and showing the GamUpdate.txt file.
Pause 
