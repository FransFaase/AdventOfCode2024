# Day 16 of Advent of Code 2024

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

At 6:04, I checked that the size of my input is 141 by 141.

```c

num_t cost[141][141][4];

void solve1()
{
    int e_i, e_j;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
        {
            for (int r = 0; r < 4; r++)
                cost[i][j][r] = 100000000000L;
            if (d[i][j] == 'S')
                cost[i][j][3] = 0;
            if (d[i][j] == 'E')
            {
                e_i = i;
                e_j = j;
            }
        }
    for (bool go = TRUE; go;)
    {
        go = FALSE;
        
        for (int i = 0; i < n; i++)
            for (int j = 0; j < m; j++)
                if (d[i][j] != '#')
                {
                    num_t v;
                    for (int r = 0; r < 4; r++)
                    {
                        v = cost[i][j][(r+1)%4] + 1000;
                        if (v < cost[i][j][r]) { cost[i][j][r] = v; go = TRUE; }
                        v = cost[i][j][(r+3)%4] + 1000;
                        if (v < cost[i][j][r]) { cost[i][j][r] = v; go = TRUE; }
                    }
                    v = cost[i+1][j][0] + 1;                            
                    if (v < cost[i][j][0]) { cost[i][j][0] = v; go = TRUE; }
                    v = cost[i][j-1][1] + 1;                            
                    if (v < cost[i][j][1]) { cost[i][j][1] = v; go = TRUE; }
                    v = cost[i-1][j][2] + 1;                            
                    if (v < cost[i][j][2]) { cost[i][j][2] = v; go = TRUE; }
                    v = cost[i][j+1][3] + 1;                            
                    if (v < cost[i][j][3]) { cost[i][j][3] = v; go = TRUE; }
                }
    }
    num_t answer = 100000000000L;
    for (int r = 0; r < 4; r++)
        if (cost[e_i][e_j][r] < answer) answer = cost[e_i][e_j][r];
    printf("%lld\n", answer);    
}
```

At 6:26, that did not return the correct answer. Lets try the example
input.

```c
void pre() { use_sample = TRUE; }
```

At 6:28, it return the correct answer for the first sample input.

At 6:29, it return the correct answer for the second sample input.

```c

void solve1()
{
    int e_i, e_j;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
        {
            for (int r = 0; r < 4; r++)
                cost[i][j][r] = -1;
            if (d[i][j] == 'S')
                cost[i][j][3] = 0;
            if (d[i][j] == 'E')
            {
                e_i = i;
                e_j = j;
            }
        }
    for (bool go = TRUE; go;)
    {
        go = FALSE;
        
        for (int i = 0; i < n; i++)
            for (int j = 0; j < m; j++)
                if (d[i][j] != '#')
                {
                    num_t v;
                    for (int r = 0; r < 4; r++)
                    {
                        v = cost[i][j][(r+1)%4] + 1000;
                        if (v != 999 && (cost[i][j][r] == -1 || v < cost[i][j][r])) { cost[i][j][r] = v; go = TRUE; }
                        v = cost[i][j][(r+3)%4] + 1000;
                        if (v != 999 && (cost[i][j][r] == -1 || v < cost[i][j][r])) { cost[i][j][r] = v; go = TRUE; }
                    }
                    v = cost[i+1][j][0] + 1;                            
                    if (v != 0 && (cost[i][j][0] == -1 || v < cost[i][j][0])) { cost[i][j][0] = v; go = TRUE; }
                    v = cost[i][j-1][1] + 1;                            
                    if (v != 0 && (cost[i][j][1] == -1 || v < cost[i][j][1])) { cost[i][j][1] = v; go = TRUE; }
                    v = cost[i-1][j][2] + 1;                            
                    if (v != 0 && (cost[i][j][2] == -1 || v < cost[i][j][2])) { cost[i][j][2] = v; go = TRUE; }
                    v = cost[i][j+1][3] + 1;                            
                    if (v != 0 && (cost[i][j][3] == -1 || v < cost[i][j][3])) { cost[i][j][3] = v; go = TRUE; }
                }
    }
    for (int r = 0; r < 4; r++)
        printf("%lld\n", cost[e_i][e_j][r]);
}
```

At 6:39, that still gave the correct answer for the second sample.

```c
void pre() { use_sample = FALSE; }
```

And the same answer as before for my puzzle input.

```c

void solve1()
{
    int e_i, e_j;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
        {
            for (int r = 0; r < 4; r++)
                cost[i][j][r] = -1;
            if (d[i][j] == 'S')
                cost[i][j][1] = 0;
            if (d[i][j] == 'E')
            {
                e_i = i;
                e_j = j;
            }
        }
    for (bool go = TRUE; go;)
    {
        go = FALSE;
        
        for (int i = 0; i < n; i++)
            for (int j = 0; j < m; j++)
                if (d[i][j] != '#')
                {
                    num_t v;
                    for (int r = 0; r < 4; r++)
                    {
                        v = cost[i][j][(r+1)%4] + 1000;
                        if (v != 999 && (cost[i][j][r] == -1 || v < cost[i][j][r])) { cost[i][j][r] = v; go = TRUE; }
                        v = cost[i][j][(r+3)%4] + 1000;
                        if (v != 999 && (cost[i][j][r] == -1 || v < cost[i][j][r])) { cost[i][j][r] = v; go = TRUE; }
                    }
                    v = cost[i+1][j][0] + 1;                            
                    if (v != 0 && (cost[i][j][0] == -1 || v < cost[i][j][0])) { cost[i][j][0] = v; go = TRUE; }
                    v = cost[i][j-1][1] + 1;                            
                    if (v != 0 && (cost[i][j][1] == -1 || v < cost[i][j][1])) { cost[i][j][1] = v; go = TRUE; }
                    v = cost[i-1][j][2] + 1;                            
                    if (v != 0 && (cost[i][j][2] == -1 || v < cost[i][j][2])) { cost[i][j][2] = v; go = TRUE; }
                    v = cost[i][j+1][3] + 1;                            
                    if (v != 0 && (cost[i][j][3] == -1 || v < cost[i][j][3])) { cost[i][j][3] = v; go = TRUE; }
                }
    }
    for (int r = 0; r < 4; r++)
        printf("%lld\n", cost[e_i][e_j][r]);
}
```

At 6:48:02, this returned the correct answer. I must have made a mistake with respect to
the direction of East.

### Second part of the puzzle.

```c

bool on[141][141][4];

void solve2()
{
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            for (int r = 0; r < 4; r++)
                on[i][j][r] = d[i][j] == 'E';

    for (bool go = TRUE; go;)
    {
        go = FALSE;
        
        for (int i = 0; i < n; i++)
            for (int j = 0; j < m; j++)
                if (d[i][j] != '#')
                {
                    num_t v;
                    for (int r = 0; r < 4; r++)
                        if (on[i][j][r])
                        {
                            if (cost[i][j][r] == cost[i][j][(r+1)%4] + 1000) { on[i][j][(r+1)%4] = TRUE; go = TRUE; }
                            if (cost[i][j][r] == cost[i][j][(r+3)%4] + 1000) { on[i][j][(r+3)%4] = TRUE; go = TRUE; }
                        }
                    if (cost[i][j][0] == cost[i+1][j][0] + 1) { on[i+1][j][0] = TRUE; go = TRUE; }                        
                    if (cost[i][j][0] == cost[i][j-1][0] + 1) { on[i][j-1][0] = TRUE; go = TRUE; }                        
                    if (cost[i][j][0] == cost[i-1][j][0] + 1) { on[i-1][j][0] = TRUE; go = TRUE; }                        
                    if (cost[i][j][0] == cost[i][j+1][0] + 1) { on[i][j+1][0] = TRUE; go = TRUE; }                        
                }
    }
    
    num_t answer = 0;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            if (on[i][j][0] || on[i][j][1] || on[i][j][2] || on[i][j][3])
                answer++;
    printf("%lld\n", answer);
}

```

At 7:03, it turns out that is getting into an infinite loop;

```c

void solve2()
{
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            for (int r = 0; r < 4; r++)
                on[i][j][r] = d[i][j] == 'E';

    for (bool go = TRUE; go;)
    {
        go = FALSE;
        
        for (int i = 0; i < n; i++)
            for (int j = 0; j < m; j++)
                if (d[i][j] != '#')
                {
                    num_t v;
                    for (int r = 0; r < 4; r++)
                        if (on[i][j][r])
                        {
                            if (!on[i][j][(r+1)%4] && cost[i][j][r] == cost[i][j][(r+1)%4] + 1000) { on[i][j][(r+1)%4] = TRUE; go = TRUE; }
                            if (!on[i][j][(r+3)%4] && cost[i][j][r] == cost[i][j][(r+3)%4] + 1000) { on[i][j][(r+3)%4] = TRUE; go = TRUE; }
                        }
                    if (!on[i+1][j][0] && cost[i][j][0] == cost[i+1][j][0] + 1) { on[i+1][j][0] = TRUE; go = TRUE; }                        
                    if (!on[i][j-1][1] && cost[i][j][1] == cost[i][j-1][1] + 1) { on[i][j-1][1] = TRUE; go = TRUE; }                        
                    if (!on[i-1][j][2] && cost[i][j][2] == cost[i-1][j][2] + 1) { on[i-1][j][2] = TRUE; go = TRUE; }                        
                    if (!on[i][j+1][3] && cost[i][j][3] == cost[i][j+1][3] + 1) { on[i][j+1][3] = TRUE; go = TRUE; }                        
                }
    }
    
    num_t answer = 0;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            if (on[i][j][0] || on[i][j][1] || on[i][j][2] || on[i][j][3])
                answer++;
    printf("%lld\n", answer);
}

```

At 7:08, that did not return the correct answer for my input.
Let try the example input;

```c

void pre() { use_sample = TRUE; }
 
void solve2()
{
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            for (int r = 0; r < 4; r++)
                on[i][j][r] = d[i][j] == 'E';

    for (bool go = TRUE; go;)
    {
        go = FALSE;
        
        for (int i = 0; i < n; i++)
            for (int j = 0; j < m; j++)
                if (d[i][j] != '#')
                {
                    num_t v;
                    for (int r = 0; r < 4; r++)
                        if (on[i][j][r])
                        {
                            if (!on[i][j][(r+1)%4] && cost[i][j][r] == cost[i][j][(r+1)%4] + 1000) { on[i][j][(r+1)%4] = TRUE; go = TRUE; }
                            if (!on[i][j][(r+3)%4] && cost[i][j][r] == cost[i][j][(r+3)%4] + 1000) { on[i][j][(r+3)%4] = TRUE; go = TRUE; }
                        }
                    if (!on[i+1][j][0] && cost[i][j][0] == cost[i+1][j][0] + 1) { on[i+1][j][0] = TRUE; go = TRUE; }                        
                    if (!on[i][j-1][1] && cost[i][j][1] == cost[i][j-1][1] + 1) { on[i][j-1][1] = TRUE; go = TRUE; }                        
                    if (!on[i-1][j][2] && cost[i][j][2] == cost[i-1][j][2] + 1) { on[i-1][j][2] = TRUE; go = TRUE; }                        
                    if (!on[i][j+1][3] && cost[i][j][3] == cost[i][j+1][3] + 1) { on[i][j+1][3] = TRUE; go = TRUE; }                        
                }
    }
    
    num_t answer = 0;
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < m; j++)
        {
            if (on[i][j][0] || on[i][j][1] || on[i][j][2] || on[i][j][3])
            {
                printf("O");
                answer++;
            }
            else
                printf("%c", d[i][j]);
        }
        printf("\n");
    }
    printf("%lld\n", answer);
}

```

At 7:12, that clearly marks too many locations.

```c

void pre() { use_sample = TRUE; }

num_t answer1;

void solve1()
{
    ...
    answer1 = cost[e_i][e_j][0];
    for (int r = 1; r < 4; r++)
        if (cost[e_i][e_j][r] < answer1) answer1 = cost[e_i][e_j][r];
}

void solve2()
{
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            for (int r = 0; r < 4; r++)
                on[i][j][r] = d[i][j] == 'E' && cost[i][j][r] == answer1;

    for (bool go = TRUE; go;)
    {
        go = FALSE;
        
        for (int i = 0; i < n; i++)
            for (int j = 0; j < m; j++)
                if (d[i][j] != '#')
                {
                    num_t v;
                    for (int r = 0; r < 4; r++)
                        if (on[i][j][r])
                        {
                            if (!on[i][j][(r+1)%4] && cost[i][j][r] == cost[i][j][(r+1)%4] + 1000) { on[i][j][(r+1)%4] = TRUE; go = TRUE; }
                            if (!on[i][j][(r+3)%4] && cost[i][j][r] == cost[i][j][(r+3)%4] + 1000) { on[i][j][(r+3)%4] = TRUE; go = TRUE; }
                        }
                    if (!on[i+1][j][0] && cost[i][j][0] == cost[i+1][j][0] + 1) { on[i+1][j][0] = TRUE; go = TRUE; }                        
                    if (!on[i][j-1][1] && cost[i][j][1] == cost[i][j-1][1] + 1) { on[i][j-1][1] = TRUE; go = TRUE; }                        
                    if (!on[i-1][j][2] && cost[i][j][2] == cost[i-1][j][2] + 1) { on[i-1][j][2] = TRUE; go = TRUE; }                        
                    if (!on[i][j+1][3] && cost[i][j][3] == cost[i][j+1][3] + 1) { on[i][j+1][3] = TRUE; go = TRUE; }                        
                }
    }
    
    num_t answer = 0;
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < m; j++)
        {
            if (on[i][j][0] || on[i][j][1] || on[i][j][2] || on[i][j][3])
            {
                printf("O");
                answer++;
            }
            else
                printf("%c", d[i][j]);
        }
        printf("\n");
    }
    printf("%lld\n", answer);
}

```

At 7:18, this still returns the same incorrect answer.

```c
void solve2()
{
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            for (int r = 0; r < 4; r++)
                on[i][j][r] = d[i][j] == 'E' && cost[i][j][r] == answer1;

    for (bool go = TRUE; go;)
    {
        go = FALSE;
        
        for (int i = 0; i < n; i++)
            for (int j = 0; j < m; j++)
                if (d[i][j] != '#')
                {
                    num_t v;
                    for (int r = 0; r < 4; r++)
                        if (on[i][j][r])
                        {
                            if (!on[i][j][(r+1)%4] && cost[i][j][r] == cost[i][j][(r+1)%4] + 1000) { on[i][j][(r+1)%4] = TRUE; go = TRUE; }
                            if (!on[i][j][(r+3)%4] && cost[i][j][r] == cost[i][j][(r+3)%4] + 1000) { on[i][j][(r+3)%4] = TRUE; go = TRUE; }
                        }
                    if (on[i][j][0] && !on[i+1][j][0] && cost[i][j][0] == cost[i+1][j][0] + 1) { on[i+1][j][0] = TRUE; go = TRUE; }                        
                    if (on[i][j][1] && !on[i][j-1][1] && cost[i][j][1] == cost[i][j-1][1] + 1) { on[i][j-1][1] = TRUE; go = TRUE; }                        
                    if (on[i][j][2] && !on[i-1][j][2] && cost[i][j][2] == cost[i-1][j][2] + 1) { on[i-1][j][2] = TRUE; go = TRUE; }                        
                    if (on[i][j][3] && !on[i][j+1][3] && cost[i][j][3] == cost[i][j+1][3] + 1) { on[i][j+1][3] = TRUE; go = TRUE; }                        
                }
    }
    
    num_t answer = 0;
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < m; j++)
        {
            if (on[i][j][0] || on[i][j][1] || on[i][j][2] || on[i][j][3])
            {
                printf("O");
                answer++;
            }
            else
                printf("%c", d[i][j]);
        }
        printf("\n");
    }
    printf("%lld\n", answer);
}

```

Surprisingly, it return one more than given in the text.

At 7:27, I see that it is because on of the wall is marked counted.

```c
void solve2()
{
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            for (int r = 0; r < 4; r++)
                on[i][j][r] = d[i][j] == 'E' && cost[i][j][r] == answer1;

    for (bool go = TRUE; go;)
    {
        go = FALSE;
        
        for (int i = 0; i < n; i++)
            for (int j = 0; j < m; j++)
                if (d[i][j] != '#')
                {
                    num_t v;
                    for (int r = 0; r < 4; r++)
                        if (on[i][j][r])
                        {
                            if (!on[i][j][(r+1)%4] && cost[i][j][r] == cost[i][j][(r+1)%4] + 1000) { on[i][j][(r+1)%4] = TRUE; go = TRUE; }
                            if (!on[i][j][(r+3)%4] && cost[i][j][r] == cost[i][j][(r+3)%4] + 1000) { on[i][j][(r+3)%4] = TRUE; go = TRUE; }
                        }
                    if (d[i+1][j] != '#' && on[i][j][0] && !on[i+1][j][0] && cost[i][j][0] == cost[i+1][j][0] + 1) { on[i+1][j][0] = TRUE; go = TRUE; }                        
                    if (d[i][j-1] != '#' && on[i][j][1] && !on[i][j-1][1] && cost[i][j][1] == cost[i][j-1][1] + 1) { on[i][j-1][1] = TRUE; go = TRUE; }                        
                    if (d[i-1][j] != '#' && on[i][j][2] && !on[i-1][j][2] && cost[i][j][2] == cost[i-1][j][2] + 1) { on[i-1][j][2] = TRUE; go = TRUE; }                        
                    if (d[i][j+1] != '#' && on[i][j][3] && !on[i][j+1][3] && cost[i][j][3] == cost[i][j+1][3] + 1) { on[i][j+1][3] = TRUE; go = TRUE; }                        
                }
    }
    
    num_t answer = 0;
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < m; j++)
        {
            if (on[i][j][0] || on[i][j][1] || on[i][j][2] || on[i][j][3])
            {
                printf("O");
                answer++;
            }
            else
                printf("%c", d[i][j]);
        }
        printf("\n");
    }
    printf("%lld\n", answer);
}

```

At 7:31:07, it returns the correct answer.

I think, I could have benefited from using some macros:

```c
void pre() { use_sample = FALSE; }

#define COST(R1,I2,J2,R2,V) \
    v = cost[I2][J2][R2] + V; \
    if (v != (V-1) && (cost[i][j][R1] == -1 || v < cost[i][j][R1])) { cost[i][j][R1] = v; go = TRUE; }

num_t answer1;

void solve1()
{
    int e_i, e_j;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
        {
            for (int r = 0; r < 4; r++)
                cost[i][j][r] = -1;
            if (d[i][j] == 'S')
                cost[i][j][1] = 0;
            if (d[i][j] == 'E')
            {
                e_i = i;
                e_j = j;
            }
        }
    for (bool go = TRUE; go;)
    {
        go = FALSE;
        
        for (int i = 0; i < n; i++)
            for (int j = 0; j < m; j++)
                if (d[i][j] != '#')
                {
                    num_t v;
                    for (int r = 0; r < 4; r++)
                    {
                        COST(r, i, j, (r+1)%4, 1000)
                        COST(r, i, j, (r+3)%4, 1000)
                    }
                    COST(0, i+1, j, 0, 1) 
                    COST(1, i, j-1, 1, 1) 
                    COST(2, i-1, j, 2, 1) 
                    COST(3, i, j+1, 3, 1) 
                }
    }
    answer1 = cost[e_i][e_j][0];
    for (int r = 1; r < 4; r++)
        if (cost[e_i][e_j][r] < answer1) answer1 = cost[e_i][e_j][r];
    printf("%lld\n", answer1);
}

#define ON(R1,I2,J2,R2,V) \
    if (d[I2][J2] != '#' && on[i][j][R1] && !on[I2][J2][R2] && cost[i][j][R1] == cost[I2][J2][R2] + V) { on[I2][J2][R2] = TRUE; go = TRUE; }                        

void solve2()
{
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            for (int r = 0; r < 4; r++)
                on[i][j][r] = d[i][j] == 'E' && cost[i][j][r] == answer1;

    for (bool go = TRUE; go;)
    {
        go = FALSE;
        
        for (int i = 0; i < n; i++)
            for (int j = 0; j < m; j++)
                if (d[i][j] != '#')
                {
                    num_t v;
                    for (int r = 0; r < 4; r++)
                        if (on[i][j][r])
                        {
                            ON(r, i, j, (r+1)%4, 1000)
                            ON(r, i, j, (r+3)%4, 1000)
                        }
                    ON(0, i+1, j, 0, 1)
                    ON(1, i, j-1, 1, 1)
                    ON(2, i-1, j, 2, 1)
                    ON(3, i, j+1, 3, 1)
                }
    }
    
    num_t answer = 0;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            if (on[i][j][0] || on[i][j][1] || on[i][j][2] || on[i][j][3])
                answer++;
    printf("%lld\n", answer);
}

```




### Executing this page

The command to process this markdown file, is:
```
../IParse/software/MarkDownC Std.md Day16.md >day16.c; gcc -g -Wall day16.c -o day16; ./day16 16
```
I run the bash file [`runOnSave.sh`](runOnSave.sh) with `16` as the argument,
which everytime when I save this file, runs the above command and shows the
result or the first compile errors, if there are any.


