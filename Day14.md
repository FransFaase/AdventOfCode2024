# Day 14 of Advent of Code 2024

The code below makes use of [a standard library](Std.md), which
also contains the `main` function that reads the input in the global variable `d`
where `n` contains the number of lines and `m` the length of the longest line,
and than calls the function `solve1` and `solve2`.

I already read the puzzle in the morning and thought a little bit about it. At
13:49, I started writing this.

```c
void solve1()
{
    num_t w = 101;
    num_t h = 103;
    num_t w2 = w / 2;
    num_t h2 = h / 2;
    num_t steps = 100;
    num_t quadrant[4] = { 0, 0, 0, 0 };
    for (int i = 0; i < n; i++)
    {
        char *s = d[i] + 2;
        num_t px = parse_number(&s); s++;
        num_t py = parse_number(&s); s += 3;
        num_t vx = parse_number(&s); s++;
        num_t vy = parse_number(&s);
        num_t x = (px + steps * (vx + w)) % w;
        num_t y = (py + steps * (vy + h)) % h;
        if (x < w2 && y < h2) quadrant[0]++;
        if (x > w2 && y < h2) quadrant[1]++;
        if (x < w2 && y > h2) quadrant[2]++;
        if (x > w2 && y > h2) quadrant[3]++;
    }    
        
    printf("%lld\n", quadrant[0] * quadrant[1] * quadrant[2] * quadrant[3]);
}
```

At 14:00:47, that returned the correct answer for the first part of the puzzle
in a single try (including compiling correctly).

### Second part of the puzzle.

Okay, but how is the shape of a christmas tree defined. At 14:14, I got the idea
that maybe the example input gives some clue. Lets see.

```c

#define N 500
#define W 101
#define H 103

char *ds[12] = {
"p=0,4 v=3,-3",
"p=6,3 v=-1,-3",
"p=10,3 v=-1,2",
"p=2,0 v=2,-1",
"p=0,0 v=1,3",
"p=3,0 v=-2,-2",
"p=7,6 v=-1,-3",
"p=3,0 v=-1,-2",
"p=9,3 v=2,3",
"p=7,3 v=-1,2",
"p=2,4 v=2,-3",
"p=9,5 v=-3,-3",
};
char map[W][H];


void solve2()
{
    n = 12;
    int w = 11;
    int h = 7;
    num_t px[N];
    num_t py[N];
    num_t vx[N];
    num_t vy[N]; 
    for (int i = 0; i < n; i++)
    {
        char *s = ds[i] + 2;
        px[i] = parse_number(&s); s++;
        py[i] = parse_number(&s); s += 3;
        vx[i] = parse_number(&s); s++;
        vy[i] = parse_number(&s);
    }
    
    for (int s = 0; s <= 100; s++)
    {
        for (int x = 0; x < w; x++)
            for (int y = 0; y < h; y++)
                map[x][y] = '.';
        
        for (int i = 0; i < n; i++)
        {
            num_t x = (px[i] + s * (vx[i] + w)) % w;
            num_t y = (py[i] + s * (vy[i] + h)) % h;
            if (map[x][y] == '.')
                map[x][y] = '1';
            else if (map[x][y] < '9')
                map[x][y]++;
        }
        for (int y = 0; y < h; y++)
        {
            for (int x = 0; x < w; x++)
                printf("%c", map[x][y]);
            printf("\n");
        }
        printf("\n");
    }
}

```

At 14:31, the above produced some output. For `step` is 100 this
does return the output that is given for the example. Again,
verifies that the algorithm is correct. I looked through the
output, but could not discover any thing in the shape of a 
christmas tree.

Lets think about some way to detect the shape of a christmas
tree. For that the top left and top right corners should be
as empty as possible. Left calculate the emptiness and print
output for each time the emptiness gets bigger.

```c
void solve2()
{
    num_t px[N];
    num_t py[N];
    num_t vx[N];
    num_t vy[N]; 
    for (int i = 0; i < n; i++)
    {
        char *s = d[i] + 2;
        px[i] = parse_number(&s); s++;
        py[i] = parse_number(&s); s += 3;
        vx[i] = parse_number(&s); s++;
        vy[i] = parse_number(&s);
    }
    int w = 101;
    int h = 103;
    
    int max_empty = 0;
    for (int s = 0; s <= 100; s++)
    {
        int min_empty = h + w;
        
        for (int i = 0; i < n; i++)
        {
            num_t x = (px[i] + s * (vx[i] + w)) % w;
            num_t y = (py[i] + s * (vy[i] + h)) % h;
            if (x + y < min_empty)
                min_empty = x + y;
            if ((w - x) + y < min_empty)
                min_empty = (w - x) + y;
        }
        if (min_empty > max_empty)
        {
            max_empty = min_empty;
            printf("s = %d: %d\n", s, max_empty);
            for (int y = 0; y < h; y++)
            {
                for (int x = 0; x < w; x++)
                    printf("%c", map[x][y]);
                printf("\n");
            }
        }
        printf("\n");
    }
}
```

At 14:44, the above code did not return the exepected output.
I should not have removed all the `map` related code.

```c
void solve2()
{
    num_t px[N];
    num_t py[N];
    num_t vx[N];
    num_t vy[N]; 
    for (int i = 0; i < n; i++)
    {
        char *s = d[i] + 2;
        px[i] = parse_number(&s); s++;
        py[i] = parse_number(&s); s += 3;
        vx[i] = parse_number(&s); s++;
        vy[i] = parse_number(&s);
    }
    int w = 101;
    int h = 103;
    
    int max_empty = 0;
    for (int s = 0; s <= 100; s++)
    {
        for (int x = 0; x < w; x++)
            for (int y = 0; y < h; y++)
                map[x][y] = '.';

        int min_empty = h + w;
        
        for (int i = 0; i < n; i++)
        {
            num_t x = (px[i] + s * (vx[i] + w)) % w;
            num_t y = (py[i] + s * (vy[i] + h)) % h;
            if (x + y < min_empty)
                min_empty = x + y;
            if ((w - x) + y < min_empty)
                min_empty = (w - x) + y;
            if (map[x][y] == '.')
                map[x][y] = '1';
            else if (map[x][y] < '9')
                map[x][y]++;
        }
        if (min_empty > max_empty)
        {
            max_empty = min_empty;
            printf("s = %d: %d\n", s, max_empty);
            for (int y = 0; y < h; y++)
            {
                for (int x = 0; x < w; x++)
                    printf("%c", map[x][y]);
                printf("\n");
            }
            printf("\n");
        }
    }
}
```

At 14:48, I did return some output, but after 100 steps, it does not
look like a tree yet. Lets try some more steps.

```c
void solve2()
{
    num_t px[N];
    num_t py[N];
    num_t vx[N];
    num_t vy[N]; 
    for (int i = 0; i < n; i++)
    {
        char *s = d[i] + 2;
        px[i] = parse_number(&s); s++;
        py[i] = parse_number(&s); s += 3;
        vx[i] = parse_number(&s); s++;
        vy[i] = parse_number(&s);
    }
    int w = 101;
    int h = 103;
    
    int max_empty = 0;
    for (int s = 0; s <= 1000000; s++)
    {
        for (int x = 0; x < w; x++)
            for (int y = 0; y < h; y++)
                map[x][y] = '.';

        int min_empty = h + w;
        
        for (int i = 0; i < n; i++)
        {
            num_t x = (px[i] + s * (vx[i] + w)) % w;
            num_t y = (py[i] + s * (vy[i] + h)) % h;
            if (x + y < min_empty)
                min_empty = x + y;
            if ((w - x) + y < min_empty)
                min_empty = (w - x) + y;
            if (map[x][y] == '.')
                map[x][y] = '1';
            else if (map[x][y] < '9')
                map[x][y]++;
        }
        if (min_empty >= max_empty)
        {
            max_empty = min_empty;
            printf("s = %d: %d\n", s, max_empty);
            for (int y = 0; y < h; y++)
            {
                for (int x = 0; x < w; x++)
                    printf("%c", map[x][y]);
                printf("\n");
            }
            printf("\n");
        }
    }
}
```

At 14:51, that still did not return anything looking like
a christmas tree.

At 14:54, maybe the tree is not centered at the bottom,
but somewhere in the middle. It looks like the pattern is repeating
after some time. Of course every robot is going to return at
the same location after a number of steps. We could calculate the
maximum cycle time.

At 15:03, I realized that 101 and 103 are prime, which means that
the maximum cycle time is 101 * 103 = 10403.

At 15:08, I thought it might be a good idea to find the step at
which the robots are within the narrows possible rectangle.

```c
void solve2()
{
    num_t px[N];
    num_t py[N];
    num_t vx[N];
    num_t vy[N]; 
    for (int i = 0; i < n; i++)
    {
        char *s = d[i] + 2;
        px[i] = parse_number(&s); s++;
        py[i] = parse_number(&s); s += 3;
        vx[i] = parse_number(&s); s++;
        vy[i] = parse_number(&s);
    }
    int w = 101;
    int h = 103;
    int wh = w * h;

    int max_width = 0;
    for (int s = 0; s <= wh; s++)
    {
        for (int x = 0; x < w; x++)
            for (int y = 0; y < h; y++)
                map[x][y] = '.';

        int min_empty = h + w;
        
        int min_x = w;
        int max_x = 0;
        for (int i = 0; i < n; i++)
        {
            num_t x = (px[i] + s * (vx[i] + w)) % w;
            num_t y = (py[i] + s * (vy[i] + h)) % h;
            if (x < min_x)
                min_x = x;
            if (x > max_x)
                max_x = x;
        }
        if (max_x - min_x <= max_width)
        {
            max_width = min_x - min_x;
            printf("s = %d: %d\n", s, max_width);
            for (int y = 0; y < h; y++)
            {
                for (int x = 0; x < w; x++)
                    printf("%c", map[x][y]);
                printf("\n");
            }
            printf("\n");
        }
    }
}
```

At 15:14, that did not print anything. Mixed up minimum and maximum.

```c
void solve2()
{
    num_t px[N];
    num_t py[N];
    num_t vx[N];
    num_t vy[N]; 
    for (int i = 0; i < n; i++)
    {
        char *s = d[i] + 2;
        px[i] = parse_number(&s); s++;
        py[i] = parse_number(&s); s += 3;
        vx[i] = parse_number(&s); s++;
        vy[i] = parse_number(&s);
    }
    int w = 101;
    int h = 103;
    int wh = w * h;

    int min_width = w;
    for (int s = 0; s <= wh; s++)
    {
        for (int x = 0; x < w; x++)
            for (int y = 0; y < h; y++)
                map[x][y] = '.';

        int min_empty = h + w;
        
        int min_x = w;
        int max_x = 0;
        for (int i = 0; i < n; i++)
        {
            num_t x = (px[i] + s * (vx[i] + w)) % w;
            num_t y = (py[i] + s * (vy[i] + h)) % h;
            if (x < min_x)
                min_x = x;
            if (x > max_x)
                max_x = x;
        }
        if (max_x - min_x <= min_width)
        {
            min_width = min_x - min_x;
            printf("s = %d: %d\n", s, min_width);
            for (int y = 0; y < h; y++)
            {
                for (int x = 0; x < w; x++)
                    printf("%c", map[x][y]);
                printf("\n");
            }
            printf("\n");
        }
    }
}
```

At 15:16, that returned a completly empty map. I must be doing
something wrong.

```c
void solve2()
{
    num_t px[N];
    num_t py[N];
    num_t vx[N];
    num_t vy[N]; 
    for (int i = 0; i < n; i++)
    {
        char *s = d[i] + 2;
        px[i] = parse_number(&s); s++;
        py[i] = parse_number(&s); s += 3;
        vx[i] = parse_number(&s); s++;
        vy[i] = parse_number(&s);
    }
    int w = 101;
    int h = 103;
    int max_steps = w * h;
    
    int min_width = w;
    for (int s = 0; s <= max_steps; s++)
    {
        for (int x = 0; x < w; x++)
            for (int y = 0; y < h; y++)
                map[x][y] = '.';

        int min_x = w;
        int max_x = 0;
        for (int i = 0; i < n; i++)
        {
            num_t x = (px[i] + s * (vx[i] + w)) % w;
            num_t y = (py[i] + s * (vy[i] + h)) % h;
            if (x < min_x)
                min_x = x;
            if (x > max_x)
                max_x = x;
            if (map[x][y] == '.')
                map[x][y] = '1';
            else if (map[x][y] < '9')
                map[x][y]++;
        }
        if (max_x - min_x <= min_width)
        {
            min_width = max_x - min_x;
            printf("s = %d: %d\n", s, min_width);
            for (int y = 0; y < h; y++)
            {
                for (int x = 0; x < w; x++)
                    printf("%c", map[x][y]);
                printf("\n");
            }
            printf("\n");
        }
    }
}
```

At 15:25, this did return some data, but the minimum width is
something like 99, so not realy interesting.

At 15:27, I reread the puzzle description and noticed the
text 'most of the robots'. Thus not 'all of the robots' as I
had presumed.

Lets print out the distibution of the robots along the x-axes.

```c
void solve2()
{
    num_t px[N];
    num_t py[N];
    num_t vx[N];
    num_t vy[N]; 
    for (int i = 0; i < n; i++)
    {
        char *s = d[i] + 2;
        px[i] = parse_number(&s); s++;
        py[i] = parse_number(&s); s += 3;
        vx[i] = parse_number(&s); s++;
        vy[i] = parse_number(&s);
    }
    int w = 101;
    int h = 103;
    int max_steps = w * h;
    
    int min_width = w;
    for (int s = 0; s <= max_steps; s++)
    {
        int nr_x[101];
        for (int i = 0; i < 101; i++)
            nr_x[i] = 0;

        for (int i = 0; i < n; i++)
        {
            num_t x = (px[i] + s * (vx[i] + w)) % w;
            num_t y = (py[i] + s * (vy[i] + h)) % h;
            nr_x[x]++;
        }
        for (int i = 0; i < 101; i++)
            if (nr_x[i] == 0)
                printf(".");
            else if (nr_x[i] >= 26)
                printf("*");
            else
                printf("%c", nr_x[i] + 'A');
        printf(": %d\n", s);
    }
}
```

At 15:36, that returned lines almost all looking the same.

```c
void solve2()
{
    num_t px[N];
    num_t py[N];
    num_t vx[N];
    num_t vy[N]; 
    for (int i = 0; i < n; i++)
    {
        char *s = d[i] + 2;
        px[i] = parse_number(&s); s++;
        py[i] = parse_number(&s); s += 3;
        vx[i] = parse_number(&s); s++;
        vy[i] = parse_number(&s);
    }
    int w = 101;
    int h = 103;
    int max_steps = w * h;
    
    int min_width = w;
    for (int s = 0; s <= max_steps; s++)
    {
        int nr_x[101];
        for (int i = 0; i < 101; i++)
            nr_x[i] = 0;

        for (int i = 0; i < n; i++)
        {
            num_t x = (px[i] + s * (vx[i] + w)) % w;
            num_t y = (py[i] + s * (vy[i] + h)) % h;
            nr_x[x]++;
        }
        for (int i = 0; i < 101; i++)
            if (nr_x[i] <= 10)
                printf(".");
            else if (nr_x[i] >= 36)
                printf("*");
            else
                printf("%c", nr_x[i] + 'A');
        printf(": %d\n", s);
    }
}
```

At about 15:38, this did produce some interesting patterns.
I returned the first step with a concentration at some spot,
but the answer was too low. Lets also try this for y-axes.

```c
void solve2()
{
    num_t px[N];
    num_t py[N];
    num_t vx[N];
    num_t vy[N]; 
    for (int i = 0; i < n; i++)
    {
        char *s = d[i] + 2;
        px[i] = parse_number(&s); s++;
        py[i] = parse_number(&s); s += 3;
        vx[i] = parse_number(&s); s++;
        vy[i] = parse_number(&s);
    }
    int w = 101;
    int h = 103;
    int max_steps = w * h;
    
    int min_width = w;
    for (int s = 0; s <= max_steps; s++)
    {
        int nr_x[101];
        for (int i = 0; i < 101; i++)
            nr_x[i] = 0;
        int nr_y[103];
        for (int i = 0; i < 103; i++)
            nr_y[i] = 0;

        for (int i = 0; i < n; i++)
        {
            num_t x = (px[i] + s * (vx[i] + w)) % w;
            num_t y = (py[i] + s * (vy[i] + h)) % h;
            nr_x[x]++;
            nr_y[y]++;
        }
        for (int i = 0; i < 101; i++)
            if (nr_x[i] <= 10)
                printf(".");
            else if (nr_x[i] >= 36)
                printf("*");
            else
                printf("%c", nr_x[i] + 'A');
        printf(" ");
        for (int i = 0; i < 103; i++)
            if (nr_y[i] <= 10)
                printf(".");
            else if (nr_y[i] >= 36)
                printf("*");
            else
                printf("%c", nr_y[i] + 'A');
        printf(": %d\n", s);
    }
}
```

At 15:43, that returned some output.

At 15:49, I found some line with both a concentration for the x and y-axes,
but it was not the correct answer. At 14:52:42, I did submit the correct
answer. Looks like it was correct, but I made a copy and paste error.

Lets have a look at the christmas tree:

```c
void solve2()
{
    num_t px[N];
    num_t py[N];
    num_t vx[N];
    num_t vy[N]; 
    for (int i = 0; i < n; i++)
    {
        char *s = d[i] + 2;
        px[i] = parse_number(&s); s++;
        py[i] = parse_number(&s); s += 3;
        vx[i] = parse_number(&s); s++;
        vy[i] = parse_number(&s);
    }
    int w = 101;
    int h = 103;
    
    int s = 7338; // My answer

    for (int x = 0; x < w; x++)
        for (int y = 0; y < h; y++)
            map[x][y] = '.';

    int min_empty = h + w;
    
    for (int i = 0; i < n; i++)
    {
        num_t x = (px[i] + s * (vx[i] + w)) % w;
        num_t y = (py[i] + s * (vy[i] + h)) % h;
        if (x + y < min_empty)
            min_empty = x + y;
        if ((w - x) + y < min_empty)
            min_empty = (w - x) + y;
        if (map[x][y] == '.')
            map[x][y] = '1';
        else if (map[x][y] < '9')
            map[x][y]++;
    }
    for (int y = 0; y < h; y++)
    {
        for (int x = 0; x < w; x++)
            printf("%c", map[x][y]);
        printf("\n");
    }
    printf("\n");
}
```

This returned:
```
.....................................................................................................
.......1.............................................................................................
...................1....1.1..........................................................................
.................................................................................1...................
............................................1.........1....1.........................................
................................1....................................................................
..................1..................................................................................
...1.......................................................................1.........................
...............................................................1.....................................
..................1...................................1............1.................................
.1..1................................................................................................
......................1..............................................................1...............
................1..................1.......1...............................1.........................
............................................................................1........................
.............1.....................1.................................................................
................................1.....................................................1..............
.1..................1......1.....................................1...................................
...............1................................................1....................................
...............1....1................................................................................
...............................................................................................1.....
......................................................................1..............................
......1.............................................................................1.....1..........
.........................1...........................................................................
......1.........................1............................................1.......................
..........1...............................................1..........................................
.....................................................................................................
.....................................................................................................
........................................1.......1...............11.............1.....................
.....................................................................................................
................................................................................................1....
1.........................................................................................1..........
......1..............................1.......1.......................................................
.....................................................................................................
.................................................................................1.1.................
...............1111111111111111111111111111111.......................................................
...............1.............................1...............1.......................................
...............1.............................1.......................................1...............
...............1.............................1..........................1............................
1..............1.............................1.........................................1.............
...............1..............1..............1.....................................1............1....
...............1.............111.............1.......................................................
.1.............1............11111............1.......................1.........................1.....
...............1...........1111111...........1................................................11.....
...............1..........111111111..........1..............................................1........
...............1............11111............1..........1....................1.....................1.
.............1.1...........1111111...........1.......................................................
...............1..........111111111..........1.......................................................
...............1.........11111111111.........1.......................................................
...............1........1111111111111........1.............1.............1.......1...................
...............1..........111111111..........1...1...................................................
...............1.........11111111111.........1.......................................................
......1........1........1111111111111........1.........................................1.............
...............1.......111111111111111.......1..............11...................1...............1...
...............1......11111111111111111......1.................1.....................................
...............1........1111111111111........1.......................................................
...............1.......111111111111111.......1..........1............................................
...............1......11111111111111111......1..............1........................................
...............1.....1111111111111111111.....1.......................................................
...............1....111111111111111111111....1..1....................................................
...............1.............111.............1.......................1...............................
...............1.............111.............1.......................................................
.............1.1.............111.............1......1......................1.........................
.........1.....1.............................1...........................................1...........
...............1.............................1......................1......................1.........
...............1.............................1..............1........................................
...............1.............................1..................................................1....
...............1111111111111111111111111111111.......................................................
.....................................................................1........1......................
.....................................................................................................
.....................................................................................................
.........................................1...........................................................
.....................................................................................................
.............................................................................1.......................
...........................1.........................................................................
................................................................................1....................
....1................................................................................................
................................1...............................1....................................
.....................................................................................................
...................1..............1.....1............................................................
..............................................................1......................................
................................1....................................................................
..................................................................1..................................
.....................................................................................................
.......................1..........1....................1.............................................
........................1..............................1.............................................
.........................................1...........................................................
............................................................................1........................
...................................................................1.................................
....1......................................................1.........................................
...........................................................1...................................1.....
.................1...............................1.....1.................1...........................
.....................................................................................................
.....................................................................................................
1...1......................................1..........................1..............1...............
.....................................................................................................
...............................................................................................1.....
............................................................1........................................
.....................................1...............................................................
...................................................................................................1.
................................................1....................................................
...........1.........................................................................................
.....................................................................................................
.................1.............1.....1...............................................................

```


### Executing this page

The command to process this markdown file, is:
```
../IParse/software/MarkDownC Std.md Day14.md >day14.c; gcc -g -Wall day14.c -o day14; ./day14 14
```
I run the bash file [`runOnSave.sh`](runOnSave.sh) with `14` as the argument,
which everytime when I save this file, runs the above command and shows the
result or the first compile errors, if there are any.

