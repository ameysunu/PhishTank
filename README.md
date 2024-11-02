## PhishTank

### Running the DMG from Release
Since CODE SIGNING is set to No on the Github Release Action while generating the Xcodebuild, you would have to run a tiny step after extracting the app from the DMG.
On terminal run the command as below:

```
xattr -rd com.apple.quarantine /path/to/PhishTank.app
```
