# Day 15 of Advent of Code 2024

The code below makes use of [a standard library](Std.md), which
also contains the `main` function that reads the input in the global variable `d`
where `n` contains the number of lines and `m` the length of the longest line,
and than calls the function `solve1` and `solve2`.

I started reading the puzzle at 9:14 and writing this at 9:20. Let try again to
solve this puzzle in one go.

```c
int x, y;

bool move(int dx, int dy)
{
    int ex = x + dx;
    int ey = y + dy;
    while (d[ey][ex] == 'O')
    {
        ex += dx;
        ey += dy;
    }
    if (d[ey][ex] == '.')
    {
        d[y][x] = '.';
        x += dx;
        y += dy;
        if (d[y][x] == 'O')
            d[ey][ex] = 'O';
        d[y][x] = '@';
    }
}



void solve1()
{
    // Locate the robot
    int i = 0;
    for (; d[i][0] == '#'; i++)
    {
        for (int j = 1; d[i][j] != '\0'; j++)
            if (d[i][j] == '@')
            {
                x = j;
                y = i;
            }
    }
    
    for (i++; i < n; i++)
        for (int j = 0; d[i][j] != '\0'; j++)
        {
            switch (d[i][j])
            {
                case '^': move(0, -1); break;
                case '<': move(-1, 0); break;
                case 'v': move(0, 1); break;
                case '>': move(1, 0); break;
            }
        }

    num_t answer = 0;
    for (i = 0; d[i][0] == '#'; i++)
        for (int j = 1; d[i][j] != '\0'; j++)
            if (d[i][j] == 'O')
                answer += 100 * i + j;
        
    printf("%lld\n", answer);
}
```

At 9::45:17, I got this in one try.

### Second part of the puzzle.

Okay, that is a bit more complicated. Let see if I can do the
second part also in one try. In my input, the warehose is 50 by 50.

```c

char w[50][100];

bool can_move_up_down(int sx, int sy, int dy)
{
    if (w[sy][sx] == '#')
        return FALSE;
    if (w[sy][sx] == '@')
        return can_move_up_down(sx, sy+dy, dy);    
    if (w[sy][sx] == '[')
    {
        w[sy][sx  ] = '<';
        w[sy][sx+1] = '>';
        return    can_move_up_down(sx  , sy+dy, dy) 
               && can_move_up_down(sx+1, sy+dy, dy);
    }
    if (w[sy][sx] == ']')
    {
        w[sy][sx-1] = '<';
        w[sy][sx  ] = '>';
        return    can_move_up_down(sx-1, sy+dy, dy) 
               && can_move_up_down(sx  , sy+dy, dy);
    }
    return TRUE;
}

void move_up_down(int sx, int sy, int dy, bool move)
{
    if (w[sy][sx] == '@')
    {
        move_up_down(sx, sy+dy, dy, move);
        if (move)
        {
            w[sy+dy][sx] = '@';
            w[sy][sx] = '.';
            y += dy;
        }
    }
    else if (w[sy][sx] == '<')
    {
        move_up_down(sx  , sy+dy, dy, move);
        move_up_down(sx+1, sy+dy, dy, move);
        if (move)
        {
            w[sy+dy][sx  ] = '[';
            w[sy+dy][sx+1] = ']';
            w[sy][sx  ] = '.';
            w[sy][sx+1] = '.';
        }
    }
    else if (w[sy][sx] == '>')
    {
        move_up_down(sx-1, sy+dy, dy, move);
        move_up_down(sx  , sy+dy, dy, move);
        if (move)
        {
            w[sy+dy][sx-1] = '[';
            w[sy+dy][sx  ] = ']';
            w[sy][sx-1] = '.';
            w[sy][sx  ] = '.';
        }
    }
}

void solve2()
{
    // create new warehose
    int i;
    for (i = 0; d[i][0] == '#'; i++)
        for (int j = 1; d[i][j] != '\0'; j++)
            if (d[i][j] == '@')
            {
                w[i][2*j] = '@';
                w[i][2*j+1] = '.';
                x = 2*j;
                y = i;
            }
            else if (d[i][j] == 'O')
            {
                w[i][2*j] = '[';
                w[i][2*j+1] = ']';
            }
            else
                w[i][2*j] = w[i][2*j+1] = d[i][j];
    
    for (i++; i < n; i++)
        for (int j = 0; d[i][j] != '\0'; j++)
        {
            switch (d[i][j])
            {
                case '^': move_up_down(x, y, -1, can_move_up_down(x, y, -1)); break;
                case 'v': move_up_down(x, y,  1, can_move_up_down(x, y,  1)); break;
                case '<':
                    {
                        int sx = x - 1;
                        while (w[y][sx] == ']')
                            sx -= 2;
                        if (w[y][sx] == '.')
                        {
                            while (w[y][sx+1] == '[')
                            {
                                w[y][sx] = '[';
                                w[y][sx+1] = ']';
                                sx += 2;
                            }
                            w[y][x] = '.';
                            x--;
                            w[y][x] = '@';
                        }
                    }
                    break;    
                case '>':
                    {
                        int sx = x + 1;
                        while (w[y][sx] == '[')
                            sx += 2;
                        if (w[y][sx] == '.')
                        {
                            while (w[y][sx-1] == ']')
                            {
                                w[y][sx] = ']';
                                w[y][sx-1] = '[';
                                sx -= 2;
                            }
                            w[y][x] = '.';
                            x++;
                            w[y][x] = '@';
                        }
                    }
                    break;    
            }
        }

    num_t answer = 0;
    for (i = 0; d[i][0] == '#'; i++)
        for (int j = 1; d[i][j] != '\0'; j++)
            if (d[i][j] == '[')
                answer += 100 * i + j;
        
    printf("%lld\n", answer);
}

```

At 11:20, after four fixes to get the program compile, it
returned a segmentation fault. I did take a break to shower and
while in the shower, I got some ideas to improve the program to
prevent unnecessary recursion.

```c

char w[50][100];

void move_up_down(int sx, int sy, int dy, bool move)
{
    if (w[sy][sx] == '@')
    {
        move_up_down(sx, sy+dy, dy, move);
        if (move)
        {
            w[sy+dy][sx] = '@';
            w[sy][sx] = '.';
            y += dy;
        }
    }
    else if (w[sy][sx] == '<')
    {
        w[sy][sx  ] = '[';
        w[sy][sx+1] = ']';
        move_up_down(sx  , sy+dy, dy, move);
        move_up_down(sx+1, sy+dy, dy, move);
        if (move)
        {
            w[sy+dy][sx  ] = '[';
            w[sy+dy][sx+1] = ']';
            w[sy][sx  ] = '.';
            w[sy][sx+1] = '.';
        }
    }
    else if (w[sy][sx] == '>')
    {
        w[sy][sx-1] = '[';
        w[sy][sx  ] = ']';
        move_up_down(sx-1, sy+dy, dy, move);
        move_up_down(sx  , sy+dy, dy, move);
        if (move)
        {
            w[sy+dy][sx-1] = '[';
            w[sy+dy][sx  ] = ']';
            w[sy][sx-1] = '.';
            w[sy][sx  ] = '.';
        }
    }
}
    
```

At 11:34, the above code returned 0 as answer for the first puzzle, which
cannot be correct.

```c
void solve2()
{
    // create new warehose
    int i;
    for (i = 0; d[i][0] == '#'; i++)
        for (int j = 1; d[i][j] != '\0'; j++)
            if (d[i][j] == '@')
            {
                w[i][2*j] = '@';
                w[i][2*j+1] = '.';
                x = 2*j;
                y = i;
            }
            else if (d[i][j] == 'O')
            {
                w[i][2*j] = '[';
                w[i][2*j+1] = ']';
            }
            else
                w[i][2*j] = w[i][2*j+1] = d[i][j];
    
    for (i++; i < n; i++)
        for (int j = 0; d[i][j] != '\0'; j++)
        {
            switch (d[i][j])
            {
                case '^': move_up_down(x, y, -1, can_move_up_down(x, y, -1)); break;
                case 'v': move_up_down(x, y,  1, can_move_up_down(x, y,  1)); break;
                case '<':
                    {
                        int sx = x - 1;
                        while (w[y][sx] == ']')
                            sx -= 2;
                        if (w[y][sx] == '.')
                        {
                            while (w[y][sx+1] == '[')
                            {
                                w[y][sx] = '[';
                                w[y][sx+1] = ']';
                                sx += 2;
                            }
                            w[y][x] = '.';
                            x--;
                            w[y][x] = '@';
                        }
                    }
                    break;    
                case '>':
                    {
                        int sx = x + 1;
                        while (w[y][sx] == '[')
                            sx += 2;
                        if (w[y][sx] == '.')
                        {
                            while (w[y][sx-1] == ']')
                            {
                                w[y][sx] = ']';
                                w[y][sx-1] = '[';
                                sx -= 2;
                            }
                            w[y][x] = '.';
                            x++;
                            w[y][x] = '@';
                        }
                    }
                    break;    
            }
        }

    num_t answer = 0;
    for (i = 0; i < 50; i++)
        for (int j = 1; j < 100; j++)
            if (w[i][j] == '[')
                answer += 100 * i + j;
        
    printf("%lld\n", answer);
}

```

At 11:39, that did not return the correct answer. Lets try to do
some debugging with the example input.

```c

void pre() { use_sample = TRUE; }

void solve2()
{
    read_input("15");
    
    // create new warehose
    int i;
    for (i = 0; d[i][0] == '#'; i++)
        for (int j = 0; d[i][j] != '\0'; j++)
            if (d[i][j] == '@')
            {
                w[i][2*j] = '@';
                w[i][2*j+1] = '.';
                x = 2*j;
                y = i;
            }
            else if (d[i][j] == 'O')
            {
                w[i][2*j] = '[';
                w[i][2*j+1] = ']';
            }
            else
                w[i][2*j] = w[i][2*j+1] = d[i][j];
    
    for (i++; i < n; i++)
        for (int j = 0; d[i][j] != '\0'; j++)
        {
            switch (d[i][j])
            {
                case '^': move_up_down(x, y, -1, can_move_up_down(x, y, -1)); break;
                case 'v': move_up_down(x, y,  1, can_move_up_down(x, y,  1)); break;
                case '<':
                    {
                        int sx = x - 1;
                        while (w[y][sx] == ']')
                            sx -= 2;
                        if (w[y][sx] == '.')
                        {
                            while (w[y][sx+1] == '[')
                            {
                                w[y][sx] = '[';
                                w[y][sx+1] = ']';
                                sx += 2;
                            }
                            w[y][x] = '.';
                            x--;
                            w[y][x] = '@';
                        }
                    }
                    break;    
                case '>':
                    {
                        int sx = x + 1;
                        while (w[y][sx] == '[')
                            sx += 2;
                        if (w[y][sx] == '.')
                        {
                            while (w[y][sx-1] == ']')
                            {
                                w[y][sx] = ']';
                                w[y][sx-1] = '[';
                                sx -= 2;
                            }
                            w[y][x] = '.';
                            x++;
                            w[y][x] = '@';
                        }
                    }
                    break;    
            }
            
            for (int i1 = 0; i1 < 10; i1++)
            {
                for (int j1 = 0; j1 < 20; j1++)
                    printf("%c", w[i1][j1]);
                printf("\n");
            }
            printf("\n");
        }

    num_t answer = 0;
    for (i = 0; i < 50; i++)
        for (int j = 1; j < 100; j++)
            if (w[i][j] == '[')
                answer += 100 * i + j;
        
    printf("%lld\n", answer);
}

```

There was something wrong with the initialization of `w` (the loop with `j` started
at 1 instead of 0) and I also should have read the input again, because `solve1`
modifies the input. I fixed that in the above code.

At 12:05, it returned the correct answer for the example input.

```c

void pre() { use_sample = FALSE; }
```

At 12:08:59, it returned the correct answer for my puzzle input.


### Executing this page

The command to process this markdown file, is:
```
../IParse/software/MarkDownC Std.md Day15.md >day15.c; gcc -g -Wall day15.c -o day15; ./day15 15
```
I run the bash file [`runOnSave.sh`](runOnSave.sh) with `15` as the argument,
which everytime when I save this file, runs the above command and shows the
result or the first compile errors, if there are any.


