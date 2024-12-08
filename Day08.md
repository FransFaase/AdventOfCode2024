# Day 8 of Advent of Code 2024

The code below makes use of [a standard library](Std.md), which
also contains the `main` function that reads the input in the global variable `d`
where `n` contains the number of lines and `m` the length of the longest line,
and than calls the function `solve1` and `solve2`.

```c

bool antinode[50][50];

void solve1()
{
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            antinode[i][j] = FALSE;
            
    for (int i1 = 0; i1 < n; i1++)
        for (int j1 = 0; j1 < m; j1++)
            if (d[i1][j1] != '.')
                for (int i2 = 0; i2 < n; i2++)
                    for (int j2 = 0; j2 < m; j2++)
                        if (d[i2][j2] == d[i1][j1])
                        {
                            int di = i1 - i2;
                            int dj = j1 - j2;
                            if (di != 0 || dj != 0)
                            {
                                int i3 = i1 + di;
                                int j3 = j1 + dj;
                                if (i3 >= 0 && i3 < n && j3 >= 0 && j3 < m)
                                    antinode[i3][j3] = TRUE;
                            }
                        }
    int count = 0;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            if (antinode[i][j])
                count++;
                
    printf("%d\n", count);
}
```

At 6:14:34, that found the correct answer in one try
with no compile errors.

### Second part of the puzzle.

```c
void solve2()
{
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            antinode[i][j] = FALSE;
            
    for (int i1 = 0; i1 < n; i1++)
        for (int j1 = 0; j1 < m; j1++)
            if (d[i1][j1] != '.')
                for (int i2 = 0; i2 < n; i2++)
                    for (int j2 = 0; j2 < m; j2++)
                        if (d[i2][j2] == d[i1][j1])
                        {
                            int di = i1 - i2;
                            int dj = j1 - j2;
                            if (di != 0 || dj != 0)
                            {
                                int i3 = i1 + di;
                                int j3 = j1 + dj;
                                while (i3 >= 0 && i3 < n && j3 >= 0 && j3 < m)
                                {
                                    antinode[i3][j3] = TRUE;
                                    i3 += di;
                                    j3 += dj;
                                }
                            }
                        }
    int count = 0;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            if (antinode[i][j])
                count++;
                
    printf("%d\n", count);
}

```

That did not return the correct answer. I went back to reading
the puzzle description and after some reading, realized that the
antenna itself should also be counted. That meant only a small
change in the assignment of `i3` and `j3`.

```c
void solve2()
{
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            antinode[i][j] = FALSE;
            
    for (int i1 = 0; i1 < n; i1++)
        for (int j1 = 0; j1 < m; j1++)
            if (d[i1][j1] != '.')
                for (int i2 = 0; i2 < n; i2++)
                    for (int j2 = 0; j2 < m; j2++)
                        if (d[i2][j2] == d[i1][j1])
                        {
                            int di = i1 - i2;
                            int dj = j1 - j2;
                            if (di != 0 || dj != 0)
                            {
                                int i3 = i1;
                                int j3 = j1;
                                while (i3 >= 0 && i3 < n && j3 >= 0 && j3 < m)
                                {
                                    antinode[i3][j3] = TRUE;
                                    i3 += di;
                                    j3 += dj;
                                }
                            }
                        }
    int count = 0;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            if (antinode[i][j])
                count++;
                
    printf("%d\n", count);
}

```

At 6:19:34, that returned the correct answer.

### Executing this page

The command to process this markdown file, is:
```
../IParse/software/MarkDownC Std.md Day08.md >day08.c; gcc -g -Wall day08.c -o day08; ./day08 08
```
I run the bash file [`runOnSave.sh`](runOnSave.sh) with `08` as the argument,
which everytime when I save this file, runs the above command and shows the
result or the first compile errors, if there are any.


