
-- Schema of the table used
DROP TABLE Depth
CREATE TABLE Depth
(
	position  INT PRIMARY KEY IDENTITY(1, 1),
	depth_val INT
)

-- Imagine here I inserted the values
-- Now stop because I already did that and now you have to too >:D

-- Part 1 -> Join the tables with a lag of 1 position and count the rows in which the current value is bigger than the last one
-- Why use procedures when you can join tables?
SELECT COUNT(*) FROM 
(
	Depth D1 
	INNER JOIN 
	(
		-- Is it really a lag1 here? I just wanted different column names
		SELECT position 'Lag1-position', depth_val 'Lag1-depth-val'
		FROM Depth
	) D2
	ON D1.position - 1 = D2.[Lag1-position]
)
WHERE depth_val > [Lag1-depth-val]



-- Part 2 -> I'm saving TSQL for another day
-- Same idea like in Part 1 but copied for multiple times
SELECT COUNT(*) FROM
(
	SELECT D1.position, D1.depth_val + D2.[Lag1-depth-val] + D3.[Lag2-depth-val] 'Sum3' FROM Depth D1
	INNER JOIN 
	(
		-- Is it really a lag1 here? I just wanted different column names
		SELECT position 'Lag1-position', depth_val 'Lag1-depth-val'
		FROM Depth
	) D2
	ON D1.position - 1 = D2.[Lag1-position]
	INNER JOIN
	(
		-- Is it really a lag2 here? I just wanted different column names
		SELECT position 'Lag2-position', depth_val 'Lag2-depth-val'
		FROM Depth
	) D3
	ON D1.position - 2 = D3.[Lag2-position]
) DepthSum1 
INNER JOIN 
(
		SELECT D1.position, D1.depth_val + D2.[Lag1-depth-val] + D3.[Lag2-depth-val] 'Sum3' FROM Depth D1
	INNER JOIN 
	(
		-- Is it really a lag1 here? I just wanted different column names
		SELECT position 'Lag1-position', depth_val 'Lag1-depth-val'
		FROM Depth
	) D2
	ON D1.position - 1 = D2.[Lag1-position]
	INNER JOIN
	(
		-- Is it really a lag2 here? I just wanted different column names
		SELECT position 'Lag2-position', depth_val 'Lag2-depth-val'
		FROM Depth
	) D3
	ON D1.position - 2 = D3.[Lag2-position]
) DepthSum2 
ON DepthSum1.position - 1 = DepthSum2.position
WHERE DepthSum1.Sum3 > DepthSum2.Sum3