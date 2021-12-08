
int countOverlappingLines(String [] lines, boolean includeDiagonals)
{
    var grid = new int[1000][1000];
    int gridCount = 0; 
    
    for(int i_line = 0; i_line < lines.length; i_line++)
    {
        String line = lines[i_line];
        String[] p1 = line.substring(0, line.indexOf(" ")).split(",");
        String[] p2 = line.substring(line.lastIndexOf(" ") + 1).split(",");
        int x1 = Integer.parseInt(p1[0]);
        int y1 = Integer.parseInt(p1[1]);
        int x2 = Integer.parseInt(p2[0]);
        int y2 = Integer.parseInt(p2[1]);
        
        int deltaX = Math.abs(x2 - x1);
        int deltaY = Math.abs(y2 - y1);
        
        // Skip nonzero deltas if the diagonals are not included
        if(!includeDiagonals && (deltaX != 0 && deltaY != 0))
            continue;
        
        // The idea is to traverse the points by their differences and mark them
        // in a grid. Also count the cells with their values greater than 1
        int distance = deltaX > deltaY ? deltaX : deltaY;
        deltaX = Integer.signum(x2 - x1);
        deltaY = Integer.signum(y2 - y1);
        
        for(int i = 0; i <= distance; ++i)
        {
            // Increase the grid count if it becomes 2 (the cell is visited twice)
            grid[x1 + i * deltaX][y1 + i * deltaY]++;
            if(grid[x1 + i * deltaX][y1 + i * deltaY] == 2)
                gridCount++;
        }
    }
    
    return gridCount;
}

void setup()
{
  size(1000, 1000);
  noSmooth();
  background(0);
  stroke(255, 255, 102, 200);
  
  // Read the lines from the input file and draw them
  String[] lines = loadStrings("input.txt");
  
  for (int i = 0 ; i < lines.length; i++) 
  {
      String line = lines[i];
      String[] p1 = line.substring(0, line.indexOf(" ")).split(",");
      String[] p2 = line.substring(line.lastIndexOf(" ") + 1).split(",");
      int x1 = Integer.parseInt(p1[0]);
      int y1 = Integer.parseInt(p1[1]);
      int x2 = Integer.parseInt(p2[0]);
      int y2 = Integer.parseInt(p2[1]);
      line(x1, y1, x2, y2);
  }
  
  // Now count the pixels with a higher intensity. It should work?
  // Spoiler: It didn't, I can't lower the antialiasing enough for part 2 :c
  // (but I still solved it using Processing anyway...)
  
  //loadPixels();
  //int[] freq = new int[300];
  //for(int x = 0; x < width; ++x)
  //{
  //  for(int y = 0; y < height; ++y)
  //  {
  //    freq[int(red(pixels[x + y * width]))]++;
  //  }
  //}
  
  println("Part 1 solution: " + countOverlappingLines(lines, false));
  println("Part 2 solution: " + countOverlappingLines(lines, true));
}
