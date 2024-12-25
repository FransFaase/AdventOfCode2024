# Day 25 of Advent of Code 2024

The code below makes use of [a standard library](Std.md), which
also contains the `main` function that reads the input in the global variable `d`
where `n` contains the number of lines and `m` the length of the longest line,
and than calls the function `solve1` and `solve2`.

```c
void solve1()
{
    num_t count = 0;
    for (int i1 = 0; i1 < n; i1 += 8)
        for (int i2 = i1 + 8; i2 < n; i2 += 8)
        {
            bool ok = TRUE;
            for (int i = 0; i < 7 && ok; i++)
                for (int j = 0; j < m; j++)
                    ok = d[i1+i][j] == '.' || d[i2+i][j] == '.';
            if (ok)
                count++;
        }
    
    printf("%d\n", count);
}
```

At 6:11, it did not return the correct answer. Lets try
the example input.

```c
bool use_sample = TRUE;

void solve1()
{
    num_t count = 0;
    for (int i1 = 0; i1 < n; i1 += 8)
        for (int i2 = i1 + 8; i2 < n; i2 += 8)
        {
            bool ok = TRUE;
            for (int i = 0; i < 7 && ok; i++)
                for (int j = 0; j < m && ok; j++)
                    ok = d[i1+i][j] == '.' || d[i2+i][j] == '.';
            if (ok)
            {
                printf("%d %d\n", i1,i2);
                for (int i = 0; i < 7; i++)
                    printf("%s %s\n", d[i1+i], d[i2+i]);
                count++;
            }
        }
    
    printf("%d\n", count);
}
```

At 6:17, it returned the correct answer for the example input.

```c
bool use_sample = FALSE;
```

At 6:18:26, this returned the correct answer and at 6:18:51 I got
the fifthied star for this year at rank 1719. Could have been
better if I had not made that one little mistake.


### Executing this page

The command to process this markdown file, is:
```
../IParse/software/MarkDownC Std.md Day25.md >day25.c; gcc -g -Wall day25.c -o day25; ./day25 25
```
I run the bash file [`runOnSave.sh`](runOnSave.sh) with `25` as the argument,
which everytime when I save this file, runs the above command and shows the
result or the first compile errors, if there are any.


