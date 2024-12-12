# Day 12 of Advent of Code 2024

The code below makes use of [a standard library](Std.md), which
also contains the `main` function that reads the input in the global variable `d`
where `n` contains the number of lines and `m` the length of the longest line,
and than calls the function `solve1` and `solve2`.

```c

char dd(int i, int j) { return i >= 0 && i < n && j >= 0; j < m ? d[i][j] : ' '; }

void solve1()
{
    num_t answer = 0;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            if ('A' <= d[i][j] && d[i][j] <= 'Z')
            {
                char letter = d[i][j];
                d[i][j] = '#';
                for (bool go = TRUE; go;)
                {
                    go = FALSE;
                    for (int i1 = 0; i1 < n; i1++)
                        for (int j1 = 0; j1 < m; j1++)
                            if (   d[i1][j1] == letter
                                && (   dd(i1-1, j1) == '#' || dd(i1+1, j1) == '#'
                                    || dd(i1, j1-1) == '#' || dd(i1, j1+1) == '#'))
                            {
                                d[i1][j1] = '#';
                                go = TRUE;
                            }
                }
                
                num_t perm = 0;
                num_t area = 0;
                for (int i1 = 0; i1 < n; i1++)
                    for (int j1 = 0; j1 < m; j1++)
                        if (d[i1][j1] == '#')
                        {
                            area++;
                            if (dd(i1-1, j1) != '#') perm++;
                            if (dd(i1+1, j1) != '#') perm++;
                            if (dd(i1, j1-1) != '#') perm++;
                            if (dd(i1, j1+1) != '#') perm++;
                        }
                letter += 'a' - 'A';
                answer += perm * area;
                for (int i1 = 0; i1 < n; i1++)
                    for (int j1 = 0; j1 < m; j1++)
                        if (d[i1][j1] == '#')
                            d[i1][j1] = letter;
            }
    
    printf("%lld\n", answer);
}
```

At 6:17, the above program compiled after removing one extra ')',
but it returned the incorrect answer on the my input.

```c

void pre() { use_sample = TRUE; }

void solve1()
{
    num_t answer = 0;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            if ('A' <= d[i][j] && d[i][j] <= 'Z')
            {
                char letter = d[i][j];
                d[i][j] = '#';
                for (bool go = TRUE; go;)
                {
                    go = FALSE;
                    for (int i1 = 0; i1 < n; i1++)
                        for (int j1 = 0; j1 < m; j1++)
                            if (   d[i1][j1] == letter
                                && (   dd(i1-1, j1) == '#' || dd(i1+1, j1) == '#'
                                    || dd(i1, j1-1) == '#' || dd(i1, j1+1) == '#'))
                            {
                                d[i1][j1] = '#';
                                go = TRUE;
                            }
                }
                
                num_t perm = 0;
                num_t area = 0;
                for (int i1 = 0; i1 < n; i1++)
                {
                    for (int j1 = 0; j1 < m; j1++)
                    {
                        printf("%c", d[i1][j1]);
                        if (d[i1][j1] == '#')
                        {
                            area++;
                            if (dd(i1-1, j1) != '#') perm++;
                            if (dd(i1+1, j1) != '#') perm++;
                            if (dd(i1, j1-1) != '#') perm++;
                            if (dd(i1, j1+1) != '#') perm++;
                        }
                    }
                    printf("\n");
                }
                letter += 'a' - 'A';
                printf("%c %lld * %lld = %lld\n", letter, area, perm, area * perm);
                answer += perm * area;
                for (int i1 = 0; i1 < n; i1++)
                    for (int j1 = 0; j1 < m; j1++)
                        if (d[i1][j1] == '#')
                            d[i1][j1] = letter;
            }
    
    printf("%lld\n", answer);
}
```

At 6:22, it seems that my algorithm to find the groups does not work.
At 6:27, I get the same answer, after I added some print statements.

```c

char dd(int i, int j) { return i >= 0 && i < n && j >= 0 && j < m ? d[i][j] : ' '; }

void pre() { use_sample = FALSE; }

```

At 6:30:22, this returned the correct answer after I spotted a silly
mistake in the `dd` function. I am going to add this function to my
standard library, becaue I already used it several times.

### Second part of the puzzle.


```c
void solve2()
{
    num_t answer = 0;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            if ('a' <= d[i][j] && d[i][j] <= 'z')
            {
                char letter = d[i][j];
                d[i][j] = '#';
                for (bool go = TRUE; go;)
                {
                    go = FALSE;
                    for (int i1 = 0; i1 < n; i1++)
                        for (int j1 = 0; j1 < m; j1++)
                            if (   d[i1][j1] == letter
                                && (   dd(i1-1, j1) == '#' || dd(i1+1, j1) == '#'
                                    || dd(i1, j1-1) == '#' || dd(i1, j1+1) == '#'))
                            {
                                d[i1][j1] = '#';
                                go = TRUE;
                            }
                }
                
                num_t perm = 0;
                num_t area = 0;
                for (int i1 = 0; i1 < n; i1++)
                    for (int j1 = 0; j1 < m; j1++)
                        if (d[i1][j1] == '#')
                        {
                            area++;
                            if (dd(i1-1, j1) != '#') perm++;
                            if (dd(i1+1, j1) != '#') perm++;
                            if (dd(i1, j1-1) != '#') perm++;
                            if (dd(i1, j1+1) != '#') perm++;
                        }
                letter += 'A' - 'a';
                answer += perm * area;
                for (int i1 = 0; i1 < n; i1++)
                    for (int j1 = 0; j1 < m; j1++)
                        if (d[i1][j1] == '#')
                            d[i1][j1] = letter;
            }
    
    printf("%lld\n", answer);
}

```

At 6:35, the above program produces the same answer as for the first part.

```c
void solve2()
{
    num_t answer = 0;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            if ('a' <= d[i][j] && d[i][j] <= 'z')
            {
                char letter = d[i][j];
                d[i][j] = '#';
                for (bool go = TRUE; go;)
                {
                    go = FALSE;
                    for (int i1 = 0; i1 < n; i1++)
                        for (int j1 = 0; j1 < m; j1++)
                            if (   d[i1][j1] == letter
                                && (   dd(i1-1, j1) == '#' || dd(i1+1, j1) == '#'
                                    || dd(i1, j1-1) == '#' || dd(i1, j1+1) == '#'))
                            {
                                d[i1][j1] = '#';
                                go = TRUE;
                            }
                }
                
                num_t perm = 0;
                num_t area = 0;
                for (int i1 = 0; i1 < n; i1++)
                    for (int j1 = 0; j1 < m; j1++)
                        if (d[i1][j1] == '#')
                            area++;
                for (int i1 = 0; i1 <= n; i1++)
                {
                    char state = ' ';
                    for (int j1 = 0; j1 < m; j1++)
                        if (dd(i1, j1) == '#' && dd(i1-1, j1) != '#')
                        {
                            if (state != 't')
                            {
                                perm++;
                                state = 't';
                            }
                        }
                        else if (dd(i1, j1) != '#' && dd(i1-1, j1) == '#')
                        {
                            if (state != 'b')
                            {
                                perm++;
                                state = 'b';
                            }
                        }
                        else
                            state = ' ';
                }
                for (int j1 = 0; j1 <= m; j1++)
                {
                    char state = ' ';
                    for (int i1 = 0; i1 < n; i1++)
                        if (dd(i1, j1) == '#' && dd(i1, j1-1) != '#')
                        {
                            if (state != 'l')
                            {
                                perm++;
                                state = 'l';
                            }
                        }
                        else if (dd(i1, j1) != '#' && dd(i1, j1-1) == '#')
                        {
                            if (state != 'r')
                            {
                                perm++;
                                state = 'r';
                            }
                        }
                        else
                            state = ' ';
                }
                letter += 'A' - 'a';
                answer += perm * area;
                for (int i1 = 0; i1 < n; i1++)
                    for (int j1 = 0; j1 < m; j1++)
                        if (d[i1][j1] == '#')
                            d[i1][j1] = letter;
            }
    
    printf("%lld\n", answer);
}

```

At 6:41:48, this gave the correct answer in one try. This gave me the
lowest rank sofar.

### Executing this page

The command to process this markdown file, is:
```
../IParse/software/MarkDownC Std.md Day12.md >day12.c; gcc -g -Wall day12.c -o day12; ./day12 12
```
I run the bash file [`runOnSave.sh`](runOnSave.sh) with `12` as the argument,
which everytime when I save this file, runs the above command and shows the
result or the first compile errors, if there are any.


