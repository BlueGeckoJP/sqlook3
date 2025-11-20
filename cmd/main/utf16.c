#include <iconv.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

char *utf16le_to_utf8(const uint8_t *input, size_t input_bytes,
                      size_t *output_bytes) {
    if (input_bytes % 2 != 0)
        return NULL;

    iconv_t cd = iconv_open("UTF-8", "UTF-16LE");
    if (cd == (iconv_t)-1)
        return NULL;

    size_t out_size = input_bytes + input_bytes / 2 + 8;
    char *out_buf = malloc(out_size);
    char *out_ptr = out_buf;
    size_t in_left = input_bytes;
    size_t out_left = out_size;
    const char *in_ptr = (const char *)input;

    if (iconv(cd, (char **)&in_ptr, &in_left, &out_ptr, &out_left) ==
        (size_t)-1) {
        free(out_buf);
        out_buf = NULL;
    } else {
        *out_ptr = '\0';
        *output_bytes = out_ptr - out_buf + 1;
    }

    iconv_close(cd);
    return out_buf;
}
