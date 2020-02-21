<<<<<<< HEAD
=======
// #include "exiv2/exiv2.hpp"
#include "libexif/exif-data.h"
#include "libexif/exif-ifd.h"
>>>>>>> 91ae2a9dfad0009f8946dceaf489383445b8f5bb
#include <stdint.h>
#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <string.h>

extern "C" __attribute__((visibility("default"))) __attribute__((used)) char *native_add(char *filepath)
{
    return (char *)"hello world";
}