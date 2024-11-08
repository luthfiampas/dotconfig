#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

float get_current_value();
int execute_command(const char *command);

int main(int argc, char **argv)
{
    if (argc != 2 || (strcmp(argv[1], "A") != 0 && strcmp(argv[1], "U") != 0 && strcmp(argv[1], "I") != 0))
    {
        fprintf(stderr, "Error: You must supply a single argument, either 'A' or 'U' or 'I'.\n");
        return 1;
    }

    float current_value_float = get_current_value();
    int current_value = (int)ceil(current_value_float);

    if (strcmp(argv[1], "A") == 0)
    {
        current_value += 2;
    }
    else if (strcmp(argv[1], "U") == 0)
    {
        current_value -= 2;
    }

    char command[128];

    sprintf(command, "light -S %d", current_value);
    execute_command(command);
    execute_command("light -O");

    sprintf(command, "ddcutil setvcp 10 %d", current_value);
    execute_command(command);

    return 0;
}

float get_current_value()
{
    FILE *fp;
    char path[1035];
    float current_value = 0;

    fp = popen("light -G", "r");
    if (fp == NULL)
    {
        printf("Failed to run command\n");
        exit(1);
    }

    while (fgets(path, sizeof(path), fp) != NULL)
    {
        sscanf(path, "%f", &current_value);
    }

    pclose(fp);
    return current_value;
}

int execute_command(const char *command)
{
    return system(command);
}
