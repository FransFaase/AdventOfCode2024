# Day 4 of Advent of Code 2024

The code below makes use of [a standard library](Std.md), which
also contains the `main` function that reads the input in the global variable `d`
where `n` contains the number of lines and `m` the length of the longest line,
and than calls the function `solve1` and `solve2`.

```c

num_t number = 0;

void search(char *s, int i, int j)
{
    if (*s == '\0')
    {
        number++;
        return;
    }
    if (d[i][j] == *s)
    {
        s++;
        if (i > 0) search(s, i-1, j);
        if (i < n - 1) search(s, i+1, j);
        if (j > 0) search(s, i, j-1);
        if (j < m - 1) search(s, i, j+1);
    }
}
 
void solve1()
{
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            search("XMAS", i, j);
            
    printf("%d\n", number);
}
```

Totally misunderstood the puzzle.

```c

int di[8] = { -1, -1,  0,  1,  1,  1,  0, -1 };
int dj[8] = {  0, -1, -1, -1,  0,  1,  1,  1 };

char dd(int i, int j) { return i < 0 || i >= n || j < 0 || j >= m ? ' ' : d[i][j]; }

void solve1()
{
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            for (int dir = 0; dir < 8; dir++)
                for (int s = 0; s < 4 && dd(i + s * di[dir], j + s * dj[dir]) == "XMAS"[s]; s++)
                    if (s == 3)
                        number++;
    printf("%d\n", number);
}
```

That did return the correct answer.

### Second part of the puzzle.

```c

void solve2()
{
    num_t number2 = 0;
    for (int i = 1; i < n-1; i++)
        for (int j = 1; j < m-1; j++)
            if (d[i][j] == 'A')
            {
                char p[5];
                p[0] = d[i-1][j-1];
                p[1] = d[i-1][j+1];
                p[2] = d[i+1][j+1];
                p[3] = d[i+1][j-1];
                p[4] = '\0';
                if (   strcmp(p, "MMSS") == 0
                    || strcmp(p, "SMMS") == 0
                    || strcmp(p, "SSMM") == 0
                    || strcmp(p, "MSSM") == 0)
                    number2++;
            }
    printf("%d\n", number2);
}

```
That found the correct answer. During the day, I did think a
bit about other ways I could have solved the second half of the
puzzle with two loops, similar to what I did for the first.

```c
void solve2()
{
    ...
    num_t number3 = 0;
    for (int i = 1; i < n-1; i++)
        for (int j = 1; j < m-1; j++)
            if (d[i][j] == 'A')
                for (int s = 0; s < 4; s++)
                    for (int dir = 0; dir < 4 && dd(i + di[1 + 2*dir], j + dj[1 + 2*dir]) == "MMSSMMS"[dir + s]; dir++)
                        if (dir == 3)
                            number3++;
    printf("%d\n", number3);
}
```

I needed a number of tries to get the above code correctly. I guess
it was the decision to solve it in the way I did above.

### Executing this page

The command to process this markdown file, is:
```
../IParse/software/MarkDownC Std.md Day04.md >day04.c; gcc -g -Wall day04.c -o day04; ./day04 04
```
I run the bash file [`runOnSave.sh`](runOnSave.sh) with `04` as the argument,
which everytime when I save this file, runs the above command and shows the
result or the first compile errors, if there are any.


