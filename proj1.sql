-- Before running drop any existing views
DROP VIEW IF EXISTS q0;
DROP VIEW IF EXISTS q1i;
DROP VIEW IF EXISTS q1ii;
DROP VIEW IF EXISTS q1iii;
DROP VIEW IF EXISTS q1iv;
DROP VIEW IF EXISTS q2i;
DROP VIEW IF EXISTS q2ii;
DROP VIEW IF EXISTS q2iii;
DROP VIEW IF EXISTS q3i;
DROP VIEW IF EXISTS q3ii;
DROP VIEW IF EXISTS q3iii;
DROP VIEW IF EXISTS q4i;
DROP VIEW IF EXISTS q4ii;
DROP VIEW IF EXISTS q4iii;
DROP VIEW IF EXISTS q4iv;
DROP VIEW IF EXISTS q4v;

-- Question 0
CREATE VIEW q0(era)
AS
  SELECT 1 -- replace this line
;

-- Question 1i
CREATE VIEW q1i(namefirst, namelast, birthyear)
AS
  SELECT namefirst, namelast, birthyear 
  FROM people 
  WHERE weight > 300 -- replace this line
;

-- Question 1ii
CREATE VIEW q1ii(namefirst, namelast, birthyear)
AS
  SELECT namefirst, namelast, birthyear 
  FROM people 
  WHERE birthyear IS NOT NULL AND namelast IS NOT NULL AND namefirst IS NOT NULL AND namefirst GLOB '* *'
  ORDER BY namefirst-- replace this line
;

-- Question 1iii
CREATE VIEW q1iii(birthyear, avgheight, count)
AS
  SELECT birthyear, avg(height), count(*)
  FROM people
  GROUP BY birthyear
  ORDER BY birthyear-- replace this line
;

-- Question 1iv
CREATE VIEW q1iv(birthyear, avgheight, count)
AS
  SELECT birthyear, avg(height), count(*)
  FROM people
  GROUP BY birthyear
  HAVING avg(height) > 70
  ORDER BY birthyear  -- replace this line
;

-- Question 2i
CREATE VIEW q2i(namefirst, namelast, playerid, yearid)
AS
  SELECT namefirst, namelast, people.playerid, yearid
  FROM people, HallOfFame
  WHERE people.playerid = HallOfFame.playerid 
  AND inducted = 'Y'
  ORDER BY yearid DESC, people.playerid;



-- Question 2ii
CREATE VIEW q2ii(namefirst, namelast, playerid, schoolid, yearid)
AS
  SELECT namefirst, namelast, people.playerId, schools.schoolid, yearid
  FROM people, schools, collegeplaying, HallOfFame
  WHERE people.playerid = HallOfFame.playerid AND inducted = 'Y'
  AND people.playerid = collegeplaying.playerid AND collegeplaying.schoolid = schools.schoolid AND schools.schoolState = 'CA'
  -- GROUP BY collegeplaying.playerid
  ORDER BY yearid DESC, schools.schoolid, people.playerid;
;

-- Question 2iii
CREATE VIEW q2iii(playerid, namefirst, namelast, schoolid)
AS
  SELECT people.playerid, namefirst, namelast, schoolid
  FROM people 
	INNER JOIN HallOfFame
  ON people.playerid = HallOfFame.playerid 
  LEFT OUTER JOIN CollegePlaying 
  ON HallOfFame.playerid = CollegePlaying.playerid
  WHERE inducted = 'Y'
  ORDER BY people.playerid DESC, schoolid ASC;
;

-- Question 3i
CREATE VIEW q3i(playerid, namefirst, namelast, yearid, slg)
AS
  SELECT people.playerid,
  people.namefirst,
  people.namelast,
  yearid,
  ((H - H2B - H3B - HR) + (2 * H2B) + (3 * H3B) + (4 * HR) + 0.0) / AB as slg
FROM people
  INNER JOIN batting ON people.playerid = batting.playerid
WHERE ab > 50
ORDER BY slg desc,
  yearid,
  people.playerid
LIMIT 10;
;

-- Question 3ii
CREATE VIEW q3ii(playerid, namefirst, namelast, lslg)
AS
  SELECT people.playerid,
  people.namefirst,
  people.namelast,
  (
    SUM(H - H2B - H3B - HR) + SUM(2 * H2B) + SUM(3 * H3B) + SUM(4 * HR) + 0.0
  ) / SUM(AB) as slg
FROM people
  INNER JOIN batting ON people.playerid = batting.playerid
GROUP BY people.playerid
HAVING SUM(AB) > 50
ORDER BY slg desc,
  yearid,
  people.playerid
LIMIT 10;
;

-- Question 3iii
CREATE VIEW q3iii(namefirst, namelast, lslg)
AS
  SELECT SELECT people.namefirst, people.namelast, (SUM(H-H2B-H3B-HR) + SUM(2*H2B) + SUM(3*H3B) + SUM(4*HR)+0.0) / SUM(AB) as slg
FROM people INNER JOIN batting ON people.playerid = batting.playerid
GROUP BY people.playerid
HAVING SUM(AB) > 50 AND slg > (SELECT (SUM(H-H2B-H3B-HR) + SUM(2*H2B) + SUM(3*H3B) + SUM(4*HR)+0.0) / SUM(AB) as slg
FROM people INNER JOIN batting ON people.playerid = batting.playerid
WHERE nameFirst = 'Willie' AND nameLast = 'Mays'
)
ORDER BY slg desc, people.playerid;


-- Question 4i
CREATE VIEW q4i(yearid, min, max, avg)
AS
  SELECT yearid, MIN(salary) AS mindiff, MAX(salary)maxdiff, AVG(salary)avgdiff
FROM salaries
GROUP BY yearID
ORDER BY yearid;
;

-- Question 4ii
CREATE VIEW q4ii(binid, low, high, count)
AS
  SELECT 1, 1, 1, 1 -- replace this line
;

-- Question 4iii
CREATE VIEW q4iii(yearid, mindiff, maxdiff, avgdiff)
AS
  SELECT 1, 1, 1, 1 -- replace this line
;

-- Question 4iv
CREATE VIEW q4iv(playerid, namefirst, namelast, salary, yearid)
AS
  SELECT people.playerid, people.namefirst, people.namelast,salary,yearid
FROM salaries, people
WHERE (yearID = 2000 OR yearID = 2001) AND people.playerID = salaries.playerID
ORDER BY salary DESC
LIMIT 2;
;
-- Question 4v
CREATE VIEW q4v(team, diffAvg) AS
 SELECT a.teamid, (max(salary) - min(salary)) as diffAvg
  FROM AllstarFull a INNER JOIN salaries s
  ON a.playerid = s.playerid
  AND a.yearid = s.yearid
  WHERE a.yearid = 2016
  GROUP BY a.teamid
  ORDER BY a.teamid

