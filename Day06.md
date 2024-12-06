# Day 6 of Advent of Code 2024

The code below makes use of [a standard library](Std.md), which
also contains the `main` function that reads the input in the global variable `d`
where `n` contains the number of lines and `m` the length of the longest line,
and than calls the function `solve1` and `solve2`.

I started reading the puzzle text at 21:21 in the evening. Looks not too complex.


```c
void solve1()
{
	// find the starting position of the guard
	int gi, gj;
	for (int i = 0; i < n; i++)
		for (int j = 0; j < m; j++)
			if (d[i][j] == '^')
			{
				gi = i;
				gj = j;
			}
	printf("%d, %d\n", gi, gj);
}
```

```c

int di[4] = { -1,  0,  1,  0 };
int dj[4] = {  0,  1,  0, -1 };

char dd(int i, int j) { return i < 0 || i >= n || j < 0 || j >= m ? ' ' : d[i][j]; }

void solve1()
{
	// find the starting position of the guard
	int gi, gj;
	for (int i = 0; i < n; i++)
		for (int j = 0; j < m; j++)
			if (d[i][j] == '^')
			{
				gi = i;
				gj = j;
			}
	
	int visited = 0;
	int dir = 0;
	for (;;)
	{
		if (gi < 0 || gi >= n || gj < 0 || gj >= m)
			break;
			
		if (d[gi][gj] != 'X')
			visited++;
		d[gi][gj] = 'X';
		
		if (dd(gi + di[dir], gj + dj[dir]) == '#')
			dir = (dir + 1) % 4;
		else
		{
			gi += di[dir];
			gj += dj[dir];
		}
	}
	printf("%d\n", visited);
}
```

At 21:39, the above code, which compiled in one time, returned the
correct answer.


### Second part of the puzzle.


The second part is a bit harder. For detecting the guard is running
in a circle, it is enough to detect that he leaves a location for
the second time in the same direction. This means we have to detect
this.

I think it is enough to try to place an extra object at every location
that was visited by the guard in the first part of the puzzle.


```c

int sgi, sgj;

void solve1()
{
	// find the starting position of the guard
	int gi, gj;
	for (int i = 0; i < n; i++)
		for (int j = 0; j < m; j++)
			if (d[i][j] == '^')
			{
				gi = i;
				gj = j;
			}

	sgi = gi;
	sgj = gj;	

	int visited = 0;
	int dir = 0;
	for (;;)
	{
		if (gi < 0 || gi >= n || gj < 0 || gj >= m)
			break;
			
		if (d[gi][gj] != 'X')
			visited++;
		d[gi][gj] = 'X';
		
		if (dd(gi + di[dir], gj + dj[dir]) == '#')
			dir = (dir + 1) % 4;
		else
		{
			gi += di[dir];
			gj += dj[dir];
		}
	}
	printf("%d\n", visited);
}

bool left[200][200][4];

void solve2()
{
	int nr_sol = 0;
	for (int i = 0; i < n; i++)
		for (int j = 0; j < m; j++)
			if ((i != sgi || j != sgj) && d[i][j] == 'X')
			{
				// place an extra object at this location
				char save = d[i][j];
				d[i][j] = '#';
				
				for (int i2 = 0; i2 < n; i2++)
					for (int j2 = 0; j2 < n; j2++)
						for (int dir = 0; dir < 4; dir++)
							left[i2][j2][dir] = FALSE;

				int gi = i;
				int gj = j;
				int dir = 0;
				bool cycle = FALSE;
				for (;;)
				{
					if (gi < 0 || gi >= n || gj < 0 || gj >= m)
						break;
						
					if (left[gi][gj][dir])
					{
						cycle = TRUE;
						break;
					}
					left[gi][gj][dir] = TRUE;

					if (dd(gi + di[dir], gj + dj[dir]) == '#')
						dir = (dir + 1) % 4;
					else
					{
						gi += di[dir];
						gj += dj[dir];
					}
				}
				
				if (cycle)
					nr_sol++;
				
				// remove the object
				d[i][j] = save;
			}
	printf("%d\n", nr_sol);
}

```

At 22:10, the above code did not return the correct answer.
Lets try the algorithm on the example puzzle.

```c
void pre()
{
	use_sample = TRUE;
}
```

It returns 0 for the second part of the puzzle.

```c
void solve2()
{
	int nr_sol = 0;
	for (int i = 0; i < n; i++)
		for (int j = 0; j < m; j++)
			if ((i != sgi || j != sgj) && d[i][j] == 'X')
			{
				// place an extra object at this location
				char save = d[i][j];
				d[i][j] = '#';
				
				for (int i2 = 0; i2 < n; i2++)
					for (int j2 = 0; j2 < m; j2++)
						for (int dir = 0; dir < 4; dir++)
							left[i2][j2][dir] = FALSE;

				printf("Try %d,%d: ", i, j);
				int gi = i;
				int gj = j;
				int dir = 0;
				bool cycle = FALSE;
				for (;;)
				{
					if (gi < 0 || gi >= n || gj < 0 || gj >= m)
						break;
						
					if (left[gi][gj][dir])
					{
						cycle = TRUE;
						break;
					}
					left[gi][gj][dir] = TRUE;

					if (dd(gi + di[dir], gj + dj[dir]) == '#')
						dir = (dir + 1) % 4;
					else
					{
						gi += di[dir];
						gj += dj[dir];
					}
					printf(" %d,%d", gi, gj);
				}
				
				if (cycle)
					nr_sol++;
				
				// remove the object
				d[i][j] = save;
				printf("\n");
			}
	printf("%d\n", nr_sol);
}

```

At 22:20, after having added some debug code, I noticed that I
let the guard start at the wrong location.

```c
void solve2()
{
	int nr_sol = 0;
	for (int i = 0; i < n; i++)
		for (int j = 0; j < m; j++)
			if ((i != sgi || j != sgj) && d[i][j] == 'X')
			{
				// place an extra object at this location
				char save = d[i][j];
				d[i][j] = '#';
				
				for (int i2 = 0; i2 < n; i2++)
					for (int j2 = 0; j2 < m; j2++)
						for (int dir = 0; dir < 4; dir++)
							left[i2][j2][dir] = FALSE;

				int gi = sgi;
				int gj = sgj;
				int dir = 0;
				bool cycle = FALSE;
				for (;;)
				{
					if (gi < 0 || gi >= n || gj < 0 || gj >= m)
						break;
						
					if (left[gi][gj][dir])
					{
						cycle = TRUE;
						break;
					}
					left[gi][gj][dir] = TRUE;

					if (dd(gi + di[dir], gj + dj[dir]) == '#')
						dir = (dir + 1) % 4;
					else
					{
						gi += di[dir];
						gj += dj[dir];
					}
				}
				
				if (cycle)
					nr_sol++;
				
				// remove the object
				d[i][j] = save;
			}
	printf("%d\n", nr_sol);
}

```

That gives the correct answer for the example input.

```c
void pre()
{
}
```

At 22:23, it did return the corect answer. This means that my algorithm
was correct, but that I made some small mistake in the implementation,
namely starting at the wrong location.


### Executing this page

The command to process this markdown file, is:
```
../IParse/software/MarkDownC Std.md Day06.md >day06.c; gcc -g -Wall day06.c -o day06; ./day06 06
```
I run the bash file [`runOnSave.sh`](runOnSave.sh) with `06` as the argument,
which everytime when I save this file, runs the above command and shows the
result or the first compile errors, if there are any.


