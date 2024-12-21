# Day 21 of Advent of Code 2024

The code below makes use of [a standard library](Std.md), which
also contains the `main` function that reads the input in the global variable `d`
where `n` contains the number of lines and `m` the length of the longest line,
and than calls the function `solve1` and `solve2`.

At 16:47, I start writing this file after having read the puzzle description
for a second time. I did during the morning and thought a bit about it during
the day.

Lets write a program that prints out what happens if a the first solution in the
example input is executed.

```c

char numeric[4][3] = {
    { '7', '8', '9' },
    { '4', '5', '6' },
    { '1', '2', '3' },
    { '*', '0', 'A' },
};


char arrow[2][3] = {
    { '*', '^', 'A' },
    { '<', 'v', '>' },
};

struct
{
    int x, y;
} pos[3] = {
    { 2, 0 },
    { 2, 0 },
    { 2, 3 }
};

void solve1()
{
    char *s = "<vA<AA>>^AvAA<^A>A<v<A>>^AvA^A<vA>^A<v<A>^A>AAvA^A<v<A>A>^AAAvA<^A>A";
    for (; *s != '\0'; s++)
    {
        char a = *s;
        printf("%c:", a);
        for (int i = 0; i < 3; i++)
        {
            if (a == '<') { pos[i].x--; break; }
            if (a == '>') { pos[i].x++; break; }
            if (a == '^') { pos[i].y--; break; }
            if (a == 'v') { pos[i].y++; break; }
            if (i < 2)
                a = arrow[pos[i].y][pos[i].x];
            else
                a = numeric[pos[i].y][pos[i].x];
            printf(" %c", a);
        }
        printf("\n");
    }
}
```

I prepared dinner, had dinner and did some surfing. Lets think about it.
So the most inner pannel, we need to press '0', '2', '9' and 'A'.
That means on the one less panel, we have to press '<A^A>^^AvvvA'.
A movement from one key to another always exists of a sequence of zero or
more horizontal movements followed by zero or more vertical movements.
(In some cases the horizontal and vertical movements have to be swapped
for not getting into the illegal locations).

```c
void solve1()
{
    char *s = "<vA<AA>>^AvAA<^A>A<v<A>>^AvA^A<vA>^A<v<A>^A>AAvA^A<v<A>A>^AAAvA<^A>A";
    int p = 2;
    for (; *s != '\0'; s++)
    {
        char a = *s;
        for (; p >= 0; p--) printf("(");
        printf("%c", a);
        for (int i = 0; i < 3; i++)
        {
            if (a == '<') { pos[i].x--; break; }
            if (a == '>') { pos[i].x++; break; }
            if (a == '^') { pos[i].y--; break; }
            if (a == 'v') { pos[i].y++; break; }
            if (i < 2)
                a = arrow[pos[i].y][pos[i].x];
            else
                a = numeric[pos[i].y][pos[i].x];
            printf(")%c", a);
            p++;
        }
    }
}
```

At 19:55. Let work out the movements between all possible combinations:

```c
void solve1()
{
    printf("Numeric:\n");
    for (char *f = "A0123456789"; *f != '\0'; f++)
    {
        int fi, fj;
        for (int i = 0; i < 4; i++)
            for (int j = 0; j < 3; j++)
                if (numeric[i][j] == *f)
                {
                    fi = i;
                    fj = j;
                }
        
        for (char *t = "A0123456789"; *t != '\0'; t++)
        {
            int ti, tj;
            for (int i = 0; i < 4; i++)
                for (int j = 0; j < 3; j++)
                    if (numeric[i][j] == *t)
                    {
                        ti = i;
                        tj = j;
                    }
            printf("from %c to %c: ", *f, *t);
            if (fi == ti)
            {
                if (fj == tj)
                    printf("A");
                else
                {
                    for (int j = fj; j != tj; ) if (j < tj) { printf(">"); j++; } else { printf("<"); j--; }
                    printf("A");
                }
            }
            else
            {
                if (fj == tj)
                {
                    for (int i = fi; i != ti; ) if (i < ti) { printf("v"); i++; } else { printf("^"); i--; }
                    printf("A");
                }
                else
                {
                    bool vh = FALSE;
                    if (fi != 3 || tj != 0)
                    {
                        for (int j = fj; j != tj; ) if (j < tj) { printf(">"); j++; } else { printf("<"); j--; }
                        for (int i = fi; i != ti; ) if (i < ti) { printf("v"); i++; } else { printf("^"); i--; }
                        printf("A");
                        vh = TRUE;
                    }
                    if (fj != 0 || ti != 3)
                    {
                        if (vh) printf(" or ");                
                        for (int i = fi; i != ti; ) if (i < ti) { printf("v"); i++; } else { printf("^"); i--; }
                        for (int j = fj; j != tj; ) if (j < tj) { printf(">"); j++; } else { printf("<"); j--; }
                        printf("A");
                    }
                }
            }
            printf("\n");
        }
    }

    printf("\nArrow:\n");
    for (char *f = "A<>^v"; *f != '\0'; f++)
    {
        int fi, fj;
        for (int i = 0; i < 2; i++)
            for (int j = 0; j < 3; j++)
                if (arrow[i][j] == *f)
                {
                    fi = i;
                    fj = j;
                }
        
        for (char *t = "A<>^v"; *t != '\0'; t++)
        {
            int ti, tj;
            for (int i = 0; i < 2; i++)
                for (int j = 0; j < 3; j++)
                    if (arrow[i][j] == *t)
                    {
                        ti = i;
                        tj = j;
                    }
            printf("from %c to %c: ", *f, *t);
            if (fi == ti)
            {
                if (fj == tj)
                    printf("A");
                else
                {
                    for (int j = fj; j != tj; ) if (j < tj) { printf(">"); j++; } else { printf("<"); j--; }
                    printf("A");
                }
            }
            else
            {
                if (fj == tj)
                {
                    for (int i = fi; i != ti; ) if (i < ti) { printf("v"); i++; } else { printf("^"); i--; }
                    printf("A");
                }
                else
                {
                    bool vh = FALSE;
                    if (fi != 0 || tj != 0)
                    {
                        for (int j = fj; j != tj; ) if (j < tj) { printf(">"); j++; } else { printf("<"); j--; }
                        for (int i = fi; i != ti; ) if (i < ti) { printf("v"); i++; } else { printf("^"); i--; }
                        printf("A");
                        vh = TRUE;
                    }
                    if (fj != 0 || ti != 0)
                    {
                        if (vh) printf(" or ");                
                        for (int i = fi; i != ti; ) if (i < ti) { printf("v"); i++; } else { printf("^"); i--; }
                        for (int j = fj; j != tj; ) if (j < tj) { printf(">"); j++; } else { printf("<"); j--; }
                        printf("A");
                    }
                }
            }
            printf("\n");
        }
    }
}

```

At 20:39, does the program produce all the transitions; Lets store them in some table.

```c

typedef struct trans_s trans_t;
struct trans_s
{
    int nr;
    char pattern[2][10];
};

trans_t tnumeric[11][11];
trans_t tarrow[5][5];

void solve1()
{
    printf("Numeric:\n");
    const char *numkeys = "A0123456789";
    for (int f = 0; f < 11; f++)
    {
        int fi, fj;
        for (int i = 0; i < 4; i++)
            for (int j = 0; j < 3; j++)
                if (numeric[i][j] == numkeys[f])
                {
                    fi = i;
                    fj = j;
                }
        
        for (int t = 0; t < 11; t++)
        {
            int ti, tj;
            for (int i = 0; i < 4; i++)
                for (int j = 0; j < 3; j++)
                    if (numeric[i][j] == numkeys[t])
                    {
                        ti = i;
                        tj = j;
                    }
            printf("from %c to %c: ", numkeys[f], numkeys[t]);
            tnumeric[f][t].nr = 0;
            if (fi == ti)
            {
                if (fj == tj)
                {
                    char *s = tnumeric[f][t].pattern[tnumeric[f][t].nr];
                    *s++ = 'A';
                    *s = '\0';
                    printf("%s", tnumeric[f][t].pattern[tnumeric[f][t].nr]);
                    tnumeric[f][t].nr++;
                }
                else
                {
                    char *s = tnumeric[f][t].pattern[tnumeric[f][t].nr];
                    for (int j = fj; j != tj; ) if (j < tj) { *s++ = '>'; j++; } else { *s++ = '<'; j--; }
                    *s++ = 'A';
                    *s = '\0';
                    printf("%s", tnumeric[f][t].pattern[tnumeric[f][t].nr]);
                    tnumeric[f][t].nr++;
                }
            }
            else
            {
                if (fj == tj)
                {
                    char *s = tnumeric[f][t].pattern[tnumeric[f][t].nr];
                    for (int i = fi; i != ti; ) if (i < ti) { *s++ = 'v'; i++; } else { *s++ = '^'; i--; }
                    *s++ = 'A';
                    *s = '\0';
                    printf("%s", tnumeric[f][t].pattern[tnumeric[f][t].nr]);
                    tnumeric[f][t].nr++;
                }
                else
                {
                    bool vh = FALSE;
                    if (fi != 3 || tj != 0)
                    {
                        char *s = tnumeric[f][t].pattern[tnumeric[f][t].nr];
                        for (int j = fj; j != tj; ) if (j < tj) { *s++ = '>'; j++; } else { *s++ = '<'; j--; }
                        for (int i = fi; i != ti; ) if (i < ti) { *s++ = 'v'; i++; } else { *s++ = '^'; i--; }
                        *s++ = 'A';
                        *s = '\0';
                        printf("%s", tnumeric[f][t].pattern[tnumeric[f][t].nr]);
                        tnumeric[f][t].nr++;
                        vh = TRUE;
                    }
                    if (fj != 0 || ti != 3)
                    {
                        if (vh) printf(" or ");
                        char *s = tnumeric[f][t].pattern[tnumeric[f][t].nr];
                        for (int i = fi; i != ti; ) if (i < ti) { *s++ = 'v'; i++; } else { *s++ = '^'; i--; }
                        for (int j = fj; j != tj; ) if (j < tj) { *s++ = '>'; j++; } else { *s++ = '<'; j--; }
                        *s++ = 'A';
                        *s = '\0';
                        printf("%s", tnumeric[f][t].pattern[tnumeric[f][t].nr]);
                        tnumeric[f][t].nr++;
                    }
                }
            }
            printf("\n");
        }
    }

    printf("\nArrow:\n");
    const char *arrowkeys = "A<>^v";
    for (int f = 0; f < 5; f++)
    {
        int fi, fj;
        for (int i = 0; i < 2; i++)
            for (int j = 0; j < 3; j++)
                if (arrow[i][j] == arrowkeys[f])
                {
                    fi = i;
                    fj = j;
                }
        
        for (int t = 0; t < 5; t++)
        {
            int ti, tj;
            for (int i = 0; i < 2; i++)
                for (int j = 0; j < 3; j++)
                    if (arrow[i][j] == arrowkeys[t])
                    {
                        ti = i;
                        tj = j;
                    }
            printf("from %c to %c: ", arrowkeys[f], arrowkeys[t]);
            tarrow[f][t].nr = 0;
            if (fi == ti)
            {
                if (fj == tj)
                {
                    char *s = tarrow[f][t].pattern[tarrow[f][t].nr];
                    *s++ = 'A';
                    *s = '\0';
                    printf("%s", tarrow[f][t].pattern[tarrow[f][t].nr]);
                    tarrow[f][t].nr++;
                }
                else
                {
                    char *s = tarrow[f][t].pattern[tarrow[f][t].nr];
                    for (int j = fj; j != tj; ) if (j < tj) { *s++ = '>'; j++; } else { *s++ = '<'; j--; }
                    *s++ = 'A';
                    *s = '\0';
                    printf("%s", tarrow[f][t].pattern[tarrow[f][t].nr]);
                    tarrow[f][t].nr++;
                }
            }
            else
            {
                if (fj == tj)
                {
                    char *s = tarrow[f][t].pattern[tarrow[f][t].nr];
                    for (int i = fi; i != ti; ) if (i < ti) { *s++ = 'v'; i++; } else { *s++ = '^'; i--; }
                    *s++ = 'A';
                    *s = '\0';
                    printf("%s", tarrow[f][t].pattern[tarrow[f][t].nr]);
                    tarrow[f][t].nr++;
                }
                else
                {
                    bool vh = FALSE;
                    if (fi != 0 || tj != 0)
                    {
                        char *s = tarrow[f][t].pattern[tarrow[f][t].nr];
                        for (int j = fj; j != tj; ) if (j < tj) { *s++ = '>'; j++; } else { *s++ = '<'; j--; }
                        for (int i = fi; i != ti; ) if (i < ti) { *s++ = 'v'; i++; } else { *s++ = '^'; i--; }
                        *s++ = 'A';
                        *s = '\0';
                        printf("%s", tarrow[f][t].pattern[tarrow[f][t].nr]);
                        tarrow[f][t].nr++;
                        vh = TRUE;
                    }
                    if (fj != 0 || ti != 0)
                    {
                        if (vh) printf(" or ");
                        char *s = tarrow[f][t].pattern[tarrow[f][t].nr];
                        for (int i = fi; i != ti; ) if (i < ti) { *s++ = 'v'; i++; } else { *s++ = '^'; i--; }
                        for (int j = fj; j != tj; ) if (j < tj) { *s++ = '>'; j++; } else { *s++ = '<'; j--; }
                        *s++ = 'A';
                        *s = '\0';
                        printf("%s", tarrow[f][t].pattern[tarrow[f][t].nr]);
                        tarrow[f][t].nr++;
                    }
                }
            }
            printf("\n");
        }
    }
}

```

At 21:11, the above program does return the same information;

```c

num_t arrowdist[5][5];
num_t n_arrowdist[5][5];
num_t numericdist[11][11];

int arrow_index(char c)
{
    for (int i = 0; i < 5; i++)
        if (c == "A<>^v"[i])
            return i;
    return 0;
}

int numeric_index(char c)
{
    for (int i = 0; i < 11; i++)
        if (c == "A0123456789"[i])
            return i;
    return 0;
}

void solve1()
{
    ...

    for (int f = 0; f < 5; f++)
        for (int t = 0; t < 5; t++)
            arrowdist[f][t] = 1;
            
    for (int nr_key = 0; nr_key < 2; nr_key++)
    {
        for (int f = 0; f < 5; f++)
        {
            for (int t = 0; t < 5; t++)
            {
                printf("[%c %c:%d]", "A<>^v"[f], "A<>^v"[t], tarrow[f][t].nr);
                num_t min_dist = -1;
                for (int p = 0; p < tarrow[f][t].nr; p++)
                {
                    int p_i = arrow_index('A');
                    num_t dist = 0;
                    printf("%s", tarrow[f][t].pattern[p]);
                    for (char *s = tarrow[f][t].pattern[p]; *s != '\0'; s++)
                    {
                        int i = arrow_index(*s);
                        dist += arrowdist[p_i][i];
                        p_i = i;
                    }
                    printf("(%lld)", dist);
                    if (min_dist == -1 || dist < min_dist)
                        min_dist = dist;
                }
                n_arrowdist[f][t] = min_dist;
                printf("%4lld %d", min_dist, tarrow[f][t].nr);
            }
            printf("\n");
        }
        printf("\n");
        
        for (int f = 0; f < 5; f++)
            for (int t = 0; t < 5; t++)
                arrowdist[f][t] = n_arrowdist[f][t];
    }

    for (int f = 0; f < 11; f++)
    {    for (int t = 0; t < 11; t++)
        {
            num_t min_dist = -1;
            for (int p = 0; p < tnumeric[f][t].nr; p++)
            {
                int p_i = arrow_index('A');
                num_t dist = 0;
                for (char *s = tnumeric[f][t].pattern[p]; *s != '\0'; s++)
                {
                    int i = arrow_index(*s);
                    dist += arrowdist[p_i][i];
                    p_i = i;
                }
                if (min_dist == -1 || dist < min_dist)
                    min_dist = dist;
            }
            numericdist[f][t] = min_dist;
            printf("%4lld", min_dist);
        }
        printf("\n");
    }
    
    calc();
}

void calc()
{
    char *s = "029A";
    int p_i = numeric_index('A');
    num_t dist = 0;
    for (char *t = s; *t != '\0'; t++)
    {
        printf("%c: ", *t);
        int i = numeric_index(*t);
        dist += numericdist[p_i][i];
        printf("%c %c %lld\n", "A0123456789"[p_i], "A0123456789"[i], numericdist[p_i][i]);
        p_i = i;
    }
    printf("%lld\n", dist);
}
```

At 22:39, the above program returns the correct answer. Let try it for
my input:

```c
void calc()
{
    num_t answer = 0;
    
    for (int l = 0; l < n; l++)
    {
        char *s = d[l];
        int p_i = numeric_index('A');
        num_t dist = 0;
        for (char *t = s; *t != '\0'; t++)
        {
            printf("%c: ", *t);
            int i = numeric_index(*t);
            dist += numericdist[p_i][i];
            printf("%c %c %lld\n", "A0123456789"[p_i], "A0123456789"[i], numericdist[p_i][i]);
            p_i = i;
        }
        s = d[l];
        num_t v = parse_number(&s); 
        printf("%lld %lld\n", v, dist);
        answer += v * dist;
    }
    printf("%lld\n", answer);
}
```

At 22:42:46, that returned the correct answer for the first part of
the puzzle.

### Second part of the puzzle.

With all the work that I did for first part, solving the second part
is really easy. Simply replacing 2 by 25 in the `nr_key` loop.

```c
void solve2()
{
    for (int f = 0; f < 5; f++)
        for (int t = 0; t < 5; t++)
            arrowdist[f][t] = 1;
            
    for (int nr_key = 0; nr_key < 25; nr_key++)
    {
        for (int f = 0; f < 5; f++)
        {
            for (int t = 0; t < 5; t++)
            {
                printf("[%c %c:%d]", "A<>^v"[f], "A<>^v"[t], tarrow[f][t].nr);
                num_t min_dist = -1;
                for (int p = 0; p < tarrow[f][t].nr; p++)
                {
                    int p_i = arrow_index('A');
                    num_t dist = 0;
                    printf("%s", tarrow[f][t].pattern[p]);
                    for (char *s = tarrow[f][t].pattern[p]; *s != '\0'; s++)
                    {
                        int i = arrow_index(*s);
                        dist += arrowdist[p_i][i];
                        p_i = i;
                    }
                    printf("(%lld)", dist);
                    if (min_dist == -1 || dist < min_dist)
                        min_dist = dist;
                }
                n_arrowdist[f][t] = min_dist;
                printf("%4lld %d", min_dist, tarrow[f][t].nr);
            }
            printf("\n");
        }
        printf("\n");
        
        for (int f = 0; f < 5; f++)
            for (int t = 0; t < 5; t++)
                arrowdist[f][t] = n_arrowdist[f][t];
    }

    for (int f = 0; f < 11; f++)
    {    for (int t = 0; t < 11; t++)
        {
            num_t min_dist = -1;
            for (int p = 0; p < tnumeric[f][t].nr; p++)
            {
                int p_i = arrow_index('A');
                num_t dist = 0;
                for (char *s = tnumeric[f][t].pattern[p]; *s != '\0'; s++)
                {
                    int i = arrow_index(*s);
                    dist += arrowdist[p_i][i];
                    p_i = i;
                }
                if (min_dist == -1 || dist < min_dist)
                    min_dist = dist;
            }
            numericdist[f][t] = min_dist;
            printf("%4lld", min_dist);
        }
        printf("\n");
    }
    
    calc();
}

```

At 22:45:17, that returned the correct answer for the second part.


### Executing this page

The command to process this markdown file, is:
```
../IParse/software/MarkDownC Std.md Day21.md >day21.c; gcc -g -Wall day21.c -o day21; ./day21 21
```
I run the bash file [`runOnSave.sh`](runOnSave.sh) with `21` as the argument,
which everytime when I save this file, runs the above command and shows the
result or the first compile errors, if there are any.


