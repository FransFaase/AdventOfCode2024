# Day 3 of Advent of Code 2024

The code below makes use of [a standard library](Std.md), which
also contains the `main` function that reads the input in the global variable `d`
where `n` contains the number of lines and `m` the length of the longest line,
and than calls the function `solve1` and `solve2`.

I started reading the puzzle text around 7:45 (which is at about 1:45 after
it became available) while preparing and consuming my breakfast. I decided to
try to write the code in one time correctly and not trying to be as fast as possible.

```c

void solve1()
{
	num_t sum = 0;
	for (int i = 0; i < n; i++)
	{
		for (char *s = d[i]; *s != '\0'; s++)
			if (strncmp(s, "mul(", 4) == 0)
			{
				char *r = s + 4;
				if (is_digit(*r))
				{
					int v1 = 0;
					for (int j = 0; j < 3 && is_digit(*r); j++)
						v1 = 10 * v1 + *r++ - '0';
					if (*r == ',')
					{
						r++;
						if (is_digit(*r))
						{
							int v2 = 0;
							for (int j = 0; j < 3 && is_digit(*r); j++)
								v2 = 10 * v2 + *r++ - '0';
							if (*r == ')')
								sum += v1 * v2;
						}
					}
				}
			}
	}
	printf("%lld\n", sum);
}
```

The above code compiled in one time and did return the correct answer
at 2:11:28.

### Second part of the puzzle.

```c
void solve2()
{
	num_t sum = 0;
	bool on = TRUE;
	for (int i = 0; i < n; i++)
	{
		for (char *s = d[i]; *s != '\0'; s++)
			if (on && strncmp(s, "mul(", 4) == 0)
			{
				char *r = s + 4;
				if (is_digit(*r))
				{
					int v1 = 0;
					for (int j = 0; j < 3 && is_digit(*r); j++)
						v1 = 10 * v1 + *r++ - '0';
					if (*r == ',')
					{
						r++;
						if (is_digit(*r))
						{
							int v2 = 0;
							for (int j = 0; j < 3 && is_digit(*r); j++)
								v2 = 10 * v2 + *r++ - '0';
							if (*r == ')')
								sum += v1 * v2;
						}
					}
				}
			}
			else if (strncmp(s, "don't()", 7) == 0)
				on = FALSE;
			else if (strncmp(s, "do()", 4) == 0)
				on = TRUE;
	}
	printf("%lld\n", sum);
}

```

This did not compile in the first time because I had made the mistake to use
`strcmp` instead of `strncmp`. When I had corrected this, it did return the
correct answer at 2:16:43.

### Executing this page

The command to process this markdown file, is:
```
../IParse/software/MarkDownC Std.md Day03.md >day03.c; gcc -g -Wall day03.c -o day03; ./day03 03
```
I run the bash file [`runOnSave.sh`](runOnSave.sh) with `03` as the argument,
which everytime when I save this file, runs the above command and shows the
result or the first compile errors, if there are any.


