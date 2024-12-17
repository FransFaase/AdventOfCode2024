# Day 17 of Advent of Code 2024

The code below makes use of [a standard library](Std.md), which
also contains the `main` function that reads the input in the global variable `d`
where `n` contains the number of lines and `m` the length of the longest line,
and than calls the function `solve1` and `solve2`.

I read the puzzle text in the morning. Around 17:13, I started
writing this (while going to have dinner soon):

```c
void solve1()
{
	char *s = d[0];
	num_t reg_A;
	reg_A = parse_number(&s);
	s = d[1];
	num_t reg_B = parse_number(&s);
	s = d[2];
	num_t reg_C = parse_number(&s);
	
	int pc = 0;
	while (pc < (m - 9 / 2))
	{
		int inst = d[4][9 + 2 * pc] - '0';
		num_t oper = d[4][11 + 2 * pc] - '0';
		num_t combo_oper = oper;
		switch (combo_oper)
		{
			case 4: combo_oper = reg_A; break;
			case 5: combo_oper = reg_B; break;
			case 6: combo_oper = reg_C; break;
		}
		switch (inst)
		{
			case 0:
				reg_A = reg_A >> combo_oper;
				pc += 2;
				break;
			case 1:
				reg_B = reg_B ^ oper;
				pc += 2;
				break;
			case 2:
				reg_B = oper % 8;
				pc += 2;
				break;
			case 3:
				if (reg_A == 0)
					pc += 2;
				else
					pc = oper;
				break;
			case 4:
				reg_B = reg_B ^ reg_C;
				pc += 2;
				break;
			case 5:
				printf("%c\n", (char)('0' + combo_oper % 8));
				pc += 2;
				break;
			case 6:
				reg_B = reg_A >> combo_oper;
				pc += 2;
				break;
			case 7:
				reg_C = reg_A >> combo_oper;
				pc += 2;
				break;
		}
	}
}
```

At 17:36, I discover that the program contained some
syntax errors;

At 17:46, I fixed a number of syntax errors and it looked like
the program got into an infinite loop.

```c
void solve1()
{
	char *s = d[0] + 12;
	num_t reg_A = parse_number(&s);
	s = d[1] + 12;
	num_t reg_B = parse_number(&s);
	s = d[2] + 12;
	num_t reg_C = parse_number(&s);
	
	int pc = 0;
	while (pc < (m - 9) / 2)
	{
		int inst = d[4][9 + 2 * pc] - '0';
		num_t oper = d[4][11 + 2 * pc] - '0';
		num_t combo_oper = oper;
		switch (combo_oper)
		{
			case 4: combo_oper = reg_A; break;
			case 5: combo_oper = reg_B; break;
			case 6: combo_oper = reg_C; break;
		}
		//printf("%3lld: %lld %lld %lld A:%lld B:%lld C:%lld\n", pc, inst, oper, combo_oper, reg_A, reg_B, reg_C);
		switch (inst)
		{
			case 0:
				reg_A = reg_A >> combo_oper;
				pc += 2;
				break;
			case 1:
				reg_B = reg_B ^ oper;
				pc += 2;
				break;
			case 2:
				reg_B = oper % 8;
				pc += 2;
				break;
			case 3:
				if (reg_A == 0)
					pc += 2;
				else
					pc = oper;
				break;
			case 4:
				reg_B = reg_B ^ reg_C;
				pc += 2;
				break;
			case 5:
				printf("%c", (char)('0' + combo_oper % 8));
				pc += 2;
				break;
			case 6:
				reg_B = reg_A >> combo_oper;
				pc += 2;
				break;
			case 7:
				reg_C = reg_A >> combo_oper;
				pc += 2;
				break;
		}
	}
	printf("\n");
}
```

At 18:00, the above program did return an answer that was not correct.
Lets try the example input.

```c
void pre() { use_sample = TRUE; }

void solve1()
{
	char *s = d[0] + 12;
	num_t reg_A = parse_number(&s);
	s = d[1] + 12;
	num_t reg_B = parse_number(&s);
	s = d[2] + 12;
	num_t reg_C = parse_number(&s);
	
	int pc = 0;
	while (pc < (m - 9) / 2)
	{
		int inst = d[4][9 + 2 * pc] - '0';
		num_t oper = d[4][11 + 2 * pc] - '0';
		num_t combo_oper = oper;
		switch (combo_oper)
		{
			case 4: combo_oper = reg_A; break;
			case 5: combo_oper = reg_B; break;
			case 6: combo_oper = reg_C; break;
		}
		//printf("%3lld: %lld %lld %lld A:%lld B:%lld C:%lld\n", pc, inst, oper, combo_oper, reg_A, reg_B, reg_C);
		switch (inst)
		{
			case 0:
				reg_A = reg_A >> combo_oper;
				pc += 2;
				break;
			case 1:
				reg_B = reg_B ^ oper;
				pc += 2;
				break;
			case 2:
				reg_B = oper % 8;
				pc += 2;
				break;
			case 3:
				if (reg_A == 0)
					pc += 2;
				else
					pc = oper;
				break;
			case 4:
				reg_B = reg_B ^ reg_C;
				pc += 2;
				break;
			case 5:
				printf("%c,", (char)('0' + combo_oper % 8));
				pc += 2;
				break;
			case 6:
				reg_B = reg_A >> combo_oper;
				pc += 2;
				break;
			case 7:
				reg_C = reg_A >> combo_oper;
				pc += 2;
				break;
		}
	}
	printf("\n");
}
```

At 18:03, that does return the correct answer.
Let try the other examples

```c
void pre() { use_sample = TRUE; }

void solve1()
{
	for (int i = 0; i < n; i += 6)
	{
		char *s = d[i] + 12;
		num_t reg_A = parse_number(&s);
		s = d[i+1] + 12;
		num_t reg_B = parse_number(&s);
		s = d[i+2] + 12;
		num_t reg_C = parse_number(&s);
		
		char output[100];
		
		s = output;
		
		int pc = 0;
		printf("Program: %s\n", d[i+4] + 9);
		printf("A:%lld B:%lld C:%lld\n", reg_A, reg_B, reg_C);
		int end = (strlen(d[i+4]) - 8) / 2;
		printf("end = %d\n", end);
		while (pc < end)
		{
			int inst = d[i+4][9 + 2 * pc] - '0';
			num_t oper = d[i+4][11 + 2 * pc] - '0';
			num_t combo_oper = oper;
			switch (combo_oper)
			{
				case 4: combo_oper = reg_A; break;
				case 5: combo_oper = reg_B; break;
				case 6: combo_oper = reg_C; break;
			}
			printf("%3d: %d %lld %lld ", pc, inst, oper, combo_oper);
			switch (inst)
			{
				case 0:
					reg_A = reg_A >> combo_oper;
					pc += 2;
					break;
				case 1:
					reg_B = reg_B ^ oper;
					pc += 2;
					break;
				case 2:
					reg_B = combo_oper % 8;
					pc += 2;
					break;
				case 3:
					if (reg_A == 0)
						pc += 2;
					else
						pc = oper;
					break;
				case 4:
					reg_B = reg_B ^ reg_C;
					pc += 2;
					break;
				case 5:
					sprintf(s, "%c,", (char)('0' + combo_oper % 8));
					s += 2;
					pc += 2;
					break;
				case 6:
					reg_B = reg_A >> combo_oper;
					pc += 2;
					break;
				case 7:
					reg_C = reg_A >> combo_oper;
					pc += 2;
					break;
			}
			printf(" A:%lld B:%lld C:%lld\n", reg_A, reg_B, reg_C);
		}
		*s = '\0';
		printf("Answer: %s\n\n", output);
	}
}
```

At 18:28, the program returns the corect answer for all the provided
examples.

```c
void pre() { use_sample = FALSE; }
```

At 18:31:21, the program returned the correct answer for my puzzle input.

### Second part of the puzzle.

Lets modify the program a little bit:

```c
void solve2()
{
	for (int i = 0; i < n; i += 6)
	{
		char *s = d[i] + 12;
		num_t reg_A = parse_number(&s);
		s = d[i+1] + 12;
		num_t reg_B = parse_number(&s);
		s = d[i+2] + 12;
		num_t reg_C = parse_number(&s);
		
		char output[100];
		
		s = output;
		
		int pc = 0;
		printf("Program: %s\n", d[i+4] + 9);
		printf("A:%llo B:%llo C:%llo\n", reg_A, reg_B, reg_C);
		int end = (strlen(d[i+4]) - 8) / 2;
		printf("end = %d\n", end);
		while (pc < end)
		{
			int inst = d[i+4][9 + 2 * pc] - '0';
			num_t oper = d[i+4][11 + 2 * pc] - '0';
			num_t combo_oper = oper;
			switch (combo_oper)
			{
				case 4: combo_oper = reg_A; break;
				case 5: combo_oper = reg_B; break;
				case 6: combo_oper = reg_C; break;
			}
			printf("%3lld: %lld %lld %llo ", pc, inst, oper, combo_oper);
			switch (inst)
			{
				case 0:
					reg_A = reg_A >> combo_oper;
					pc += 2;
					break;
				case 1:
					reg_B = reg_B ^ oper;
					pc += 2;
					break;
				case 2:
					reg_B = combo_oper % 8;
					pc += 2;
					break;
				case 3:
					if (reg_A == 0)
						pc += 2;
					else
						pc = oper;
					break;
				case 4:
					reg_B = reg_B ^ reg_C;
					pc += 2;
					break;
				case 5:
					sprintf(s, "%c,", (char)('0' + combo_oper % 8));
					printf("Add: %o,\n", combo_oper % 8);
					s += 2;
					pc += 2;
					break;
				case 6:
					reg_B = reg_A >> combo_oper;
					pc += 2;
					break;
				case 7:
					reg_C = reg_A >> combo_oper;
					pc += 2;
					break;
			}
			printf(" A:%llo B:%llo C:%llo\n", reg_A, reg_B, reg_C);
		}
		*s = '\0';
		printf("Answer: %s\n\n", output);
	}
}

```

At 19:02, Let generate code from the program:


```c
void solve2()
{
	printf("Program: %s\n", d[4] + 9);
	int end = (strlen(d[4]) - 8) / 2;
	printf("end = %d\n", end);
	for (int pc = 0; pc < end; pc += 2)
	{
		printf("/* %2d */ ", pc);
		int inst = d[4][9 + 2 * pc] - '0';
		char oper = d[4][11 + 2 * pc];
		char combo_oper = oper;
		switch (combo_oper)
		{
			case '4': combo_oper = 'A'; break;
			case '5': combo_oper = 'B'; break;
			case '6': combo_oper = 'C'; break;
		}
		switch (inst)
		{
			case 0:
				printf("A = A >> %c", combo_oper);
				break;
			case 1:
				printf("B = B ^ %c", oper);
				break;
			case 2:
				printf("B = %c %% 8", combo_oper);
				break;
			case 3:
				printf("if (A == 0) goto %c", oper);
				break;
			case 4:
				printf("B = B ^ C");
				break;
			case 5:
				printf("print: %c %% 8", combo_oper);
				break;
			case 6:
				printf("B = A >> %c", combo_oper);
				break;
			case 7:
				printf("C = A >> %c", combo_oper);
				break;
		}
		printf("\n");
	}
}
```

At 19:27, I noticed that the program outputs one
character in each loop.

```c
void solve2()
{
	char *prog = d[4] + 9;
	int prog_len = strlen(prog);
	printf("Prog: |%s| %d\n", prog, prog_len);
	int end = (strlen(prog) + 1) / 2;
	num_t Answer = 0;
	for (int k = 0; k < 20; k++)
	{
		for (int i = 0; i < 64; i++)
		{
			char *s;
			num_t reg_A = Answer;
			s = d[1] + 12;
			num_t reg_B = parse_number(&s);
			s = d[2] + 12;
			num_t reg_C = parse_number(&s);
			
			char output[100];
			
			s = output;
			
			int pc = 0;
			//printf("Program: %s\n", d[i+4] + 9);
			//printf("A:%llo B:%llo C:%llo\n", reg_A, reg_B, reg_C);
			//printf("end = %d\n", end);
			while (pc < end)
			{
				int inst = d[4][9 + 2 * pc] - '0';
				num_t oper = d[4][11 + 2 * pc] - '0';
				num_t combo_oper = oper;
				switch (combo_oper)
				{
					case 4: combo_oper = reg_A; break;
					case 5: combo_oper = reg_B; break;
					case 6: combo_oper = reg_C; break;
				}
				//printf("%3lld: %lld %lld %llo ", pc, inst, oper, combo_oper);
				switch (inst)
				{
					case 0:
						reg_A = reg_A >> combo_oper;
						pc += 2;
						break;
					case 1:
						reg_B = reg_B ^ oper;
						pc += 2;
						break;
					case 2:
						reg_B = combo_oper % 8;
						pc += 2;
						break;
					case 3:
						if (reg_A == 0)
							pc += 2;
						else
							pc = oper;
						break;
					case 4:
						reg_B = reg_B ^ reg_C;
						pc += 2;
						break;
					case 5:
						sprintf(s, "%c,", (char)('0' + combo_oper % 8));
						//printf("Add: %o,\n", combo_oper % 8);
						s += 2;
						pc += 2;
						break;
					case 6:
						reg_B = reg_A >> combo_oper;
						pc += 2;
						break;
					case 7:
						reg_C = reg_A >> combo_oper;
						pc += 2;
						break;
				}
				//printf(" A:%llo B:%llo C:%llo\n", reg_A, reg_B, reg_C);
			}
			if (s > output) s--;
			*s = '\0';
			int len = strlen(output);
			printf("%llo Answer: %s %s\n\n", Answer, output, prog + prog_len - len);
			if (len == (k * 2) + 1 && strcmp(output, prog + prog_len - len) == 0)
			{
				printf("Match for %llo %lld\n", Answer);
				break;
			}
			Answer += ((num_t)1) << (k * 3);
		}
	}
}

```

At 19:52, I have to conclude that this idea is not going to work.
I thought it would be possible to generate a correct answer by
incrementally guessing another digit at the front.

```c
void solve2()
{
	char *prog = d[4] + 9;
	int prog_len = strlen(prog);
	printf("Prog: |%s| %d\n", prog, prog_len);
	int end = (strlen(prog) + 1) / 2;
	num_t Answer = 0;
	for (int k = 0; k < 20; k++)
	{
		for (num_t i = 0;; i++)
		{
			Answer = i;
			char *s;
			num_t reg_A = Answer;
			s = d[1] + 12;
			num_t reg_B = parse_number(&s);
			s = d[2] + 12;
			num_t reg_C = parse_number(&s);
			
			char output[100];
			
			s = output;
			
			int pc = 0;
			//printf("Program: %s\n", d[i+4] + 9);
			//printf("A:%llo B:%llo C:%llo\n", reg_A, reg_B, reg_C);
			//printf("end = %d\n", end);
			while (pc < end)
			{
				int inst = d[4][9 + 2 * pc] - '0';
				num_t oper = d[4][11 + 2 * pc] - '0';
				num_t combo_oper = oper;
				switch (combo_oper)
				{
					case 4: combo_oper = reg_A; break;
					case 5: combo_oper = reg_B; break;
					case 6: combo_oper = reg_C; break;
				}
				//printf("%3lld: %lld %lld %llo ", pc, inst, oper, combo_oper);
				switch (inst)
				{
					case 0:
						reg_A = reg_A >> combo_oper;
						pc += 2;
						break;
					case 1:
						reg_B = reg_B ^ oper;
						pc += 2;
						break;
					case 2:
						reg_B = combo_oper % 8;
						pc += 2;
						break;
					case 3:
						if (reg_A == 0)
							pc += 2;
						else
							pc = oper;
						break;
					case 4:
						reg_B = reg_B ^ reg_C;
						pc += 2;
						break;
					case 5:
						sprintf(s, "%c,", (char)('0' + combo_oper % 8));
						//printf("Add: %o,\n", combo_oper % 8);
						s += 2;
						pc += 2;
						break;
					case 6:
						reg_B = reg_A >> combo_oper;
						pc += 2;
						break;
					case 7:
						reg_C = reg_A >> combo_oper;
						pc += 2;
						break;
				}
				//printf(" A:%llo B:%llo C:%llo\n", reg_A, reg_B, reg_C);
			}
			if (s > output) s--;
			*s = '\0';
			int len = strlen(output);
			//printf("%llo Answer: %s %s\n\n", Answer, output, prog + prog_len - len);
			if (len == (k * 2) + 1 && strcmp(output, prog + prog_len - len) == 0)
			{
				printf("%llo Answer: %s %s\n\n", Answer, output, prog + prog_len - len);
				printf("Match for %llo %lld\n", Answer);
				break;
			}
			//Answer += ((num_t)1) << (k * 3);
		}
	}
}

```

At 20:11, I realize that I should add a digit at the end.

```c
void solve2()
{
	char *prog = d[4] + 9;
	int prog_len = strlen(prog);
	printf("Prog: |%s| %d\n", prog, prog_len);
	int end = (strlen(prog) + 1) / 2;
	num_t Answer = 0;
	for (int k = 0; k < end; k++)
	{
		for (int i = 0; i < 8; i++)
		{
			char *s;
			num_t reg_A = Answer + i;
			if (reg_A == 0) continue;
			s = d[1] + 12;
			num_t reg_B = parse_number(&s);
			s = d[2] + 12;
			num_t reg_C = parse_number(&s);
			
			char output[100];
			
			s = output;
			
			int pc = 0;
			//printf("Program: %s\n", d[i+4] + 9);
			//printf("A:%llo B:%llo C:%llo\n", reg_A, reg_B, reg_C);
			//printf("end = %d\n", end);
			while (pc < end)
			{
				int inst = d[4][9 + 2 * pc] - '0';
				num_t oper = d[4][11 + 2 * pc] - '0';
				num_t combo_oper = oper;
				switch (combo_oper)
				{
					case 4: combo_oper = reg_A; break;
					case 5: combo_oper = reg_B; break;
					case 6: combo_oper = reg_C; break;
				}
				//printf("%3lld: %lld %lld %llo ", pc, inst, oper, combo_oper);
				switch (inst)
				{
					case 0:
						reg_A = reg_A >> combo_oper;
						pc += 2;
						break;
					case 1:
						reg_B = reg_B ^ oper;
						pc += 2;
						break;
					case 2:
						reg_B = combo_oper % 8;
						pc += 2;
						break;
					case 3:
						if (reg_A == 0)
							pc += 2;
						else
							pc = oper;
						break;
					case 4:
						reg_B = reg_B ^ reg_C;
						pc += 2;
						break;
					case 5:
						sprintf(s, "%c,", (char)('0' + combo_oper % 8));
						//printf("Add: %o,\n", combo_oper % 8);
						s += 2;
						pc += 2;
						break;
					case 6:
						reg_B = reg_A >> combo_oper;
						pc += 2;
						break;
					case 7:
						reg_C = reg_A >> combo_oper;
						pc += 2;
						break;
				}
				//printf(" A:%llo B:%llo C:%llo\n", reg_A, reg_B, reg_C);
			}
			if (s > output) s--;
			*s = '\0';
			int len = strlen(output);
			printf("%llo Answer: %s %s\n\n", Answer, output, prog + prog_len - len);
			if (len == (k * 2) + 1 && strcmp(output, prog + prog_len - len) == 0)
			{
				printf("Match for %llo %lld\n", Answer, Answer);
				Answer += i;
				break;
			}
		}
		Answer *= 8;
	}
}

```

At 22:07, after being away for some time, the above code only
works for some part.

```c
void solve2()
{
	char *prog = d[4] + 9;
	int prog_len = strlen(prog);
	printf("Prog: |%s| %d\n", prog, prog_len);
	int end = (strlen(prog) + 1) / 2;
	num_t Answer = 0;
	num_t till = 512;
	for (int k = 2; k <= end; k++)
	{
		printf("Search with %llo %llo for %s\n", Answer, till - 1, prog + prog_len - ((2*k) - 1));
		bool found_match = FALSE;
		if (k > 10 && k < end)
		{
			till *= 8;
			Answer *= 8;
			continue;
		}
		for (num_t i = -till; i < till; i++)
		{
			char *s;
			num_t reg_A = Answer + i;
			if (reg_A <= 0) continue;
			s = d[1] + 12;
			num_t reg_B = parse_number(&s);
			s = d[2] + 12;
			num_t reg_C = parse_number(&s);
			
			char output[100];
			
			s = output;
			
			int pc = 0;
			//printf("Program: %s\n", d[i+4] + 9);
			//printf("A:%llo B:%llo C:%llo\n", reg_A, reg_B, reg_C);
			//printf("end = %d\n", end);
			while (pc < end)
			{
				int inst = d[4][9 + 2 * pc] - '0';
				num_t oper = d[4][11 + 2 * pc] - '0';
				num_t combo_oper = oper;
				switch (combo_oper)
				{
					case 4: combo_oper = reg_A; break;
					case 5: combo_oper = reg_B; break;
					case 6: combo_oper = reg_C; break;
				}
				//printf("%3lld: %lld %lld %llo ", pc, inst, oper, combo_oper);
				switch (inst)
				{
					case 0:
						reg_A = reg_A >> combo_oper;
						pc += 2;
						break;
					case 1:
						reg_B = reg_B ^ oper;
						pc += 2;
						break;
					case 2:
						reg_B = combo_oper % 8;
						pc += 2;
						break;
					case 3:
						if (reg_A == 0)
							pc += 2;
						else
							pc = oper;
						break;
					case 4:
						reg_B = reg_B ^ reg_C;
						pc += 2;
						break;
					case 5:
						sprintf(s, "%c,", (char)('0' + combo_oper % 8));
						//printf("Add: %o,\n", combo_oper % 8);
						s += 2;
						pc += 2;
						break;
					case 6:
						reg_B = reg_A >> combo_oper;
						pc += 2;
						break;
					case 7:
						reg_C = reg_A >> combo_oper;
						pc += 2;
						break;
				}
				//printf(" A:%llo B:%llo C:%llo\n", reg_A, reg_B, reg_C);
			}
			if (s > output) s--;
			*s = '\0';
			int len = strlen(output);
			if (len == (k * 2) - 1)
			{
				//if (k == 16)
				//	printf("%llo Answer: %s %s\n", Answer + i, output, prog + prog_len - len);
				if (strcmp(output, prog + prog_len - len) == 0)
				{
					printf("%llo Answer: %s %s\n\n", Answer + i, output, prog + prog_len - len);
					printf("%d Match for %llo %lld\n", k, Answer + i, Answer + i);
					Answer += (i / (till/8)) * (till/8);
					found_match = TRUE;
					break;
				}
			}
		}
		if (!found_match)
			till *= 64;
		Answer *= 8;
	}
}

```

At 23:51:06, the above program, which I modified many times, returned
the correct answer. I am not very happy with it, because it is a bit
too much brute force.

### Executing this page

The command to process this markdown file, is:
```
../IParse/software/MarkDownC Std.md Day17.md >day17.c; gcc -g -Wall day17.c -o day17; ./day17 17
```
I run the bash file [`runOnSave.sh`](runOnSave.sh) with `17` as the argument,
which everytime when I save this file, runs the above command and shows the
result or the first compile errors, if there are any.


