cmake_minimum_required(VERSION 3.4.1)  # for example

add_library( native_add

             # Sets the library as a shared library.
             SHARED

             # Provides a relative path to your source file(s).
             ../ios/Classes/native_add.cpp )

add_library( libexif
            SHARED
            IMPORTED )

set_target_properties( # Specifies the target library.
                       libexif

                       # Specifies the parameter you want to define.
                       PROPERTIES IMPORTED_LOCATION

                       # Provides the path to the library you want to import.
                       /home/kewersonhugo/Develop/beakyn/exif/ios/Classes/libexif/lib/libexif.so.12 )

include_directories( /home/kewersonhugo/Develop/beakyn/exif/ios/Classes/libexif/ )
