using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;

namespace AoC2021 
{
    public static class Day3 
    {
        static string[] input = File.ReadAllLines("input.txt");

        public static void Solve() 
        {
            Console.WriteLine("Day 3");
            Console.WriteLine("Part 1: {0}", Part1(input));
            Console.WriteLine("Part 2: {0}", Part2(input));
        }

        public static long Part1(string[] input) 
        {
            string gamma = "";
            string epsilon = "";
            
            // The idea: iterate through the positions and find the digit which
            // appears more times. At the end, convert the gamma and epsilon 
            // to decimal integers
            for (int i = 0; i < input[0].Length; i++) 
            {
                int count = input.Sum(x => x[i] == '1' ? 1 : 0);
                if (count > input.Length / 2) 
                {
                    gamma += '1';
                    epsilon += '0';
                }
                else 
                {
                    gamma += '0';
                    epsilon += '1';
                }
            }
            return Convert.ToInt64(gamma, 2) * Convert.ToInt64(epsilon, 2);
        }

        public static long Part2(string[] input) 
        {
            List<string> oxygen = input.ToList();
            List<string> co2 = input.ToList();
            
            // The idea is to iterate through every digit position and count 
            // which appears more times. For the oxygen list, we remove all 
            // the strings for which the digit at that position appears less times
            // For co2, we do the opposite
            for(int i = 0; i < input[0].Length; i++) 
            {
                int count = 0;
                
                // TIL in C# lists have a Count which is different than length 
                // because length holds the maximum number of items and count 
                // holds the actual number of items in the list, pretty cool
                if(oxygen.Count > 1) 
                {
                    // Get the count of 1 digits at position i
                    count = oxygen.Sum(x => x[i] == '1' ? 1 : 0);
                    
                    // If 1 is the majority, remove the strings with 0, else
                    // remove the ones with 1
                    if (count > oxygen.Count - count || count == oxygen.Count - count)
                        oxygen.RemoveAll(x => x[i] == '0');
                    else
                        oxygen.RemoveAll(x => x[i] == '1');
                }
                count = 0;
                if(co2.Count > 1) 
                {
                    // similar to oxygen
                    count = co2.Sum(x => x[i] == '1' ? 1 : 0);
                    
                    if (count > co2.Count - count || count == co2.Count - count)
                        co2.RemoveAll(x => x[i] == '1');
                    else
                        co2.RemoveAll(x => x[i] == '0');
                }
            }
            // Return the converted product
            return Convert.ToInt64(oxygen[0], 2) * Convert.ToInt64(co2[0], 2);
        }
        
        static void Main() 
        {
            Solve();
        }
    }
}