# AlfredLibraryInHaskell

This is a Haskell library for creating Alfred workflows. The library has the following functions:

**addItem**

This adds an item to the xml list for a script filter. This function expects all of the script filter items to be defined. EX: addItem uid arg valid autocomplete title subtitle icon.

**addItemBasic**

This calls the **adItem** with the valid set to yes, and icon set to icon.png.

**getBundleID**

This gets the Alfred Bundle ID form the workflow.

**getAlfredDataFileContents**

This function returns the contents of the named file in the Alfred data directory for the workflow.

**putAlfredDataFileContents**

This function expects a file name and a string. The string is written to the file name in the Alfred data directory.

**getAlfredCacheFileContents**

This function expects a file name and a string. The string is written to the file name in the Alfred cache directory.

**putAlfredCacheFileContents**

This function expects a file name and a string. The string is written to the file name in the Alfred cache directory.

 
This repository also has the cases.hs Haskell program for creating the Haskell Case Converter workflow for Alfred. It gives a good example of using this library.

For more code, please visit my web site at [Custom Computer Tools](http://customct.com).
