SELECT *
FROM [portfolio project].[dbo].[CovidDeaths$]
WHERE continent is not Null

SELECT *
FROM [portfolio project].[dbo].[CovidVaccinations$]
ORDER BY 3,4

SELECT *
FROM [portfolio project].[dbo].[CovidDeaths$]
ORDER BY 3,4

SELECT location, date, total_cases, total_deaths, population
FROM [portfolio project].[dbo].[CovidDeaths$]
ORDER By 1,2


--Looking at total_cases vs total_deaths

--shows likelihood of dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 AS Deathpercentage
FROM [portfolio project].[dbo].[CovidDeaths$]
WHERE location like '%states%'
ORDER By 1,2

--Looking at total_cases vs population

--shows what percentage of population got infected

SELECT location, date, total_cases,population, (total_cases / population)*100 AS percentpopulationinfected
FROM [portfolio project].[dbo].[CovidDeaths$]
WHERE location like '%India%'
ORDER By 1,2

--Looking at countries with highest infection rate compared to population

SELECT location,population,MAX(total_cases) AS highestcount, MAX((total_cases / population)*100) AS percentpopulationinfected
FROM [portfolio project].[dbo].[CovidDeaths$]
WHERE continent is not Null
GROUP BY location,population
ORDER By percentpopulationinfected desc

--SHOWING THE COUNTRIES WITH HIGHEST DEATHCOUNT per population

SELECT location,MAX(total_deaths) AS highestdeathcount
FROM [portfolio project].[dbo].[CovidDeaths$]
WHERE continent is not Null
GROUP BY location
ORDER By highestdeathcount desc

--lets break things into continent

--showing continents with highest death count per population

SELECT location,MAX(total_deaths) AS highestdeathcount
FROM [portfolio project].[dbo].[CovidDeaths$]
WHERE continent is Null
GROUP BY location
ORDER By highestdeathcount desc

--Global numbers

SELECT continent,SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) AS total_deaths, SUM(new_cases) / SUM(cast(new_deaths as int)) AS globaldeathpercentage
FROM [portfolio project].[dbo].[CovidDeaths$]
WHERE continent is not null
GROUP By continent
ORDER By 1,2

SELECT *
FROM [portfolio project].[dbo].[CovidVaccinations$]

--Looking at total population vs people vaccinated 
--With CTE

WITH popvsvac(continent, location, date,population, new_vaccinations, rollingpopulationvaccinated)
as
(
SELECT de.continent, de.location, de.date, de.population, va.new_vaccinations,
sum(convert(int,va.new_vaccinations)) over (partition by de.location order by de.location,de.date) as rollingpopulationvaccinated
FROM [portfolio project].[dbo].[CovidDeaths$]de
JOIN [portfolio project].[dbo].[CovidVaccinations$] va
ON de.location = va.location AND de.date = va.date
where de.continent is not null
)
SELECT *, (rollingpopulationvaccinated /population) *100 as percentpoulationvaccinated
FROM popvsvac

--creating view to store the data for later visulaization

CREATE view percentpopulationvaccinated as 
SELECT de.continent, de.location, de.date, de.population, va.new_vaccinations,
sum(convert(int,va.new_vaccinations)) over (partition by de.location order by de.location,de.date) as rollingpopulationvaccinated
FROM [portfolio project].[dbo].[CovidDeaths$]de
JOIN [portfolio project].[dbo].[CovidVaccinations$] va
ON de.location = va.location AND de.date = va.date
Where de.continent is not null


Select *
From percentpopulationvaccinated