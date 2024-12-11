# Day 11 of Advent of Code 2024

The code below makes use of [a standard library](Std.md), which
also contains the `main` function that reads the input in the global variable `d`
where `n` contains the number of lines and `m` the length of the longest line,
and than calls the function `solve1` and `solve2`.

I already read the puzzle in the morning and did have some time to think
about a possible solution. I continued at 19:13.

```c

typedef struct Number_s Number;
struct Number_s
{
    num_t number;
    num_t times;
    Number *next;
};

Number *numbers = 0;

void insert(num_t num, num_t times)
{
    Number **ref_num = &numbers;
    while ((*ref_num) != 0 && (*ref_num)->number < num)
        ref_num = &(*ref_num)->next;
    if ((*ref_num) == 0 || (*ref_num)->number > num)
    {
        Number *new_number = (Number*)malloc(sizeof(Number));
        new_number->number = num;
        new_number->times = times;
        new_number->next = (*ref_num);
        (*ref_num) = new_number;
    }
    else
        (*ref_num)->times += times;
}

void solve1()
{
    char *s = d[0];
    insert(parse_number(&s), 1);
    while (*s == ' ')
    {
        s++;
        insert(parse_number(&s), 1);
    }
    
    for (int i = 0; i < 25; i++)
    {
        Number *number = numbers;
        numbers = 0;
        for (; number != 0; number = number->next)
        {
            num_t num = number->number;
            if (num == 0)
                insert(1, number->times);
            else
            {
                int nr_digits = 1;
                num_t f = 10;
                while (nr_digits < 14 && num >= f)
                {
                    nr_digits++;
                    f *= 10;
                }
                if (nr_digits == 14)
                {
                    printf("18 digits\n");
                    return;
                }
                if (nr_digits % 2 == 1)
                    insert(num * 2024, number->times);
                else
                {
                    f = 1;
                    for (int i = 0; i < nr_digits; i += 2)
                        f *= 10;
                    insert(num / f, number->times);
                    insert(num % f, number->times);
                }
            }
        }
    }
    
    num_t count = 0;
    for (Number *num = numbers; num != 0; num = num->next)
        count += num->times;
    printf("%lld\n", count);
}
```

At 19:43, after fixing about 10 compilation errors, the program
returned a segmentation fault.

After fixing a small bug in the `insert` function, the program
returned the correct answer at 19:44:40

### Second part of the puzzle.

I already had anticipated the second part of the puzzle in the
design of the algorithm, so, it was just copying the code and
changing 25 into 75 to get:

```c
void solve2()
{
    numbers = 0;
    char *s = d[0];
    insert(parse_number(&s), 1);
    while (*s == ' ')
    {
        s++;
        insert(parse_number(&s), 1);
    }
    
    for (int i = 0; i < 75; i++)
    {
        Number *number = numbers;
        numbers = 0;
        for (; number != 0; number = number->next)
        {
            num_t num = number->number;
            if (num == 0)
                insert(1, number->times);
            else
            {
                int nr_digits = 1;
                num_t f = 10;
                while (nr_digits < 14 && num >= f)
                {
                    nr_digits++;
                    f *= 10;
                }
                if (nr_digits == 14)
                {
                    printf("18 digits\n");
                    return;
                }
                if (nr_digits % 2 == 1)
                    insert(num * 2024, number->times);
                else
                {
                    f = 1;
                    for (int i = 0; i < nr_digits; i += 2)
                        f *= 10;
                    insert(num / f, number->times);
                    insert(num % f, number->times);
                }
            }
        }
    }
    
    num_t count = 0;
    for (Number *num = numbers; num != 0; num = num->next)
        count += num->times;
    printf("%lld\n", count);
}

```

At 19:45:48, this returned the correct answer.

### Executing this page

The command to process this markdown file, is:
```
../IParse/software/MarkDownC Std.md Day11.md >day11.c; gcc -g -Wall day11.c -o day11; ./day11 11
```
I run the bash file [`runOnSave.sh`](runOnSave.sh) with `11` as the argument,
which everytime when I save this file, runs the above command and shows the
result or the first compile errors, if there are any.


