# Day 2 of Advent of Code 2024

The code below makes use of [a standard library](Std.md), which
also contains the `main` function that reads the input in the global variable `d`
where `n` contains the number of lines and `m` the length of the longest line,
and than calls the function `solve1` and `solve2`.

I started around 6:00 while I did not feel very well.

```c
void solve1()
{
	int safe = 0;
	for (int i = 0; i < 6; i++)
	{
		bool incr = TRUE;
		bool decr = TRUE;
		char *s = d[i];
		int v = parse_number(&s);
		for (int j = 0; j < 4; j++)
		{
			s++;
			int v2 = parse_number(&s);
			if (v2 <= v || v2 - v > 3)
				incr = FALSE;
			if (v2 >= v || v2 - v < -3)
				decr = FALSE;
			v = v2;
		}
		if (incr || decr)
			++safe;
	}
	printf("%d\n", safe);
}
```

The above solution did not work.


```c
void solve1()
{
	int safe = 0;
	for (int i = 0; i < n; i++)
	{
		bool incr = TRUE;
		bool decr = TRUE;
		char *s = d[i];
		int v = parse_number(&s);
		printf("%d", v);
		while (*s == ' ')
		{
			s++;
			int v2 = parse_number(&s);
			printf(" %d", v2);
			int diff = v2 - v;
			v = v2;
			if (!(diff > 0 && diff <= 3))
			{
				printf("i");
				incr = FALSE;
			}
			if (!(diff < 0 && diff >= -3))
			{
				printf("d");
				decr = FALSE;
			}
		}
		if (incr || decr)
		{
			printf(" OK");
			++safe;
		}
		printf("\n");
	}
	printf("%d\n", safe);
}
```

It took me several iterations to find the correct solution.


### Second part of the puzzle.

At first, I thought it was easy and that it was just enough
to count the number of correct transitions.

```c
void solve1()
{
}
void solve2()
{
	int safe = 0;
	for (int i = 0; i < n; i++)
	{
		int incr = 0;
		int decr = 0;
		char *s = d[i];
		int v = parse_number(&s);
		printf("%d", v);
		int j = 0;
		while (*s == ' ')
		{
			s++;
			j++;
			int v2 = parse_number(&s);
			printf(" %d", v2);
			int diff = v2 - v;
			v = v2;
			if (!(diff > 0 && diff <= 3))
			{
				printf("i");
				incr++;
			}
			if (!(diff < 0 && diff >= -3))
			{
				printf("d");
				decr++;
			}
		}
		printf(" %d %d", incr, decr);
		if (incr >= j - 1 || decr >= j - 1)
		{
			printf(" OK");
			++safe;
		}
		printf("\n");
	}
	printf("%d\n", safe);
}

```

```c
void solve2()
{
	int safe = 0;
	for (int i = 0; i < n; i++)
	{
		int incr = 0;
		int decr = 0;
		char *s = d[i];
		int v = parse_number(&s);
		int vi = v;
		int vd = v;
		printf("%d", v);
		int j = 0;
		while (*s == ' ')
		{
			s++;
			j++;
			int v2 = parse_number(&s);
			printf(" %d", v2);
			int diff = v2 - vi;
			if (diff > 0 && diff <= 3)
			{
				printf("i");
				incr++;
				vi = v2;
			}
			diff = v2 - vd;
			if (diff < 0 && diff >= -3)
			{
				printf("d");
				decr++;
				vd = v2;
			}
		}
		printf(" | %d %d %d", j, incr, decr);
		if (incr >= j - 1 || decr >= j - 1)
		{
			printf(" OK");
			++safe;
		}
		printf("\n");
	}
	printf("%d\n", safe);
}

```

```c
void solve2()
{
	int safe = 0;
	for (int i = 0; i < n; i++)
	{
		int incr = 0;
		int decr = 0;
		char *s = d[i];
		int v = parse_number(&s);
		int vi = v;
		int vd = v;
		printf("%d", v);
		int j = 0;
		bool last_i;
		bool last_d;
		while (*s == ' ')
		{
			s++;
			j++;
			last_i = FALSE;
			last_d = FALSE;
			int v2 = parse_number(&s);
			printf(" %d", v2);
			int diff = v2 - vi;
			if (diff > 0 && diff <= 3)
			{
				printf("i");
				incr++;
				vi = v2;
				last_i = TRUE;
			}
			diff = v2 - vd;
			if (diff < 0 && diff >= -3)
			{
				printf("d");
				decr++;
				vd = v2;
				last_d = TRUE;
			}
		}
		printf(" | %d %d %d", j, incr, decr);
		if ((last_i && incr >= j - 1) || (last_d && decr >= j - 1))
		{
			printf(" OK");
			++safe;
		}
		printf("\n");
	}
	printf("%d\n", safe);
}

```

```c
void solve2()
{
	int safe = 0;
	for (int i = 0; i < n; i++)
	{
		int incr = 0;
		int decr = 0;
		char *s = d[i];
		int v = parse_number(&s);
		int vi = v;
		int vd = v;
		printf("%d", v);
		int j = 0;
		bool last_i;
		bool last_d;
		while (*s == ' ')
		{
			s++;
			j++;
			last_i = FALSE;
			last_d = FALSE;
			int v2 = parse_number(&s);
			printf(" %d", v2);
			int diff = v2 - vi;
			if (diff > 0 && diff <= 3)
			{
				printf("i");
				incr++;
				vi = v2;
				last_i = TRUE;
			}
			diff = v2 - vd;
			if (diff < 0 && diff >= -3)
			{
				printf("d");
				decr++;
				vd = v2;
				last_d = TRUE;
			}
		}
		printf(" | %d %d %d", j, incr, decr);
		if ((last_i && incr >= j - 1) || (last_d && decr >= j - 1))
		{
			printf(" OK");
			++safe;
		}
		printf("\n");
	}
	printf("%d\n", safe);
}

```

```c
void solve2()
{
	int safe = 0;
	for (int i = 0; i < 6; i++)
	{
		bool incr = TRUE;
		bool decr = TRUE;
		for (int skip = 1; ; skip++)
		{
			char *s = d[i];
			int v = parse_number(&s);
			printf("%d", v);
			int j = 0;
			while (*s == ' ')
			{
				s++;
				j++;
				int v2 = parse_number(&s);
				if (j == skip)
					printf(" (%d)", v2);
				else
				{
					printf(" %d", v2);
					int diff = v2 - v;
					v = v2;
					if (!(diff > 0 && diff <= 3))
					{
						printf("i");
						incr = FALSE;
					}
					if (!(diff < 0 && diff >= -3))
					{
						printf("d");
						decr = FALSE;
					}
				}
			}
			if (incr || decr)
			{
				printf(" OK");
				++safe;
				break;
			}
			if (skip > j)
				break;
			printf(" | ");
		}
		printf("\n");
	}
	printf("%d\n", safe);
}
```

```c
void solve2()
{
	int safe = 0;
	for (int i = 0; i < n; i++)
	{
		for (int skip = 0; ; skip++)
		{
			bool incr = TRUE;
			bool decr = TRUE;
			char *s = d[i];
			int v = parse_number(&s);
			printf("%d", v);
			int j = 0;
			while (*s == ' ')
			{
				s++;
				j++;
				int v2 = parse_number(&s);
				if (j == skip)
					printf(" (%d)", v2);
				else
				{
					printf(" %d", v2);
					int diff = v2 - v;
					v = v2;
					if (!(diff > 0 && diff <= 3))
					{
						printf("i");
						incr = FALSE;
					}
					if (!(diff < 0 && diff >= -3))
					{
						printf("d");
						decr = FALSE;
					}
				}
			}
			if (incr || decr)
			{
				printf(" OK");
				++safe;
				break;
			}
			if (skip > j)
				break;
			printf(" | ");
		}
		printf("\n");
	}
	printf("%d\n", safe);
}
```

```c
void solve2()
{
	int safe = 0;
	for (int i = 0; i < n; i++)
	{
		for (int skip = 0; ; skip++)
		{
			bool incr = TRUE;
			bool decr = TRUE;
			char *s = d[i];
			int v = parse_number(&s);
			printf("%d", v);
			int j = 0;
			while (*s == ' ')
			{
				s++;
				j++;
				int v2 = parse_number(&s);
				if (j == skip)
					printf(" (%d)", v2);
				else
				{
					printf(" %d", v2);
					int diff = v2 - v;
					v = v2;
					if (!(diff > 0 && diff <= 3))
					{
						printf("i");
						incr = FALSE;
					}
					if (!(diff < 0 && diff >= -3))
					{
						printf("d");
						decr = FALSE;
					}
				}
			}
			if (incr || decr)
			{
				printf(" OK");
				++safe;
				break;
			}
			if (skip >= j - 1)
				break;
			printf(" | ");
		}
		printf("\n");
	}
	printf("%d\n", safe);
}
```

After many uncessful attempts, I decided to go for a more solid solution with some
additional functions.

```c

bool all_incr(int m, int *num)
{
	for (int j = 0; j + 1 < m; j++)
	{
		int diff = num[j+1] - num[j];
		if (diff <= 0 || diff > 3)
			return FALSE;
	}
	for (int j = 0; j < m; j++)
		printf("%d ", num[j]);
	printf("incr \n");
	return TRUE;
}

bool all_decr(int m, int *num)
{
	for (int j = 0; j + 1 < m; j++)
	{
		int diff = num[j] - num[j+1];
		if (diff <= 0 || diff > 3)
			return FALSE;
	}
	for (int j = 0; j < m; j++)
		printf("%d ", num[j]);
	printf("decr \n");
	return TRUE;
}

void solve2()
{
	int safe = 0;
	for (int i = 0; i < n; i++)
	{
		char *s = d[i];
		int numbers[40];
		int m = 0;
		numbers[m++] = parse_number(&s);
		while (*s == ' ')
		{
			s++;
			numbers[m++] = parse_number(&s);
		}
		
		if (all_incr(m, numbers) || all_decr(m, numbers))
		{
			safe++;
			printf("%d OK", i);
		}
		else
		{
			for (int skip = 1; skip < m - 1; skip++)
			{
				int num[40];
				int j2 = 0;
				for (int j = 0; j < m; j++)
					if (j != skip)
						num[j2++] = numbers[j];
				if (all_incr(j2, num) || all_decr(j2, num))
				{
					safe++;
					printf("%d OK skip %d", i, skip);
					break;
				}
			}
		}
		printf("\n");
	}
	printf("%d\n", safe);
}
```

When the above did not work, I decided to quit. But after some time, I
reealized that the first and the last number might also be excluded
from the list. There are no examples of this in the example input, but the
description does not exclude it.


```c
void solve2()
{
	int safe = 0;
	for (int i = 0; i < n; i++)
	{
		char *s = d[i];
		int numbers[40];
		int m = 0;
		numbers[m++] = parse_number(&s);
		while (*s == ' ')
		{
			s++;
			numbers[m++] = parse_number(&s);
		}
		
		if (all_incr(m, numbers) || all_decr(m, numbers))
		{
			safe++;
			printf("%d OK", i);
		}
		else
		{
			for (int skip = 0; skip < m; skip++)
			{
				int num[40];
				int j2 = 0;
				for (int j = 0; j < m; j++)
					if (j != skip)
						num[j2++] = numbers[j];
				if (all_incr(j2, num) || all_decr(j2, num))
				{
					safe++;
					printf("%d OK skip %d", i, skip);
					break;
				}
			}
		}
		printf("\n");
	}
	printf("%d\n", safe);
}
```
	
### Executing this page

The command to process this markdown file, is:
```
../IParse/software/MarkDownC Std.md Day02.md >day02.c; gcc -g -Wall day02.c -o day02; ./day02 02
```
I run the bash file [`runOnSave.sh`](runOnSave.sh] with `02` as the argument,
which everytime when I save this file, runs the above command and shows the
result or the first compile errors, if there are any.


