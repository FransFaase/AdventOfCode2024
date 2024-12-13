# Day 13 of Advent of Code 2024

The code below makes use of [a standard library](Std.md), which
also contains the `main` function that reads the input in the global variable `d`
where `n` contains the number of lines and `m` the length of the longest line,
and than calls the function `solve1` and `solve2`.

In the morning, I did read the puzzle text, such that I could already
think about a possible solution.

At 21:23, I started working on solving the puzzles. So we need to solve
the equations:

```
A.X1 + B.X2 = X
A.Y1 + B.Y2 = Y

A.X1.Y1 + B.X2.Y1 = X.Y1
A.X1.Y1 + B.X1.Y2 = Y.X1
B.(X1.Y2 - X2.Y1) = Y.X1 - X.Y1

A.X1.Y2 + B.X2.Y2 = X.Y2
A.X2.Y1 + B.X2.Y2 = Y.X2
A.(X1.Y2 - X2.Y1) = X.Y2 - Y.X2 

```

At 21:30, I started writing:

```c
void solve1()
{
    num_t sum = 0;
    for (int i = 0; i < n; i += 4)
    {
        char *s;
        s = d[i] + 12;
        num_t x1 = parse_number(&s);
        s += 4;
        num_t y1 = parse_number(&s);
        s = d[i+1] + 12;
        num_t x2 = parse_number(&s);
        s += 4;
        num_t y2 = parse_number(&s);
        s = d[i+2] + 9;
        num_t x = parse_number(&s);
        s += 4;
        num_t y = parse_number(&s);
        
        num_t det = x1 * y2 - x2 * y1;
        if (det == 0)
        {
            num_t min_sum = 0;
            for (num_t a = 0; a * x1 <= x; a++)
            {
                num_t v = x - a * x1;
                if (v % x2 == 0)
                {
                    num_t p_sum = 3 * a + v / x2;
                    if (min_sum == 0 || p_sum < min_sum)
                        min_sum = p_sum;
                }
            }
            if (min_sum > 0)
                sum += min_sum;
        }
        else
        {
            num_t a = x * y2 - y * x2;
            num_t b = x * y1 - y * x1;
            if (a % det == 0 && b % det == 0)
                sum += (3 * a + b) / det;
        }
    }
    printf("%lld\n", sum);
}
```

At 21:50, did not return the correct answer.

```c
void pre() { use_sample = TRUE; }

void solve1()
{
    num_t sum = 0;
    for (int i = 0; i < n; i += 4)
    {
        char *s;
        s = d[i] + 12;
        num_t x1 = parse_number(&s);
        s += 4;
        num_t y1 = parse_number(&s);
        s = d[i+1] + 12;
        num_t x2 = parse_number(&s);
        s += 4;
        num_t y2 = parse_number(&s);
        s = d[i+2] + 9;
        num_t x = parse_number(&s);
        s += 4;
        num_t y = parse_number(&s);
        
        printf("%lld, %lld  %lld, %lld  %lld, %lld ", x1, y1, x2, y2, x, y);
        
        num_t det = x1 * y2 - x2 * y1;
        printf(" det = %lld: ", det);
        if (det == 0)
        {
            num_t min_sum = 0;
            for (num_t a = 0; a * x1 <= x; a++)
            {
                num_t v = x - a * x1;
                if (v % x2 == 0)
                {
                    num_t p_sum = 3 * a + v / x2;
                    if (min_sum == 0 || p_sum < min_sum)
                        min_sum = p_sum;
                }
            }
            printf("%lld", min_sum);
            if (min_sum > 0)
                sum += min_sum;
        }
        else
        {
            num_t a = x * y2 - y * x2;
            num_t b = y * x1 - x * y1;
            if (a % det == 0 && b % det == 0)
            {
                printf("%lld %lld  %lld", a / det, b / det, (3 * a + b) / det);
                sum += (3 * a + b) / det;
            }
        }
        printf("\n");
    }
    printf("%lld\n", sum);
}
```

At 22:01, I discovered that the problem is related to a sign error.
Lets try on my puzzle input.

```c
void pre() { use_sample = FALSE; }
```

At 22:03:20, this returned the answer for part two.

### Second part of the puzzle.

This rather simple with the solution that I already had implemented.

```c
void solve2()
{
    num_t sum = 0;
    for (int i = 0; i < n; i += 4)
    {
        char *s;
        s = d[i] + 12;
        num_t x1 = parse_number(&s);
        s += 4;
        num_t y1 = parse_number(&s);
        s = d[i+1] + 12;
        num_t x2 = parse_number(&s);
        s += 4;
        num_t y2 = parse_number(&s);
        s = d[i+2] + 9;
        num_t x = parse_number(&s) + 10000000000000L;
        s += 4;
        num_t y = parse_number(&s) + 10000000000000L;
        
        printf("%lld, %lld  %lld, %lld  %lld, %lld ", x1, y1, x2, y2, x, y);
        
        num_t det = x1 * y2 - x2 * y1;
        printf(" det = %lld: ", det);
        if (det == 0)
        {
            num_t min_sum = 0;
            for (num_t a = 0; a * x1 <= x; a++)
            {
                num_t v = x - a * x1;
                if (v % x2 == 0)
                {
                    num_t p_sum = 3 * a + v / x2;
                    if (min_sum == 0 || p_sum < min_sum)
                        min_sum = p_sum;
                }
            }
            printf("%lld", min_sum);
            if (min_sum > 0)
                sum += min_sum;
        }
        else
        {
            num_t a = x * y2 - y * x2;
            num_t b = y * x1 - x * y1;
            if (a % det == 0 && b % det == 0)
            {
                printf("%lld %lld  %lld", a / det, b / det, (3 * a + b) / det);
                sum += (3 * a + b) / det;
            }
        }
        printf("\n");
    }
    printf("%lld\n", sum);
}

```

At 22:05:15, this returned the correct answer for the second part of the puzzle.

It looks like the case that `det` is zero does not occur with my sample input
and that branch of the code is never executed. Does not rule out the possibility
that it contains a bug.

### Executing this page

The command to process this markdown file, is:
```
../IParse/software/MarkDownC Std.md Day13.md >day13.c; gcc -g -Wall day13.c -o day13; ./day13 13
```
I run the bash file [`runOnSave.sh`](runOnSave.sh) with `13` as the argument,
which everytime when I save this file, runs the above command and shows the
result or the first compile errors, if there are any.


