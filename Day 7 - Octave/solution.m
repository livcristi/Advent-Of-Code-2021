# Advent of Code Day 7

# Read the input and save it in data
input = "input.txt";
data = csvread(input);

# For part 1, the optimal position for the crab submarines is the median of the 
# initial positions (so the answer is the sum of distances to it)
printf("Part 1 answer: %d\n", sum(abs(data - median(data))));

# For part 2, my initial attempt was to run through the data and find the optimal
# position, but after I looked through other solutions, I found that the mean of
# the positions is the "best" position in the triangular case (we need to take)
# the minimum between the floor and ceil of the mean. The math is done on reddit
triang_dist = @(num) 0.5 * (num.^2 + num);
# Octave/Matlab has lambda functions too, cool
printf("Part 2 answer: %d\n", min(
  sum(triang_dist(abs(data - floor(mean(data))))),
  sum(triang_dist(abs(data - ceil(mean(data)))))));