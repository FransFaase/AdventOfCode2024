# Day 19 of Advent of Code 2024

The code below makes use of [a standard library](Std.md), which
also contains the `main` function that reads the input in the global variable `d`
where `n` contains the number of lines and `m` the length of the longest line,
and than calls the function `solve1` and `solve2`.

At 7:16, I started reading the puzzle text. This an interesting puzzle,
especially if you want to solve it efficiently. I think, I am going to build 
a tree for all the towel patterns.

```c

typedef struct node_s node_t, *node_p;
struct node_s
{
    bool match;
    node_p next[5];
};

node_p root = 0;

char *colors = "wubrg";

int kind(char c) { return c == 'w' ? 0 : c == 'u' ? 0 : c == 'b' ? 0 : c == 'r' ? 0 : 4; } 

bool match(char *s, node_p node)
{
    if (node == 0)
        return *s == '\0';
    if (*s == '\0')
        return FALSE;
    return    match(s + 1, node->next[kind(*s)])
           || (node->match && match(s + 1, root));
}

void solve1()
{
    char *s = d[0];
    for (;;)
    {
        node_p *ref_node = &root;
        for (; *s != ',' && *s != '\0'; s++)
        {
            if (*ref_node == 0)
            {
                *ref_node = (node_p)malloc(sizeof(node_t));
                (*ref_node)->match = FALSE;
                for (int i = 0; i < 5; i++)
                    (*ref_node)->next[i] = 0;
            }
            ref_node = (*ref_node)->next + kind(*s);
        }
        (*ref_node)->match = TRUE;
        if (*s != ',')
            break;
        s += 2;
    }
    
    int count = 0;
    for (int i = 2; i < n; i++)
        if (match(d[i], root))
            count++;
        
    printf("%d\n", count);
}
```

At 7:42, the above program caused a segmenation fault.

```c
void solve1()
{
    char *s = d[0];
    for (;;)
    {
        node_p *ref_node = &root;
        for (;; s++)
        {
            if (*ref_node == 0)
            {
                *ref_node = (node_p)malloc(sizeof(node_t));
                (*ref_node)->match = FALSE;
                for (int i = 0; i < 5; i++)
                    (*ref_node)->next[i] = 0;
            }
            if (*s == '\0' || *s == ',')
                break;
            ref_node = (*ref_node)->next + kind(*s);
        }
        (*ref_node)->match = TRUE;
        if (*s != ',')
            break;
        s += 2;
    }
    
    int count = 0;
    for (int i = 2; i < n; i++)
        if (match(d[i], root))
            count++;
        
    printf("%d\n", count);
}
```

At 7:46, the program seem to run a long time.

```c
void solve1()
{
    char *s = d[0];
    for (;;)
    {
        printf("%s", s);
        node_p *ref_node = &root;
        for (;; s++)
        {
            if (*ref_node == 0)
            {
                *ref_node = (node_p)malloc(sizeof(node_t));
                (*ref_node)->match = FALSE;
                for (int i = 0; i < 5; i++)
                    (*ref_node)->next[i] = 0;
            }
            if (*s == '\0' || *s == ',')
                break;
            ref_node = (*ref_node)->next + kind(*s);
        }
        (*ref_node)->match = TRUE;
        if (*s != ',')
            break;
        s += 2;
    }
    
    int count = 0;
    for (int i = 2; i < n; i++)
    {
        printf("%d\n", i);
        if (match(d[i], root))
            count++;
    }
        
    printf("%d\n", count);
}
```

It seems to hang at the 5th input line.

```c
bool match(char *s, node_p node)
{
    printf("%p %s\n", node, s);
    if (node == 0)
        return *s == '\0';
    if (*s == '\0')
        return FALSE;
    return    match(s + 1, node->next[kind(*s)])
           || (node->match && match(s + 1, root));
}
```

At 7:55, I think, I spot the error:

```c
bool match(char *s, node_p node)
{
    printf("%p %s\n", node, s);
    if (node == 0)
        return *s == '\0';
    if (*s == '\0')
        return node->match;
    return    match(s + 1, node->next[kind(*s)])
           || (node->match && match(s + 1, root));
}
```

At 7:57, it returned the answer 400, which to me did not look
correct and indeed it was not the correct answer.

```c
bool match(char *s, node_p node)
{
    printf("%p %s\n", node, s);
    if (*s == '\0')
        return node->match;
    if (node == 0)
        return FALSE;
    return    match(s + 1, node->next[kind(*s)])
           || (node->match && match(s, root));
}
```

At 8:00, that returned a segmentation error again.

```c
bool match(char *s, node_p node)
{
    printf("%p %s\n", node, s);
    if (*s == '\0')
        return node != 0 && node->match;
    if (node == 0)
        return FALSE;
    return    match(s + 1, node->next[kind(*s)])
           || (node->match && match(s, root));
}
```

At 8:01, that returned 400 again.

```c
bool match(char *s, node_p node)
{
    printf("%p %s", node, s);
    if (node == 0)
    {
        printf("\n");
        return FALSE;
    }
    if (*s == '\0')
    {
        printf("%s\n", node->match ? "Match" : "");
        return node->match;
    }
    printf("\n");
    return    match(s + 1, node->next[kind(*s)])
           || (node->match && match(s, root));
}
```

At 8:10, still the same answer. Lets try it on the example input.

```c
void pre() { use_sample = TRUE; }
```

I had to leave for work and at 18:27, after dinner, I continued having
thought about a better way solve the puzzle. (At 18:39, I discovered there
was a big bug in the `kind` function.)

```c
int kind(char c) { return c == 'w' ? 0 : c == 'u' ? 1 : c == 'b' ? 2 : c == 'r' ? 3 : 4; } 

void solve1()
{
    char *s = d[0];
    for (;;)
    {
        printf("%s", s);
        node_p *ref_node = &root;
        for (;; s++)
        {
            if (*ref_node == 0)
            {
                *ref_node = (node_p)malloc(sizeof(node_t));
                (*ref_node)->match = FALSE;
                for (int i = 0; i < 5; i++)
                    (*ref_node)->next[i] = 0;
            }
            if (*s == '\0' || *s == ',')
                break;
            ref_node = (*ref_node)->next + kind(*s);
        }
        (*ref_node)->match = TRUE;
        if (*s != ',')
            break;
        s += 2;
    }
    
    int count = 0;
    for (int i = 2; i < n; i++)
    {
        char *s = d[i];
        int len = strlen(s);
        bool possible[100];
        possible[0] = TRUE;
        for (int j = 1; j <= len; j++)
            possible[j] = FALSE;
        for (int j = 0; j < len; j++)
        {
            node_p node = root;
            for (int j2 = j; j2 <= len && node != 0; j2++)
            {
                if (node->match && !possible[j2])
                {
                    printf("%d ", j2);
                    possible[j2] = TRUE;
                }
                node = node->next[kind(s[j2])];
            }
            possible[j] = FALSE;
        }
        printf("%s\n", possible[len] ? "Match" : "!!");
        if (possible[len])
            count++;
    }
    
    printf("%d\n", count);
}
```

At 18:43, I see that it still matches everything.

```c
char str[30];

void print_nodes(node_p node, int depth)
{
    if (node == 0)
        return;
    if (node->match)
    {
        str[depth] = '\0';
        printf("%s\n", str);
    }
    for (int i = 0; i < 5; i++)
    {
        str[depth] = colors[i];
        print_nodes(node->next[i], depth + 1);
    }
} 

void solve1()
{
    char *s = d[0];
    for (;;)
    {
        printf("%s", s);
        node_p *ref_node = &root;
        for (;; s++)
        {
            if (*ref_node == 0)
            {
                *ref_node = (node_p)malloc(sizeof(node_t));
                (*ref_node)->match = FALSE;
                for (int i = 0; i < 5; i++)
                    (*ref_node)->next[i] = 0;
            }
            if (*s == '\0' || *s == ',')
                break;
            ref_node = (*ref_node)->next + kind(*s);
        }
        (*ref_node)->match = TRUE;
        if (*s != ',')
            break;
        s += 2;
    }

    print_nodes(root, 0);
        
    int count = 0;
    for (int i = 2; i < n; i++)
    {
        char *s = d[i];
        int len = strlen(s);
        bool possible[100];
        possible[0] = TRUE;
        for (int j = 1; j <= len; j++)
            possible[j] = FALSE;
        for (int j = 0; j < len; j++)
        {
            node_p node = root;
            for (int j2 = j; j2 <= len && node != 0; j2++)
            {
                if (node->match && !possible[j2])
                {
                    printf("%d ", j2);
                    possible[j2] = TRUE;
                }
                node = node->next[kind(s[j2])];
            }
            possible[j] = FALSE;
        }
        printf("%s\n", possible[len] ? "Match" : "!!");
        if (possible[len])
            count++;
    }
    
    printf("%d\n", count);
}
```

At 18:50, I see that there is really some wrong with it.

```c
char str[30];

void print_nodes(node_p node, int depth)
{
    if (node == 0)
        return;
    if (node->match)
    {
        str[depth] = '\0';
        printf("%s ", str);
    }
    for (int i = 0; i < 5; i++)
    {
        str[depth] = colors[i];
        print_nodes(node->next[i], depth + 1);
    }
}

node_p new_node()
{
    node_p node = (node_p)malloc(sizeof(node_t));
    node->match = FALSE;
    for (int i = 0; i < 5; i++)
        node->next[i] = 0;
    return node;
}

void solve1()
{
    char *s = d[0];
    for (;;)
    {
        printf("%s\n", s);
        node_p *ref_node = &root;
        for (; *s != '\0' && *s != ','; s++)
        {
            printf("%c", *s);
            if (*ref_node == 0)
                *ref_node = new_node();
            ref_node = &(*ref_node)->next[kind(*s)];
        }
        if (*ref_node == 0)
            *ref_node = new_node();
        (*ref_node)->match = TRUE;
        if (*s != ',')
            break;
        printf("|");
        s += 2;
    }

    printf("\n");
    print_nodes(root, 0);
    printf("\n");
        
    int count = 0;
    for (int i = 2; i < n; i++)
    {
        char *s = d[i];
        int len = strlen(s);
        bool possible[100];
        possible[0] = TRUE;
        for (int j = 1; j <= len; j++)
            possible[j] = FALSE;
        for (int j = 0; j < len; j++)
            if (possible[j])
            {
                node_p node = root;
                for (int j2 = j; j2 <= len && node != 0; j2++)
                {
                    if (node->match && !possible[j2])
                    {
                        printf("%d ", j2);
                        possible[j2] = TRUE;
                    }
                    node = node->next[kind(s[j2])];
                }
                possible[j] = FALSE;
            }
        printf("%s\n", possible[len] ? "Match" : "!!");
        if (possible[len])
            count++;
    }
    
    printf("%d\n", count);
}
```

At 19:03, it looked like there was no bug in the first part, but in
the second part. Lets clean up the code a bit.

```c
void pre() { use_sample = FALSE; }

void solve1()
{
    char *s = d[0];
    for (;;)
    {
        node_p *ref_node = &root;
        for (; *s != '\0' && *s != ','; s++)
        {
            if (*ref_node == 0)
                *ref_node = new_node();
            ref_node = &(*ref_node)->next[kind(*s)];
        }
        if (*ref_node == 0)
            *ref_node = new_node();
        (*ref_node)->match = TRUE;
        if (*s != ',')
            break;
        s += 2;
    }

    int count = 0;
    for (int i = 2; i < n; i++)
    {
        char *s = d[i];
        int len = strlen(s);
        bool possible[100];
        possible[0] = TRUE;
        for (int j = 1; j <= len; j++)
            possible[j] = FALSE;
        for (int j = 0; j < len; j++)
            if (possible[j])
            {
                node_p node = root;
                for (int j2 = j; j2 <= len && node != 0; j2++)
                {
                    if (node->match)
                        possible[j2] = TRUE;
                    node = node->next[kind(s[j2])];
                }
                possible[j] = FALSE;
            }
        if (possible[len])
            count++;
    }
    
    printf("%d\n", count);
}
```

At 16:05:47, that returned the correct answer for the first
part of the puzzle.

### Second part of the puzzle.

Really easy with the above solution. Just replace the Boolean
`possible` with integers and just add the number of possible
ways to get at each location.

```c
void solve2()
{
    num_t count = 0;
    for (int i = 2; i < n; i++)
    {
        char *s = d[i];
        int len = strlen(s);
        num_t possible[100];
        possible[0] = 1;
        for (int j = 1; j <= len; j++)
            possible[j] = 0;
        for (int j = 0; j < len; j++)
            if (possible[j] > 0)
            {
                node_p node = root;
                for (int j2 = j; j2 <= len && node != 0; j2++)
                {
                    if (node->match)
                        possible[j2] += possible[j];
                    node = node->next[kind(s[j2])];
                }
            }
        count += possible[len];
    }
    
    printf("%lld\n", count);
}

```

At 19:11:49, that returned the correct answer with
a total runtime of 3 miliseconds.

### Executing this page

The command to process this markdown file, is:
```
../IParse/software/MarkDownC Std.md Day19.md >day19.c; gcc -g -Wall day19.c -o day19; ./day19 19
```
I run the bash file [`runOnSave.sh`](runOnSave.sh) with `19` as the argument,
which everytime when I save this file, runs the above command and shows the
result or the first compile errors, if there are any.


