# gamupdate
Scripts to update GAM7 & GAMADV-XTD3 if there is an update available, and also show what's new.

## For Linux and macOS. Separate scripts for GAM7 & GAMADV-XTD3!
### [update](https://github.com/NoSubstitute/gamupdate/blob/main/update), update GAMADV-XTD3
### [update7](https://github.com/NoSubstitute/gamupdate/blob/main/update7), update GAM7
Simply put the _update7_ in ~/bin and make it executeable with `chmod +x ~/bin/update7` (with or without the 7) after adjusting the GAMDIR path variable on line 10.

Then you can run the update command whenever you want to initiate an update check, and if there is an update, it will be downloaded, unpacked, and the list of updates will be presented to you using _more_. Press q to exit _more_.

## For Windows 10/11. Separate scripts for GAM7 & GAMADV-XTD3!
### update-gam, Broken, and I don't know why. Don't use.
### [updategam.ps1](https://github.com/NoSubstitute/gamupdate/blob/main/updategam.ps1), update GAMADV-XTD3 on Windows
### [updategam7.ps1](https://github.com/NoSubstitute/gamupdate/blob/main/updategam7.ps1), update GAM7 on Windows
Simply put either of the scripts somewhere in your [Windows PATH](https://www.computerhope.com/issues/ch000549.htm).

Edit the script and adjust the $dir variable to match where you have gam on your system.

Then you can run the update command (updategam/updategam7) whenever you want to initiate an update check, and if there is an update, it will be downloaded, unpacked, and the list of updates will be presented to you.

## Need more information?
Oh, you read all of this. Good, that means that you know that you have to read _all_ instructions before trying to use new tools. Same with reading the contents of the actual scripts. They usually contain more detailed instructions.

If that fails, please, submit your question as an issue here on github, and I'll get back to you asap. Thanks for helping me improve.
