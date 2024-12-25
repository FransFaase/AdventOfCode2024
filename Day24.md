# Day 24 of Advent of Code 2024

The code below makes use of [a standard library](Std.md), which
also contains the `main` function that reads the input in the global variable `d`
where `n` contains the number of lines and `m` the length of the longest line,
and than calls the function `solve1` and `solve2`.

I started around 7:27 reading the puzzle. At 7:37, I found that my
input is 313 lines long.

```c
#define NR_LINES 313

typedef struct wire_s *wire_p;
struct wire_s
{
    char *name;
    char value;
} wires[NR_LINES];
int nr_wires = 0;

wire_p get_wire(char *name)
{
    for (int i = 0; i < nr_wires; i++)
        if (strcmp(wires[i].name, name) == 0)
            return wires + i;
    wires[nr_wires].name = name;
    wires[nr_wires].value = 'u';
    nr_wires++;
    return wires + (nr_wires - 1);
}

struct gate
{
    wire_p in1;
    wire_p in2;
    char type;
    wire_p out;
} gates[NR_LINES];
int nr_gates = 0;
    
void read_circuit()
{
    int i = 0;
    for (; i < n; i++)
    {
        char *s = d[i];
        if (*s == '\0')
            break;
        s[3] = '\0';
        wire_p wire = get_wire(s);
        wire->value = s[5];
    }
    i++;
    for (; i < n; i++)
    {
        char *s = d[i];
        s[3] = '\0';
        gates[nr_gates].in1 = get_wire(s);
        s += 4;
        gates[nr_gates].type = *s;
        s += *s == 'O' ? 3 : 4;
        s[3] = '\0';
        gates[nr_gates].in2 = get_wire(s);
        s += 7;
        s[3] = '\0';
        gates[nr_gates].out = get_wire(s);
        nr_gates++;
    }
}

void print_circuit()
{
    for (int i = 0; i < nr_wires; i++)
        printf("%s: %c\n", wires[i].name, wires[i].value);
    for (int i = 0; i < nr_gates; i++)
        printf("%s %c %s -> %s\n",
            gates[i].in1->name, gates[i].type, gates[i].in2->name, gates[i].out->name);
}

void solve1()
{
    read_circuit();
    print_circuit();
}
```

At 8:00, the above program (after some debuging) seems to have
read the input correctly.

```c
void solve1()
{
    read_circuit();
    
    __int128 answer = 0;
    __int128 bit = 1;
    for (bool go = TRUE; go; )
    {
        printf(".\n");
        go = FALSE;
        for (int i = 0; i < nr_gates; i++)
            if (gates[i].out->value == 'u' && gates[i].in1->value != 'u' && gates[i].in2->value != 'u')
            {
                if (gates[i].type == 'A')
                    gates[i].out->value = '0' + ((gates[i].in1->value - '0') && (gates[i].in2->value - '0'));
                else if (gates[i].type == 'O')
                    gates[i].out->value = '0' + ((gates[i].in1->value - '0') || (gates[i].in2->value - '0'));
                else
                    gates[i].out->value = '0' + ((gates[i].in1->value - '0') != (gates[i].in2->value - '0'));
                if (gates[i].out->value == '1')
                    answer += bit;
                printf("%s: %c\n", gates[i].out->name, gates[i].out->value);
                print128(answer);
                bit *= 2;
                go = TRUE;
            }
    }
    print128(answer);
    printf("\n");
    printf("number gates: %d\n", nr_gates);
}

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
```

At 8:20, I discover that the program has more than 128 gates, resulting
in an overflow of the `answer` because it is only 128 bits. So, we need some
big number functions. 

```c
void solve1()
{
    read_circuit();
    
    __int128 answer = 0;
    __int128 bit = 1;
    for (bool go = TRUE; go; )
    {
        printf(".\n");
        go = FALSE;
        for (int i = 0; i < nr_gates; i++)
            if (gates[i].out->value == 'u' && gates[i].in1->value != 'u' && gates[i].in2->value != 'u')
            {
                if (gates[i].type == 'A')
                    gates[i].out->value = '0' + ((gates[i].in1->value - '0') && (gates[i].in2->value - '0'));
                else if (gates[i].type == 'O')
                    gates[i].out->value = '0' + ((gates[i].in1->value - '0') || (gates[i].in2->value - '0'));
                else
                    gates[i].out->value = '0' + ((gates[i].in1->value - '0') != (gates[i].in2->value - '0'));
                if (gates[i].out->name[0] == 'z')
                {
                    if (gates[i].out->value == '1')
                        answer += bit;
                    printf("%s: %c :", gates[i].out->name, gates[i].out->value);
                    print128(answer);
                    printf("\n");
                    bit *= 2;
                }
                go = TRUE;
            }
    }
    print128(answer);
    printf("\n");
    printf("number gates: %d\n", nr_gates);
}

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
```

At 8:35, it returned an incorrect answer.

At 17:26, I continued. Lets test it on the example input.

```c
bool use_sample = TRUE;

void solve1()
{
    read_circuit();
    
    __int128 answer = 0;
    __int128 bit = 1;
    for (bool go = TRUE; go; )
    {
        printf(".\n");
        go = FALSE;
        for (int i = 0; i < nr_gates; i++)
            if (gates[i].out->value == 'u' && gates[i].in1->value != 'u' && gates[i].in2->value != 'u')
            {
                if (gates[i].type == 'A')
                    gates[i].out->value = '0' + ((gates[i].in1->value - '0') && (gates[i].in2->value - '0'));
                else if (gates[i].type == 'O')
                    gates[i].out->value = '0' + ((gates[i].in1->value - '0') || (gates[i].in2->value - '0'));
                else
                    gates[i].out->value = '0' + ((gates[i].in1->value - '0') != (gates[i].in2->value - '0'));
                printf("%s: %c :", gates[i].out->name, gates[i].out->value);
                if (gates[i].out->name[0] == 'z')
                {
                    if (gates[i].out->value == '1')
                        answer += bit;
                    bit *= 2;
                }
                print128(answer);
                printf("\n");
                go = TRUE;
            }
    }
    print128(answer);
    printf("\n");
    printf("number gates: %d\n", nr_gates);
}

```

At 17:34, I see that the 'z' variables have to be added in order.

```c
bool use_sample = TRUE;

void solve1()
{
    read_circuit();
    
    __int128 answer = 0;
    for (bool go = TRUE; go; )
    {
        printf(".\n");
        go = FALSE;
        for (int i = 0; i < nr_gates; i++)
            if (gates[i].out->value == 'u' && gates[i].in1->value != 'u' && gates[i].in2->value != 'u')
            {
                if (gates[i].type == 'A')
                    gates[i].out->value = '0' + ((gates[i].in1->value - '0') && (gates[i].in2->value - '0'));
                else if (gates[i].type == 'O')
                    gates[i].out->value = '0' + ((gates[i].in1->value - '0') || (gates[i].in2->value - '0'));
                else
                    gates[i].out->value = '0' + ((gates[i].in1->value - '0') != (gates[i].in2->value - '0'));
                printf("%s: %c :", gates[i].out->name, gates[i].out->value);
                if (gates[i].out->name[0] == 'z' && gates[i].out->value == '1')
                {
                    char *s = gates[i].out->name + 1;
                    num_t v = parse_number(&s);
                    answer += (1L << v);
                }
                print128(answer);
                printf("\n");
                go = TRUE;
            }
    }
    print128(answer);
    printf("\n");
    printf("number gates: %d\n", nr_gates);
}

```

At 17:40, that returns the correct answer for the example input.

```c
bool use_sample = FALSE;
```

At 17:41, it does not return the correct answer. I noticed that there are 'z' with
values higher than 32.

```c

void solve1()
{
    read_circuit();
    
    __int128 answer = 0;
    __int128 one = 1;
    for (bool go = TRUE; go; )
    {
        printf(".\n");
        go = FALSE;
        for (int i = 0; i < nr_gates; i++)
            if (gates[i].out->value == 'u' && gates[i].in1->value != 'u' && gates[i].in2->value != 'u')
            {
                if (gates[i].type == 'A')
                    gates[i].out->value = '0' + ((gates[i].in1->value - '0') && (gates[i].in2->value - '0'));
                else if (gates[i].type == 'O')
                    gates[i].out->value = '0' + ((gates[i].in1->value - '0') || (gates[i].in2->value - '0'));
                else
                    gates[i].out->value = '0' + ((gates[i].in1->value - '0') != (gates[i].in2->value - '0'));
                printf("%s: %c :", gates[i].out->name, gates[i].out->value);
                if (gates[i].out->name[0] == 'z' && gates[i].out->value == '1')
                {
                    char *s = gates[i].out->name + 1;
                    num_t v = parse_number(&s);
                    __int128 add = one;
                    for (int j = 0; j < v; j++)
                        add *= 2;
                    answer += add;
                }
                print128(answer);
                printf("\n");
                go = TRUE;
            }
    }
    print128(answer);
    printf("\n");
    printf("number gates: %d\n", nr_gates);
}

```

At 17:49:06, the program returned the correct answer.


### Second part of the puzzle.

I have to think a bit about how to approach the second part.

At 18:10, I realize that there is no not operator, which
means there is no other way to make an exclusive-or operator.

At 18:18, I have noticed that it seems that between all
'x<n>' and 'y<n>' there is a XOR and an AND operator.
The table for a full adder looks like:

```
Cp x y -> z C
 0 0 0    0 0
 0 0 1    1 0
 0 1 0    1 0
 0 1 1    0 1
 1 0 0    1 0
 1 0 1    0 1
 1 1 0    0 1
 1 1 1    1 1
```

From this, we can derive the two formuleas for `z` and `C`:
```
z = Cp XOR x XOR y
C = (x AND y) OR (x AND Cp) OR (y AND Cp) OR (x AND y AND Cp)
```
Not however, that there are many other formuleas for `C` that
would also work, because `(a AND b) OR (a AND c)` is equal to
`a AND (b OR c)`. In my puzzle input, there are 89 XOR operations,
(only) 89 AND operation, 133 OR operations. The low number of
AND operations, means that it will have to use a formulea like:
```
C = (Cp AND (x OR y)) OR (x AND y)
```

At 19:06, lets write a program that finds the XOR operations.

```c
void solve2()
{
    for (int i = 0; i < 45; i++)
    {
        char xname[4];
        sprintf(xname, "x%02d", i);
        int xmatch = -1;
        int xnrmatched = 0;
        for (int j = 0; j < nr_gates; j++)
            if (   gates[j].type == 'X'
                && (   strcmp(gates[j].in1->name, xname) == 0 
                    || strcmp(gates[j].in2->name, xname) == 0))
            {
                xnrmatched++;
                xmatch = j;
            }
        char yname[4];
        sprintf(yname, "y%02d", i);
        int ymatch = -1;
        int ynrmatched = 0;
        for (int j = 0; j < nr_gates; j++)
            if (   gates[j].type == 'X'
                && (   strcmp(gates[j].in1->name, yname) == 0 
                    || strcmp(gates[j].in2->name, yname) == 0))
            {
                ynrmatched++;
                ymatch = j;
            }
        char zname[4];
        sprintf(zname, "z%02d", i);
        int zmatch = -1;
        int znrmatched = 0;
        for (int j = 0; j < nr_gates; j++)
            if (   gates[j].type == 'X'
                && strcmp(gates[j].out->name, zname) == 0)
            {
                znrmatched++;
                zmatch = j;
            }
        if (xnrmatched > 1) printf("%d XOR with x%02d as input\n", xnrmatched, i); 
        if (ynrmatched > 1) printf("%d XOR with y%02d as input\n", xnrmatched, i); 
        if (xnrmatched == 1 && ynrmatched == 1 && znrmatched == 1)
            printf("%d OK\n", i);
        else
            printf("%d ERROR %d %d %d\n", i, xnrmatched, ynrmatched, znrmatched);
    }
}

```

At 20:21, have to fix each z such that it is an XOR expression of
x1, x2 and some other value with some recursive search:

```c

wire_p getxyz_wire(char n, int nr)
{
    char name[4];
    sprintf(name, "%c%02d", n, nr);
    return get_wire(name);
}    

int gate_with(wire_p wire)
{
    for (int i = 0; i < nr_gates; i++)
        if (gates[i].out == wire)
            return i;
    return -1;
}

wire_p CarryIn[45];

void fixXOR()
{
    for (int i = 0; i < 45; i++)
    {
        wire_p x_wire = getxyz_wire('x', i);
        int xmatch = -1;
        int xnrmatched = 0;
        for (int j = 0; j < nr_gates; j++)
            if (gates[j].type == 'X' && (gates[j].in1 == x_wire || gates[j].in2 == x_wire))
            {
                xnrmatched++;
                xmatch = j;
            }
        wire_p y_wire = getxyz_wire('y', i);
        char yname[4];
        sprintf(yname, "y%02d", i);
        int ymatch = -1;
        int ynrmatched = 0;
        for (int j = 0; j < nr_gates; j++)
            if (gates[j].type == 'X' && (gates[j].in1 == y_wire || gates[j].in2 == y_wire))
            {
                ynrmatched++;
                ymatch = j;
            }
        if (xnrmatched != 1 || ynrmatched != 1 || xmatch != ymatch)
            printf("ERROR: no x%d XOR y%d: %d %d %d %d\n", i, i, xnrmatched, ynrmatched, xmatch, ymatch);
        else
        {
            wire_p z_wire = getxyz_wire('z', i);
            if (i == 0 && gates[xmatch].out == z_wire)
                printf("XOR %d: OK\n", i);
            else
            {
                wire_p xy_xor_wire = gates[xmatch].out;
                int nrcandidates = 0;
                int option;
                bool found = FALSE;
                for (int j = 0; j < nr_gates; j++)
                    if (gates[j].type == 'X' && (gates[j].in1 == xy_xor_wire || gates[j].in2 == xy_xor_wire))
                    {
                        option = j;
                        nrcandidates++;
                        if (gates[j].out == z_wire)
                        {
                            found = TRUE;
                            break;
                        }
                    }
                if (found || nrcandidates == 1)
                {
                    CarryIn[i] = gates[option].in1 == xy_xor_wire ? gates[option].in2 : gates[option].in1;
                    if (found)
                        printf("XOR %d: OK\n", i);
                    else
                        printf("XOR %d: Swap %s with %s\n", i, gates[option].out->name, z_wire->name);
                }
                else
                    printf("ERROR: no XOR XOR match: %s %d %d\n", xy_xor_wire->name, found, nrcandidates);
            }
        }
    }
}

void solve2()
{
    fixXOR();
}
```

At 21:41, Some other idea:

```c
struct wire_s
{
    char *name;
    char value;
    num_t depend;
} wires[NR_LINES];

num_t wire_depends_on[NR_LINES];

void dependOn()
{
    num_t one = 1;
    for (int i = 0; i < nr_wires; i++)
    {
        wires[i].depend = 0;
        if (wires[i].name[0] == 'x' || wires[i].name[0] == 'y')
        {
            char *s = wires[i].name + 1;
            wires[i].depend = one << parse_number(&s);
        }
    }

    for (int i = 0; i < 45; i++)
    for (bool go = TRUE; go; )
    {
        printf(".\n");
        go = FALSE;
        for (int i = 0; i < nr_gates; i++)
            if (gates[i].out->depend == 0 && gates[i].in1->depend != 0 && gates[i].in2->depend != 0)
            {
                gates[i].out->depend = gates[i].in1->depend | gates[i].in2->depend;
                go = TRUE;
            }
    }

    for (int i = 0; i < nr_wires; i++)
    {
        num_t bit = 1;
        bit = bit << 44;
        for (int j = 44; j >= 0; j--, bit /= 2)
            printf("%c", wires[i].depend & bit ? 'B' : 'a');
        int gate_nr = gate_with(wires + i);
        if (gate_nr > 0)
        {
            printf(" %c %s %s -> ", gates[gate_nr].type, gates[gate_nr].in1->name, gates[gate_nr].in2->name);
        }
        else
            printf(" I");
        printf(" %s\n", wires[i].name);
    }    
}

void solve2()
{
    dependOn();
}
```

At 22:33, I understand that only the names are wrong. I had some other
idea that wires had to be swapped, not just the names.

```c
struct wire_s
{
    char *name;
    char value;
    num_t depend;
    int order;
    char expr;
} wires[NR_LINES];

void dependOn()
{
    num_t one = 1;
    for (int i = 0; i < nr_wires; i++)
    {
        wires[i].depend = 0;
        wires[i].order = 0;
        wires[i].expr = ' ';
    }

    num_t depend = 1;
    int order = 1;
    for (int i = 0; i < 45; i++, depend *= 2)
    {
        char ext[3];
        sprintf(ext, "%02d", i);
        for (int j = 0; j < nr_wires; j++)
            if (   (wires[j].name[0] == 'x' || wires[j].name[0] == 'y')
                && strcmp(wires[j].name + 1, ext) == 0)
            {
                wires[j].depend = depend;
                wires[j].order = order + (wires[j].name[0] == 'y' ? 1 : 0);
                wires[j].expr = wires[j].name[0] + (i == 0 ? 'A' - 'a' : 0);
            }
        order += 2;
        for (bool go = TRUE; go; )
        {
            go = FALSE;
            for (int i = 0; i < nr_gates; i++)
                if (gates[i].out->depend == 0 && gates[i].in1->depend != 0 && gates[i].in2->depend != 0)
                {
                    gates[i].out->depend = gates[i].in1->depend | gates[i].in2->depend;
                    gates[i].out->order = order++;
                    char l = gates[i].in1->expr;
                    char r = gates[i].in2->expr;
                    if (l > r) { char h = l; l = r; r = h; }
                    if (gates[i].type == 'A')
                    {
                        if (l == 'X' && r == 'Y')
                            gates[i].out->expr = 'C'; // x && y
                        else if (l == 'x' && r == 'y')
                            gates[i].out->expr = 'a'; // x && y
                        else if (l == 'C' && r == '^')
                            gates[i].out->expr = 'b'; // C && (x ^ y)
                        else if (l == 'Z' && r == '^')
                            gates[i].out->expr = 'c'; // (x ^ y) && (x ^ y ^ C)
                        else if (l == 'C' && r == 'a')
                            gates[i].out->expr = 'e'; // (x ^ y) && (x ^ y ^ C)
                        else
                        {
                            printf("Add A %c %c\n", l, r); 
                            goto print;
                        }
                    }
                    else if (gates[i].type == 'O')
                    {
                        if (l == 'a' && r == 'b')
                            gates[i].out->expr = 'C'; // (x && y) || (C && (x ^ y)) 
                        else if (l == 'Z' && r == 'b')
                             gates[i].out->expr = 'C'; // (x ^ y ^ C) || (C && (x ^ y))
                        else if (l == 'a' && r == 'c')
                             gates[i].out->expr = 'C'; // 
                        else if (l == '^' && r == 'e')
                             gates[i].out->expr = 'C'; // 
                        else if (l == 'Z' && r == 'a')
                             gates[i].out->expr = 'C'; // 
                        else
                        {
                            printf("Add O %c %c\n", l, r);
                            goto print;
                        }
                    }
                    else // 'X'
                    {
                        if (l == 'X' && r == 'Y')
                             gates[i].out->expr = 'Z'; // x ^ y
                        else if (l == 'x' && r == 'y')
                             gates[i].out->expr = '^'; // x ^ y
                        else if (l == 'C' && r == '^')
                             gates[i].out->expr = 'Z'; // x ^ y ^ C
                        else if (l == 'Z' && r == '^')
                             gates[i].out->expr = 'd'; // 
                        else if (l == 'C' && r == 'a')
                             gates[i].out->expr = 'f'; // 
                        else
                        {
                            printf("Add X %c %c\n", l, r);
                            goto print;
                        }
                    }
                    go = TRUE;
                }
        }
    }
    
    for (int i = 0; i < nr_wires; i++)
        if ((wires[i].name[0] == 'z') != (wires[i].expr == 'Z'))
            printf("ANSWER: %s\n", wires[i].name);
            

  print:
    for (int o = 1; o < order; o++)
        for (int i = 0; i < nr_wires; i++)
            if (wires[i].order == o)
            {
                printf("%03d ", wires[i].order);
                num_t bit = 1;
                bit = bit << 44;
                for (int j = 44; j >= 0; j--, bit /= 2)
                    printf("%c", wires[i].depend & bit ? 'B' : 'a');
                int gate_nr = gate_with(wires + i);
                if (gate_nr > 0)
                {
                    printf(" %c(%c) %s %s -> ", gates[gate_nr].type, gates[gate_nr].out->expr, gates[gate_nr].in1->name, gates[gate_nr].in2->name);
                }
                else
                    printf(" I");
                printf(" %s\n", wires[i].name);
                break;
            }
}
```

At about 0:10 (next day), it did not return the correct answer.

```c
struct wire_s
{
    char *name;
    char value;
    num_t depend;
    int order;
    char expr;
    int level;
} wires[NR_LINES];

void dependOn()
{
    num_t one = 1;
    for (int i = 0; i < nr_wires; i++)
    {
        wires[i].depend = 0;
        wires[i].order = 0;
        wires[i].expr = ' ';
        wires[i].level = 0;
    }

    num_t depend = 1;
    int order = 1;
    for (int i = 0; i < 45; i++, depend *= 2)
    {
        char ext[3];
        sprintf(ext, "%02d", i);
        for (int j = 0; j < nr_wires; j++)
            if (   (wires[j].name[0] == 'x' || wires[j].name[0] == 'y')
                && strcmp(wires[j].name + 1, ext) == 0)
            {
                wires[j].depend = depend;
                wires[j].order = order + (wires[j].name[0] == 'y' ? 1 : 0);
                wires[j].expr = wires[j].name[0] + (i == 0 ? 'A' - 'a' : 0);
                wires[j].level = i;
            }
        order += 2;
        for (bool go = TRUE; go; )
        {
            go = FALSE;
            for (int i1 = 0; i1 < nr_gates; i1++)
                if (gates[i1].out->depend == 0 && gates[i1].in1->depend != 0 && gates[i1].in2->depend != 0)
                {
                    gates[i1].out->depend = gates[i1].in1->depend | gates[i1].in2->depend;
                    gates[i1].out->order = order++;
                    gates[i1].out->level = i;
                    char l = gates[i1].in1->expr;
                    char r = gates[i1].in2->expr;
                    if (l > r) { char h = l; l = r; r = h; }
                    if (gates[i1].type == 'A')
                    {
                        if (l == 'X' && r == 'Y')
                            gates[i1].out->expr = 'C'; // x && y
                        else if (l == 'x' && r == 'y')
                            gates[i1].out->expr = 'a'; // x && y
                        else if (l == 'C' && r == '^')
                            gates[i1].out->expr = 'b'; // C && (x ^ y)
                        else if (l == 'Z' && r == '^')
                            gates[i1].out->expr = 'c'; // (x ^ y) && (x ^ y ^ C)
                        else if (l == 'C' && r == 'a')
                            gates[i1].out->expr = 'e'; // (x ^ y) && (x ^ y ^ C)
                        else
                        {
                            printf("Add A %c %c\n", l, r); 
                            goto print;
                        }
                    }
                    else if (gates[i1].type == 'O')
                    {
                        if (l == 'a' && r == 'b')
                            gates[i1].out->expr = 'C'; // (x && y) || (C && (x ^ y)) 
                        else if (l == 'Z' && r == 'b')
                             gates[i1].out->expr = 'C'; // (x ^ y ^ C) || (C && (x ^ y))
                        else if (l == 'a' && r == 'c')
                             gates[i1].out->expr = 'C'; // 
                        else if (l == '^' && r == 'e')
                             gates[i1].out->expr = 'C'; // 
                        else if (l == 'Z' && r == 'a')
                             gates[i1].out->expr = 'C'; // 
                        else
                        {
                            printf("Add O %c %c\n", l, r);
                            goto print;
                        }
                    }
                    else // 'X'
                    {
                        if (l == 'X' && r == 'Y')
                             gates[i1].out->expr = 'Z'; // x ^ y
                        else if (l == 'x' && r == 'y')
                             gates[i1].out->expr = '^'; // x ^ y
                        else if (l == 'C' && r == '^')
                             gates[i1].out->expr = 'Z'; // x ^ y ^ C
                        else if (l == 'Z' && r == '^')
                             gates[i1].out->expr = 'd'; // 
                        else if (l == 'C' && r == 'a')
                             gates[i1].out->expr = 'Z'; // 
                        else
                        {
                            printf("Add X %c %c\n", l, r);
                            goto print;
                        }
                    }
                    go = TRUE;
                }
        }
    }
    
    for (int level = 0; level < 45; level++)
    {
        char name[4];
        sprintf(name, "z%02d", level);
        for (int i = 0; i < nr_wires; i++)
            if (wires[i].level == level)
            {
                if (wires[i].name[0] == 'z' && (strcmp(wires[i].name, name) != 0 || wires[i].expr != 'Z'))
                    printf("ANSWER: %2d %s %c\n", level, wires[i].name, wires[i].expr);
                if (wires[i].name[0] != 'z' && wires[i].expr == 'Z')
                    printf("ANSWER: %2d %s %c\n", level, wires[i].name, wires[i].expr);
            }
    }            

  print:
    for (int o = 1; o < order; o++)
        for (int i = 0; i < nr_wires; i++)
            if (wires[i].order == o)
            {
                printf("%03d ", wires[i].order);
                num_t bit = 1;
                bit = bit << 44;
                for (int j = 44; j >= 0; j--, bit /= 2)
                    printf("%c", wires[i].depend & bit ? 'B' : 'a');
                int gate_nr = gate_with(wires + i);
                if (gate_nr >= 0)
                {
                    printf(" %c(%c) %s %s -> ", gates[gate_nr].type, gates[gate_nr].out->expr, gates[gate_nr].in1->name, gates[gate_nr].in2->name);
                }
                else
                    printf(" I");
                printf(" %s\n", wires[i].name);
                break;
            }
}
```

At 0:49, maybe you do have to switch the wires.

```c
void dependOn()
{
    num_t one = 1;
    for (int i = 0; i < nr_wires; i++)
    {
        wires[i].depend = 0;
        wires[i].order = 0;
        wires[i].expr = ' ';
        wires[i].level = -1;
    }

    num_t depend = 1;
    int order = 1;
    for (int i = 0; i < 45; i++, depend *= 2)
    {
        char ext[3];
        sprintf(ext, "%02d", i);
        for (int j = 0; j < nr_wires; j++)
            if (   (wires[j].name[0] == 'x' || wires[j].name[0] == 'y')
                && strcmp(wires[j].name + 1, ext) == 0)
            {
                wires[j].depend = depend;
                wires[j].order = order + (wires[j].name[0] == 'y' ? 1 : 0);
                wires[j].expr = wires[j].name[0] + (i == 0 ? 'A' - 'a' : 0);
                wires[j].level = i;
            }
        order += 2;
        for (bool go = TRUE; go; )
        {
            go = FALSE;
            for (int i1 = 0; i1 < nr_gates; i1++)
                if (gates[i1].out->depend == 0 && gates[i1].in1->depend != 0 && gates[i1].in2->depend != 0)
                {
                    gates[i1].out->depend = gates[i1].in1->depend | gates[i1].in2->depend;
                    gates[i1].out->order = order++;
                    gates[i1].out->level = i;
                    char l = gates[i1].in1->expr;
                    char r = gates[i1].in2->expr;
                    if (l > r) { char h = l; l = r; r = h; }
                    if (gates[i1].type == 'A')
                    {
                        if (l == 'X' && r == 'Y')
                            gates[i1].out->expr = 'C'; // x && y
                        else if (l == 'x' && r == 'y')
                            gates[i1].out->expr = 'a'; // x && y
                        else if (l == 'C' && r == '^')
                            gates[i1].out->expr = 'b'; // C && (x ^ y)
                        else if (l == 'Z' && r == '^')
                            gates[i1].out->expr = 'c'; // (x ^ y) && (x ^ y ^ C)
                        else if (l == 'C' && r == 'a')
                            gates[i1].out->expr = 'e'; // (x ^ y) && (x ^ y ^ C)
                        else
                        {
                            printf("Add A %c %c\n", l, r); 
                            goto print;
                        }
                    }
                    else if (gates[i1].type == 'O')
                    {
                        if (l == 'a' && r == 'b')
                            gates[i1].out->expr = 'C'; // (x && y) || (C && (x ^ y)) 
                        else if (l == 'Z' && r == 'b')
                             gates[i1].out->expr = 'C'; // (x ^ y ^ C) || (C && (x ^ y))
                        else if (l == 'a' && r == 'c')
                             gates[i1].out->expr = 'C'; // 
                        else if (l == '^' && r == 'e')
                             gates[i1].out->expr = 'C'; // 
                        else if (l == 'Z' && r == 'a')
                             gates[i1].out->expr = 'C'; // 
                        else
                        {
                            printf("Add O %c %c\n", l, r);
                            goto print;
                        }
                    }
                    else // 'X'
                    {
                        if (l == 'X' && r == 'Y')
                             gates[i1].out->expr = 'Z'; // x ^ y
                        else if (l == 'x' && r == 'y')
                             gates[i1].out->expr = '^'; // x ^ y
                        else if (l == 'C' && r == '^')
                             gates[i1].out->expr = 'Z'; // x ^ y ^ C
                        else if (l == 'Z' && r == '^')
                             gates[i1].out->expr = 'd'; // 
                        else if (l == 'C' && r == 'a')
                             gates[i1].out->expr = 'Z'; // 
                        else
                        {
                            printf("Add X %c %c\n", l, r);
                            goto print;
                        }
                    }
                    go = TRUE;
                }
        }
        int z_not_Z = -1;
        int other_is_Z = -1;        
        for (int w = 0; w < nr_wires; w++)
            if (wires[w].level == i)
            {
                if (wires[w].name[0] == 'z' && wires[w].expr != 'Z')
                    z_not_Z = w;
                if (wires[w].name[0] != 'z' && wires[w].expr == 'Z')
                    other_is_Z = w;
            }
        if (z_not_Z != -1 || other_is_Z != -1)
        {
            if (z_not_Z == -1 || other_is_Z == -1)
            {
                printf("ERROR %s %s\n", 
                    z_not_Z == -1 ? "?" : wires[z_not_Z].name, 
                    other_is_Z == -1 ? "?" : wires[other_is_Z].name);
                goto print;
            }
            printf("ANSWER: %2d %s %c\n", i, wires[z_not_Z].name, wires[z_not_Z].expr);
            printf("ANSWER: %2d %s %c\n", i, wires[other_is_Z].name, wires[other_is_Z].expr);
            wires[other_is_Z].expr = wires[z_not_Z].expr;
            wires[z_not_Z].expr = 'Z';
        }
    }
    
    for (int level = 0; level < 45; level++)
    {
        char name[4];
        sprintf(name, "z%02d", level);
        for (int i = 0; i < nr_wires; i++)
            if (wires[i].level == level)
            {
                if (wires[i].name[0] == 'z' && (strcmp(wires[i].name, name) != 0 || wires[i].expr != 'Z'))
                    printf("ANSWER: %2d %s %c\n", level, wires[i].name, wires[i].expr);
                if (wires[i].name[0] != 'z' && wires[i].expr == 'Z')
                    printf("ANSWER: %2d %s %c\n", level, wires[i].name, wires[i].expr);
            }
    }            

  print:
    for (int o = 1; o < order; o++)
        for (int i = 0; i < nr_wires; i++)
            if (wires[i].order == o)
            {
                printf("%03d ", wires[i].order);
                num_t bit = 1;
                bit = bit << 44;
                for (int j = 44; j >= 0; j--, bit /= 2)
                    printf("%c", wires[i].depend & bit ? 'B' : 'a');
                int gate_nr = gate_with(wires + i);
                if (gate_nr >= 0)
                {
                    printf(" %c(%c) %s %s -> ", gates[gate_nr].type, gates[gate_nr].out->expr, gates[gate_nr].in1->name, gates[gate_nr].in2->name);
                }
                else
                    printf(" I");
                printf(" %s\n", wires[i].name);
                break;
            }
}
```

At 1:13, still only gives three differences..

```c
void dependOn()
{
    num_t one = 1;
    for (int i = 0; i < nr_wires; i++)
    {
        wires[i].depend = 0;
        wires[i].order = 0;
        wires[i].expr = ' ';
        wires[i].level = -1;
    }

    num_t depend = 1;
    int order = 1;
    for (int i = 0; i < 45; i++, depend *= 2)
    {
        char ext[3];
        sprintf(ext, "%02d", i);
        for (int j = 0; j < nr_wires; j++)
            if (   (wires[j].name[0] == 'x' || wires[j].name[0] == 'y')
                && strcmp(wires[j].name + 1, ext) == 0)
            {
                wires[j].depend = depend;
                wires[j].order = order + (wires[j].name[0] == 'y' ? 1 : 0);
                wires[j].expr = wires[j].name[0] + (i == 0 ? 'A' - 'a' : 0);
                wires[j].level = i;
            }
        order += 2;
        for (bool go = TRUE; go; )
        {
            go = FALSE;
            for (int i1 = 0; i1 < nr_gates; i1++)
                if (gates[i1].out->depend == 0 && gates[i1].in1->depend != 0 && gates[i1].in2->depend != 0)
                {
                    gates[i1].out->depend = gates[i1].in1->depend | gates[i1].in2->depend;
                    gates[i1].out->order = order++;
                    gates[i1].out->level = i;
                    char l = gates[i1].in1->expr;
                    char r = gates[i1].in2->expr;
                    if (l > r) { char h = l; l = r; r = h; }
                    if (gates[i1].type == 'A')
                    {
                        if (l == 'X' && r == 'Y')
                            gates[i1].out->expr = 'C'; // x && y
                        else if (l == 'x' && r == 'y')
                            gates[i1].out->expr = 'a'; // x && y
                        else if (l == 'C' && r == '^')
                            gates[i1].out->expr = 'b'; // C && (x ^ y)
                        //else if (l == 'Z' && r == '^')
                        //    gates[i1].out->expr = 'c'; // (x ^ y) && (x ^ y ^ C)
                        //else if (l == 'C' && r == 'a')
                        //    gates[i1].out->expr = 'e'; // (x ^ y) && (x ^ y ^ C)
                        else
                        {
                            printf("Add A %c %c\n", l, r); 
                            goto print;
                        }
                    }
                    else if (gates[i1].type == 'O')
                    {
                        if (l == 'a' && r == 'b')
                            gates[i1].out->expr = 'C'; // (x && y) || (C && (x ^ y)) 
                        else if (l == 'Z' && r == 'b')
                             gates[i1].out->expr = 'C'; // (x ^ y ^ C) || (C && (x ^ y))
                        //else if (l == 'a' && r == 'c')
                        //     gates[i1].out->expr = 'C'; // 
                        else if (l == '^' && r == 'e')
                             gates[i1].out->expr = 'C'; // 
                        else if (l == 'Z' && r == 'a')
                             gates[i1].out->expr = 'C'; // 
                        else
                        {
                            printf("Add O %c %c\n", l, r);
                            goto print;
                        }
                    }
                    else // 'X'
                    {
                        if (l == 'X' && r == 'Y')
                             gates[i1].out->expr = 'Z'; // x ^ y
                        else if (l == 'x' && r == 'y')
                             gates[i1].out->expr = '^'; // x ^ y
                        else if (l == 'C' && r == '^')
                             gates[i1].out->expr = 'Z'; // x ^ y ^ C
                        //else if (l == 'Z' && r == '^')
                        //     gates[i1].out->expr = 'd'; // 
                        //else if (l == 'C' && r == 'a')
                        //     gates[i1].out->expr = 'f'; // 
                        else
                        {
                            printf("Add X %c %c\n", l, r);
                            goto print;
                        }
                    }
                    go = TRUE;
                    // Big hack:
                    if (order == 170)
                    {
                        printf("ANSWER: wsv\nANSWER: rjm\n");
                        for (int i = 0; i < nr_wires; i++)
                            if (wires[i].order == 168)
                                wires[i].expr = 'a';
                            else if (wires[i].order == 169)
                                wires[i].expr = '^';
                    }
                }
        }
        int z_not_Z = -1;
        int other_is_Z = -1;        
        for (int w = 0; w < nr_wires; w++)
            if (wires[w].level == i)
            {
                if (wires[w].name[0] == 'z' && wires[w].expr != 'Z')
                    z_not_Z = w;
                if (wires[w].name[0] != 'z' && wires[w].expr == 'Z')
                    other_is_Z = w;
            }
        if (z_not_Z != -1 || other_is_Z != -1)
        {
            if (z_not_Z == -1 || other_is_Z == -1)
            {
                printf("ERROR %s %s\n", 
                    z_not_Z == -1 ? "?" : wires[z_not_Z].name, 
                    other_is_Z == -1 ? "?" : wires[other_is_Z].name);
                goto print;
            }
            printf("ANSWER: %s %c\n", wires[z_not_Z].name, wires[z_not_Z].expr);
            printf("ANSWER: %s %c\n", wires[other_is_Z].name, wires[other_is_Z].expr);
            wires[other_is_Z].expr = wires[z_not_Z].expr;
            wires[z_not_Z].expr = 'Z';
        }
    }
    
    for (int level = 0; level < 45; level++)
    {
        char name[4];
        sprintf(name, "z%02d", level);
        for (int i = 0; i < nr_wires; i++)
            if (wires[i].level == level)
            {
                if (wires[i].name[0] == 'z' && (strcmp(wires[i].name, name) != 0 || wires[i].expr != 'Z'))
                    printf("ANSWER: %2d %s %c\n", level, wires[i].name, wires[i].expr);
                if (wires[i].name[0] != 'z' && wires[i].expr == 'Z')
                    printf("ANSWER: %2d %s %c\n", level, wires[i].name, wires[i].expr);
            }
    }            

  print:
    for (int o = 1; o < order; o++)
        for (int i = 0; i < nr_wires; i++)
            if (wires[i].order == o)
            {
                printf("%03d ", wires[i].order);
                num_t bit = 1;
                bit = bit << 44;
                for (int j = 44; j >= 0; j--, bit /= 2)
                    printf("%c", wires[i].depend & bit ? 'B' : 'a');
                int gate_nr = gate_with(wires + i);
                if (gate_nr >= 0)
                {
                    printf(" %c(%c) %s %s -> ", gates[gate_nr].type, gates[gate_nr].out->expr, gates[gate_nr].in1->name, gates[gate_nr].in2->name);
                }
                else
                    printf(" I");
                printf(" %s\n", wires[i].name);
                break;
            }
}
```

At 1:37:03, I submitted the correct answer with the above program.


### Executing this page

The command to process this markdown file, is:
```
../IParse/software/MarkDownC Std.md Day24.md >day24.c; gcc -g -Wall day24.c -o day24; ./day24 24
```
I run the bash file [`runOnSave.sh`](runOnSave.sh) with `24` as the argument,
which everytime when I save this file, runs the above command and shows the
result or the first compile errors, if there are any.


