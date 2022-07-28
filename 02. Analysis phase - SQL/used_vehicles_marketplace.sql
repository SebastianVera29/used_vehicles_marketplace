-- Used vehicles marketplace Analysis

-- Looking at the average price per manufacturer in descending order

SELECT manufacturer, ROUND(AVG(price),2) AS average_price
FROM `golden-nectar-338803.vehicles.vehicles_information` 
WHERE manufacturer <> 'NA'
GROUP BY manufacturer
ORDER BY average_price DESC;

-- Looking at the average price per region

SELECT region, ROUND(AVG(price),2) AS average_price
FROM `golden-nectar-338803.vehicles.vehicles_information`
WHERE manufacturer <> 'NA'
GROUP BY region
ORDER BY region, average_price;

-- Looking at the average price per region and per manufacturer

SELECT region, manufacturer, ROUND(AVG(price),2) AS average_price
FROM `golden-nectar-338803.vehicles.vehicles_information`
WHERE manufacturer <> 'NA'
GROUP BY region, manufacturer
ORDER BY region, manufacturer, average_price DESC;

-- Looking at average age at which a car is sold

SELECT AVG(CAST(age_of_car AS int)) AS average_age
FROM `golden-nectar-338803.vehicles.vehicles_information`
WHERE age_of_car <> 'NA';

-- Identifying the top regions where most cars are offered

SELECT region, COUNT(*) AS number_of_offers
FROM `golden-nectar-338803.vehicles.vehicles_information`
GROUP BY region
ORDER BY number_of_offers DESC;

-- Other way: Identifying the top regions where most cars are offered

SELECT region, manufacturer, lat, long, COUNT(*) AS number_of_offers
FROM `golden-nectar-338803.vehicles.vehicles_information`
WHERE manufacturer <> 'NA'
GROUP BY region, manufacturer, lat, long
ORDER BY number_of_offers DESC;

-- Determining the percentage of car offers per manufacturer and per type of fuel

WITH CarsFeatures AS 
(
SELECT manufacturer, fuel, COUNT(*) AS number_of_cars
FROM `golden-nectar-338803.vehicles.vehicles_information`
WHERE manufacturer <> 'NA' AND fuel <> 'NA'
GROUP BY manufacturer, fuel
)
SELECT *, SUM(number_of_cars) OVER(PARTITION BY manufacturer) AS total, 
  ROUND(number_of_cars/SUM(number_of_cars) OVER(PARTITION BY manufacturer), 2)*100 AS cars_percentage
FROM CarsFeatures
ORDER BY manufacturer, fuel, number_of_cars;

-- Determining the percentage of fuel used

WITH FuelType AS
(
SELECT fuel, COUNT(*) AS number_of_cars
FROM `golden-nectar-338803.vehicles.vehicles_information`
WHERE fuel <> 'NA'
GROUP BY fuel
ORDER BY number_of_cars DESC
)
SELECT *, ROUND(number_of_cars*100/SUM(number_of_cars) OVER(), 2) AS percentage
FROM FuelType
ORDER BY percentage DESC;