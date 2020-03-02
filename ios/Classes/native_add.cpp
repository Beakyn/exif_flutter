#include <stdint.h>
#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <string.h>

extern "C" __attribute__((visibility("default"))) __attribute__((used)) char *native_add(char *filepath)
{
    return (char *)"hello world";
}