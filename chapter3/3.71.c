#include <stdio.h>
#define BUF_SIZE 12

void good_echo(char *, size_t);

int main()
{
    char buffer[BUF_SIZE];
    good_echo(buffer, sizeof(buffer));
    return 0;
}

void good_echo(char *buf, size_t buf_size)
{
    printf("大小%zu", buf_size);
    printf("大小%zu", sizeof(buf));
    while (fgets(buf, buf_size, stdin) != NULL)
    {
        printf("%s", buf);
    }
}