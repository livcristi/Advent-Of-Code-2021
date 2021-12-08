
fn simulate(mut fish: [i64; 9], days: i32) -> i64
{
    // For each day, compute the new amount of fish
    for _day in 0..days
    {
        let mut next: [i64; 9] = [0;9];

        for i in 0..9
        {
            // "Each day, a 0 becomes a 6 and adds a new 8 to the end of the list,
            // while each other number decreases by 1 if it was present at the start of the day."
            // So, increase the number of 6 and 8 internal timers if the fish is a 0, otherwise
            // increase with the following count of fish
            if i == 0
            {
                next[6] += fish[i];
                next[8] += fish[i];
            } else
            {
                next[i - 1] += fish[i];
            }
        }

        // Copy the new array into the previous fish array
        fish = next;
    }

    // At the end, sum all the fish in the array and return the result
    fish.iter().sum()
}

fn main()
{
    // The idea: Store the input as an array of 9 integers formed from the frequencies of values
    // in the input

    let mut fish: [i64; 9] = [0; 9];

    let input = include_str!("input.txt");
    for e in input
        .split(',')
        .map(|numstr| numstr.parse::<usize>().unwrap())
    {
        fish[e] += 1;
    }

    // Print the results
    println!("Part 1: {}", simulate(fish, 80));
    println!("Part 2: {}", simulate(fish, 256));
}
