# Day 22 of Advent of Code 2024

The code below makes use of [a standard library](Std.md), which
also contains the `main` function that reads the input in the global variable `d`
where `n` contains the number of lines and `m` the length of the longest line,
and than calls the function `solve1` and `solve2`.

At 9:45, I started reading the puzzle. At 9:51, I started writing this.

```c

#define PRUNEMIX(X,Y) (((X) ^ (Y)) % 16777216)

num_t next(num_t secret)
{
    secret = PRUNEMIX(secret, secret * 64);
    secret = PRUNEMIX(secret, secret / 32);
    secret = PRUNEMIX(secret, secret % 2048);
    return secret;
}

void solve1()
{
    num_t secret = 123;
    for (int i = 0; i < 10; i++)
    {
        secret = next(secret);
        printf("%lld\n", secret);
    }
}
```

At 10:06, that does not return the expected result for 123.

```c
num_t next(num_t secret)
{
    secret = PRUNEMIX(secret, secret * 64);
    secret = PRUNEMIX(secret, secret / 32);
    secret = PRUNEMIX(secret, secret * 2048);
    return secret;
}
```

At 10:09, that did return the correct sequence.

```c
void solve1()
{
    num_t answer = 0;
    for (int i = 0; i < n; i++)
    {
        char *s = d[i];
        num_t secret = parse_number(&s);
        for (int j = 0; j < 2000; j++)
            secret = next(secret);
        answer += secret;
    }
    printf("%lld\n", answer);
}
```

At 10:12:46, that returned the correct answer for my puzzle input.


### Second part of the puzzle.

At 10:18, I finished reading the description. I am first
going to implement the algorith for detecting a sequence.

```c
void solve2()
{
    num_t secret = 123;
    num_t seq[4];
    seq[3] = secret % 10;
    for (int j = 0; j < 10; j++)
    {
        secret = next(secret);
        seq[0] = seq[1];
        seq[1] = seq[2];
        seq[2] = seq[3];
        seq[3] = secret % 10 - seq[3];
        printf("%10lld: %lld (%lld)\n", secret, secret % 10, seq[3]);
    }
}

```

At 10:27, the above code does not return the correct answer.

```c
void solve2()
{
    num_t secret = 123;
    int seq[4];
    int prev = secret % 10;
    for (int j = 0; j < 10; j++)
    {
        secret = next(secret);
        seq[0] = seq[1];
        seq[1] = seq[2];
        seq[2] = seq[3];
        seq[3] = secret % 10 - prev;
        prev = secret % 10;
        printf("%10lld: %d (%d)\n", secret, secret % 10, seq[3]);
    }
}

```

At 10:30 that does return the correc sequence. Now test this
on the example input.

```c

num_t match(int *search, num_t secret)
{
    int seq[4];
    int prev = secret % 10;
    for (int j = 0; j < 2000; j++)
    {
        secret = next(secret);
        seq[0] = seq[1];
        seq[1] = seq[2];
        seq[2] = seq[3];
        seq[3] = secret % 10 - prev;
        if (   j > 0 
            && seq[0] == search[0] 
            && seq[1] == search[1] 
            && seq[2] == search[2] 
            && seq[3] == search[3])
        {
            return secret % 10;
        }
        prev = secret % 10;
    }
    
    return 0;
}

void solve2()
{
    num_t example[4] = { 1, 2, 3, 2024 };
    int search[4] = { -2, 1, -1, 3 };
    for (int i = 0; i < 4; i++)
    {
        printf("%d\n", match(search, example[i]));
    }
}
        
```

At 10:37, it looks like the above code does work.
Now we only need to generate search sequences.
A search sequence like -5,-5 is not possible.

```c
void solve2()
{
    num_t max_bananas = 0;
    int search[4];
    for (search[0] = -9; search[0] <= 9; search[0]++)
        for (search[1] = -9; search[1] <= 9; search[1]++)
        {
            int sum01 = search[0] + search[1];
            if (-9 <= sum01 && sum01 <= 9)
                for (search[2] = -9; search[2] <= 9; search[2]++)
                {
                    int sum012 = sum01 + search[2];
                    if (-9 <= sum012 && sum012 <= 9)
                        for (search[3] = -9; search[3] <= 9; search[3]++)
                        {
                            int sum0123 = sum012 + search[3];
                            if (-9 <= sum0123 && sum0123 <= 9)
                            {
                                printf("%3d %3d %3d %3d:", search[0], search[1], search[2], search[3]);
                                num_t bananas = 0;
                                for (int i = 0; i < n; i++)
                                {
                                    char *s = d[1];
                                    num_t secret = parse_number(&s);
                                    bananas += match(search, secret);
                                }
                                printf(" %lld", bananas);
                                if (bananas > max_bananas)
                                {
                                    printf(" !!!");
                                    max_bananas = bananas;
                                }
                                printf("\n");
                            }
                        }
                }
        }
    printf("%lld\n", max_bananas);
}
```
At 11:01, the above program started running, but it is rather slow.
There are many sequences that return 0.

At 11:16, it is almost half way. Let see if we can find something
faster.

At 11:20, I discovered a bug in the `match` function. It should
have been:
```c
num_t match(int *search, num_t secret)
{
    int seq[4];
    int prev = secret % 10;
    for (int j = 0; j < 2000; j++)
    {
        secret = next(secret);
        seq[0] = seq[1];
        seq[1] = seq[2];
        seq[2] = seq[3];
        seq[3] = secret % 10 - prev;
        if (   j >= 3
            && seq[0] == search[0] 
            && seq[1] == search[1] 
            && seq[2] == search[2] 
            && seq[3] == search[3])
        {
            return secret % 10;
        }
        prev = secret % 10;
    }
    
    return 0;
}

```

Lets find a way to calculate all sequences:

```c
bool poss[19][19][19][19];

void fill()
{
    for (int i1 = 0; i1 < 19; i1++) 
        for (int i2 = 0; i2 < 19; i2++) 
            for (int i3 = 0; i3 < 19; i3++) 
                for (int i4 = 0; i4 < 19; i4++)
                    poss[i1][i2][i3][i4] = FALSE;

    for (int i = 0; i < n; i++)
    {
        char *s = d[1];
        num_t secret = parse_number(&s);
        int seq[4];
        int prev = secret % 10;
        for (int j = 0; j < 2000; j++)
        {
            secret = next(secret);
            seq[0] = seq[1];
            seq[1] = seq[2];
            seq[2] = seq[3];
            seq[3] = secret % 10 - prev;
            if (j >= 3)
                poss[seq[0]+9][seq[0]+9][seq[0]+9][seq[0]+9] = TRUE;
        }
    }
}

void solve2()
{
    fill();
    num_t max_bananas = 0;
    int search[4];
    for (search[0] = -9; search[0] <= 9; search[0]++)
        for (search[1] = -9; search[1] <= 9; search[1]++)
            for (search[2] = -9; search[2] <= 9; search[2]++)
                for (search[3] = -9; search[3] <= 9; search[3]++)
                    if (poss[search[0]+9][search[0]+9][search[0]+9][search[0]+9])
                    {
                        printf("%3d %3d %3d %3d:", search[0], search[1], search[2], search[3]);
                        num_t bananas = 0;
                        for (int i = 0; i < n; i++)
                        {
                            char *s = d[1];
                            num_t secret = parse_number(&s);
                            bananas += match(search, secret);
                        }
                        printf(" %lld", bananas);
                        if (bananas > max_bananas)
                        {
                            printf(" !!!");
                            max_bananas = bananas;
                        }
                        printf("\n");
                    }
    printf("%lld\n", max_bananas);
}
```

At 11:39, my first run did not return the correct answer.
Lets try with the improved algorithm and the fix for the `match` function.

At 11:42, the improved program does not look to work as expected.

```c
void fill()
{
    for (int i1 = 0; i1 < 19; i1++) 
        for (int i2 = 0; i2 < 19; i2++) 
            for (int i3 = 0; i3 < 19; i3++) 
                for (int i4 = 0; i4 < 19; i4++)
                    poss[i1][i2][i3][i4] = FALSE;

    for (int i = 0; i < n; i++)
    {
        char *s = d[1];
        num_t secret = parse_number(&s);
        int seq[4];
        int prev = secret % 10;
        for (int j = 0; j < 2000; j++)
        {
            secret = next(secret);
            seq[0] = seq[1];
            seq[1] = seq[2];
            seq[2] = seq[3];
            seq[3] = secret % 10 - prev;
            if (j >= 3)
                poss[seq[0]+9][seq[1]+9][seq[2]+9][seq[3]+9] = TRUE;
        }
    }
}

void solve2()
{
    fill();
    num_t max_bananas = 0;
    int search[4];
    for (search[0] = -9; search[0] <= 9; search[0]++)
        for (search[1] = -9; search[1] <= 9; search[1]++)
            for (search[2] = -9; search[2] <= 9; search[2]++)
                for (search[3] = -9; search[3] <= 9; search[3]++)
                    if (poss[search[0]+9][search[1]+9][search[2]+9][search[3]+9])
                    {
                        printf("%3d %3d %3d %3d:", search[0], search[1], search[2], search[3]);
                        num_t bananas = 0;
                        for (int i = 0; i < n; i++)
                        {
                            char *s = d[1];
                            num_t secret = parse_number(&s);
                            bananas += match(search, secret);
                        }
                        printf(" %lld", bananas);
                        if (bananas > max_bananas)
                        {
                            printf(" !!!");
                            max_bananas = bananas;
                        }
                        printf("\n");
                    }
    printf("%lld\n", max_bananas);
}
```

At 11:44, again it looks like it is not working.

```c
void fill()
{
    for (int i1 = 0; i1 < 19; i1++) 
        for (int i2 = 0; i2 < 19; i2++) 
            for (int i3 = 0; i3 < 19; i3++) 
                for (int i4 = 0; i4 < 19; i4++)
                    poss[i1][i2][i3][i4] = FALSE;

    for (int i = 0; i < n; i++)
    {
        char *s = d[1];
        num_t secret = parse_number(&s);
        int seq[4];
        int prev = secret % 10;
        for (int j = 0; j < 2000; j++)
        {
            secret = next(secret);
            seq[0] = seq[1];
            seq[1] = seq[2];
            seq[2] = seq[3];
            seq[3] = secret % 10 - prev;
            if (j >= 3)
                poss[seq[0]+9][seq[1]+9][seq[2]+9][seq[3]+9] = TRUE;
            prev = secret % 10;
        }
    }
}
```

At 11:47, the above program, now much faster, finds the same
number as before.

Let see how it works on the example input. It should find the
same best sequence.

```c
bool use_sample = TRUE;
```

At 11:50, I see that it does not return the correct answer.

```c
void fill()
{
    for (int i1 = 0; i1 < 19; i1++) 
        for (int i2 = 0; i2 < 19; i2++) 
            for (int i3 = 0; i3 < 19; i3++) 
                for (int i4 = 0; i4 < 19; i4++)
                    poss[i1][i2][i3][i4] = FALSE;

    for (int i = 0; i < n; i++)
    {
        char *s = d[i];
        num_t secret = parse_number(&s);
        int seq[4];
        int prev = secret % 10;
        for (int j = 0; j < 2000; j++)
        {
            secret = next(secret);
            seq[0] = seq[1];
            seq[1] = seq[2];
            seq[2] = seq[3];
            seq[3] = secret % 10 - prev;
            if (j >= 3)
                poss[seq[0]+9][seq[1]+9][seq[2]+9][seq[3]+9] = TRUE;
            prev = secret % 10;
        }
    }
}

void solve2()
{
    fill();
    num_t max_bananas = 0;
    int search[4];
    for (search[0] = -9; search[0] <= 9; search[0]++)
        for (search[1] = -9; search[1] <= 9; search[1]++)
            for (search[2] = -9; search[2] <= 9; search[2]++)
                for (search[3] = -9; search[3] <= 9; search[3]++)
                    if (poss[search[0]+9][search[1]+9][search[2]+9][search[3]+9])
                    {
                        printf("%3d %3d %3d %3d:", search[0], search[1], search[2], search[3]);
                        num_t bananas = 0;
                        for (int i = 0; i < n; i++)
                        {
                            char *s = d[i];
                            num_t secret = parse_number(&s);
                            int v = match(search, secret);
                            printf(" %d", v);
                            bananas += v;
                        }
                        printf(" %lld", bananas);
                        if (bananas > max_bananas)
                        {
                            printf(" !!!");
                            max_bananas = bananas;
                        }
                        printf("\n");
                    }
    printf("%lld\n", max_bananas);
}
```

At 11:56, I verified that it now does return the correct answer on
the example input.

```c
bool use_sample = FALSE;

void solve2()
{
    fill();
    num_t max_bananas = 0;
    int search[4];
    for (search[0] = -9; search[0] <= 9; search[0]++)
        for (search[1] = -9; search[1] <= 9; search[1]++)
            for (search[2] = -9; search[2] <= 9; search[2]++)
                for (search[3] = -9; search[3] <= 9; search[3]++)
                    if (poss[search[0]+9][search[1]+9][search[2]+9][search[3]+9])
                    {
                        printf("%3d %3d %3d %3d:", search[0], search[1], search[2], search[3]);
                        num_t bananas = 0;
                        for (int i = 0; i < n; i++)
                        {
                            char *s = d[i];
                            num_t secret = parse_number(&s);
                            bananas += match(search, secret);
                        }
                        printf(" %lld", bananas);
                        if (bananas > max_bananas)
                        {
                            printf(" !!!");
                            max_bananas = bananas;
                        }
                        printf("\n");
                    }
    printf("%lld\n", max_bananas);
}

```

At 12:02, while waiting for the program to finish, I got another idea
to implement this:

```c
int sums[19][19][19][19];

void solve2()
{
    for (int i1 = 0; i1 < 19; i1++) 
        for (int i2 = 0; i2 < 19; i2++) 
            for (int i3 = 0; i3 < 19; i3++) 
                for (int i4 = 0; i4 < 19; i4++)
                    sums[i1][i2][i3][i4] = 0;

    for (int i = 0; i < n; i++)
    {
        char *s = d[i];
        num_t secret = parse_number(&s);
        int seq[4];
        int prev = secret % 10;
        for (int j = 0; j < 2000; j++)
        {
            secret = next(secret);
            seq[0] = seq[1];
            seq[1] = seq[2];
            seq[2] = seq[3];
            seq[3] = secret % 10 - prev;
            if (j >= 3)
                sums[seq[0]+9][seq[1]+9][seq[2]+9][seq[3]+9] += secret % 10;
            prev = secret % 10;
        }
    }

    int max_bananas = 0;
    for (int i1 = 0; i1 < 19; i1++) 
        for (int i2 = 0; i2 < 19; i2++) 
            for (int i3 = 0; i3 < 19; i3++) 
                for (int i4 = 0; i4 < 19; i4++)
                {
                    if (sums[i1][i2][i3][i4] > max_bananas)
                        max_bananas = sums[i1][i2][i3][i4];
                }
    printf("%d\n", max_bananas);
}
```

At 12:08, this does not return the correct answer. Lets try on
the example input.

```c
bool use_sample = TRUE;

void solve2()
{
    for (int i1 = 0; i1 < 19; i1++) 
        for (int i2 = 0; i2 < 19; i2++) 
            for (int i3 = 0; i3 < 19; i3++) 
                for (int i4 = 0; i4 < 19; i4++)
                    sums[i1][i2][i3][i4] = 0;

    for (int i = 0; i < n; i++)
    {
        char *s = d[i];
        num_t secret = parse_number(&s);
        int seq[4];
        int prev = secret % 10;
        for (int j = 0; j < 2000; j++)
        {
            secret = next(secret);
            seq[0] = seq[1];
            seq[1] = seq[2];
            seq[2] = seq[3];
            seq[3] = secret % 10 - prev;
            if (j >= 3)
                sums[seq[0]+9][seq[1]+9][seq[2]+9][seq[3]+9] += secret % 10;
            prev = secret % 10;
        }
    }

    int max_bananas = 0;
    for (int i1 = 0; i1 < 19; i1++) 
        for (int i2 = 0; i2 < 19; i2++) 
            for (int i3 = 0; i3 < 19; i3++) 
                for (int i4 = 0; i4 < 19; i4++)
                {
                    if (sums[i1][i2][i3][i4] > max_bananas)
                    {
                        printf("%2d %2d %2d %2d: %d\n", i1-9, i2-9, i3-9, i4-9, sums[i1][i2][i3][i4]);
                        max_bananas = sums[i1][i2][i3][i4];
                    }
                }
    printf("%d\n", max_bananas);
}
```

At 12:14, it does not return the correct answer. I think I have an
idea why.

```c
bool use_sample = TRUE;

void solve2()
{
    for (int i1 = 0; i1 < 19; i1++) 
        for (int i2 = 0; i2 < 19; i2++) 
            for (int i3 = 0; i3 < 19; i3++) 
                for (int i4 = 0; i4 < 19; i4++)
                    sums[i1][i2][i3][i4] = 0;

    for (int i = 0; i < n; i++)
    {
        for (int i1 = 0; i1 < 19; i1++) 
            for (int i2 = 0; i2 < 19; i2++) 
                for (int i3 = 0; i3 < 19; i3++) 
                    for (int i4 = 0; i4 < 19; i4++)
                        poss[i1][i2][i3][i4] = TRUE;
        char *s = d[i];
        num_t secret = parse_number(&s);
        int seq[4];
        int prev = secret % 10;
        for (int j = 0; j < 2000; j++)
        {
            secret = next(secret);
            seq[0] = seq[1];
            seq[1] = seq[2];
            seq[2] = seq[3];
            seq[3] = secret % 10 - prev;
            if (j >= 3 && poss[seq[0]+9][seq[1]+9][seq[2]+9][seq[3]+9])
            {
                sums[seq[0]+9][seq[1]+9][seq[2]+9][seq[3]+9] += secret % 10;
                poss[seq[0]+9][seq[1]+9][seq[2]+9][seq[3]+9] = FALSE;
            }
            prev = secret % 10;
        }
    }

    int max_bananas = 0;
    for (int i1 = 0; i1 < 19; i1++) 
        for (int i2 = 0; i2 < 19; i2++) 
            for (int i3 = 0; i3 < 19; i3++) 
                for (int i4 = 0; i4 < 19; i4++)
                {
                    if (sums[i1][i2][i3][i4] > max_bananas)
                    {
                        printf("%2d %2d %2d %2d: %d\n", i1-9, i2-9, i3-9, i4-9, sums[i1][i2][i3][i4]);
                        max_bananas = sums[i1][i2][i3][i4];
                    }
                }
    printf("%d\n", max_bananas);
}
```

At 12:21, not it does.

```c
bool use_sample = FALSE;
```

At 12:22:40, that returned the correct answer for my puzzle input.


### Executing this page

The command to process this markdown file, is:
```
../IParse/software/MarkDownC Std.md Day22.md >day22.c; gcc -g -Wall day22.c -o day22; ./day22 22
```
I run the bash file [`runOnSave.sh`](runOnSave.sh) with `22` as the argument,
which everytime when I save this file, runs the above command and shows the
result or the first compile errors, if there are any.


