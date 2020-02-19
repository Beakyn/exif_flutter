cmake_minimum_required(VERSION 3.4.1)  # for example

add_library( native_add

             # Sets the library as a shared library.
             SHARED

             # Provides a relative path to your source file(s).
             ../ios/Classes/native_add.cpp )

add_library( exiv2
             SHARED
             IMPORTED )

set_target_properties( # Specifies the target library.
                       exiv2

                       # Specifies the parameter you want to define.
                       PROPERTIES IMPORTED_LOCATION

                       # Provides the path to the library you want to import.
                       ~/Downloads/exiv2-0.27.2-Linux64/lib/libexiv2.so )

include_directories( ~/Downloads/exiv2-0.27.2-Linux64/include/ )
