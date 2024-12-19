# Day 18 of Advent of Code 2024

The code below makes use of [a standard library](Std.md), which
also contains the `main` function that reads the input in the global variable `d`
where `n` contains the number of lines and `m` the length of the longest line,
and than calls the function `solve1` and `solve2`.

```c

bool mem[72][72];
int dist[72][72];
void solve1()
{
    for (int i = 1; i < 72; i++)
        for (int j = 1; j < 72; j++)
            mem[i][j] = i != 0 && i != 71 && j != 0 && j != 71;
    
    for (int i = 0; i < 1024; i++)
    {
        char *s = d[i];
        num_t x = parse_number(&s);
        s++;
        num_t y = parse_number(&s);
        mem[x+1][y+1] = FALSE;
    }
    
    for (int i = 1; i < 72; i++)
        for (int j = 1; j < 72; j++)
            dist[i][j] = 100000;
    dist[1][1] = 0;
    
    for (bool go = TRUE; go;)
    {
        go = FALSE;
        
        for (int i = 1; i < 71; i++)
            for (int j = 1; j < 71; j++)
                if (mem[i][j])
                {
                    if (dist[i-1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i-1][j] + 1; go = TRUE; } 
                    if (dist[i+1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i+1][j] + 1; go = TRUE; } 
                    if (dist[i][j-1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j-1] + 1; go = TRUE; } 
                    if (dist[i][j+1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j+1] + 1; go = TRUE; }
                }
    }
    printf("%d\n", dist[70][70]);
}
```

At 7:56, that returned the maximum value, which cannot be correct. I see that the range is
0 to 70 included.

```c

bool mem[73][73];
int dist[73][73];
void solve1()
{
    for (int i = 1; i < 73; i++)
        for (int j = 1; j < 73; j++)
            mem[i][j] = i != 0 && i != 72 && j != 0 && j != 72;
    
    for (int i = 0; i < 1024; i++)
    {
        char *s = d[i];
        num_t x = parse_number(&s);
        s++;
        num_t y = parse_number(&s);
        mem[x+1][y+1] = FALSE;
    }
    
    for (int i = 1; i < 73; i++)
        for (int j = 1; j < 73; j++)
            dist[i][j] = 100000;
    dist[1][1] = 0;
    
    for (bool go = TRUE; go;)
    {
        go = FALSE;
        
        for (int i = 1; i < 72; i++)
            for (int j = 1; j < 72; j++)
                if (mem[i][j])
                {
                    if (dist[i-1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i-1][j] + 1; go = TRUE; } 
                    if (dist[i+1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i+1][j] + 1; go = TRUE; } 
                    if (dist[i][j-1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j-1] + 1; go = TRUE; } 
                    if (dist[i][j+1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j+1] + 1; go = TRUE; }
                }
    }
    printf("%d\n", dist[71][71]);
}
```

At 7:59, I submitted an incorrect answer. Time to use try this on the example input.

```c
void pre() { use_sample = TRUE; }

void solve1()
{
    int size = use_sample ? 6 : 70;
    for (int i = 1; i < size + 3; i++)
        for (int j = 1; j < size + 3; j++)
            mem[i][j] = 0 < i && i < size + 2 && 0 < j && j < size + 2;
    
    int till = use_sample ? 12 : 1024;
    for (int i = 0; i < till; i++)
    {
        char *s = d[i];
        num_t x = parse_number(&s);
        s++;
        num_t y = parse_number(&s);
        mem[x+1][y+1] = FALSE;
    }
    
    for (int i = 1; i < size + 2; i++)
    {
        for (int j = 1; j < size + 2; j++)
            printf("%c", mem[i][j] ? '.' : '#');
        printf("\n");
    }

    for (int i = 0; i < size + 3; i++)
        for (int j = 0; j < size + 3; j++)
            dist[i][j] = 100000;
    dist[1][1] = 0;
    
    for (bool go = TRUE; go;)
    {
        go = FALSE;
        
        for (int i = 1; i < size + 2; i++)
            for (int j = 1; j < size + 2; j++)
                if (mem[i][j])
                {
                    if (dist[i-1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i-1][j] + 1; go = TRUE; } 
                    if (dist[i+1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i+1][j] + 1; go = TRUE; } 
                    if (dist[i][j-1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j-1] + 1; go = TRUE; } 
                    if (dist[i][j+1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j+1] + 1; go = TRUE; }
                }
    }
    printf("%d\n", dist[size + 1][size + 1]);
}
```

At 8:11, the above program returned the correct answer to the example
input. (I made several edits.)

```c
void pre() { use_sample = FALSE; }
```

At 8:13:05, the program returned the correct answer.

### Second part of the puzzle.

The second part was something that I already had expected. After some
consideration, I got the idea to solve it in the reverse order, by first
placing all failed bytes and then remove them in the reverse order until
a path is found. In this way the incremental algorithm to calculated the
shortest path to all locations can be called, because distances will
only become shorter when new memory locations are added.

```c
void solve2()
{
    int size = use_sample ? 6 : 70;
    for (int i = 1; i < size + 3; i++)
        for (int j = 1; j < size + 3; j++)
            mem[i][j] = 0 < i && i < size + 2 && 0 < j && j < size + 2;
    
    for (int i = 0; i < n; i++)
    {
        char *s = d[i];
        num_t x = parse_number(&s);
        s++;
        num_t y = parse_number(&s);
        mem[x+1][y+1] = FALSE;
    }
    
    for (int i = 0; i < size + 3; i++)
        for (int j = 0; j < size + 3; j++)
            dist[i][j] = 100000;
    dist[1][1] = 0;
    
    for (int i = n-1; i >= 0; i--)
    {
        char *s = d[i];
        num_t x = parse_number(&s);
        s++;
        num_t y = parse_number(&s);
        mem[x+1][y+1] = TRUE;

        for (bool go = TRUE; go;)
        {
            go = FALSE;
            
            for (int i = 1; i < size + 2; i++)
                for (int j = 1; j < size + 2; j++)
                    if (mem[i][j])
                    {
                        if (dist[i-1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i-1][j] + 1; go = TRUE; } 
                        if (dist[i+1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i+1][j] + 1; go = TRUE; } 
                        if (dist[i][j-1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j-1] + 1; go = TRUE; } 
                        if (dist[i][j+1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j+1] + 1; go = TRUE; }
                    }
        }
        if (dist[size + 1][size + 1] < 10000)
        {
            printf("%d,%d\n", x, y);
            break;
        }
    }
}

```

At 8:33:26, the above program returned the correct answer after I fixed
some syntax errors.

### Executing this page

The command to process this markdown file, is:
```
../IParse/software/MarkDownC Std.md Day18.md >day18.c; gcc -g -Wall day18.c -o day18; ./day18 18
```
I run the bash file [`runOnSave.sh`](runOnSave.sh) with `18` as the argument,
which everytime when I save this file, runs the above command and shows the
result or the first compile errors, if there are any.


