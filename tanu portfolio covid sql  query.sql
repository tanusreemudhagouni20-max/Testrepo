--select *
--from tanu_portfolio_project..[CovidDeaths 1st]
--where continent is not null
--order by 3,4

--select location,date,total_cases,new_cases,total_deaths,population
----from tanu_portfolio_project..[CovidDeaths 1st]
--where continent is not null
----order by 1,2

----toatl case vs total deaths for death percentage
----select location,date,total_cases,total_deaths,(CAST(total_deaths as FLOAT)/total_cases)*100 as death_percent
----from tanu_portfolio_project..[CovidDeaths 1st]
----where location like '%states%'
--and continent is not null
----order by 1,2

----total cases vs the population for cases percent
----select location,date, population,total_cases,total_deaths,( CAST(total_cases AS FLOAT)/population)*100 as cases_percent
----from tanu_portfolio_project..[CovidDeaths 1st]
------where location like '%states%'
--and continent is not null
----order by 1,2


----countries with highest infection rate
----select location, population,max(total_cases) as highestInfectionCount, max(( CAST(total_cases AS FLOAT)/population))*100 as percent_population_inf
----from tanu_portfolio_project..[CovidDeaths 1st]
------Where location like '%states%'
--and  continent is not null
----group by location, population
----order by percent_population_inf desc


----countreies with highest death count
--select location, population,max(total_deaths) as TotalDeathCount
--from tanu_portfolio_project..[CovidDeaths 1st]
----Where location like '%states%'
--where continent is not null
--group by location, population
--order by TotalDeathCount desc

--by continent 
--showing the continents with the highest death count

--select continent,max(total_deaths) as TotalDeathCount
--from tanu_portfolio_project..[CovidDeaths 1st]
----Where location like '%states%'
--where continent is not null
--group by continent
--order by TotalDeathCount desc

-- global numbers
--select date, SUM(new_cases), sum(cast(new_deaths as int)) as NewDeathTotal  sum (CAST(new_deaths as int)/new_cases)*100 as death_percent
--from tanu_portfolio_project..[CovidDeaths 1st]
--group by date
----where location like '%states%'
-- --where continent is not null
----order by 1,2

--select
--sum(cast( new_deaths as int)) as TotalNewDeaths,
--sum(new_cases) as TotalNewCases,
--sum(cast(new_deaths as float))/ NULLIF (sum(new_cases),0)*100 as DeathPercent
--from tanu_portfolio_project..[CovidDeaths 1st]
--order by 1,2  

----loking at total population vs vaccinations
--select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
--sum(convert(int, isnull(vac.new_vaccinations,0))) over (partition by dea.location order by dea.location, dea.date)as Rollingvaccinations
--from tanu_portfolio_project..[CovidDeaths 1st] dea
--join tanu_portfolio_project..[Covid vaccinations csv] vac
--on dea.location=vac.location
--and dea.date=vac.date
--where dea.continent is not null
--order by 2,3

with popvsvac(continent,location,date,population,new_vaccinations,Rollingvaccination)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int, isnull(vac.new_vaccinations,0))) over (partition by dea.location order by dea.location, dea.date)as Rollingvaccinations
from tanu_portfolio_project..[CovidDeaths 1st] dea
join tanu_portfolio_project..[Covid vaccinations csv] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select *,(cast(Rollingvaccination as float)/population)*100 as VaccinationPercentage
from popvsvac

--TEMP TABLE

drop table if exists #PERCENTPOPULATIONVACCINATED
CREATE TABLE #PERCENTPOPULATIONVACCINATED
(
CONTINENT NVARCHAR(255),
LOCATION NVARCHAR(255),
DATE DATETIME,
POPULATION NUMERIC,
new_vaccination numeric,
ROLLINGPEOPLEVACCCINATED NUMERIC
)


INSERT INTO #PERCENTPOPULATIONVACCINATED
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int, isnull(vac.new_vaccinations,0))) over (partition by dea.location order by dea.location, dea.date)as Rollingvaccinations
from tanu_portfolio_project..[CovidDeaths 1st] dea
join tanu_portfolio_project..[Covid vaccinations csv] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
select *,(ROLLINGPEOPLEVACCCINATED/population)*100
from #PERCENTPOPULATIONVACCINATED


--creating viewe to store data for later visualisations
create view PercentPopulationVaccinaated as 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int, isnull(vac.new_vaccinations,0))) over (partition by dea.location order by dea.location, dea.date)as Rollingvaccinations
from tanu_portfolio_project..[CovidDeaths 1st] dea
join tanu_portfolio_project..[Covid vaccinations csv] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select * 
from PercentPopulationVaccinaated







