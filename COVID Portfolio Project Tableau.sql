

/*	Queries used for Tableau Project	*/

--	1.TotalCases, TotalDeaths, DeathPercentage
SELECT SUM(new_cases) AS total_cases, 
	   SUM(CAST(new_deaths AS INT)) AS total_deaths, 
	   ROUND(SUM(new_deaths)/SUM(new_cases) *100, 2) AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE Continent is not null
ORDER BY 1,2 DESC

--	2.TotalCases, TotalDeaths, DeathPercentage Grouped By Location
SELECT Continent, 
	   SUM(CAST(new_deaths AS INT)) AS TotalDeaths, 
	   ROUND(SUM(new_deaths)/SUM(new_cases) *100, 2) AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE Continent is not null AND Continent NOT IN ('World', 'European Union', 'International')
GROUP BY Continent
ORDER BY 1,2 DESC

--	3.
SELECT Location, Population, MAX(total_cases) as HighestInfectionCount, ROUND(MAX((total_cases/population)) *100,2) as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE Continent is not null
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC 

--	4.
SELECT Location, Population, Date, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)) *100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY  Location, Population, Date
ORDER BY 1,2 