#define NODES_SIZE 10 

typedef struct syntax_node
{
    const char* name;
    double value;
    struct syntax_node* next_elements[NODES_SIZE];
} syntax_node;

syntax_node* create_node(const char* name);
syntax_node* create_node_value(const char* name, double value);
syntax_node* create_node_list_2(const char* name, syntax_node* one, syntax_node* two);
syntax_node* create_node_list_3(const char* name, syntax_node* one, syntax_node* two, syntax_node* three);

void add_sub_node(syntax_node* main_node, syntax_node* sub_node);

void print_syntax_tree(syntax_node* node);