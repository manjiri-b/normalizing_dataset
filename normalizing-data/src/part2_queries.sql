--1.
SELECT DISTINCT year
FROM country_stats
ORDER BY year DESC;

--2.
SELECT name FROM countries ORDER BY name ASC LIMIT 5;

--3.
SELECT name, gdp
    FROM countries
    INNER JOIN country_stats ON country_stats.country_id = countries.country_id WHERE country_stats.year = 2018
    ORDER BY gdp DESC LIMIT 5;

--4.
SELECT region_id,
    COUNT(*) as country_count
    FROM countries
    GROUP BY region_id
    ORDER BY country_count DESC;

--5.
SELECT
	region_id,
	ROUND( AVG( area ), 0 ) AS avg_area
FROM
	countries
GROUP BY
	region_id
ORDER BY avg_area ASC;

--6.
SELECT
	region_id,
	ROUND( AVG( area ), 0 ) AS avg_area
FROM
	countries
GROUP BY
	region_id
HAVING ROUND( AVG( area ), 0 ) < 1000
ORDER BY avg_area ASC;

--7.
-- First get  population of each country
-- Next match region id of country
-- From countries table match region id to region id of regions table
-- From regions table get continent id

SELECT continents.name,
       ROUND((SUM(country_stats.population)/1000000.0),2) as tot_pop
    FROM continents
    INNER JOIN regions ON continents.continent_id = regions.continent_id
    INNER JOIN countries ON regions.region_id = countries.region_id
    INNER JOIN country_stats ON countries.country_id = country_stats.country_id WHERE country_stats.year = 2018
    GROUP BY continents.name
    ORDER BY tot_pop DESC;

--8.
SELECT countries.name
  FROM countries
  LEFT JOIN country_languages ON countries.country_id = country_languages.country_id
  WHERE country_languages.country_id IS NULL;

--9.
SELECT countries.name, COUNT(country_languages.language_id) AS lang_count
    FROM country_languages
    LEFT JOIN countries ON countries.country_id = country_languages.country_id
    GROUP BY countries.name
    ORDER BY lang_count DESC, countries.name ASC
    LIMIT 10;

--10.
SELECT countries.name, STRING_AGG(languages.language,',') AS string_agg
    FROM country_languages
    INNER JOIN countries ON countries.country_id = country_languages.country_id
    INNER JOIN languages ON languages.language_id = country_languages.language_id
    GROUP BY countries.name
    ORDER BY COUNT(country_languages.language_id) DESC, countries.name ASC
    LIMIT 10;

--11.
--Number of countries by region
--Number of languages by region
    -- Number of languages by country
    -- Then find number of countries by region and add
-- Average = number of languages by region/number of countries by region
--
-- AT most one decimal place
SELECT regions.name,
       ROUND(COUNT(country_languages.country_id)/1.0/(COUNT(DISTINCT countries.name)),1) as avg_lang_count_per_country
FROM regions
LEFT JOIN countries ON countries.region_id = regions.region_id
LEFT JOIN country_languages ON countries.country_id = country_languages.country_id
GROUP BY regions.name
ORDER BY avg_lang_count_per_country DESC, regions.name DESC;

--12.
SELECT name, national_day FROM countries
WHERE national_day = (SELECT MAX(national_day) FROM countries)
UNION
SELECT name, national_day FROM countries
WHERE national_day = (SELECT MIN(national_day) FROM countries);
