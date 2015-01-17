# this file only gives example useage and required packages
require 'image_size'
require 'RMagick'
include Magick

load 'CordovaImagesInjector.rb'


# lets pretend that you only need to inject one icon and one screen
# so this is the list of images from that directory
## note - that the name of the image file does not matter,
# it looks for images based on width x height
list_of_images = [
    # these are the android images
    '/my/full/directory/droid/image-1.png',
    '/my/full/directory/droid/image-2.png',
    # these are the iphone images
    '/my/full/directory/ios/image-3.png',
    '/my/full/directory/ios/image-4.png',
]

# lets say that your root cordova project exists here:
# /usr/myprojects/cordova_project (or ionic project)

# lets also assume that cordova_project is the application name
injector = CordovaImages::Injector.new(
    :app_name => 'cordova_project',
    :root_cordova_app_dir => '/usr/myprojects/cordova_project',
    # you can also use root_dir variable
)

# inject the images into the iphone project
injector.run(list_of_images, '/the/directory/where/i/want/to/save/the/images', 'iphone')
# inject the images into the android project
injector.run(list_of_images, '/the/directory/where/i/want/to/save/the/images', 'android')

# voila! any changes to icons or screens is now automated
# just clean and build