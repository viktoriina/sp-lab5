#include "utils.h"
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <stdio.h>

static variable_node* variable_table;

variable_node* get_variable(const char* name) {
    variable_node* tmp = variable_table;

    while(tmp != NULL) {
        if(strcmp(tmp->name, name) == 0) {
            break;
        }
        tmp = tmp->next;
    }

    return tmp;
}

variable_node* create_variable(const char* name, double value) {
    variable_node* new_node = malloc(sizeof(variable_node));
    new_node->name = name;
    new_node->value = value;

    return new_node;
}

void add_variable(const char* name, double value)
{
    variable_node* found = get_variable(name);
    if(found != NULL) {
        found->value = value;
        return;
    }

    found = create_variable(name, value);
    found->next = variable_table;
    variable_table = found;
}

void init_variable_table() {
    variable_table = create_variable("z", 0);
    variable_table->next = NULL;
}

int process_unary_function(const char* func, double val, double* res) 
{
    double result = 0;

    if(strcmp(func, "log") == 0) {
        if(val < 0) {
            printf("Non positive number to logarithm - %f\n", val);
            return 0;
        }
        result = log(val);
    } 
    else if(strcmp(func, "sin") == 0) {
        result = sin(val);
    }
    else if(strcmp(func, "cos") == 0) {
        result = cos(val);
    }
    else if(strcmp(func, "tan") == 0) {
        result = tan(val);
    } 
    else if(strcmp(func, "abs") == 0) {
        result = val < 0 ? -val : val;
    }

    (*res) = result;
    return 1;
}