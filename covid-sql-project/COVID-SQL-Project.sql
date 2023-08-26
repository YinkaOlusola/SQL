SELECT *
FROM sql_covid_Project..CovidDeaths
ORDER BY 3,4


SELECT *
FROM sql_covid_Project..CovidVaccinations
ORDER BY 3,4


SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM sql_covid_project..CovidDeaths
ORDER BY 1,2


-- Total cases versus total deaths
-- Likelihood of death of a Covid Patient in Nigeria

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM sql_covid_Project..CovidDeaths
WHERE location like '%Nigeria%'
ORDER BY 1,2


-- Total cases versus Polulation
-- Percentage of population that contracted COVID

SELECT Location, date, population, total_cases, (total_cases/population)*100 AS CovidPopulationPercentage
FROM sql_covid_Project..CovidDeaths
-- changing the line below will show the statistics for Nigeria.
-- WHERE location like '%Nigeria%'
ORDER BY 1,2


-- Countries with Highest Infection rate compared to Population

SELECT Location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentagePopulationInfected
FROM sql_covid_Project..CovidDeaths
-- WHERE location like '%Nigeria%'
GROUP BY Location, population
ORDER BY PercentagePopulationInfected DESC


-- Highest death counts per Population by Country

SELECT Location, MAX(CAST(total_deaths AS int)) AS Total_Death_Count
FROM sql_covid_Project..CovidDeaths
-- WHERE location like '%Nigeria%'
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY Total_Death_Count DESC


-- Exploratory data analysis by Continent


-- Continents with Highest death counts

SELECT continent, MAX(CAST(total_deaths AS int)) AS Total_Death_Count
FROM sql_covid_Project..CovidDeaths
-- WHERE location like '%Nigeria%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Total_Death_Count DESC


-- Global Numbers

-- Death percentage across the world on different days

SELECT date, SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS int)) AS Total_Deaths, (SUM(CAST(new_deaths AS int))/SUM(new_cases))*100 AS DeathPercentage
FROM sql_covid_Project..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1 DESC


-- Death Percentage in total across the world.

SELECT SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS int)) AS Total_Deaths, (SUM(CAST(new_deaths AS int))/SUM(new_cases))*100 AS DeathPercentage
FROM sql_covid_Project..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1 DESC


-- Total Population versus Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, CAST(vac.new_vaccinations AS int),
	SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)  AS RollingPeopleVaccinated
FROM sql_covid_Project..CovidDeaths dea
JOIN sql_covid_Project..CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3


-- USING CTE
WITH PopulationVsVaccination (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
	(
		SELECT dea.continent, dea.location, dea.date, dea.population, CAST(vac.new_vaccinations AS int),
			SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)  AS RollingPeopleVaccinated
		FROM sql_covid_Project..CovidDeaths dea
		JOIN sql_covid_Project..CovidVaccinations vac
		ON dea.location = vac.location
		AND dea.date = vac.date
		WHERE dea.continent IS NOT NULL
		--ORDER BY 2,3
	)

SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopulationVsVaccination



-- TEMP TABLE

DROP TABLE IF EXISTS #PercentagePopulationVaccinated
CREATE TABLE #PercentagePopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric, 
new_vaccination numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentagePopulationVaccinated
		SELECT dea.continent, dea.location, dea.date, dea.population, CAST(vac.new_vaccinations AS int),
			SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)  AS RollingPeopleVaccinated
		FROM sql_covid_Project..CovidDeaths dea
		JOIN sql_covid_Project..CovidVaccinations vac
		ON dea.location = vac.location
		AND dea.date = vac.date
		WHERE dea.continent IS NOT NULL

SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PercentagePopulationVaccinated


-- Creating views to store data for visualization

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
			SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)  AS RollingPeopleVaccinated
FROM sql_covid_Project..CovidDeaths dea
JOIN sql_covid_Project..CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3


SELECT *
FROM PercentPopulationVaccinated