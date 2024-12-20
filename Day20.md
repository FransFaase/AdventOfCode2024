# Day 20 of Advent of Code 2024

The code below makes use of [a standard library](Std.md), which
also contains the `main` function that reads the input in the global variable `d`
where `n` contains the number of lines and `m` the length of the longest line,
and than calls the function `solve1` and `solve2`.

I started reading around 6:03 and writing this around 6:08. At 6:10, I
establised that my input is 141 by 141.

```c

num_t dist[141][141];

void solve1()
{
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            dist[i][j] = d[i][j] == 'S' ? 0 : 1000000;
    
    for (bool go = TRUE; go;)
    {
        go = FALSE;
        for (int i = 1; i + 1 < n; i++)
            for (int j = 1; j + 1 < m; j++)
                if (d[i][j] != '#')
                {
                    if (dist[i-1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i-1][j] + 1; go = TRUE; }
                    if (dist[i+1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i+1][j] + 1; go = TRUE; }
                    if (dist[i][j-1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j-1] + 1; go = TRUE; }
                    if (dist[i][j+1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j+1] + 1; go = TRUE; }
                }
    }
    
    num_t count = 0;
    for (int i = 1; i + 1 < n; i++)
        for (int j = 1; j + 1 < m; j++)
            if (d[i][j] == '#')
            {
                if (   d[i-1][j] == '.' && d[i+1][j] == '.'
                    && (   dist[i-1][j] - dist[i+1][j] >= 100
                        || dist[i+1][j] - dist[i-1][j] >= 100))
                    count++;
                if (   d[i][j-1] == '.' && d[i][j+1] == '.'
                    && (   dist[i][j-1] - dist[i][j+1] >= 100
                        || dist[i][j+1] - dist[i][j-1] >= 100))
                    count++;
            }
    
        
    printf("%lld\n", count);
}
```

At 6:25, that did not return the correct answer. Lets debug the
code with the example puzzle. At 6:27, I realized that I forgot
to eliminate all paths that are not going to the end.

```c

bool on[141][141];

void solve1()
{
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
        {
            dist[i][j] = d[i][j] == 'S' ? 0 : 1000000;
            on[i][j] = d[i][j] == 'E';
        }
    
    for (bool go = TRUE; go;)
    {
        go = FALSE;
        for (int i = 1; i + 1 < n; i++)
            for (int j = 1; j + 1 < m; j++)
                if (d[i][j] != '#')
                {
                    if (dist[i-1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i-1][j] + 1; go = TRUE; }
                    if (dist[i+1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i+1][j] + 1; go = TRUE; }
                    if (dist[i][j-1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j-1] + 1; go = TRUE; }
                    if (dist[i][j+1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j+1] + 1; go = TRUE; }
                }
    }
    
    for (bool go = TRUE; go;)
    {
        go = FALSE;
        for (int i = 1; i + 1 < n; i++)
            for (int j = 1; j + 1 < m; j++)
                if (on[i][j])
                {
                    if (dist[i-1][j] + 1 == dist[i][j]) { on[i-1][j] = TRUE; go = TRUE; }
                    if (dist[i+1][j] + 1 == dist[i][j]) { on[i+1][j] = TRUE; go = TRUE; }
                    if (dist[i][j-1] + 1 == dist[i][j]) { on[i][j-1] = TRUE; go = TRUE; }
                    if (dist[i][j+1] + 1 == dist[i][j]) { on[i][j+1] = TRUE; go = TRUE; }
                }
    }
    
    num_t count = 0;
    for (int i = 1; i + 1 < n; i++)
        for (int j = 1; j + 1 < m; j++)
            if (d[i][j] == '#')
            {
                if (   d[i-1][j] == '.' && d[i+1][j] == '.'
                    && (   dist[i-1][j] - dist[i+1][j] >= 100
                        || dist[i+1][j] - dist[i-1][j] >= 100))
                    count++;
                if (   d[i][j-1] == '.' && d[i][j+1] == '.'
                    && (   dist[i][j-1] - dist[i][j+1] >= 100
                        || dist[i][j+1] - dist[i][j-1] >= 100))
                    count++;
            }
        
    printf("%lld\n", count);
}
```

At 6:36, I just realized that it is a bit more complicated. Maybe a more brute force
solution is going to work better.

```c
num_t n_dist[141][141];

void solve1()
{
    int e_i, e_j;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
        {
            dist[i][j] = d[i][j] == 'S' ? 0 : 1000000;
            if (d[i][j] == 'E')
            {
                e_i = i;
                e_j = j;
            }
        }
    
    for (bool go = TRUE; go;)
    {
        go = FALSE;
        for (int i = 1; i + 1 < n; i++)
            for (int j = 1; j + 1 < m; j++)
                if (d[i][j] != '#')
                {
                    if (dist[i-1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i-1][j] + 1; go = TRUE; }
                    if (dist[i+1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i+1][j] + 1; go = TRUE; }
                    if (dist[i][j-1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j-1] + 1; go = TRUE; }
                    if (dist[i][j+1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j+1] + 1; go = TRUE; }
                }
    }

    num_t length = dist[e_i][e_j];
                
    num_t count = 0;
    for (int i1 = 1; i1 + 1 < n; i1++)
        for (int j1 = 1; j1 + 1 < m; j1++)
            if (   d[i1][j1] == '#'
                && (   d[i1-1][j1] != '#' && d[i1+1][j1] != '#')
                    || d[i1][j1-1] != '#' && d[i1][j1+1] != '#')
            {
                d[i1][j1] = '.';
                for (int i = 0; i < n; i++)
                    for (int j = 0; j < m; j++)
                        n_dist[i][j] = dist[i][j];
                
                for (bool go = TRUE; go;)
                {
                    go = FALSE;
                    for (int i = 1; i + 1 < n; i++)
                        for (int j = 1; j + 1 < m; j++)
                            if (d[i][j] != '#')
                            {
                                if (n_dist[i-1][j] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i-1][j] + 1; go = TRUE; }
                                if (n_dist[i+1][j] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i+1][j] + 1; go = TRUE; }
                                if (n_dist[i][j-1] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i][j-1] + 1; go = TRUE; }
                                if (n_dist[i][j+1] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i][j+1] + 1; go = TRUE; }
                            }
                }
            
                if (n_dist[e_i][e_j] <= length)
                    count++;
                d[i1][j1] = '#';
            }
    
    printf("%lld\n", count);
}
```

At 6:51, looks like the program is running very slow. At 6:52, it
did return an answer, but it was not correct. Lets try the example
input.

```c
void pre() { use_sample = TRUE; }

void solve1()
{
    int e_i, e_j;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
        {
            dist[i][j] = d[i][j] == 'S' ? 0 : 1000000;
            if (d[i][j] == 'E')
            {
                e_i = i;
                e_j = j;
            }
        }
    
    for (bool go = TRUE; go;)
    {
        go = FALSE;
        for (int i = 1; i + 1 < n; i++)
            for (int j = 1; j + 1 < m; j++)
                if (d[i][j] != '#')
                {
                    if (dist[i-1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i-1][j] + 1; go = TRUE; }
                    if (dist[i+1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i+1][j] + 1; go = TRUE; }
                    if (dist[i][j-1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j-1] + 1; go = TRUE; }
                    if (dist[i][j+1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j+1] + 1; go = TRUE; }
                }
    }

    num_t length = dist[e_i][e_j];
                
    num_t count = 0;
    for (int i1 = 1; i1 + 1 < n; i1++)
        for (int j1 = 1; j1 + 1 < m; j1++)
            if (   d[i1][j1] == '#'
                && (   d[i1-1][j1] != '#' && d[i1+1][j1] != '#')
                    || d[i1][j1-1] != '#' && d[i1][j1+1] != '#')
            {
                d[i1][j1] = '.';
                for (int i = 0; i < n; i++)
                    for (int j = 0; j < m; j++)
                        n_dist[i][j] = dist[i][j];
                
                for (bool go = TRUE; go;)
                {
                    go = FALSE;
                    for (int i = 1; i + 1 < n; i++)
                        for (int j = 1; j + 1 < m; j++)
                            if (d[i][j] != '#')
                            {
                                if (n_dist[i-1][j] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i-1][j] + 1; go = TRUE; }
                                if (n_dist[i+1][j] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i+1][j] + 1; go = TRUE; }
                                if (n_dist[i][j-1] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i][j-1] + 1; go = TRUE; }
                                if (n_dist[i][j+1] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i][j+1] + 1; go = TRUE; }
                            }
                }
            
                if (n_dist[e_i][e_j] < length)
                {
                    printf("%d ", length - n_dist[e_i][e_j]);
                    count++;
                }
                d[i1][j1] = '#';
            }
    
    printf("%lld\n", count);
}
```

At 6:57, I see that it return less cheats than expected.

At 7:02, I got the idea to calculate in `n_dist` the reverse
distance to the end.

```c
void pre() { use_sample = TRUE; }

void solve1()
{
    int e_i, e_j;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
        {
            dist[i][j] = d[i][j] == 'S' ? 0 : 1000000;
            n_dist[i][j] = d[i][j] == 'E' ? 0 : 1000000;
            if (d[i][j] == 'E')
            {
                e_i = i;
                e_j = j;
            }
        }
    
    for (bool go = TRUE; go;)
    {
        go = FALSE;
        for (int i = 1; i + 1 < n; i++)
            for (int j = 1; j + 1 < m; j++)
                if (d[i][j] != '#')
                {
                    if (dist[i-1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i-1][j] + 1; go = TRUE; }
                    if (dist[i+1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i+1][j] + 1; go = TRUE; }
                    if (dist[i][j-1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j-1] + 1; go = TRUE; }
                    if (dist[i][j+1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j+1] + 1; go = TRUE; }
                }
    }

    for (bool go = TRUE; go;)
    {
        go = FALSE;
        for (int i = 1; i + 1 < n; i++)
            for (int j = 1; j + 1 < m; j++)
                if (d[i][j] != '#')
                {
                    if (n_dist[i-1][j] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i-1][j] + 1; go = TRUE; }
                    if (n_dist[i+1][j] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i+1][j] + 1; go = TRUE; }
                    if (n_dist[i][j-1] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i][j-1] + 1; go = TRUE; }
                    if (n_dist[i][j+1] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i][j+1] + 1; go = TRUE; }
                }
    }
    
    num_t length = dist[e_i][e_j];

    num_t count = 0;
    for (int i = 1; i + 1 < n; i++)
        for (int j = 1; j + 1 < m; j++)
            if (d[i][j] == '#')
            {
                if (d[i-1][j] != '#' && d[i+1][j] != '#')
                {
                    int n_length = dist[i-1][j] + n_dist[i+1][j] + 2;
                    if (n_length < length)
                    {
                        printf("%d ", length - n_length);
                        count++;
                    }
                    n_length = n_dist[i-1][j] + dist[i+1][j] + 2;
                    if (n_length < length)
                    {
                        printf("%d ", length - n_length);
                        count++;
                    }
                }
                if (d[i][j-1] != '#' && d[i][j+1] != '#')
                {
                    int n_length = dist[i][j-1] + n_dist[i][j+1] + 2;
                    if (n_length < length)
                    {
                        printf("%d ", length - n_length);
                        count++;
                    }
                    n_length = n_dist[i][j-1] + dist[i][j+1] + 2;
                    if (n_length < length)
                    {
                        printf("%d ", length - n_length);
                        count++;
                    }
                }
            }
    
    printf("%lld\n", count);
}
```

At 7:19, it looks like it returns the correct answer for the example puzzle.

```c
void pre() { use_sample = FALSE; }

void solve1()
{
    int e_i, e_j;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
        {
            dist[i][j] = d[i][j] == 'S' ? 0 : 1000000;
            n_dist[i][j] = d[i][j] == 'E' ? 0 : 1000000;
            if (d[i][j] == 'E')
            {
                e_i = i;
                e_j = j;
            }
        }
    
    for (bool go = TRUE; go;)
    {
        go = FALSE;
        for (int i = 1; i + 1 < n; i++)
            for (int j = 1; j + 1 < m; j++)
                if (d[i][j] != '#')
                {
                    if (dist[i-1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i-1][j] + 1; go = TRUE; }
                    if (dist[i+1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i+1][j] + 1; go = TRUE; }
                    if (dist[i][j-1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j-1] + 1; go = TRUE; }
                    if (dist[i][j+1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j+1] + 1; go = TRUE; }
                }
    }

    for (bool go = TRUE; go;)
    {
        go = FALSE;
        for (int i = 1; i + 1 < n; i++)
            for (int j = 1; j + 1 < m; j++)
                if (d[i][j] != '#')
                {
                    if (n_dist[i-1][j] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i-1][j] + 1; go = TRUE; }
                    if (n_dist[i+1][j] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i+1][j] + 1; go = TRUE; }
                    if (n_dist[i][j-1] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i][j-1] + 1; go = TRUE; }
                    if (n_dist[i][j+1] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i][j+1] + 1; go = TRUE; }
                }
    }
    
    num_t length = dist[e_i][e_j];

    num_t count = 0;
    for (int i = 1; i + 1 < n; i++)
        for (int j = 1; j + 1 < m; j++)
            if (d[i][j] == '#')
            {
                if (d[i-1][j] != '#' && d[i+1][j] != '#')
                {
                    int n_length = dist[i-1][j] + n_dist[i+1][j] + 2;
                    if (n_length <= length - 100)
                    {
                        printf("%d ", length - n_length);
                        count++;
                    }
                    n_length = n_dist[i-1][j] + dist[i+1][j] + 2;
                    if (n_length <= length - 100)
                    {
                        printf("%d ", length - n_length);
                        count++;
                    }
                }
                if (d[i][j-1] != '#' && d[i][j+1] != '#')
                {
                    int n_length = dist[i][j-1] + n_dist[i][j+1] + 2;
                    if (n_length <= length - 100)
                    {
                        printf("%d ", length - n_length);
                        count++;
                    }
                    n_length = n_dist[i][j-1] + dist[i][j+1] + 2;
                    if (n_length <= length - 100)
                    {
                        printf("%d ", length - n_length);
                        count++;
                    }
                }
            }
    
    printf("%lld\n", count);
}
```

At 7:21:01, the above program returned the correct solution.


### Second part of the puzzle.

Let go back to the sample puzzle, to try out some ideas.

```c
void pre() { use_sample = TRUE; }

int cheat = 2;

void solve2()
{
    int e_i, e_j;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
        {
            dist[i][j] = d[i][j] == 'S' ? 0 : 1000000;
            n_dist[i][j] = d[i][j] == 'E' ? 0 : 1000000;
            if (d[i][j] == 'E')
            {
                e_i = i;
                e_j = j;
            }
        }
    
    for (bool go = TRUE; go;)
    {
        go = FALSE;
        for (int i = 1; i + 1 < n; i++)
            for (int j = 1; j + 1 < m; j++)
                if (d[i][j] != '#')
                {
                    if (dist[i-1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i-1][j] + 1; go = TRUE; }
                    if (dist[i+1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i+1][j] + 1; go = TRUE; }
                    if (dist[i][j-1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j-1] + 1; go = TRUE; }
                    if (dist[i][j+1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j+1] + 1; go = TRUE; }
                }
    }

    for (bool go = TRUE; go;)
    {
        go = FALSE;
        for (int i = 1; i + 1 < n; i++)
            for (int j = 1; j + 1 < m; j++)
                if (d[i][j] != '#')
                {
                    if (n_dist[i-1][j] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i-1][j] + 1; go = TRUE; }
                    if (n_dist[i+1][j] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i+1][j] + 1; go = TRUE; }
                    if (n_dist[i][j-1] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i][j-1] + 1; go = TRUE; }
                    if (n_dist[i][j+1] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i][j+1] + 1; go = TRUE; }
                }
    }
    
    num_t length = dist[e_i][e_j];

    num_t count = 0;
    for (int i = 1; i + 1 < n; i++)
        for (int j = 1; j + 1 < m; j++)
            if (d[i][j] != '#')
                for (int di = 0; di <= cheat && i + di < n; di++)
                    for (int dj = 0; di + dj <= cheat && j + dj < m; dj++)
                        if (d[i+di][j+dj] != '#')
                        {
                            int n_length = dist[i][j] + n_dist[i+di][j+dj] + 2;
                            if (n_length < length)
                            {
                                printf("%d ", length - n_length);
                                count++;
                            }
                            n_length = n_dist[i][j] + dist[i+di][j+dj] + 2;
                            if (n_length < length)
                            {
                                printf("%d ", length - n_length);
                                count++;
                            }
                        }
    
    printf("%lld\n", count);
}
```

At 7:37, that returned the correct answer for a cheat of 2 picoseconds.

```c
int cheat = 20;
int more = 50;

void solve2()
{
    int e_i, e_j;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
        {
            dist[i][j] = d[i][j] == 'S' ? 0 : 1000000;
            n_dist[i][j] = d[i][j] == 'E' ? 0 : 1000000;
            if (d[i][j] == 'E')
            {
                e_i = i;
                e_j = j;
            }
        }
    
    for (bool go = TRUE; go;)
    {
        go = FALSE;
        for (int i = 1; i + 1 < n; i++)
            for (int j = 1; j + 1 < m; j++)
                if (d[i][j] != '#')
                {
                    if (dist[i-1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i-1][j] + 1; go = TRUE; }
                    if (dist[i+1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i+1][j] + 1; go = TRUE; }
                    if (dist[i][j-1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j-1] + 1; go = TRUE; }
                    if (dist[i][j+1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j+1] + 1; go = TRUE; }
                }
    }

    for (bool go = TRUE; go;)
    {
        go = FALSE;
        for (int i = 1; i + 1 < n; i++)
            for (int j = 1; j + 1 < m; j++)
                if (d[i][j] != '#')
                {
                    if (n_dist[i-1][j] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i-1][j] + 1; go = TRUE; }
                    if (n_dist[i+1][j] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i+1][j] + 1; go = TRUE; }
                    if (n_dist[i][j-1] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i][j-1] + 1; go = TRUE; }
                    if (n_dist[i][j+1] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i][j+1] + 1; go = TRUE; }
                }
    }
    
    num_t length = dist[e_i][e_j];

    num_t count = 0;
    for (int i = 1; i + 1 < n; i++)
        for (int j = 1; j + 1 < m; j++)
            if (d[i][j] != '#')
                for (int di = 0; di <= cheat && i + di < n; di++)
                    for (int dj = 0; di + dj <= cheat && j + dj < m; dj++)
                        if (d[i+di][j+dj] != '#')
                        {
                            int n_length = dist[i][j] + n_dist[i+di][j+dj] + 2;
                            if (n_length <= length - more)
                            {
                                printf("%d\n", length - n_length);
                                count++;
                            }
                            n_length = n_dist[i][j] + dist[i+di][j+dj] + 2;
                            if (n_length <= length - more)
                            {
                                printf("%d\n", length - n_length);
                                count++;
                            }
                        }
    
    printf("%lld\n", count);
}
```

At 7:43, I realized that there is still a small bug in the program.

```c
void solve2()
{
    int e_i, e_j;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
        {
            dist[i][j] = d[i][j] == 'S' ? 0 : 1000000;
            n_dist[i][j] = d[i][j] == 'E' ? 0 : 1000000;
            if (d[i][j] == 'E')
            {
                e_i = i;
                e_j = j;
            }
        }
    
    for (bool go = TRUE; go;)
    {
        go = FALSE;
        for (int i = 1; i + 1 < n; i++)
            for (int j = 1; j + 1 < m; j++)
                if (d[i][j] != '#')
                {
                    if (dist[i-1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i-1][j] + 1; go = TRUE; }
                    if (dist[i+1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i+1][j] + 1; go = TRUE; }
                    if (dist[i][j-1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j-1] + 1; go = TRUE; }
                    if (dist[i][j+1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j+1] + 1; go = TRUE; }
                }
    }

    for (bool go = TRUE; go;)
    {
        go = FALSE;
        for (int i = 1; i + 1 < n; i++)
            for (int j = 1; j + 1 < m; j++)
                if (d[i][j] != '#')
                {
                    if (n_dist[i-1][j] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i-1][j] + 1; go = TRUE; }
                    if (n_dist[i+1][j] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i+1][j] + 1; go = TRUE; }
                    if (n_dist[i][j-1] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i][j-1] + 1; go = TRUE; }
                    if (n_dist[i][j+1] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i][j+1] + 1; go = TRUE; }
                }
    }
    
    num_t length = dist[e_i][e_j];

    num_t count = 0;
    for (int i = 1; i + 1 < n; i++)
        for (int j = 1; j + 1 < m; j++)
            if (d[i][j] != '#')
                for (int di = 0; di <= cheat && i + di < n; di++)
                    for (int dj = 0; di + dj <= cheat && j + dj < m; dj++)
                        if (d[i+di][j+dj] != '#')
                        {
                            int n_length = dist[i][j] + n_dist[i+di][j+dj] + di + dj;
                            if (n_length <= length - more)
                            {
                                printf("%d\n", length - n_length);
                                count++;
                            }
                            n_length = n_dist[i][j] + dist[i+di][j+dj] + di + dj;
                            if (n_length <= length - more)
                            {
                                printf("%d\n", length - n_length);
                                count++;
                            }
                        }
    
    printf("%lld\n", count);
}
```

At 7:45, I noticed that it does not return the correct answer. I am still missing
a large number of solutions.

```c
void solve2()
{
    int e_i, e_j;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
        {
            dist[i][j] = d[i][j] == 'S' ? 0 : 1000000;
            n_dist[i][j] = d[i][j] == 'E' ? 0 : 1000000;
            if (d[i][j] == 'E')
            {
                e_i = i;
                e_j = j;
            }
        }
    
    for (bool go = TRUE; go;)
    {
        go = FALSE;
        for (int i = 1; i + 1 < n; i++)
            for (int j = 1; j + 1 < m; j++)
                if (d[i][j] != '#')
                {
                    if (dist[i-1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i-1][j] + 1; go = TRUE; }
                    if (dist[i+1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i+1][j] + 1; go = TRUE; }
                    if (dist[i][j-1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j-1] + 1; go = TRUE; }
                    if (dist[i][j+1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j+1] + 1; go = TRUE; }
                }
    }

    for (bool go = TRUE; go;)
    {
        go = FALSE;
        for (int i = 1; i + 1 < n; i++)
            for (int j = 1; j + 1 < m; j++)
                if (d[i][j] != '#')
                {
                    if (n_dist[i-1][j] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i-1][j] + 1; go = TRUE; }
                    if (n_dist[i+1][j] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i+1][j] + 1; go = TRUE; }
                    if (n_dist[i][j-1] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i][j-1] + 1; go = TRUE; }
                    if (n_dist[i][j+1] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i][j+1] + 1; go = TRUE; }
                }
    }
    
    num_t length = dist[e_i][e_j];

    num_t count = 0;
    for (int i = 1; i + 1 < n; i++)
        for (int j = 1; j + 1 < m; j++)
            if (d[i][j] != '#')
                for (int di = 0; di <= cheat && i + di < n; di++)
                    for (int dj = 0; di + dj <= cheat && j + dj < m; dj++)
                        if (d[i+di][j+dj] != '#')
                        {
                            int n_length = dist[i][j] + n_dist[i+di][j+dj] + di + dj;
                            if (n_length <= length - more)
                            {
                                printf("%d\n", length - n_length);
                                count++;
                            }
                            n_length = dist[i+di][j+dj] + n_dist[i][j] + di + dj;
                            if (n_length <= length - more)
                            {
                                printf("%d\n", length - n_length);
                                count++;
                            }
                            n_length = dist[i][j+dj] + n_dist[i+di][j] + di + dj;
                            if (n_length <= length - more)
                            {
                                printf("%d\n", length - n_length);
                                count++;
                            }
                            n_length = dist[i+di][j] + n_dist[i][j+dj] + di + dj;
                            if (n_length <= length - more)
                            {
                                printf("%d\n", length - n_length);
                                count++;
                            }
                        }
    
    printf("%lld\n", count);
}
```

At 7:50, this still returns the incorrect values.

```c
void solve2()
{
    int e_i, e_j;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
        {
            dist[i][j] = d[i][j] == 'S' ? 0 : 1000000;
            n_dist[i][j] = d[i][j] == 'E' ? 0 : 1000000;
            if (d[i][j] == 'E')
            {
                e_i = i;
                e_j = j;
            }
        }
    
    for (bool go = TRUE; go;)
    {
        go = FALSE;
        for (int i = 1; i + 1 < n; i++)
            for (int j = 1; j + 1 < m; j++)
                if (d[i][j] != '#')
                {
                    if (dist[i-1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i-1][j] + 1; go = TRUE; }
                    if (dist[i+1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i+1][j] + 1; go = TRUE; }
                    if (dist[i][j-1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j-1] + 1; go = TRUE; }
                    if (dist[i][j+1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j+1] + 1; go = TRUE; }
                }
    }

    for (bool go = TRUE; go;)
    {
        go = FALSE;
        for (int i = 1; i + 1 < n; i++)
            for (int j = 1; j + 1 < m; j++)
                if (d[i][j] != '#')
                {
                    if (n_dist[i-1][j] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i-1][j] + 1; go = TRUE; }
                    if (n_dist[i+1][j] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i+1][j] + 1; go = TRUE; }
                    if (n_dist[i][j-1] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i][j-1] + 1; go = TRUE; }
                    if (n_dist[i][j+1] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i][j+1] + 1; go = TRUE; }
                }
    }
    
    num_t length = dist[e_i][e_j];

    num_t count = 0;
    for (int i = 1; i + 1 < n; i++)
        for (int j = 1; j + 1 < m; j++)
            for (int di = 0; di <= cheat && i + di < n; di++)
                for (int dj = 0; di + dj <= cheat && j + dj < m; dj++)
                {
                    int n_length = dist[i][j] + n_dist[i+di][j+dj] + di + dj;
                    if (n_length <= length - more)
                    {
                        printf("%lld\n", length - n_length);
                        count++;
                    }
                    n_length = dist[i+di][j+dj] + n_dist[i][j] + di + dj;
                    if (n_length <= length - more)
                    {
                        printf("%lld\n", length - n_length);
                        count++;
                    }
                    n_length = dist[i][j+dj] + n_dist[i+di][j] + di + dj;
                    if (n_length <= length - more)
                    {
                        printf("%lld\n", length - n_length);
                        count++;
                    }
                    n_length = dist[i+di][j] + n_dist[i][j+dj] + di + dj;
                    if (n_length <= length - more)
                    {
                        printf("%lld\n", length - n_length);
                        count++;
                    }
                }
    
    printf("%lld\n", count);
}
```

At 7:56, I realize that the chear walk should go through only walls. I am going to take a break;

```c
bool walls(int fi, int fj, int ti, int tj, bool first)
{
    if (fi == ti && fj == tj) return TRUE;
    if (!first && d[fi][fj] != '#') return FALSE;
    if (fi < ti && walls(fi + 1, fj, ti, tj, FALSE)) return TRUE;
    if (fi > ti && walls(fi - 1, fj, ti, tj, FALSE)) return TRUE;
    if (fj < tj && walls(fi, fj + 1, ti, tj, FALSE)) return TRUE;
    if (fj > tj && walls(fi, fj - 1, ti, tj, FALSE)) return TRUE;
    return FALSE;
}

void solve2()
{
    int e_i, e_j;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
        {
            dist[i][j] = d[i][j] == 'S' ? 0 : 1000000;
            n_dist[i][j] = d[i][j] == 'E' ? 0 : 1000000;
            if (d[i][j] == 'E')
            {
                e_i = i;
                e_j = j;
            }
        }
    
    for (bool go = TRUE; go;)
    {
        go = FALSE;
        for (int i = 1; i + 1 < n; i++)
            for (int j = 1; j + 1 < m; j++)
                if (d[i][j] != '#')
                {
                    if (dist[i-1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i-1][j] + 1; go = TRUE; }
                    if (dist[i+1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i+1][j] + 1; go = TRUE; }
                    if (dist[i][j-1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j-1] + 1; go = TRUE; }
                    if (dist[i][j+1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j+1] + 1; go = TRUE; }
                }
    }

    for (bool go = TRUE; go;)
    {
        go = FALSE;
        for (int i = 1; i + 1 < n; i++)
            for (int j = 1; j + 1 < m; j++)
                if (d[i][j] != '#')
                {
                    if (n_dist[i-1][j] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i-1][j] + 1; go = TRUE; }
                    if (n_dist[i+1][j] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i+1][j] + 1; go = TRUE; }
                    if (n_dist[i][j-1] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i][j-1] + 1; go = TRUE; }
                    if (n_dist[i][j+1] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i][j+1] + 1; go = TRUE; }
                }
    }
    
    num_t length = dist[e_i][e_j];

    num_t count = 0;
    for (int i = 1; i + 1 < n; i++)
        for (int j = 1; j + 1 < m; j++)
            for (int di = 0; di <= cheat && i + di < n; di++)
                for (int dj = 0; di + dj <= cheat && j + dj < m; dj++)
                {
                    int n_length = dist[i][j] + n_dist[i+di][j+dj] + di + dj;
                    if (n_length <= length - more && walls(i, j, i+di, j+dj, TRUE))
                    {
                        printf("%d\n", length - n_length);
                        count++;
                    }
                    n_length = dist[i+di][j+dj] + n_dist[i][j] + di + dj;
                    if (n_length <= length - more && walls(i+di, j+dj, i, j, TRUE))
                    {
                        printf("%d\n", length - n_length);
                        count++;
                    }
                    n_length = dist[i][j+dj] + n_dist[i+di][j] + di + dj;
                    if (n_length <= length - more && walls(i, j+dj, i+di, j, TRUE))
                    {
                        printf("%d\n", length - n_length);
                        count++;
                    }
                    n_length = dist[i+di][j] + n_dist[i][j+dj] + di + dj;
                    if (n_length <= length - more && walls(i+di, j, i, j+dj, TRUE))
                    {
                        printf("%d\n", length - n_length);
                        count++;
                    }
                }
    
    printf("%lld\n", count);
}
```

At 8:32, it still returns the incorrect answer for the sample input.

While walking to work, I realized that my previous code is counting some cheats double. Let
see what it the answer, if I fix this. It is not 17:11.

```c
void solve2()
{
    int e_i, e_j;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
        {
            dist[i][j] = d[i][j] == 'S' ? 0 : 1000000;
            n_dist[i][j] = d[i][j] == 'E' ? 0 : 1000000;
            if (d[i][j] == 'E')
            {
                e_i = i;
                e_j = j;
            }
        }
    
    for (bool go = TRUE; go;)
    {
        go = FALSE;
        for (int i = 1; i + 1 < n; i++)
            for (int j = 1; j + 1 < m; j++)
                if (d[i][j] != '#')
                {
                    if (dist[i-1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i-1][j] + 1; go = TRUE; }
                    if (dist[i+1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i+1][j] + 1; go = TRUE; }
                    if (dist[i][j-1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j-1] + 1; go = TRUE; }
                    if (dist[i][j+1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j+1] + 1; go = TRUE; }
                }
    }

    for (bool go = TRUE; go;)
    {
        go = FALSE;
        for (int i = 1; i + 1 < n; i++)
            for (int j = 1; j + 1 < m; j++)
                if (d[i][j] != '#')
                {
                    if (n_dist[i-1][j] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i-1][j] + 1; go = TRUE; }
                    if (n_dist[i+1][j] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i+1][j] + 1; go = TRUE; }
                    if (n_dist[i][j-1] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i][j-1] + 1; go = TRUE; }
                    if (n_dist[i][j+1] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i][j+1] + 1; go = TRUE; }
                }
    }
    
    num_t length = dist[e_i][e_j];

    num_t count = 0;
    for (int i = 1; i + 1 < n; i++)
        for (int j = 1; j + 1 < m; j++)
            for (int di = 0; di <= cheat && i + di < n; di++)
                for (int dj = 0; di + dj <= cheat && j + dj < m; dj++)
                {
                    int n_length = dist[i][j] + n_dist[i+di][j+dj] + di + dj;
                    if (n_length <= length - more)
                    {
                        printf("%lld\n", length - n_length);
                        count++;
                    }
                    n_length = dist[i+di][j+dj] + n_dist[i][j] + di + dj;
                    if (n_length <= length - more)
                    {
                        printf("%lld\n", length - n_length);
                        count++;
                    }
                    if (i > 0 || j > 0)
                    {
                        n_length = dist[i][j+dj] + n_dist[i+di][j] + di + dj;
                        if (n_length <= length - more)
                        {
                            printf("%lld\n", length - n_length);
                            count++;
                        }
                        n_length = dist[i+di][j] + n_dist[i][j+dj] + di + dj;
                        if (n_length <= length - more)
                        {
                            printf("%lld\n", length - n_length);
                            count++;
                        }
                    }
                }
    
    printf("%lld\n", count);
}
```

At 17:20, that returned the correct answer for the sample input. Lets try it on my puzzle input:

```c
void pre() { use_sample = FALSE; }
int more = 100;

```

At 17:26, that did not return the correct answer. It looks like I was mistaken.

```c
void pre() { use_sample = TRUE; }
int more = 50;

void solve2()
{
    int e_i, e_j;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
        {
            dist[i][j] = d[i][j] == 'S' ? 0 : 1000000;
            n_dist[i][j] = d[i][j] == 'E' ? 0 : 1000000;
            if (d[i][j] == 'E')
            {
                e_i = i;
                e_j = j;
            }
        }
    
    for (bool go = TRUE; go;)
    {
        go = FALSE;
        for (int i = 1; i + 1 < n; i++)
            for (int j = 1; j + 1 < m; j++)
                if (d[i][j] != '#')
                {
                    if (dist[i-1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i-1][j] + 1; go = TRUE; }
                    if (dist[i+1][j] + 1 < dist[i][j]) { dist[i][j] = dist[i+1][j] + 1; go = TRUE; }
                    if (dist[i][j-1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j-1] + 1; go = TRUE; }
                    if (dist[i][j+1] + 1 < dist[i][j]) { dist[i][j] = dist[i][j+1] + 1; go = TRUE; }
                }
    }

    for (bool go = TRUE; go;)
    {
        go = FALSE;
        for (int i = 1; i + 1 < n; i++)
            for (int j = 1; j + 1 < m; j++)
                if (d[i][j] != '#')
                {
                    if (n_dist[i-1][j] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i-1][j] + 1; go = TRUE; }
                    if (n_dist[i+1][j] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i+1][j] + 1; go = TRUE; }
                    if (n_dist[i][j-1] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i][j-1] + 1; go = TRUE; }
                    if (n_dist[i][j+1] + 1 < n_dist[i][j]) { n_dist[i][j] = n_dist[i][j+1] + 1; go = TRUE; }
                }
    }
    
    num_t length = dist[e_i][e_j];

    num_t count = 0;
    for (int i = 1; i + 1 < n; i++)
        for (int j = 1; j + 1 < m; j++)
            for (int di = 0; di <= cheat && i + di < n; di++)
                for (int dj = 0; di + dj <= cheat && j + dj < m; dj++)
                {
                    int n_length = dist[i][j] + n_dist[i+di][j+dj] + di + dj;
                    if (n_length <= length - more)
                    {
                        printf("%lld\n", length - n_length);
                        count++;
                    }
                    n_length = dist[i+di][j+dj] + n_dist[i][j] + di + dj;
                    if (n_length <= length - more)
                    {
                        printf("%lld\n", length - n_length);
                        count++;
                    }
                    if (di > 0 && dj > 0)
                    {
                        n_length = dist[i][j+dj] + n_dist[i+di][j] + di + dj;
                        if (n_length <= length - more)
                        {
                            printf("%lld\n", length - n_length);
                            count++;
                        }
                        n_length = dist[i+di][j] + n_dist[i][j+dj] + di + dj;
                        if (n_length <= length - more)
                        {
                            printf("%lld\n", length - n_length);
                            count++;
                        }
                    }
                }
    
    printf("%lld\n", count);
}
```

At 17:29, not it does.

```c
void pre() { use_sample = FALSE; }
int more = 100;

```

At 17:31:34, it did return the correct answer.


### Executing this page

The command to process this markdown file, is:
```
../IParse/software/MarkDownC Std.md Day20.md >day20.c; gcc -g -Wall day20.c -o day20; ./day20 20
```
I run the bash file [`runOnSave.sh`](runOnSave.sh) with `20` as the argument,
which everytime when I save this file, runs the above command and shows the
result or the first compile errors, if there are any.
