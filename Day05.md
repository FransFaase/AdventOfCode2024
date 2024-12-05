# Day 5 of Advent of Code 2024

The code below makes use of [a standard library](Std.md), which
also contains the `main` function that reads the input in the global variable `d`
where `n` contains the number of lines and `m` the length of the longest line,
and than calls the function `solve1` and `solve2`.

At 7:39, left first write a function to read the 'before' relationship.

```c
int start_books = 0;

bool before[100][100];

void read_before()
{
	for (int i = 0; i < 100; i++)
		for (int j = 0; j < 100; j++)
			before[i][j] = FALSE;
	
	for (int i = 0; i < n; i++)
	{
		char *s = d[i];
		if (*s == '\0')
		{
			start_books = i + 1;
			break;
		}
		int v1 = parse_number(&s);
		s++;
		int v2 = parse_number(&s);
		before[v1][v2] = TRUE;
	}
}

void solve1()
{
	read_before();
	printf("%d %d\n", n, start_books);
}
```

At 7:49, that looks like it works.

```c
void solve1()
{
	read_before();
	
	num_t answer = 0;
	for (int i = start_books; i < n; i++)
	{
		char *s = d[i];
		int line[100];
		int m = 0;
		line[m++] = parse_number(&s);
		while (*s == ',')
		{
			s++;
			line[m++] = parse_number(&s);
		}
		bool correct = TRUE;
		for (int j = 0; j + 1 < m && correct; j++)
			correct = before[line[j]][line[j + 1]];
		if (correct)
			answer += line[m / 2];
	}
	printf("%d\n", answer);
}	
```

At 7:54, I summitted the answer and it was correct.

### Second part of the puzzle.

The first thing I want to verify is whether the before
relationship is a complete relationship.

```c

void check_complete()
{
	for (int i = 10; i < 99; i++)
		for (int j = i + 1; j < 99; j++)
			if (before[i][j] == before[j][i])
				printf("%d %d\n", i, j);
}

void solve2()
{
	check_complete();
}

```

It looks like it is not a complete relationship.
Lets try to implement a kind of bubble sort algorithm
starting from the back, moving pages to the front if
they do not match.

```c
void solve2()
{
	num_t answer = 0;
	for (int i = start_books; i < n; i++)
	{
		char *s = d[i];
		int line[100];
		int m = 0;
		line[m++] = parse_number(&s);
		while (*s == ',')
		{
			s++;
			line[m++] = parse_number(&s);
		}
		for (int k = 0; k < m; k++)
			for (int j = m - 2; j >= 0; j--)
				if (!before[line[j]][line[j + 1]])
				{
					int s = line[j];
					line[j] = line[j + 1];
					line[j + 1] = s;
				}
		answer += line[m / 2];
	}
	printf("%d\n", answer);
}
```

At 8:09, the returned answer was not correct. I noticed
that I did it for all the lines, not just the ones that
were incorrectly-ordered. Lets see if that works.

```c
void solve2()
{
	num_t answer = 0;
	for (int i = start_books; i < n; i++)
	{
		char *s = d[i];
		int line[100];
		int m = 0;
		line[m++] = parse_number(&s);
		while (*s == ',')
		{
			s++;
			line[m++] = parse_number(&s);
		}
		bool correct = TRUE;
		for (int j = 0; j + 1 < m && correct; j++)
			correct = before[line[j]][line[j + 1]];
		if (!correct)
		{
			for (int k = 0; k < m; k++)
				for (int j = m - 2; j >= 0; j--)
					if (!before[line[j]][line[j + 1]])
					{
						int s = line[j];
						line[j] = line[j + 1];
						line[j + 1] = s;
					}
			answer += line[m / 2];
		}
	}
	printf("%d\n", answer);
}
```

At 8:14, that did indeed return the correct answer.
I wonder if it was just luck. There could be multiple
solution for reordering a sequence of numbers with
a incomplete relationship. Lets try what will happen
if I bubble in the other direction.

```c
void solve2()
{
	num_t answer = 0;
	for (int i = start_books; i < n; i++)
	{
		char *s = d[i];
		int line[100];
		int m = 0;
		line[m++] = parse_number(&s);
		while (*s == ',')
		{
			s++;
			line[m++] = parse_number(&s);
		}
		bool correct = TRUE;
		for (int j = 0; j + 1 < m && correct; j++)
			correct = before[line[j]][line[j + 1]];
		if (!correct)
		{
			for (int k = 0; k < m; k++)
				for (int j = 0; j + 1 < m; j++)
					if (!before[line[j]][line[j + 1]])
					{
						int s = line[j];
						line[j] = line[j + 1];
						line[j + 1] = s;
					}
			answer += line[m / 2];
		}
	}
	printf("%d\n", answer);
}
```

It does return the same answer for my input.

### Executing this page

The command to process this markdown file, is:
```
../IParse/software/MarkDownC Std.md Day05.md >day05.c; gcc -g -Wall day05.c -o day05; ./day05 05
```
I run the bash file [`runOnSave.sh`](runOnSave.sh) with `05` as the argument,
which everytime when I save this file, runs the above command and shows the
result or the first compile errors, if there are any.


