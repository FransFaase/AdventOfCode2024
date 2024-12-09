# Day 9 of Advent of Code 2024

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

My input is 19999 characters long. This means the maximum number of positions
needed will be at most ten fold this number.

```c

num_t disk[10*19999];
void solve1()
{
    int m = 0;
    int file_nr = 0;
    for (char *s = d[0]; *s != '\0'; s++)
    {
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = file_nr;
        file_nr++;
        s++;
        if (*s == '\0')
            break;
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = -1;
    }
    
    for (int b = 0; b < m; b++)
    {
        while (disk[m-1] == -1)
            m--;
        if (disk[b] == -1)
            disk[b] = disk[--m];
    }
    
    num_t sum = 0;
    for (int i = 0; i < m; i++)
        sum = i * disk[i];
                
    printf("%lld\n", sum);
}
```

At 6:20, the above code did not return the correct answer. Lets try it on the
example input, and add some debugging statements;

```c

void pre() { use_sample = TRUE; }

void solve1()
{
    int m = 0;
    int file_nr = 0;
    for (char *s = d[0]; *s != '\0'; s++)
    {
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = file_nr;
        file_nr++;
        s++;
        if (*s == '\0')
            break;
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = -1;
    }
    
    for (int b = 0; b < m; b++)
    {
        while (disk[m-1] == -1)
            m--;
        if (disk[b] == -1)
        {
            disk[b] = disk[--m];
            for (int i = 0; i < m; i++)
                if (disk[i] == -1)
                    printf(".");
                else
                    printf("%lld", disk[i]);
            printf("\n");
        }
    }
    
    num_t sum = 0;
    for (int i = 0; i < m; i++)
        sum = i * disk[i];
                
    printf("%lld\n", sum);
}
```

At 6:25, that resulted in a segmentation fault. Which was due to
not having the sample input a newline at the end of the first line.

```c

void pre() { use_sample = FALSE; }

void solve1()
{
    int m = 0;
    int file_nr = 0;
    for (char *s = d[0]; *s != '\0'; s++)
    {
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = file_nr;
        file_nr++;
        s++;
        if (*s == '\0')
            break;
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = -1;
    }
    
    for (int b = 0; b < m; b++)
    {
        while (disk[m-1] == -1)
            m--;
        if (disk[b] == -1)
            disk[b] = disk[--m];
    }
    
    num_t sum = 0;
    for (int i = 0; i < m; i++)
        sum += i * disk[i];
                
    printf("%lld\n", sum);
}
```

At 6:30, the above program did return the correct value on the
example input, but not on my input. (The bug was that I did not
add the multiplication of the 'checksum' values.)

```c

void print128(__int128 value)
{
    char buffer[100];
    buffer[99] = '\0';
    char *s = buffer + 99;
    while (value > 0)
    {
        s--;
        *s = '0' + value % 10;
        value = value / 10;
    }
    printf("%s", s);
}

void solve1()
{
    int m = 0;
    int file_nr = 0;
    for (char *s = d[0]; *s != '\0'; s++)
    {
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = file_nr;
        file_nr++;
        s++;
        if (*s == '\0')
            break;
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = -1;
    }
    
    for (int b = 0; b < m; b++)
    {
        while (disk[m-1] == -1)
            m--;
        if (disk[b] == -1)
            disk[b] = disk[--m];
    }
    
    __int128 sum = 0;
    for (__int128 i = 0; i < m; i++)
        sum += i * disk[i];
                
    print128(sum);
    printf("\n");
}
```

At 6:43, that still returned the same answer. I am rather
stuck now. I am pretty sure there are no empty spaces left,
but lets just check.

```c

void solve1()
{
    int m = 0;
    int file_nr = 0;
    for (char *s = d[0]; *s != '\0'; s++)
    {
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = file_nr;
        file_nr++;
        s++;
        if (*s == '\0')
            break;
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = -1;
    }
    
    for (int b = 0; b < m; b++)
    {
        while (disk[m-1] == -1)
            m--;
        if (disk[b] == -1)
            disk[b] = disk[--m];
    }
    
    __int128 sum = 0;
    for (__int128 i = 0; i < m; i++)
        if (disk[i] != -1)
            sum += i * disk[i];
                
    print128(sum);
    printf("\n");
}
```

Yes, it returns the same number. Lets study the code again
to see if there is maybe something wrong with it. I decided
to reimplement the compact algorithm in a different way.

```c

void pre() { use_sample = FALSE; }

void solve1()
{
    int m = 0;
    int file_nr = 0;
    for (char *s = d[0]; *s != '\0'; s++)
    {
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = file_nr;
        file_nr++;
        s++;
        if (*s == '\0')
            break;
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = -1;
    }
    
    for (int b = 0; b < m; b++)
        if (disk[b] == -1)
        {
            // search for left most value
            int e = m-1;
            for (; e >= 0; e--)
                if (disk[e] != -1)
                    break;
            if (e <= b)
                break;
            disk[b] = disk[e];
            disk[e] = -1;
        }
    
    __int128 sum = 0;
    for (__int128 i = 0; i < m; i++)
        if (disk[i] != -1)
            sum += i * disk[i];
                
    print128(sum);
    printf("\n");
}
```

At 6:56, that did return a slightly different answer that was
correct.


### Second part of the puzzle.

Okay, that was something to be expected.

```c
void pre() { use_sample = TRUE; }

void solve2()
{
    int m = 0;
    int file_nr = 0;
    for (char *s = d[0]; *s != '\0'; s++)
    {
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = file_nr;
        file_nr++;
        s++;
        if (*s == '\0')
            break;
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = -1;
    }
    
    for (int b = 0; b < m; b++)
        if (disk[b] == -1)
        {
            // determine the size of the gap
            int g = 1;
            while (b + g < m && disk[b + g] == -1)
                g++;
            
            // search for left most file
            int best_e = -1;
            int max_l = 0;
            int e = m-1;
            for (; e > b + g; e--)
                if (disk[e] != -1)
                {
                    // determine file length
                    int l = 1;
                    while (e - l > 0 && disk[e - l] == disk[e])
                        l++;
                    if (e - l <= b + g)
                        break;
                    if (l > max_l)
                    {
                        max_l = l;
                        best_e = e - l;
                    }
                    e -= l - 1;
                }
            for (int i = 0; i < max_l; i++)
            {
                disk[b + i] = disk[best_e + i];
                disk[best_e + i] = -1;
            }
            for (int i = 0; i < m; i++)
                if (disk[i] == -1)
                    printf(".");
                else
                    printf("%lld", disk[i]);
            printf("\n");
        }
    
    __int128 sum = 0;
    for (__int128 i = 0; i < m; i++)
        if (disk[i] != -1)
            sum += i * disk[i];
                
    print128(sum);
    printf("\n");
}

```

At 7:20, I tested this on the example input, and it gave the wrong answer.

Looking at the debug output, it looks like you just have to take the
first from the back that fits, not the best fit.

```c
void pre() { use_sample = TRUE; }

void solve2()
{
    int m = 0;
    int file_nr = 0;
    for (char *s = d[0]; *s != '\0'; s++)
    {
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = file_nr;
        file_nr++;
        s++;
        if (*s == '\0')
            break;
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = -1;
    }
    
    for (int b = 0; b < m; b++)
        if (disk[b] == -1)
        {
            // determine the size of the gap
            int g = 1;
            while (b + g < m && disk[b + g] == -1)
                g++;
            
            // search for left most file
            int best_e = -1;
            int max_l = 0;
            int e = m-1;
            for (; e > b + g; e--)
                if (disk[e] != -1)
                {
                    // determine file length
                    int l = 1;
                    while (e - l > 0 && disk[e - l] == disk[e])
                        l++;
                    printf("%d %d: %d\n", e - l, l, disk[e]);
                    if (e - l <= b + g)
                        break;
                    if (l > max_l)
                    {
                        max_l = l;
                        best_e = e - l;
                        break;
                    }
                    e -= l - 1;
                }
            for (int i = 0; i < max_l; i++)
            {
                disk[b + i] = disk[best_e + i];
                disk[best_e + i] = -1;
            }
            for (int i = 0; i < m; i++)
                if (disk[i] == -1)
                    printf(".");
                else
                    printf("%lld", disk[i]);
            printf("\n");
        }
    
    __int128 sum = 0;
    for (__int128 i = 0; i < m; i++)
        if (disk[i] != -1)
            sum += i * disk[i];
                
    print128(sum);
    printf("\n");
}

```

Still did not return the correct answer for the example input.

```c
void pre() { use_sample = TRUE; }

void solve2()
{
    int m = 0;
    int file_nr = 0;
    for (char *s = d[0]; *s != '\0'; s++)
    {
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = file_nr;
        file_nr++;
        s++;
        if (*s == '\0')
            break;
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = -1;
    }
    
    for (int b = 0; b < m; b++)
        if (disk[b] == -1)
        {
            // determine the size of the gap
            int g = 1;
            while (b + g < m && disk[b + g] == -1)
                g++;
            
            // search for left most file
            int best_e = -1;
            int max_l = 0;
            int e = m-1;
            for (; e > b + g; e--)
                if (disk[e] != -1)
                {
                    // determine file length
                    int l = 1;
                    while (e - l > 0 && disk[e - l] == disk[e])
                        l++;
                    printf("%d %d: %d\n", e - l, l, disk[e]);
                    if (e - l <= b + g)
                        break;
                    if (l > max_l && l <= g)
                    {
                        max_l = l;
                        best_e = e - l + 1;
                        break;
                    }
                    e -= l - 1;
                }
            for (int i = 0; i < max_l; i++)
            {
                printf("copy %d to %d: %d\n", best_e + i, b + i, disk[best_e + i]);
                disk[b + i] = disk[best_e + i];
                disk[best_e + i] = -1;
            }
            for (int i = 0; i < m; i++)
                if (disk[i] == -1)
                    printf(".");
                else
                    printf("%lld", disk[i]);
            printf("\n");
        }
    
    __int128 sum = 0;
    for (__int128 i = 0; i < m; i++)
        if (disk[i] != -1)
            sum += i * disk[i];
                
    print128(sum);
    printf("\n");
}

```

I made several edits and compiles in the above code. It looks
like I got the algoritm wrong. You have to try to move the files
from the back into a empty space from the start.

```c
void pre() { use_sample = TRUE; }

void solve2()
{
    int m = 0;
    int file_nr = 0;
    for (char *s = d[0]; *s != '\0'; s++)
    {
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = file_nr;
        file_nr++;
        s++;
        if (*s == '\0')
            break;
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = -1;
    }

    for (int e = m-1; e >= 0; e--)
        if (disk[e] != -1)
        {
            // determine file length    
            int l = 1;
            while (e - l >= 0 && disk[e - l] == disk[e])
                l++;
            printf("%d %d: %d\n", e - l, l, disk[e]);
            
            // Search for a gab from the start
            for (int b = 0; b < m; b++)
                if (disk[b] == -1)
                {
                    // determine the size of the gap
                    int g = 1;
                    while (b + g < m && disk[b + g] == -1)
                        g++;
                    // gap should be before the file
                    if (b + g >= e - l)
                        break;
                    if (g >= l)
                    {
                        for (int i = 0; i < l; i++)
                        {
                            printf("copy %d to %d: %d\n", e - i, b + i, disk[e - i]);
                            disk[b + i] = disk[e - i];
                            disk[e - i] = -1;
                        }
                        break;
                    }
                }
            e -= l - 1;
            for (int i = 0; i < m; i++)
                if (disk[i] == -1)
                    printf(".");
                else
                    printf("%lld", disk[i]);
            printf("\n");
        }
    
    __int128 sum = 0;
    for (__int128 i = 0; i < m; i++)
        if (disk[i] != -1)
            sum += i * disk[i];
                
    print128(sum);
    printf("\n");
}

```

At 7:58, that gave the correct answer (after many tries) to the example input.

```c
void pre() { use_sample = FALSE; }

void solve2()
{
    int m = 0;
    int file_nr = 0;
    for (char *s = d[0]; *s != '\0'; s++)
    {
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = file_nr;
        file_nr++;
        s++;
        if (*s == '\0')
            break;
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = -1;
    }

    for (int e = m-1; e >= 0; e--)
        if (disk[e] != -1)
        {
            // determine file length    
            int l = 1;
            while (e - l >= 0 && disk[e - l] == disk[e])
                l++;
            //printf("%d %d: %d\n", e - l, l, disk[e]);
            
            // Search for a gab from the start
            for (int b = 0; b < m; b++)
                if (disk[b] == -1)
                {
                    // determine the size of the gap
                    int g = 1;
                    while (b + g < m && disk[b + g] == -1)
                        g++;
                    // gap should be before the file
                    if (b + g >= e - l)
                        break;
                    if (g >= l)
                    {
                        for (int i = 0; i < l; i++)
                        {
                            //printf("copy %d to %d: %d\n", e - i, b + i, disk[e - i]);
                            disk[b + i] = disk[e - i];
                            disk[e - i] = -1;
                        }
                        break;
                    }
                }
            e -= l - 1;
            //for (int i = 0; i < m; i++)
            //    if (disk[i] == -1)
            //        printf(".");
            //    else
            //        printf("%lld", disk[i]);
            //printf("\n");
        }
    
    __int128 sum = 0;
    for (__int128 i = 0; i < m; i++)
        if (disk[i] != -1)
            sum += i * disk[i];
                
    print128(sum);
    printf("\n");
}

```

But did not return the correct answer for my input. I am probably
making a one off error somewhere. At the moment, I do not have the
patience to have a look at it. Maybe will try in the evening again.
With 5907 gold stars and 5189 silver stars (at 8:01) it looks like
I am not the only one struggling with the second part.

At 8:26, lets try to write a file iterator:

```c
void pre() { use_sample = TRUE; }

void solve2()
{
    int m = 0;
    int file_nr = 0;
    for (char *s = d[0]; *s != '\0'; s++)
    {
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = file_nr;
        file_nr++;
        s++;
        if (*s == '\0')
            break;
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = -1;
    }

    for (int e = m-1; e >= 0; e--)
        if (disk[e] != -1)
        {
            // determine file length
            int v = disk[e];
            int l = 1;
            while (e > 0 && disk[e - 1] == v)
            {
                l++;
                e--;
            }
            printf("%d %d: ", e, l);
            for (int i = 0; i < l; i++)
                printf("%d", disk[e + i]);
            printf("\n");
        }
}

```

At 8:36, lets try to write a gab iterator:

```c
void pre() { use_sample = TRUE; }

void solve2()
{
    int m = 0;
    int file_nr = 0;
    for (char *s = d[0]; *s != '\0'; s++)
    {
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = file_nr;
        file_nr++;
        s++;
        if (*s == '\0')
            break;
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = -1;
    }

    for (int b = 0; b < m; b++)
        if (disk[b] == -1)
        {
            // determine file length
            int g = 1;
            while (b + g < m && disk[b + g] == -1)
                g++;
            printf("%d %d: ", b, g);
            for (int i = 0; i < g; i++)
                printf("%d", disk[b + i]);
            printf("\n");
            b += g - 1;
        }
}

```

At 8:40, lets try to combine these:

```c
void pre() { use_sample = TRUE; }

void solve2()
{
    int m = 0;
    int file_nr = 0;
    for (char *s = d[0]; *s != '\0'; s++)
    {
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = file_nr;
        file_nr++;
        s++;
        if (*s == '\0')
            break;
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = -1;
    }

    for (int e = m-1; e >= 0; e--)
        if (disk[e] != -1)
        {
            // determine file length
            int v = disk[e];
            int l = 1;
            while (e > 0 && disk[e - 1] == v)
            {
                l++;
                e--;
            }
            for (int b = 0; b < m; b++)
                if (disk[b] == -1)
                {
                    // determine file length
                    int g = 1;
                    while (b + g < m && disk[b + g] == -1)
                        g++;
                    printf("%d %d: ", b, g);
                    for (int i = 0; i < g; i++)
                        printf("%d", disk[b + i]);
                    printf("\n");
                    
                    // If gap is after file, exit
                    if (b >= e)
                        break;

                    if (g >= l)
                    {
                        for (int i = 0; i < l; i++)
                        {
                            disk[b + i] = disk[e + i];
                            disk[e + i] = -1;
                        }
                        for (int i = 0; i < m; i++)
                            if (disk[i] == -1)
                                printf(".");
                            else
                                printf("%lld", disk[i]);
                        printf("\n");
                        break;
                    }
                    b += g - 1;
                }
        }
    
    __int128 sum = 0;
    for (__int128 i = 0; i < m; i++)
        if (disk[i] != -1)
            sum += i * disk[i];
                
    print128(sum);
    printf("\n");
}

```

At 8:50, this gave the correct answer for the example input:

```c
void pre() { use_sample = FALSE; }

void solve2()
{
    int m = 0;
    int file_nr = 0;
    for (char *s = d[0]; *s != '\0'; s++)
    {
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = file_nr;
        file_nr++;
        s++;
        if (*s == '\0')
            break;
        for (int i = 0; i < *s - '0'; i++)
            disk[m++] = -1;
    }

    for (int e = m-1; e >= 0; e--)
        if (disk[e] != -1)
        {
            // determine file length
            int v = disk[e];
            int l = 1;
            while (e > 0 && disk[e - 1] == v)
            {
                l++;
                e--;
            }
            for (int b = 0; b < m; b++)
                if (disk[b] == -1)
                {
                    // determine file length
                    int g = 1;
                    while (b + g < m && disk[b + g] == -1)
                        g++;
                    
                    // If gap is after file, exit
                    if (b >= e)
                        break;

                    if (g >= l)
                    {
                        for (int i = 0; i < l; i++)
                        {
                            disk[b + i] = disk[e + i];
                            disk[e + i] = -1;
                        }
                        break;
                    }
                    b += g - 1;
                }
        }
    
    __int128 sum = 0;
    for (__int128 i = 0; i < m; i++)
        if (disk[i] != -1)
            sum += i * disk[i];
                
    print128(sum);
    printf("\n");
}

```

At 8:52:45, that found the correct answer.


### Executing this page

The command to process this markdown file, is:
```
../IParse/software/MarkDownC Std.md Day09.md >day09.c; gcc -g -Wall day09.c -o day09; ./day09 09
```
I run the bash file [`runOnSave.sh`](runOnSave.sh) with `09` as the argument,
which everytime when I save this file, runs the above command and shows the
result or the first compile errors, if there are any.


