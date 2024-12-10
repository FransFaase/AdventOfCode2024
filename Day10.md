# Day 10 of Advent of Code 2024

The code below makes use of [a standard library](Std.md), which
also contains the `main` function that reads the input in the global variable `d`
where `n` contains the number of lines and `m` the length of the longest line,
and than calls the function `solve1` and `solve2`.

```c
void solve1()
{
    printf("%d %d\n", n, m);
}
```

At 6:04, the size of the topographic map is 40 by 40.

```c

num_t map1[40][40];
num_t map2[40][40];

void solve1()
{
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            map1[i][j] = d[i][j] == '0' ? 1 : 0;
    
    for (char h = '1'; h <= '9'; h++)
    {
        for (int i = 0; i < n; i++)
            for (int j = 0; j < m; j++)
                map2[i][j] =  d[i][j] == h
                            ?   (i > 0 ? map1[i-1][j] : 0)
                              + (i + 1 < n ? map1[i+1][j] : 0)
                              + (j > 0 ? map1[i][j-1] : 0)
                              + (j + 1 < m ? map1[i][j+1] : 0)
                            : 0;
        for (int i = 0; i < n; i++)
            for (int j = 0; j < m; j++)
                map1[i][j] = map2[i][j];
    }
    
    num_t count = 0;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            count += map1[i][j];
    printf("%lld", count);
}
```

At 6:18, that did not return the correct answer. Lets try it on some of the
examples.

```c

void pre() { use_sample = TRUE; }

```

At 6:21, it return 0 for the first example. Lets add some debugging code:

```c
void solve1()
{
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            map1[i][j] = d[i][j] == '0' ? 1 : 0;
    
    for (char h = '1'; h <= '9'; h++)
    {
        for (int i = 0; i < n; i++)
            for (int j = 0; j < m; j++)
                map2[i][j] =  d[i][j] == h
                            ?   (i > 0 ? map1[i-1][j] : 0)
                              + (i + 1 < n ? map1[i+1][j] : 0)
                              + (j > 0 ? map1[i][j-1] : 0)
                              + (j + 1 < m ? map1[i][j+1] : 0)
                            : 0;
        for (int i = 0; i < n; i++)
        {
            for (int j = 0; j < m; j++)
            {
                printf("%2d", map2[i][j]);
                map1[i][j] = map2[i][j];
            }
            printf("\n");
        }
        printf("\n");
    }
    
    num_t count = 0;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            count += map1[i][j];
    printf("%lld\n", count);
}
```

At 6:23, I see that everything looks good, but that the last count
map is completely zero.

At 6:27, I noticed that the input missed an newline at the end. Now
it return the correct answer.

At 6:29, I realize that you have to find how many top locations can
be reached from each bottom location. So, lets start over:

```c

void pre() { use_sample = FALSE; }

void solve1()
{
    for (int i1 = 0; i1 < n; i1++)
        for (int j1 = 0; j1 < m; j1++)
            map1[i1][j1] = 0;
    
    num_t count = 0;
    for (int i1 = 0; i1 < n; i1++)
        for (int j1 = 0; j1 < m; j1++)
            if (d[i1][j1] == '0')
            {
                map1[i1][j1] = 1;

                for (char h = '1'; h <= '9'; h++)
                {
                    for (int i = 0; i < n; i++)
                        for (int j = 0; j < m; j++)
                            map2[i][j] =  d[i][j] == h
                                        ?   (i > 0 ? map1[i-1][j] : 0)
                                          + (i + 1 < n ? map1[i+1][j] : 0)
                                          + (j > 0 ? map1[i][j-1] : 0)
                                          + (j + 1 < m ? map1[i][j+1] : 0)
                                        : 0;
                    for (int i = 0; i < n; i++)
                        for (int j = 0; j < m; j++)
                            map1[i][j] = map2[i][j];
                }
                
                num_t count = 0;
                for (int i = 0; i < n; i++)
                    for (int j = 0; j < m; j++)
                        if (map1[i][j] != 0)
                            count++;
                
                map1[i1][j1] = 0;
            }
    printf("%lld\n", count);
}
```

At 6:36, the above program, after I fixed some small bugs, returned 0.
Which must be incorrect.

```c

void pre() { use_sample = FALSE; }

void solve1()
{
    for (int i1 = 0; i1 < n; i1++)
        for (int j1 = 0; j1 < m; j1++)
            map1[i1][j1] = 0;
    
    num_t count = 0;
    for (int i1 = 0; i1 < n; i1++)
        for (int j1 = 0; j1 < m; j1++)
            if (d[i1][j1] == '0')
            {
                map1[i1][j1] = 1;

                for (char h = '1'; h <= '9'; h++)
                {
                    for (int i = 0; i < n; i++)
                        for (int j = 0; j < m; j++)
                            map2[i][j] =  d[i][j] == h
                                        ?   (i > 0 ? map1[i-1][j] : 0)
                                          + (i + 1 < n ? map1[i+1][j] : 0)
                                          + (j > 0 ? map1[i][j-1] : 0)
                                          + (j + 1 < m ? map1[i][j+1] : 0)
                                        : 0;
                    for (int i = 0; i < n; i++)
                        for (int j = 0; j < m; j++)
                            map1[i][j] = map2[i][j];
                }
                
                for (int i = 0; i < n; i++)
                    for (int j = 0; j < m; j++)
                        if (map1[i][j] != 0)
                            count++;
                
                map1[i1][j1] = 0;
            }
    printf("%lld\n", count);
}
```

At 6:38, this returned an incorrect value. Lets debug it with some of the
example inputs.

```c

void pre() { use_sample = TRUE; }
```

At 6:41, I see that the last example return 40 instead of 36. Lets print
out the numbers for the various starting points.

```c

void solve1()
{
    for (int i1 = 0; i1 < n; i1++)
        for (int j1 = 0; j1 < m; j1++)
            map1[i1][j1] = 0;
    
    num_t count = 0;
    for (int i1 = 0; i1 < n; i1++)
        for (int j1 = 0; j1 < m; j1++)
            if (d[i1][j1] == '0')
            {
                map1[i1][j1] = 1;

                for (char h = '1'; h <= '9'; h++)
                {
                    for (int i = 0; i < n; i++)
                        for (int j = 0; j < m; j++)
                            map2[i][j] =  d[i][j] == h
                                        ?   (i > 0 ? map1[i-1][j] : 0)
                                          + (i + 1 < n ? map1[i+1][j] : 0)
                                          + (j > 0 ? map1[i][j-1] : 0)
                                          + (j + 1 < m ? map1[i][j+1] : 0)
                                        : 0;
                    for (int i = 0; i < n; i++)
                        for (int j = 0; j < m; j++)
                            map1[i][j] = map2[i][j];
                }
                
                num_t c = 0;
                for (int i = 0; i < n; i++)
                    for (int j = 0; j < m; j++)
                        if (map1[i][j] != 0)
                            c++;
                printf(" %d", c);
                count += c;
                
                map1[i1][j1] = 0;
            }
    printf("%lld\n", count);
}
```

At 6:47, I do not understand what is wrong. Lets examine the fourth
incorrect value, which counts 4 instead of 3.

```c

void solve1()
{
    for (int i1 = 0; i1 < n; i1++)
        for (int j1 = 0; j1 < m; j1++)
            map1[i1][j1] = 0;
    
    num_t count = 0;
    int t = 0;
    for (int i1 = 0; i1 < n; i1++)
        for (int j1 = 0; j1 < m; j1++)
            if (d[i1][j1] == '0')
            {
                map1[i1][j1] = 1;

                for (char h = '1'; h <= '9'; h++)
                {
                    for (int i = 0; i < n; i++)
                        for (int j = 0; j < m; j++)
                            map2[i][j] =  d[i][j] == h
                                        ?   (i > 0 ? map1[i-1][j] : 0)
                                          + (i + 1 < n ? map1[i+1][j] : 0)
                                          + (j > 0 ? map1[i][j-1] : 0)
                                          + (j + 1 < m ? map1[i][j+1] : 0)
                                        : 0;
                    for (int i = 0; i < n; i++)
                        for (int j = 0; j < m; j++)
                            map1[i][j] = map2[i][j];
                    if (t == 3)
                    {
                        for (int i = 0; i < n; i++)
                        {
                            for (int j = 0; j < m; j++)
                                printf(" %c%c", d[i][j], map1[i][j] > 0 ? '*' : ' ');
                            printf("\n");
                        }
                        printf("\n");
                    }
                }
                
                num_t c = 0;
                for (int i = 0; i < n; i++)
                    for (int j = 0; j < m; j++)
                        if (map1[i][j] != 0)
                            c++;
                printf("%d\n", c);
                count += c;
                
                map1[i1][j1] = 0;
                t++;
            }
    printf("%lld\n", count);
}
```

At 6:55, I see that something goes wrong at the start.

```c

void solve1()
{
    for (int i1 = 0; i1 < n; i1++)
        for (int j1 = 0; j1 < m; j1++)
            map1[i1][j1] = 0;
    
    num_t count = 0;
    int t = 0;
    for (int i1 = 0; i1 < n; i1++)
        for (int j1 = 0; j1 < m; j1++)
            if (d[i1][j1] == '0')
            {
                for (int i = 0; i < n; i++)
                    for (int j = 0; j < m; j++)
                        map1[i][j] = 0;
    
                map1[i1][j1] = 1;

                for (char h = '1'; h <= '9'; h++)
                {
                    for (int i = 0; i < n; i++)
                        for (int j = 0; j < m; j++)
                            map2[i][j] =  d[i][j] == h
                                        ?   (i > 0 ? map1[i-1][j] : 0)
                                          + (i + 1 < n ? map1[i+1][j] : 0)
                                          + (j > 0 ? map1[i][j-1] : 0)
                                          + (j + 1 < m ? map1[i][j+1] : 0)
                                        : 0;
                    for (int i = 0; i < n; i++)
                        for (int j = 0; j < m; j++)
                            map1[i][j] = map2[i][j];
                    if (t == 3)
                    {
                        for (int i = 0; i < n; i++)
                        {
                            for (int j = 0; j < m; j++)
                                printf(" %c%c", d[i][j], map1[i][j] > 0 ? '*' : ' ');
                            printf("\n");
                        }
                        printf("\n");
                    }
                }
                
                num_t c = 0;
                for (int i = 0; i < n; i++)
                    for (int j = 0; j < m; j++)
                        if (map1[i][j] != 0)
                            c++;
                printf("%d\n", c);
                count += c;
                
                map1[i1][j1] = 0;
                t++;
            }
    printf("%lld\n", count);
}
```
At 6:58, that returns the correct answer for the last example input.

```c

void pre() { use_sample = FALSE; }
```

At 6:59:14, that found the correct answer.

### Second part of the puzzle.

So, the second puzzle, is what I did for the first.



```c
void solve2()
{
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            map1[i][j] = d[i][j] == '0' ? 1 : 0;
    
    for (char h = '1'; h <= '9'; h++)
    {
        for (int i = 0; i < n; i++)
            for (int j = 0; j < m; j++)
                map2[i][j] =  d[i][j] == h
                            ?   (i > 0 ? map1[i-1][j] : 0)
                              + (i + 1 < n ? map1[i+1][j] : 0)
                              + (j > 0 ? map1[i][j-1] : 0)
                              + (j + 1 < m ? map1[i][j+1] : 0)
                            : 0;
        for (int i = 0; i < n; i++)
            for (int j = 0; j < m; j++)
                map1[i][j] = map2[i][j];
    }
    
    num_t count = 0;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            count += map1[i][j];
    printf("%lld", count);
}

```

At 7:01:07, that found the correct answer.

### Executing this page

The command to process this markdown file, is:
```
../IParse/software/MarkDownC Std.md Day10.md >day10.c; gcc -g -Wall day10.c -o day10; ./day10 10
```
I run the bash file [`runOnSave.sh`](runOnSave.sh) with `10` as the argument,
which everytime when I save this file, runs the above command and shows the
result or the first compile errors, if there are any.


