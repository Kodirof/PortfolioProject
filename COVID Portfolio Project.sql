
SELECT *
FROM ..CovidDeaths
WHERE Continent is not null
ORDER BY 3,4

--SELECT *
--FROM ..CovidVaccinations
--ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE Continent is not null
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths
SELECT location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases) *100,2) as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE Continent is not null
ORDER BY 1,2 DESC

-- Shows what percentage of population got Covid
SELECT location, date, population, total_cases, ROUND((total_cases/population) *100,2) as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE Continent is not null
ORDER BY 1,2 

-- Looking at Countries with Highest Infection Rate compared to Population
SELECT location, population, MAX(total_cases) as HighestInfectionCount, ROUND(MAX((total_cases/population)) *100,2) as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE Continent is not null
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC 

-- Showing Countries with Highest Death Count per Population
SELECT location, MAX(CAST(total_deaths AS INT)) as TotalDeathCount
FROM PortfolioProject
..CovidDeaths
WHERE Continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC 

-- LET'S BREAK THINGS DOWN BY CONTINENT 
-- Showing continents with the highest death count per population
SELECT Continent,  MAX(CAST(total_deaths AS INT)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE Continent is not null
GROUP BY Continent
ORDER BY TotalDeathCount DESC 

-- Global Numbers
SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, 
	   ROUND(SUM(new_deaths)/SUM(new_cases) *100, 2) AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE Continent is not null
--GROUP BY date
ORDER BY 1,2 DESC

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

-- Looking at Total Population vs Vaccinations
;WITH PopulationVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, 
	   vac.new_vaccinations, 
	   SUM(vac.new_vaccinations) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths AS dea
JOIN PortfolioProject..CovidVaccinations AS vac
	 ON dea.location=vac.location and dea.date=vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, ROUND(RollingPeopleVaccinated/Population * 100, 2)
FROM PopulationVac

-- TEMP TABLE
CREATE TABLE #PercentPopulationVaccinated
(
	Continent nvarchar(255), 
	Location nvarchar(255), 
	Date datetime, 
	Population numeric, 
	New_Vaccinations numeric, 
	RollingPeopleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, 
	   vac.new_vaccinations, 
	   SUM(vac.new_vaccinations) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths AS dea
JOIN PortfolioProject..CovidVaccinations AS vac
	 ON dea.location=vac.location and dea.date=vac.date
--WHERE dea.continent IS NOT NULL

SELECT *, ROUND((RollingPeopleVaccinated/Population) * 100, 1)
FROM #PercentPopulationVaccinated

-- Creating View to store data for later visualizations
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, 
	   vac.new_vaccinations, 
	   SUM(vac.new_vaccinations) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths AS dea
JOIN PortfolioProject..CovidVaccinations AS vac
	 ON dea.location=vac.location and dea.date=vac.date
WHERE dea.continent IS NOT NULL

SELECT *
FROM PercentPopulationVaccinated
