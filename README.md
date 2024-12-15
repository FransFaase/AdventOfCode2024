# AdventOfCode2024

My effort for the [Advent of Code 2024](https://adventofcode.com/2024) contest.
All times are for Central European Timezone (CET).

I am going to use [MarkDownC](https://github.com/FransFaase/IParse/?tab=readme-ov-file#markdownc)
again, like I did in the past years. MarkDownC is a tool for
performing literatie programming with MarkDown files. It parses one
or more MarkDown files and outputs all the fragments of C code found
in those files, rearranging them such that all the definitions are placed
in an order that can be compiled. When a certain function is repeated,
the last version is put in the output.

### Sunday, December 1, 2024

I woke up at 5:40 got up and started working at 6:00.

See further [Day 1](Day01.md).

### Monday, December 2, 2024

I woke up at 5:40 got up and started working at 6:00.
I encountered some 500 errors. I had a hard time solving this
puzzle especially the second part. I am not sure whether I am
going to continue.

See further [Day 2](Day02.md).

### Tuesday, December 3, 2024

I did not wake-up early and decided to have a look at the
puzzle around 7:45 when I was preparing and eating my breakfast.
After that I decided to give it a try and it went quite
smoothly, maybe also because I decided not trying to finish
as quickly as possible.

See further [Day 3](Day03.md).

### Wednesday, December 4, 2024

I started around 6:00 and found the answers rather easily.

See further [Day 4](Day04.md).

### Thursday, December 5, 2024

I started around 6:00 and found the answers rather easily.

See further [Day 5](Day05.md).

### Friday, December 6, 2024

I only started working on the puzzle in the evening at 21:21.
Took me about an hour to find both answers. For the second
part I did implement the correct algorithm but I made a small
bug that required some debugging using the example input.

See further [Day 6](Day06.md).

### Saturday, December 7, 2024

I started around 6:17, because I fell asleep again after
my alarm went of. It went quite smooth except for the usual
struggle with large numbers. I used `__int128`, but it might
have worked with `long long`.

See further [Day 7](Day07.md).

### Sunday, December 8, 2024

I started at 6:00. Only compiled my code three times to find
the two solutions. The second was because I had not realized
that the towers were also to be counted. Only needed a very
small change to fix that.

See further [Day 8](Day08.md).

### Monday, December 9, 2024

I started at 6:00. It took me almost three hours to solve
both puzzles.

See further [Day 9](Day09.md).

### Tuesday, December 10, 2024

I started at 6:00. It took me a little over one hour, a bit
longer than I had expected to solve both puzzles. My first
incorrect anwer for the first part, was actually the answer
for the second part. The first part took me so long, because
I thought to be smart and take a short cut by not initializing
some array correctly, which took a bit more than 20 minutes
to fix.

See further [Day 10](Day10.md).

### Wednesday, December 11, 2024

I had no time in the morning, due to some company outing
yesterday evening, but I did read the puzzle and had some
time during the day to think about how to solve it. I anticipated
the second part of the puzzle, so, after finding the solution
for the first part, it was but a little more than a minute
for finding the solution for the second part.

See further [Day 11](Day11.md).

### Thursday, December 12, 2024

I started at 6:00. I had to deal with a nasty bug in the
`dd` function that I wrote (there was a `;` where there
should have been a `&&`), for solving the first part.
After I fixed it, I rather quickly found the answer to
both parts of the puzzle. I have added the `dd` function
to [my standard library](Std.md), because I already has
written it several times.

See further [Day 12](Day12.md).

### Friday, December 13, 2024

I had no time in the morning, but I did read the puzzle
and thought a bit about it during the day. I started
working around 21:23 in the evening and found both answers
around 22:05:15.

See further [Day 13](Day13.md).

### Saturday, December 14, 2024

I had no time in the morning, but I did read the puzzle
and thought a bit about it. At 13:49, I started working
on the puzzle and rather quickly found the answer in one
try. The second part, with its vague description, was a
little more work, but honestly, also a bit more fun, in
trying to figure out what was meant.

See further [Day 14](Day14.md).

### Saturday, December 15, 2024

I decided to not set an alarm. I started reading the puzzle
on 9:14 and got the answer to the first part of the puzzle
in one try in about half an hour. The second part did take
a bit longer. I did take a break to shower and while in the
shower, I got some good ideas about how to progress. I had
to do some debugging, but the bugs where in the initialization
of the extended warehouse. I found the answer on 12:08:59.

See further [Day 15](Day15.md).


### Personal stats

```
      --------Part 1--------   --------Part 2--------
Day       Time   Rank  Score       Time   Rank  Score
 15   03:45:17  10074      0   06:08:59   7630      0
 14   08:00:47  20196      0   09:52:42  18241      0
 13   16:03:20  30707      0   16:05:15  25241      0
 12   00:30:22   3521      0   00:41:48   1091      0
 11   13:44:40  40313      0   13:45:48  30010      0
 10   00:59:14   7794      0   01:01:07   7132      0
  9   00:55:58   6812      0   02:52:45   7830      0
  8   00:13:34   1312      0   00:19:34   1196      0
  7   00:56:57   8027      0   01:06:07   7159      0
  6   15:39:56  56369      0   16:23:05  36826      0
  5   01:55:06  15602      0   02:14:16  12694      0
  4   00:20:16   4140      0   00:26:33   2814      0
  3   02:11:28  23652      0   02:16:43  18451      0
  2   00:31:48   9876      0   02:01:06  13575      0
  1   00:18:59   6367      0   00:25:06   6060      0
```

