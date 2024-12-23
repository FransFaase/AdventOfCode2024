# Day 23 of Advent of Code 2024

The code below makes use of [a standard library](Std.md), which
also contains the `main` function that reads the input in the global variable `d`
where `n` contains the number of lines and `m` the length of the longest line,
and than calls the function `solve1` and `solve2`.

I started at 6:00. Lets first find out how many different computers there are.

```c
void solve1()
{
    for (int i = 0; i < n; i++)
    {
        d[i][2] = '\0';
        printf("%s\n%s\n", d[i], d[i]+3);
    }
}
```

Using `/day23 | sort | uniq -c `, I discover there are 520 different computers
that all have 13 connections to other computers. Lets all read this into a
matrix.

```c
#define NR_C 520

char comp[NR_C][3];
int nr_comp = 0;
bool conn[NR_C][NR_C];

int comp_nr(const char *name)
{
    for (int i = 0; i < nr_comp; i++)
        if (strcmp(name, comp[i]) == 0)
            return i;
    strcpy(comp[nr_comp], name);
    nr_comp++;
    return nr_comp - 1;
}

void solve1()
{
    for (int i = 0; i < nr; i++)
        for (int j = 0; j < n; j++)
            conn[i][j] = FALSE;
            
    for (int i = 0; i < n; i++)
    {
        d[i][2] = '\0';
        int f = comp_nr(d[i]);
        int t = comp_nr(d[i]+3);
        conn[f][t] = TRUE;
        conn[t][f] = TRUE;
    }
    
    num_t count = 0;
    for (int i = 0; i < NR_C; i++)
        if (comp[i][0] == 't')
            for (int j = i + 1; j < NR_C; j++)
                if (conn[i][j])
                    for (int k = j + 1; k < NR_C; k++)
                        if (conn[i][k] & conn[j][k])
                            count++;
    printf("%lld", count);
}
```

At 6:15, this resulted in a segmentation fault.

```c
int comp_nr(const char *name)
{
    for (int i = 0; i < nr_comp; i++)
        if (strcmp(name, comp[i]) == 0)
            return i;
    strcpy(comp[nr_comp], name);
    nr_comp++;
    return nr_comp - 1;
}

void solve1()
{
    for (int i = 0; i < nr_comp; i++)
        for (int j = 0; j < nr_comp; j++)
            conn[i][j] = FALSE;
            
    for (int i = 0; i < n; i++)
    {
        d[i][2] = '\0';
        int f = comp_nr(d[i]);
        int t = comp_nr(d[i]+3);
        conn[f][t] = TRUE;
        conn[t][f] = TRUE;
    }
    
    num_t count = 0;
    for (int i = 0; i < NR_C; i++)
        if (comp[i][0] == 't')
            for (int j = i + 1; j < NR_C; j++)
                if (conn[i][j])
                    for (int k = j + 1; k < NR_C; k++)
                        if (conn[i][k] & conn[j][k])
                            count++;
    printf("%lld", count);
}
```

At 6:18, that did not return the correct answer. Lets try on
example input.

```c
bool use_sample = TRUE;

void solve1()
{
    for (int i = 0; i < nr_comp; i++)
        for (int j = 0; j < nr_comp; j++)
            conn[i][j] = FALSE;
            
    for (int i = 0; i < n; i++)
    {
        d[i][2] = '\0';
        int f = comp_nr(d[i]);
        int t = comp_nr(d[i]+3);
        conn[f][t] = TRUE;
        conn[t][f] = TRUE;
    }
    
    num_t count = 0;
    for (int i = 0; i < NR_C; i++)
        if (comp[i][0] == 't')
            for (int j = i + 1; j < NR_C; j++)
                if (conn[i][j])
                    for (int k = j + 1; k < NR_C; k++)
                        if (conn[i][k] & conn[j][k])
                        {
                            printf("%s,%s,%s\n", comp[i], comp[j], comp[3]);
                            count++;
                        }
    printf("%lld", count);
}
```

At 6:21, that did not return the correct answer. Too less.

```c
bool use_sample = TRUE;

void solve1()
{
    for (int i = 0; i < nr_comp; i++)
        for (int j = 0; j < nr_comp; j++)
            conn[i][j] = FALSE;
            
    for (int i = 0; i < n; i++)
    {
        d[i][2] = '\0';
        int f = comp_nr(d[i]);
        int t = comp_nr(d[i]+3);
        conn[f][t] = TRUE;
        conn[t][f] = TRUE;
    }
    printf("%d\n", nr_comp);
    
    num_t count = 0;
    for (int i = 0; i < nr_comp; i++)
        if (comp[i][0] == 't')
            for (int j = 0; j < nr_comp; j++)
                if (conn[i][j])
                    for (int k = j + 1; k < nr_comp; k++)
                        if (conn[i][k] & conn[j][k])
                        {
                            printf("%s,%s,%s\n", comp[i], comp[j], comp[k]);
                            count++;
                        }
    printf("%lld", count);
}
```

At 6:25, this returns:

```
16
tc,wh,td
tb,vc,wq
ta,de,ka
ta,de,co
ta,ka,co
td,tc,wh
td,qp,wh
td,yn,wh
8
```

I see that `td,tc,wh` is counted double.

```c
bool use_sample = TRUE;

void solve1()
{
    for (int i = 0; i < nr_comp; i++)
        for (int j = 0; j < nr_comp; j++)
            conn[i][j] = FALSE;
            
    for (int i = 0; i < n; i++)
    {
        d[i][2] = '\0';
        int f = comp_nr(d[i]);
        int t = comp_nr(d[i]+3);
        conn[f][t] = TRUE;
        conn[t][f] = TRUE;
    }
    printf("%d\n", nr_comp);
    
    num_t count = 0;
    for (int i = 0; i < nr_comp; i++)
        for (int j = i + 1; j < nr_comp; j++)
            if (conn[i][j])
                for (int k = j + 1; k < nr_comp; k++)
                    if (conn[i][k] && conn[j][k] && (comp[i][0] == 't' || comp[j][0] == 't' || comp[k][0] == 't'))
                    {
                        printf("%s,%s,%s\n", comp[i], comp[j], comp[k]);
                        count++;
                    }
    printf("%lld\n", count);
}
```

At 6:30, that returned the correct answer for the example input.

```c
bool use_sample = FALSE;
```

At 6:30:40, this returned the correct answer.

### Second part of the puzzle.

It seems that the names of the computer have to be listed in
alphabetic order.

```c

int comp_nr(const char *name)
{
    int i;
    for (i = 0; i < nr_comp; i++)
        if (strcmp(name, comp[i]) == 0)
            return i;
        else if (strcmp(name, comp[i]) < 0)
            break;
    for (int j = nr_comp; j > i; j--)
        strcpy(comp[j], comp[j-1]);
    nr_comp++;
    strcpy(comp[i], name);
    return i;
}

void solve2()
{
    printf("%d\n", nr_comp);
    for (int i = 0; i < nr_comp; i++)
        for (int j = i + 1; j < nr_comp; j++)
            if (conn[i][j])
                printf("%s-%s\n", comp[i], comp[j]);
    for (int i = 0; i < nr_comp; i++)
        printf("%s ", comp[i]);
}

bool use_sample = TRUE;

```

At 6:53, after making several edits to the above code, I understand why
it is incorrect.

```c
int comp_nr(const char *name)
{
    for (int i = 0; i < nr_comp; i++)
        if (strcmp(name, comp[i]) == 0)
            return i;
    strcpy(comp[nr_comp], name);
    nr_comp++;
    return nr_comp - 1;
}

void insert(const char *name)
{
    int i;
    for (i = 0; i < nr_comp; i++)
        if (strcmp(name, comp[i]) == 0)
            return;
        else if (strcmp(name, comp[i]) < 0)
            break;
    for (int j = nr_comp; j > i; j--)
        strcpy(comp[j], comp[j-1]);
    nr_comp++;
    strcpy(comp[i], name);
}

void solve2()
{
    for (int i = 0; i < nr_comp; i++)
        for (int j = 0; j < nr_comp; j++)
            conn[i][j] = FALSE;
            
    for (int i = 0; i < n; i++)
    {
        d[i][2] = '\0';
        insert(d[i]);
        insert(d[i]+3);
    }
    for (int i = 0; i < n; i++)
    {
        int f = comp_nr(d[i]);
        int t = comp_nr(d[i]+3);
        conn[f][t] = TRUE;
        conn[t][f] = TRUE;
    }
    printf("%d\n", nr_comp);
    
    num_t count = 0;
    for (int i = 0; i < nr_comp; i++)
        for (int j = i + 1; j < nr_comp; j++)
            if (conn[i][j])
                for (int k = j + 1; k < nr_comp; k++)
                    if (conn[i][k] && conn[j][k] && (comp[i][0] == 't' || comp[j][0] == 't' || comp[k][0] == 't'))
                    {
                        printf("%s,%s,%s\n", comp[i], comp[j], comp[k]);
                        count++;
                    }
    printf("%lld", count);
}
```

At 7:01, it returns the correct answer again.

```c

int max_size = 0;
int k[13];
int max_k[13];

void find(int n, int i)
{
    if (n > max_size)
    {
        for (int j = 0; j < n; j++)
            max_k[j] = k[j];
        max_size = n;
    }
    if (n == 13)
        return;
    for (; i < nr_comp; i++)
    {
        bool all_conn = TRUE;
        for (int j = 0; j < n; j++)
            if (!conn[k[j]][i])
            {
                all_conn = FALSE;
                break;
            }
        if (all_conn)
        {
            k[n] = i;
            find(n + 1, i + 1);
        }
    }
}

void solve2()
{
    for (int i = 0; i < nr_comp; i++)
        for (int j = 0; j < nr_comp; j++)
            conn[i][j] = FALSE;
            
    for (int i = 0; i < n; i++)
    {
        d[i][2] = '\0';
        insert(d[i]);
        insert(d[i]+3);
    }
    for (int i = 0; i < n; i++)
    {
        int f = comp_nr(d[i]);
        int t = comp_nr(d[i]+3);
        conn[f][t] = TRUE;
        conn[t][f] = TRUE;
    }
    printf("%d\n", nr_comp);
    
    for (int i = 0; i < nr_comp; i++)
    {
        printf(".");
        k[0] = i;
        find(1, i + 1);
    }
    
    for (int i = 0; i < max_size; i++)
        printf("%s,", comp[max_k[i]]);
}
```
At 7:13, this returned the correct answer for the sample input.

```c
bool use_sample = FALSE;
```

At 7:13, the above returned a segmenation fault.

```c
void solve2()
{
    for (int i = 0; i < nr_comp; i++)
        for (int j = 0; j < nr_comp; j++)
            conn[i][j] = FALSE;

    nr_comp = 0;            

    for (int i = 0; i < n; i++)
    {
        d[i][2] = '\0';
        insert(d[i]);
        insert(d[i]+3);
    }
    for (int i = 0; i < n; i++)
    {
        int f = comp_nr(d[i]);
        int t = comp_nr(d[i]+3);
        conn[f][t] = TRUE;
        conn[t][f] = TRUE;
    }
    printf("%d\n", nr_comp);
    
    for (int i = 0; i < nr_comp; i++)
    {
        printf(".");
        k[0] = i;
        find(1, i + 1);
    }
    
    for (int i = 0; i < max_size; i++)
        printf("%s,", comp[max_k[i]]);
}
```

At 7:17:07, that returned the correct answer with a total
running time of about 0.07 seconds, which is much less than
I had expected.

### Executing this page

The command to process this markdown file, is:
```
../IParse/software/MarkDownC Std.md Day23.md >day23.c; gcc -g -Wall day23.c -o day23; ./day23 23
```
I run the bash file [`runOnSave.sh`](runOnSave.sh) with `23` as the argument,
which everytime when I save this file, runs the above command and shows the
result or the first compile errors, if there are any.


