#include "cli.h"
#include <stdio.h>

void print_usage() {
  printf("Usage: dio [options] input_file\n");
  printf("Options:\n");
  printf(" -o <file>	Specify output file\n");
  printf(" -O <level>	Optimization level (0-3)\n");
  printf(" --debug	Enable debugging symbols\n");
  printf(" -h, --help	Display this help message\n");
}
