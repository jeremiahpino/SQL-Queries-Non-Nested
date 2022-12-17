-- Lab 5
-- jpino01
-- Nov 10, 2022

USE `AIRLINES`;
-- AIRLINES-1
-- Find all airports with exactly 17 outgoing flights. Report airport code and the full name of the airport sorted in alphabetical order by the code.
-- select column names
SELECT flights.Source, airports.Name
-- from tables and joined tables
FROM airports
JOIN flights ON airports.Code = flights.Source 
-- group by flights source (summarize data of flights.Source)
GROUP BY flights.Source
-- count of airlines 
HAVING COUNT(*) = 17
-- sort by airports code 
ORDER BY airports.Code ASC;


USE `AIRLINES`;
-- AIRLINES-2
-- Find the number of airports from which airport ANP can be reached with exactly one transfer. Make sure to exclude ANP itself from the count. Report just the number.
-- select columns flights.Source and count occurrences of rows
SELECT count(distinct flights.Source) AS "AirportCount"
-- from joined tables below
FROM flights
JOIN flights as f2
-- filter by condition below
WHERE flights.Source != "ANP" and f2.Destination = "ANP" and flights.Destination = f2.Source;


USE `AIRLINES`;
-- AIRLINES-3
-- Find the number of airports from which airport ATE can be reached with at most one transfer. Make sure to exclude ATE itself from the count. Report just the number.
-- select columns flights.Source and count occurrences of rows
SELECT count(distinct flights.Source) AS "AirportCount"
-- from joined tables below
FROM flights
JOIN flights as f2
-- filter by condition below
WHERE ((flights.Source != "ATE") and (f2.Destination = "ATE") and (flights.Destination = f2.Source)) or (flights.Destination= "ATE");


USE `AIRLINES`;
-- AIRLINES-4
-- For each airline, report the total number of airports from which it has at least one outgoing flight. Report the full name of the airline and the number of airports computed. Report the results sorted by the number of airports in descending order. In case of tie, sort by airline name A-Z.
-- select columnns below
SELECT airlines.Name as "name", Count(distinct flights.Source) as "Airports"
-- from joined tables below
FROM airlines
join flights on flights.Airline = airlines.Id
-- select distinct values in airlines name group
GROUP BY airlines.Name
-- sort by condition below
order by Airports desc, name asc;


USE `BAKERY`;
-- BAKERY-1
-- For each flavor which is found in more than three types of items offered at the bakery, report the flavor, the average price (rounded to the nearest penny) of an item of this flavor, and the total number of different items of this flavor on the menu. Sort the output in ascending order by the average price.
-- select columns
SELECT goods.Flavor, ROUND(AVG(goods.Price), 2) AS "AveragePrice", COUNT(goods.Flavor) AS "DifferentPastries"
-- from goods table
FROM goods
-- group by goods.Flavor
GROUP BY goods.Flavor
-- take the count of each flavor and check if there is more than 3 items of that flavor
HAVING COUNT(goods.Flavor) > 3 
-- sort by average price in ascending order
ORDER BY AveragePrice ASC;


USE `BAKERY`;
-- BAKERY-2
-- Find the total amount of money the bakery earned in October 2007 from selling eclairs. Report just the amount.
-- select sum of the column price of goods
SELECT SUM(goods.PRICE) AS "EclairRevenue"
-- from joined tables below
FROM goods
JOIN items ON items.Item = goods.GId
JOIN receipts ON receipts.RNumber = items.Receipt
-- filter by condition below 
WHERE MONTH(receipts.SaleDate) = 10 AND YEAR(receipts.SaleDate) = 2007 AND goods.Food = "Eclair";


USE `BAKERY`;
-- BAKERY-3
-- For each visit by NATACHA STENZ output the receipt number, sale date, total number of items purchased, and amount paid, rounded to the nearest penny. Sort by the amount paid, greatest to least.
-- select columns
SELECT receipts.RNumber , receipts.SaleDate, COUNT(receipts.SaleDate) AS "NumberOfItems", ROUND(SUM(goods.Price),2) AS "CheckAmount"
-- from joined tables
from goods
JOIN items ON items.Item = goods.GId
JOIN receipts ON receipts.RNumber = items.Receipt
JOIN customers ON customers.CId = receipts.Customer
-- filter row values by condition below
WHERE customers.Lastname = "STENZ" AND customers.FirstName = "NATACHA"
-- group by receipts RNumber
GROUP BY receipts.RNumber
-- sort amount paid in descending order
ORDER BY CheckAmount DESC;


USE `BAKERY`;
-- BAKERY-4
-- For the week starting October 8, report the day of the week (Monday through Sunday), the date, total number of purchases (receipts), the total number of pastries purchased, and the overall daily revenue rounded to the nearest penny. Report results in chronological order.
SELECT DAYNAME(receipts.SaleDate) AS "Day", receipts.SaleDate, COUNT(distinct receipts.RNumber) AS "Receipts", COUNT(receipts.SaleDate) AS "Items", ROUND(SUM(goods.Price), 2)
from receipts
join items on receipts.RNumber = items.Receipt
join goods on goods.GId = items.Item
where MONTH(receipts.SaleDate) = 10 and DAY(receipts.SaleDate) between 8 and 14
group by SaleDate
order by SaleDate ASC;


USE `BAKERY`;
-- BAKERY-5
-- Report all dates on which more than ten tarts were purchased, sorted in chronological order.
select receipts.SaleDate
from receipts
join items on items.Receipt = receipts.RNumber
join goods on goods.GId = items.Item
where goods.Food ="Tart"
group by SaleDate
having count(Food) > 10;


USE `CSU`;
-- CSU-1
-- For each campus that averaged more than $2,500 in fees between the years 2000 and 2005 (inclusive), report the campus name and total of fees for this six year period. Sort in ascending order by fee.
-- select columns
select campuses.Campus, SUM(fees.fee) AS "Total"
-- from all joined tables below
from campuses
join fees on fees.CampusId = campuses.Id
where fees.Year between 2000 and 2005
-- group by campus (need each distinct campus in a group)
group by campuses.Campus
-- for each campus select average fees greater than 2500
having AVG(fees.fee) > 2500
-- order by fee in ascending order
order by Total ASC;


USE `CSU`;
-- CSU-2
-- For each campus for which data exists for more than 60 years, report the campus name along with the average, minimum and maximum enrollment (over all years). Sort your output by average enrollment.
select campuses.Campus, AVG(enrollments.Enrolled) AS "Average",min(enrollments.Enrolled) AS "Minimum", max(enrollments.Enrolled) AS "Maximum"
-- from joined tables below
from campuses
join enrollments on enrollments.CampusId = campuses.Id
-- group by campus
group by campuses.Campus
-- each campus needs to have data for more than 60 years
having count(enrollments.Year) > 60
-- order by enrollment average in ascending order
order by average ASC;


USE `CSU`;
-- CSU-3
-- For each campus in LA and Orange counties report the campus name and total number of degrees granted between 1998 and 2002 (inclusive). Sort the output in descending order by the number of degrees.

-- select columns
select campuses.Campus, sum(degrees.degrees) AS "Total"
-- from joined tables below
from campuses
join degrees on degrees.CampusId = campuses.Id
-- filter row values by condition below
where (campuses.County = "Los Angeles" or campuses.County = "Orange") and (degrees.year between 1998 and 2002)
-- cluster data by distinct campus name
group by campuses.Campus
-- sort by total degrees in descending order
order by Total desc;


USE `CSU`;
-- CSU-4
-- For each campus that had more than 20,000 enrolled students in 2004, report the campus name and the number of disciplines for which the campus had non-zero graduate enrollment. Sort the output in alphabetical order by the name of the campus. (Exclude campuses that had no graduate enrollment at all.)
-- select columns
select campuses.Campus AS "campus", count(discEnr.Ug + discEnr.Gr) AS "count(*)"
-- from joined tables below
from campuses
join discEnr on campuses.Id = discEnr.CampusId
join enrollments on campuses.Id = enrollments.CampusId
-- filter row values by conditions below
where enrollments.Year = 2004 and enrollments.Enrolled > 20000 and (discEnr.Gr) > 0
-- group by campus because we need distinct values of each campus and their data
group by campuses.Campus
-- sort by campus name in ascending order
order by campuses.Campus ASC;


USE `INN`;
-- INN-1
-- For each room, report the full room name, total revenue (number of nights times per-night rate), and the average revenue per stay. In this summary, include only those stays that began in the months of September, October and November of calendar year 2010. Sort output in descending order by total revenue. Output full room names.
-- select columns and compute computations
select rooms.RoomName, sum(DATEDIFF(reservations.Checkout, reservations.CheckIn) * reservations.Rate) AS "TotalRevenue", ROUND(AVG(DATEDIFF(reservations.Checkout, reservations.CheckIn) * reservations.Rate), 2) AS "AverageRevenue"
-- from joined tables below
from reservations
join rooms on rooms.RoomCode = reservations.Room
-- filter row values by condition below
where (YEAR(reservations.CheckIn) = 2010) AND MONTH(reservations.CheckIn) = 9 OR MONTH(reservations.CheckIn) = 10 OR MONTH(reservations.CheckIn) = 11
-- groub by distinct room names
group by rooms.RoomName
-- sort in descending order by total revenue
order by TotalRevenue desc;


USE `INN`;
-- INN-2
-- Report the total number of reservations that began on Fridays, and the total revenue they brought in.
-- select columns
select count(reservations.CheckIn) AS "Stays", sum(DATEDIFF(reservations.Checkout, reservations.CheckIn) * reservations.Rate) AS "REVENUE"
-- from joined tables below
from rooms
join reservations on rooms.RoomCode = reservations.Room
-- filter row values by condition below
where DAYNAME(reservations.CheckIn) = "Friday";


USE `INN`;
-- INN-3
-- List each day of the week. For each day, compute the total number of reservations that began on that day, and the total revenue for these reservations. Report days of week as Monday, Tuesday, etc. Order days from Sunday to Saturday.
-- select columns and do computations
select DAYNAME(reservations.CheckIn) AS "DAY", count(reservations.CheckIn) AS "STAYS", sum(DATEDIFF(reservations.Checkout, reservations.CheckIn) * reservations.Rate) AS "REVENUE"
-- from joined tables below
from reservations
join rooms on rooms.RoomCode = reservations.Room
-- group by each specific day of the week
group by DAY
-- sort ouptut 
ORDER BY FIELD(DAY , 'Sunday','Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');


USE `INN`;
-- INN-4
-- For each room list full room name and report the highest markup against the base price and the largest markdown (discount). Report markups and markdowns as the signed difference between the base price and the rate. Sort output in descending order beginning with the largest markup. In case of identical markup/down sort by room name A-Z. Report full room names.
-- select columns and do computations
select rooms.RoomName, max(reservations.Rate) - rooms.basePrice AS "Markup" , min(reservations.Rate) - rooms.basePrice AS "Discount"
-- from joined tables below
from rooms
join reservations on reservations.Room = rooms.RoomCode
-- group by distinct room names(need reservations.Room to do computations)
-- ??????
group by rooms.RoomName, reservations.Room
-- sort by markup in descending order then room name in ascending order
order by Markup desc, rooms.RoomName asc;


USE `INN`;
-- INN-5
-- For each room report how many nights in calendar year 2010 the room was occupied. Report the room code, the full name of the room, and the number of occupied nights. Sort in descending order by occupied nights. (Note: this should be number of nights during 2010. Some reservations extend beyond December 31, 2010. The ”extra” nights in 2011 must be deducted).
-- select columns and do computations
select rooms.RoomCode, rooms.RoomName, ABS(sum(DATEDIFF(
case 
    when year(reservations.Checkin) < 2010 then "2010-01-01"
    else reservations.Checkin
    
end,
case
    when year(reservations.Checkout) > 2010 then "2011-01-01"
    else reservations.Checkout
end
))) AS "DaysOccupied"
-- from joined tables below
from rooms
join reservations on rooms.RoomCode = reservations.Room
-- where (reservations.Checkin between '2010-01-01' and '2010-12-31') and (reservations.Checkout between '2010-01-01' and '2010-12-31')
where !( (year(reservations.Checkout) < "2010") or (year(reservations.Checkin) > "2010") ) 
-- group by each distinct room 
group by rooms.RoomCode
-- order by days occupied in descending order
order by DaysOccupied desc;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- For each performer, report first name and how many times she sang lead vocals on a song. Sort output in descending order by the number of leads. In case of tie, sort by performer first name (A-Z.)
-- select columns
select Band.Firstname, count(Vocals.VocalType) AS "LeadCount"
-- from joined columns below
from Band
join Vocals on Vocals.Bandmate = Band.Id
-- filter row values by condition below
where Vocals.VocalType = "lead"
-- group by band firstname (select distinct band member names group them together)
group by Band.FirstName
-- sort by lead count in descending order then firstname in ascending order
order by LeadCount desc, Band.Firstname asc;


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- Report how many different instruments each performer plays on songs from the album 'Le Pop'. Include performer's first name and the count of different instruments. Sort the output by the first name of the performers.
-- select columns 
select Band.Firstname, count(distinct Instruments.Instrument) AS "InstrumentCount"
-- from joined tables below 
from Band
join Albums on Albums.AId = Albums.AId
join Tracklists on Tracklists.Album = Albums.AId
join Instruments on Band.Id = Instruments.Bandmate and Tracklists.Song = Instruments.Song
-- filter row values by album Le Pop
where Albums.Title = "Le Pop"
-- group by band members id
group by Band.Id
-- order by band member firstname in ascending order
order by Band.Firstname ASC;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- List each stage position along with the number of times Turid stood at each stage position when performing live. Sort output in ascending order of the number of times she performed in each position.

-- select columns
select Performance.StagePosition, count(Performance.StagePosition) AS "Count"
-- from joined tables below
from Band 
join Performance on Band.Id = Performance.Bandmate
-- filter row values by condition below
where Band.Firstname = "Turid"
-- group by stage position (need distinct rows for each stage position)
group by Performance.StagePosition
-- sort in ascending order on Count condition
order by Count ASC;


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Report how many times each performer (other than Anne-Marit) played bass balalaika on the songs where Anne-Marit was positioned on the left side of the stage. List performer first name and a number for each performer. Sort output alphabetically by the name of the performer.

-- select columns
select Band.Firstname, count(*)
-- from joined tables below
from Band
-- anne marit tables
join Band AS b1 on b1.Firstname = "Anne-Marit"
join Performance AS p1 on p1.Bandmate = b1.Id
-- other band member tables
join Instruments on Instruments.Bandmate = Band.Id 
join Performance on Performance.Bandmate = Band.Id and p1.Song = Performance.Song and p1.Song = Instruments.Song
where (Instruments.Instrument = "bass balalaika") and (Band.Firstname != "Anne-Marit") and (p1.StagePosition = "left") and (b1.Firstname = "Anne-Marit")
group by Band.Firstname
order by Band.Firstname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Report all instruments (in alphabetical order) that were played by three or more people.
-- select columns
select Instruments.Instrument
-- from instrument table
from Instruments
-- group by instruments
group by Instruments.Instrument
-- for each group of instruments see if more than 2 band members played the instrument 
having count(distinct Instruments.Bandmate) > 2
-- sort by instrument in ascending order
order by Instruments.Instrument asc;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- For each performer, list first name and report the number of songs on which they played more than one instrument. Sort output in alphabetical order by first name of the performer
-- select columns and do computations
select Band.Firstname, count(distinct i2.Song)
-- from joined tables below
from Band
join Instruments on Instruments.Bandmate = Band.Id
join Instruments AS i2 on i2.Bandmate = Band.Id
-- filter rows by condition below
where i2.Instrument != Instruments.Instrument and Instruments.Song = i2.Song
-- find distinct row values for Band.Firstname column
group by Band.Firstname
-- sort by Band.Firstname in ascending order
order by Band.Firstname asc;


USE `MARATHON`;
-- MARATHON-1
-- List each age group and gender. For each combination, report total number of runners, the overall place of the best runner and the overall place of the slowest runner. Output result sorted by age group and sorted by gender (F followed by M) within each age group.
-- select columns below
select AgeGroup, Sex, Count(*), MIN(Place), MAX(Place)
-- from marathon table
from marathon
-- select distinct row values from columns below
group by AgeGroup, Sex
-- sort by group then sex both in ascending order
order by AgeGroup ASC, Sex ASC;


USE `MARATHON`;
-- MARATHON-2
-- Report the total number of gender/age groups for which both the first and the second place runners (within the group) are from the same state.
-- select a computation
select count(*) AS "Total"
-- from marathon table
from marathon
-- join by condition below
join marathon as m1 on m1.Place != marathon.Place
-- filter rows by condition below
where (marathon.GroupPlace = 2) and (m1.GroupPlace = 1) and (marathon.State = m1.State) and (marathon.AgeGroup = m1.AgeGroup) and (marathon.Sex = m1.Sex);


USE `MARATHON`;
-- MARATHON-3
-- For each full minute, report the total number of runners whose pace was between that number of minutes and the next. In other words: how many runners ran the marathon at a pace between 5 and 6 mins, how many at a pace between 6 and 7 mins, and so on.
select minute(Pace), count(*)
-- from marathon table
from marathon
-- group by minutes
group by MINUTE(Pace);


USE `MARATHON`;
-- MARATHON-4
-- For each state with runners in the marathon, report the number of runners from the state who finished in top 10 in their gender-age group. If a state did not have runners in top 10, do not output information for that state. Report state code and the number of top 10 runners. Sort in descending order by the number of top 10 runners, then by state A-Z.
-- select columns and do computations
select distinct State, count(AgeGroup) AS "NumberOfTop10"
-- from marathon table
from marathon
-- filter rows by condition below
where GroupPlace <= 10
-- group by state
group by State
-- sort by condition below
order by NumberOfTop10 desc, State asc;


USE `MARATHON`;
-- MARATHON-5
-- For each Connecticut town with 3 or more participants in the race, report the town name and average time of its runners in the race computed in seconds. Output the results sorted by the average time (lowest average time first).
-- select columns and do computations
select Town, round(avg(time_to_sec(RunTime)), 1) AS "AverageTimeInSeconds"
-- from marathon table
from marathon 
-- select row values by condition below
where State = "CT"
-- group by town (select distinct towns from Town column)
group by Town
-- for each group find if 3 or more participants raced
having count(Town) >= 3
-- sort by average time in ascending order
order by AverageTimeInSeconds asc;


USE `STUDENTS`;
-- STUDENTS-1
-- Report the last and first names of teachers who have between seven and eight (inclusive) students in their classrooms. Sort output in alphabetical order by the teacher's last name.
-- select columns
select teachers.Last, teachers.First
-- from joined tables below
from teachers
join list on list.classroom = teachers.classroom
-- group by column below (need distinct group of teachers)
group by teachers.classroom
-- each group needs to meet condition below to display
having count(list.Lastname) between 7 and 8
-- sort in ascending order by condition below
order by teachers.Last ASC;


USE `STUDENTS`;
-- STUDENTS-2
-- For each grade, report the grade, the number of classrooms in which it is taught, and the total number of students in the grade. Sort the output by the number of classrooms in descending order, then by grade in ascending order.

-- select columns
-- count the distinct classrooms class is taught in (multiple students that will create multiple classroom values USE distinct)
-- count up all the lastnames that are in grade 
select list.grade, count(distinct list.classroom) AS "Classrooms", count(distinct list.LastName) AS "Students"
-- from joined tables
from list
join teachers on list.classroom = teachers.classroom
-- get distinct values of grade (group them together)
group by list.grade
-- sort by classroom in descending order then by grade in ascending order
order by Classrooms desc, list.grade asc;


USE `STUDENTS`;
-- STUDENTS-3
-- For each Kindergarten (grade 0) classroom, report classroom number along with the total number of students in the classroom. Sort output in the descending order by the number of students.
-- select columns
-- distinct name of every student in the classroom
select list.classroom, count(distinct list.FirstName) AS "Students"
-- from list table
from list
-- filter rows by grade of Kindergarten
where list.grade = 0
-- group by every distinct classroom of grade 0
group by list.classroom
-- sort by descending order of number of students
order by Students desc;


USE `STUDENTS`;
-- STUDENTS-4
-- For each fourth grade classroom, report the classroom number and the last name of the student who appears last (alphabetically) on the class roster. Sort output by classroom.
-- select columns
-- using max on lastname to find last student on roster (last alphabetically)
select list.classroom, max(list.LastName)
-- from list table
from list
-- filter rows by condition below
where list.grade = 4
-- group by distinct classrooms
group by list.classroom
-- sort by classroom in ascending order
order by list.classroom asc;


