# Cordova-Images-Injection
## Automate Splash Screens and Icons

### This script only supports android and iphone currently

### Setup

- Clone git repo
- Load file in ruby
- Follow instructions in ```test.rb```
 
### Dependencies
This script is dependent on:
```ruby
require "image_size"
require "RMagick"
include Magick
```

### What it does
The script takes an array of images with their absolute paths and checks their dimensions with a margin of error default to 2.  It then runs through a "map" of the files found in the cordova application and their dimensions and maps the correct image by size prepares by copying in a folder to the correct naming convention and then copies over the image in the android/iphone application directory.

A nice added benefit is that if the image is found to be a few pixels off, it'll resize it.  This is determined by the margin of error which is defaulted to 2px.  This fixes highly annoying exports from Illustrator (and perhaps other applications) that suggest in the software that the image (or artboard) is exactly 58x58 but then is exported to 58x57.

### If you like it use it, tweak it if you like.  I just ask that you push your changes to this repo if you do. :)

Thanks!
