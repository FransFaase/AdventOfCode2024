# Day 7 of Advent of Code 2024

The code below makes use of [a standard library](Std.md), which
also contains the `main` function that reads the input in the global variable `d`
where `n` contains the number of lines and `m` the length of the longest line,
and than calls the function `solve1` and `solve2`.

I started at 6:19 reading the puzzle and at 6:26 editting this file.

```c

bool search(num_t target, num_t value, char *s)
{
    if (value > target)
        return FALSE;
    if (*s != ' ')
        return target == value;
    s++;    
    num_t next = parse_number(&s);
    return    search(target, value + next, s)
           || search(target, value * next, s);
}

void solve1()
{
    num_t sum = 0;
    for (int i = 0; i < n; i++)
    {
        char *s = d[i];
        num_t target = parse_number(&s);
        s += 2;
        num_t first = parse_number(&s);
        if (search(target, first, s))
            sum += target;
    }
    printf("%d\n", sum);
}
```

At 6:39, this returns a negative value. Lets first try this on the example
input.

```c
void pre() { use_sample = TRUE; }
```

That does return the correct answer. Lets try use `__int128`:

```c

bool search(__int128 target, __int128 value, char *s)
{
    if (value > target)
        return FALSE;
    if (*s != ' ')
        return target == value;
    s++;    
    __int128 next = parse_number(&s);
    return    search(target, value + next, s)
           || search(target, value * next, s);
}

void solve1()
{
    __int128 sum = 0;
    for (int i = 0; i < n; i++)
    {
        char *s = d[i];
        __int128 target = parse_number(&s);
        s += 2;
        __int128 first = parse_number(&s);
        if (search(target, first, s))
            sum += target;
    }
    printf("%d\n", sum);
}

void pre() { use_sample = FALSE; }

```

It still returns the negative number. Must be due to using
`parse_number`.

```c

__int128 parse_number(char **s)
{
    __int128 sign = 1;
    if (**s == '-')
    {
        sign = -1;
        (*s)++;
    }
    __int128 value = 0;
    for (;is_digit(**s); (*s)++)
        value = 10 * value + **s - '0';
    return sign * value;
}

```

At 6:48, it still returns a negative number. Must be due to
the print statement at the end. Lets write a print rountine
for that:

```c
void print128(num_t value)
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
    __int128 sum = 0;
    for (int i = 0; i < n; i++)
    {
        char *s = d[i];
        __int128 target = parse_number(&s);
        s += 2;
        __int128 first = parse_number(&s);
        if (search(target, first, s))
            sum += target;
    }
    print128(sum);
    printf("\n");
}
```

At 6:56 that returned the correct answer for the first part.


### Second part of the puzzle.

Not that hard.

```c
__int128 concat(__int128 a, __int128 b)
{
    __int128 f = 1;
    while (b >= f)
        f *= 10;
    return a * f + b; 
}

bool search2(__int128 target, __int128 value, char *s)
{
    if (value > target)
        return FALSE;
    if (*s != ' ')
        return target == value;
    s++;    
    __int128 next = parse_number(&s);
    return    search2(target, value + next, s)
           || search2(target, value * next, s)
           || search2(target, concat(value, next), s);
}

void solve2()
{
    __int128 sum = 0;
    for (int i = 0; i < n; i++)
    {
        char *s = d[i];
        __int128 target = parse_number(&s);
        s += 2;
        __int128 first = parse_number(&s);
        if (search2(target, first, s))
            sum += target;
    }
    print128(sum);
    printf("\n");
}

```

At 7:06, this returns the correct answer after I made one
correction when it returned a lower value due to using
`printf("%d\n", sum)`.

### Executing this page

The command to process this markdown file, is:
```
../IParse/software/MarkDownC Std.md Day07.md >day07.c; gcc -g -Wall day07.c -o day07; ./day07 07
```
I run the bash file [`runOnSave.sh`](runOnSave.sh) with `07` as the argument,
which everytime when I save this file, runs the above command and shows the
result or the first compile errors, if there are any.


