# Day 1 of Advent of Code 2024

The code below makes use of [a standard library](Std.md), which
also contains the `main` function that reads the input in the global variable `d`
where `n` contains the number of lines and `m` the length of the longest line,
and than calls the function `solve1` and `solve2`.

I first wrote a fuunction to parse the input and echo it, to verify that I parsed
it correctly.

```c
void solve1()
{
    int left[1000], right[1000];
    for (int i = 0; i < n; i++)
    {
        char *s = d[i];
        left[i] = parse_number(&s);
        while (*s == ' ') s++;
        right[i] = parse_number(&s);
        
        printf("%d   %d\n", left[i], right[i]);
    }
    
}
```

Then I looked up the standard [`qsort`](https://www.tutorialspoint.com/c_standard_library/c_function_qsort.htm)
function. The page provided the compare function I needed, so, I just copied it.
This resulted in the program that just prints the sorted numbers.

```c

int compare(const void* a, const void* b) {
   return (*(int*)a - *(int*)b);
}

void solve1()
{
    int left[1000], right[1000];
    for (int i = 0; i < n; i++)
    {
        char *s = d[i];
        left[i] = parse_number(&s);
        while (*s == ' ') s++;
        right[i] = parse_number(&s);
    }
    qsort(left, n, sizeof(left[0]), compare);
    qsort(right, n, sizeof(right[0]), compare);
    
    for (int i = 0; i < n; i++)
    {
        printf("%d   %d\n", left[i], right[i]);
    }
}
```

When that looked okay, I decided to add the logic to sum up the
difference between the numbers, resulting in:

```c

void solve1()
{
    int left[1000], right[1000];
    for (int i = 0; i < n; i++)
    {
        char *s = d[i];
        left[i] = parse_number(&s);
        while (*s == ' ') s++;
        right[i] = parse_number(&s);
    }
    qsort(left, n, sizeof(left[0]), compare);
    qsort(right, n, sizeof(right[0]), compare);

    int sum = 0;    
    for (int i = 0; i < n; i++)
        sum += abs(left[i] - right[i]);
    printf("%d\n", sum);
}
```

At 6:18:59, that gave me the correct answer and the first star.
I felt that this first puzzle is a bit difficulter than the
usual first puzzles. I think that someone being proficient with
a spreadsheet program could solve it rather quickly.

### Second part of the puzzle.

I felt that the second part of the puzzle is actually a lot
easier, especially if you go for the 'dumb' solution of ignoring
the sorting of the first part of the puzzle.

```c
void solve2()
{
    int left[1000], right[1000];
    for (int i = 0; i < n; i++)
    {
        char *s = d[i];
        left[i] = parse_number(&s);
        while (*s == ' ') s++;
        right[i] = parse_number(&s);
    }

    num_t sum = 0;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++)
            if (left[i] == right[j])
                sum += left[i];
    printf("%d\n", sum);
}

```

At 6:25:06, I found the answer to the second part of the puzzle
after a second try, due to a small mistake in the code.

I came up with a small improvement for the base program mentioned
on the [a standard library](Std.md), when I realized that the last two
letters of the program name, `day01`, can be used to read the matching
input file.

### Executing this page

The command to process this markdown file, is:
```
../IParse/software/MarkDownC Std.md Day01.md >day01.c; gcc -g -Wall day01.c -o day01; ./day01 01
```
I run the bash file [`runOnSave.sh`](runOnSave.sh) with `01` as the argument,
which everytime when I save this file, runs the above command and shows the
result or the first compile errors, if there are any.


