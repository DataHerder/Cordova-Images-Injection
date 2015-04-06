module CordovaImages

    class Injector

        def initialize(options_data)

            # initialize the options available, app_name and root_dir
            if options_data.is_a?(Hash)
                root_dir = if options_data.has_key?(:root_dir)
                               options_data[:root_dir]
                           else
                               if options_data.has_key?(:root_cordova_app_dir)
                                   options_data[:root_cordova_app_dir]
                               else
                                   raise Exception, 'Expecting root_dir or root_cordova_app_dir'
                               end
                           end
                # app_name can be omitted, be careful though that you haven't renamed your xcode project
                # for some reason or another
                app_name = options_data.has_key?(:app_name) ? options_data[:app_name] :
                    #raise Exception, 'Expecting application name "app_name".  This is the name of the xcode project.'
                    options_data[:root_cordova_app_dir].split(/\//).pop
                error_margin = options_data.has_key?(:error_margin) ? options_data[:error_margin] : 2
            else
                raise Exception, 'Expecting app_name and root_cordova_app_dir (or root_dir) as Hash'
            end


            # set the instance variables to the app and root dir
            @dir = set_map_with_app_name(app_name)
            @loc = root_dir
            @error_margin = error_margin

            # the map to the splash and icon screens
            @map = {
                :iphone => {
                    :splash => {
                        # these are the default screen names and their dimensions
                        # new landscapes here
                        :'Default-Landscape-736h.png' => [2208, 1242],
                        :'Default-736h.png' => [1242,2208],
                        :'Default-667h.png' => [750,1334],
                        # end new
                        :'Default~iphone.png' => [320,480],
                        :'Default@2x~iphone.png' => [640,960],
                        :'Default-Portrait~ipad.png' => [768,1024],
                        :'Default-Portrait@2x~ipad.png' => [1536,2048],
                        :'Default-Landscape~ipad.png' => [1024,768],
                        :'Default-Landscape@2x~ipad.png' => [2048,1536],
                        :'Default-568h@2x~iphone.png' => [640,1136],
                    },
                    :icons => {
                        # default icon names and dimensions
                        :'icon.png' => [57,57],
                        :'icon@2x.png' => [114,114],
                        :'icon-40.png' => [40,40],
                        :'icon-40@2x.png' => [80,80],
                        :'icon-50.png' => [50,50],
                        :'icon-50@2x.png' => [100,100],
                        :'icon-60.png' => [60,60],
                        # new icon
                        :'icon-60@3x.png' => [180,180],
                        # end new icon
                        :'icon-60@2x.png' => [120,120],
                        :'icon-72.png' => [72,72],
                        :'icon-72@2x.png' => [144,144],
                        :'icon-76.png' => [76,76],
                        :'icon-76@2x.png' => [152,152],
                        :'icon-small.png' => [29,29],
                        :'icon-small@2x.png' => [58,58],
                    }
                },

                :android => {
                    :all => {
                        :'drawable/icon.png' => [96,96],
                        :'drawable-ldpi/icon.png' => [36,36],
                        :'drawable-mdpi/icon.png' => [48,48],
                        :'drawable-hdpi/icon.png' => [72,72],
                        :'drawable-xhdpi/icon.png' => [96,96],

                        :'drawable-land-ldpi/screen.png' => [320,200],
                        :'drawable-land-mdpi/screen.png' => [480,320],
                        :'drawable-land-hdpi/screen.png' => [800,480],
                        :'drawable-land-xhdpi/screen.png' => [1280,720],

                        :'drawable-port-ldpi/screen.png' => [200,320],
                        :'drawable-port-mdpi/screen.png' => [320,480],
                        :'drawable-port-hdpi/screen.png' => [480,800],
                        :'drawable-port-xhdpi/screen.png' => [720,1280],
                    },
                }
            }
        end

        # able to change the platform of ios for multiple projects
        private def dir_map
            _dir = {
                :iphone => {
                    :icons  => "platforms/ios/{{app_name}}/Resources/icons",
                    :splash => "platforms/ios/{{app_name}}/Resources/splash",
                },
                :android => {
                    :all => 'platforms/android/res'
                }
            }

            _dir
        end

        # inject the app name into the dir_map
        private def set_map_with_app_name(app_name)
            map = dir_map
            map[:iphone][:icons] = map[:iphone][:icons].gsub(/\{\{app_name\}\}/, app_name)
            map[:iphone][:splash] = map[:iphone][:splash].gsub(/\{\{app_name\}\}/, app_name)
            map
        end


        def changeLocation(folder_location)
            @loc = folder_location
            self
        end


        def changeAppName(app_name)
            @app_name = app_name
            set_map_with_app_name(app_name)
        end


        def run(images, dir, phone_type)


            if !File.directory?(dir + '/prepared')
                FileUtils.mkdir_p(dir + '/prepared')
            end


            @map[phone_type].each do |img_type|

                application_image_loc = @loc.gsub(/\/$/, '') + '/' + @dir[phone_type][img_type[0]]

                img_type[1].each do |img_dim|

                    images.each do |image_|

                        if File.directory?(image_)
                            next
                        end
                        image = Magick::Image.read(image_).first
                        width = image.columns
                        height = image.rows


                        img_width, img_height = img_dim[1]

                        file_name = img_dim[0].to_s.gsub(/\//, '-')
                        write_name = img_dim[0].to_s

                        width_diff = height - img_height
                        height_diff = width - img_width

                        write_file = dir + '/prepared/' + phone_type.to_s + '/' + file_name;
                        write_dest = application_image_loc + '/' + write_name

                        # leave an error of 2
                        if width_diff.abs <= @error_margin && height_diff.abs <= @error_margin

                            img = ImageList.new(image_)
                            nimg = img.resize_to_fill(img_width, img_height)
                            FileUtils.mkdir_p(File.dirname(write_file))
                            nimg.write(write_file)
                            FileUtils.cp(write_file, write_dest)
                            break

                        elsif width == img_width && height == img_height

                            img = ImageList.new(image_)
                            nimg = img.copy
                            FileUtils.mkdir_p(File.dirname(write_file))
                            nimg.write(write_file)
                            FileUtils.cp(write_file, write_dest)
                            break

                        end
                    end
                end
            end

            self
        end
    end
end
