/*
Introduction
When factoring heat generation required for the manufacturing and transportation of products, Greenhouse gas emissions attributable to products, from food to sneakers to appliances, make up more than 75% of global emissions. [The Carbon Catalogue](https://www.nature.com/articles/s41597-022-01178-9)

Our data, which is publicly available on [nature](https://www.nature.com/articles/s41597-022-01178-9), contains product carbon footprints (PCFs) for various companies. PCFs are the greenhouse gas emissions attributable to a given product, measured in CO2 (carbon dioxide equivalent).

This data is stored in a PostgreSQL database containing one table, product_emissions, which looks at PCFs by product as well as the stage of production that these emissions occurred. Here's a snapshot of what `product_emissions` contains in each column:

field                       | data type
----------------------------+------------
id                          | VARCHAR
year                        | INT
roduct_name                 | VARCHAR
company                     | VARCHAR
country                     | VARCHAR
industry_group              | VARCHAR
weight_kg                   | NUMERIC
carbon_footprint_pcf        | NUMERIC
upstream_percent_total_pcf  | VARCHAR
operations_percent_total_pcf| VARCHAR
downstream_percent_total_pcf| VARCHAR

*/

-- Return the first five rows to get familiar with data.
SELECT *
FROM "product_emissions_org.csv"
LIMIT 5;

/*
id            | year | product_name                            | company              | country  | industry_group                    | weight_kg | carbon_footprint_pcf  | upstream_percent_total_pcf  | operations_percent_total_pcf  | downstream_percent_total_pcf
--------------+------+-----------------------------------------+----------------------+----------+-----------------------------------+-----------+-----------------------+-----------------------------+-------------------------------+-------------------------------
10056-1-2014  | 2014 | Frosted Flakes(R) Cereal                | Kellogg Company      | USA      | "Food, Beverage & Tobacco"        | 0.7485    | 2.00                  | 57.50%                      | 30.00%                        | 12.50%
10056-1-2015  | 2015 | "Frosted Flakes, 23 oz, produced in ..."| Kellogg Company      | USA      | Food & Beverage Processing        | 0.7485    | 2.00                  | 57.50%                      | 30.00%                        | 12.50%
10222-1-2013  | 2013 | Office Chair                            | KNOLL INC            | USA      | Capital Goods                     | 20.6800   | 72.54                 | 80.63%                      | 17.36%                        | 2.01%
10261-1-2017  | 2017 | Multifunction Printers                  | Konica Minolta, Inc. | Japan    | Technology Hardware & Equipment   | 110.0000  | 1488.00               | 30.65%                      | 5.51%                         | 63.84%
10261-2-2017  | 2017 | Multifunction Printers                  | Konica Minolta, Inc. | Japan    | Technology Hardware & Equipment   | 110.0000  | 1818.00               | 25.08%                      | 4.51%                         | 70.41%
*/

/*
Project Instructions: 
* Using the `product_emissions` table, find the number of unique companies and their total carbon footprint PCF for each industry group, filtering for the most recent year in the database. 
* The query should return three columns: `industry_group`, `num_companies`, and `total_industry_footprint`, with the last column being rounded to one decimal place. 
The results should be sorted by `total_industry_footprint` from highest to lowest values.
*/

SELECT 
  "industry_group", 
	COUNT(DISTINCT "company") AS "num_companies", 
	ROUND(SUM("carbon_footprint_pcf"), 1) AS "total_industry_footprint"
FROM "product_emissions_org.csv"
WHERE "year" IN (
	SELECT MAX("year")
	FROM "product_emissions_org.csv"
)
GROUP BY "industry_group"
ORDER BY ROUND(SUM("carbon_footprint_pcf"), 1) DESC;

/*
industry_group                      | num_companies  | total_industry_footprint
------------------------------------+----------------+--------------------------
Materials                           | 3              | 107129.0
Capital Goods                       | 2              | 94942.7
Technology Hardware & Equipment     | 4              | 21865.1
"Food, Beverage & Tobacco"          | 1              | 3161.5
Commercial & Professional Services  | 1              | 740.6
*/

/*
Conclusion
The Materials industry, represented by three companies, has the highest carbon footprint of 107,129 PCF, 
while the Software & Services industry has the lowest carbon footprint of 690 PCF.
*/
