#include "exiv2.hpp"

void GetExifRecord(Dart_NativeArguments arguments) {
    Dart_EnterScope();
    
    const char *filename;
    const char *tag;
    Dart_StringToCString(
        Dart_GetNativeArgument(arguments, 0), &filename);
    Dart_StringToCString(
        Dart_GetNativeArgument(arguments, 1), &tag);

    Exiv2::Image::AutoPtr image =
        Exiv2::ImageFactory::open(filename);
    image->readMetadata();
    Exiv2::ExifData &exifData = image->exifData();
    Exiv2::ExifKey key = Exiv2::ExifKey(tag);
    Exiv2::ExifData::const_iterator pos = exifData.findKey(key);
    
    Dart_Handle result;
    
    if (pos == exifData.end()) { // not found
        result = Dart_Null();
    } else {
        result = Dart_NewStringFromCString(
            pos->value().toString().c_str());
    }
    
    Dart_SetReturnValue(arguments, result);
    Dart_ExitScope();
}

void GetAllExifRecords(Dart_NativeArguments args) {
    Dart_EnterScope();
    
    const char *fname;
    Dart_StringToCString(Dart_GetNativeArgument(args, 0), &fname);
        
    Exiv2::Image::AutoPtr image =
        Exiv2::ImageFactory::open(fname);
    image->readMetadata();
    Exiv2::ExifData &exifData = image->exifData();
    Exiv2::ExifData::const_iterator end = exifData.end();
    Exiv2::ExifData::const_iterator pointer = exifData.begin();
    
    Dart_Handle result = Dart_NewList(exifData.count());
    // Iterate all EXIF records.
    for (int j = 0; pointer != end; ++pointer, j++) {
        // Create \t delimetered char*.
        std::stringstream fmt;
        fmt << pointer->key() << "\t" << pointer->value();
        const char *record = fmt.str().c_str();
        Dart_ListSetAt(result, j,
            Dart_NewStringFromCString(record));
    }
    
    Dart_SetReturnValue(args, result);
    Dart_ExitScope();
}

