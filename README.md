Attention: This project has just born so it's not usable yet.

ActsAsAssetDispatcher
=====================

This system consists of two parts:

# AssetDispatcher
  
Given url that especifies the image and transformations and returns that image transformed

# Module acts_as_asset

This module consists on a system to store files. There are three places:

## Assets folder

This folder stores original files. All these files must be saved with a backup system so they are original files

### Assets images

Contains the original photo files

### Assets watermarks

Contains the original watermarks files

## Container folder

This folder stores transformed images this files can be removed at any time, they are cache files to speed serving transformed files

### Images container

This folder contains all image transformations served

### Watermarks folder

This folder contains all watermarks transformations served: files stored are simple images or image text files

Transformations
===============

#Available Transformations

  resize(width, height)
  crop(width, height, x, y)
  watermark(watermark_name, POSITION)
  text(text, font_options, POSITION)
  scale({:width || :height})
  
#Available POSITIONS
    
    TopCenter     == Top
    TopRight
    TopLeft
    BottomCenter  == Bottom
    BottomRight
    BottomLeft
    MiddleCenter  == Middle
    MiddleRight
    MiddleLeft

Example
=======

rails g asset::install


Copyright (c) 2010 Ricard Forniol Agustí, released under the MIT license
