// #include "exiv2/exiv2.hpp"
#include <libexif/exif-data.h>
#include <stdint.h>
#include <stdio.h>

/* Remove spaces on the right of the string */
static void trim_spaces(char *buf)
{
    char *s = buf - 1;
    for (; *buf; ++buf)
    {
        if (*buf != ' ')
            s = buf;
    }
    *++s = 0; /* nul terminate the string on the first of the final spaces */
}

/* Show the tag name and contents if the tag exists */
static char *show_tag(ExifData *d, ExifIfd ifd, ExifTag tag)
{
    /* See if this tag exists */
    ExifEntry *entry = exif_content_get_entry(d->ifd[ifd], tag);
    if (entry)
    {
        char buf[1024];

        /* Get the contents of the tag in human-readable form */
        exif_entry_get_value(entry, buf, sizeof(buf));

        /* Don't bother printing it if it's entirely blank */
        trim_spaces(buf);
        if (*buf)
        {
            printf("%s: %s\n", exif_tag_get_name_in_ifd(tag, ifd), buf);
            return buf;
        }
    }

    return "error2";
}

extern "C" __attribute__((visibility("default"))) __attribute__((used)) char *native_add(char *filepath)
{
    ExifData *ed;

    /* Load an ExifData object from an EXIF file */
    ed = exif_data_new_from_file(filepath);
    if (!ed)
    {
        printf("File not readable or no EXIF data in file %s\n", filepath);
        return "error";
    }

    /* Show all the tags that might contain information about the
     * photographer
     */
    return (char *)exif_ifd_get_name(EXIF_IFD_EXIF);
    // return show_tag(ed, EXIF_IFD_EXIF, EXIF_TAG_MODEL);
}
