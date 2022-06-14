Use Portfolio
--Replacing empty values with nulls
--SELECT 'UPDATE tablename SET ' + name + ' = NULL WHERE ' + name + ' = '''';'
--FROM syscolumns
--WHERE id = object_id('tablename')
--  AND isnullable = 1;
SELECT
*
FROM Coviddeath
ORDER BY 3,4

--SELECT
--*
--FROM CovidVaccination
--ORDER BY 3,4

SELECT
location,date,total_cases,new_cases,total_deaths,population
FROM Coviddeath
ORDER BY 1,2

---Death Percentage showing the likehood if you contract covid in a country
SELECT
location,date,total_cases,new_cases,total_deaths, (total_deaths/total_cases)*100 as deathrate
FROM Coviddeath
--where location like '%states%'
WHERE continent is not null
ORDER BY 1,2

--- Covid rate with the total populaion in country
SELECT
location,date,total_cases, population,(round((total_cases/population)*100 ,2)) AS  population_rate
FROM Coviddeath
--where location like '%states%'
WHERE continent is not null
ORDER BY 1,2

--Countries with the highest infection rate.
SELECT
location,population, max(total_cases) as highestinfectioncount, max((total_cases/population))*100 as infectionrate
FROM Coviddeath
--where location like '%states%'
WHERE continent is not null
GROUP BY location,population
ORDER BY infectionrate desc

---Countries with the highest death rate
SELECT
location, MAX(CAST(total_deaths AS INT)) as totaldeathcount
FROM Coviddeath
--where location like '%states%'
WHERE continent is not null
GROUP BY location
ORDER BY totaldeathcount DESC

----Grouping by continent
SELECT
continent, MAX(CAST(total_deaths AS INT)) as totaldeathcount
FROM Coviddeath
--where location like '%states%'
WHERE continent is not null
GROUP BY continent
ORDER BY totaldeathcount DESC

--GLobal Numbers
SELECT
SUM(new_cases) as total_cases, SUM(CAST(new_deaths as INT)) as total_deaths, SUM(CAST(new_deaths as int))/ 
SUM(New_Cases)*100 as deathpercentage
FROM Coviddeath 
--where location like '%states%'
WHERE continent is not null
--Group BY date
order by 1,2

--Joining Both CovidVaccination and CovidDeaths table
SELECT
*
FROM Coviddeath D
	JOIN CovidVaccination V
	ON D.location = V.location
	AND D.date = V.date


--Comparing Total Population with Vaccinations
SELECT
d.continent, d.location, d.date,d.population,v.new_vaccinations, SUM(CONVERT(INT,V.new_vaccinations))
over (Partition by d.location order by d.location, d.date) as totalfromlastday
FROM Coviddeath D
	JOIN CovidVaccination V
	ON D.location = V.location
	AND D.date = V.date
where d.continent is not null
order by 2,3

--Percentage rate of fully vacinated population
SELECT
D.continent,D.date,D.location,D.population,V.people_fully_vaccinated, 
(round ((v.people_fully_vaccinated/D.population)*100, 2)) as percentageratevaccinated
FROM Coviddeath D
	JOIN CovidVaccination V
	ON D.location = V.location
	AND D.date = V.date
where d.continent is not null
order by percentageratevaccinated desc