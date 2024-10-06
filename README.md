# gamupdate
Scripts to update GAM7 & GAMADV-XTD3 if there is an update available, and also show what's new.

## For Linux and macOS. Script only for GAMADV-XTD3!
Simply just put the _update_ file in ~/bin and `chmod +x ~/bin/update` after adjusting the GAM path variable on line 10.

Then you can run the command 'update' whenever you want to initiate an update check, and if there is an update, it will be downloaded, unpacked, and the list of updates will be presented to you using _more_. Press q to exit _more_.

## For Windows 10/11. Scripts for both GAM7 & GAMADV-XTD3!
Simply put either of the scripts _updategam.ps1_, _updategam7.ps1_ or _update-gam.bat_ (currently broken) somewhere in your [Windows PATH](https://www.computerhope.com/issues/ch000549.htm).

Edit the script and adjust the $dir variable to match where you have gam on your system.

Then you can run the update command (updategam/updategam7) whenever you want to initiate an update check, and if there is an update, it will be downloaded, unpacked, and the list of updates will be presented to you.

## Need more information?
Oh, you read all of this. Good, that means that you know that you have to read _all_ instructions before trying to use new tools. Same with reading the contents of the actual scripts. They usually contain more detailed instructions.

If that fails, please, submit your question as an issue here on github, and I'll get back to you asap. Thanks for helping me improve.
