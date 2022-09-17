-- Project: Исследование данных об инвестициях венчурных фондов в компании-стартапы

 -- ==========================================================================
 
SELECT COUNT(*)
 FROM company
 WHERE status = 'closed';
 
 -- ==========================================================================
 
 SELECT funding_total
FROM company
WHERE category_code = 'news' AND country_code = 'USA'
ORDER BY funding_total DESC;
 
 -- ==========================================================================
 
SELECT SUM(price_amount)
FROM acquisition
WHERE term_code = 'cash'
  AND EXTRACT(YEAR
              FROM CAST(acquired_at AS date)) BETWEEN 2011 AND 2013;
              
 -- ==========================================================================
 
SELECT first_name,
       last_name,
       twitter_username
FROM people
WHERE twitter_username LIKE 'Silver%';

 -- ==========================================================================
 
 SELECT * 
 FROM people 
 WHERE last_name LIKE 'K%' 
   AND twitter_username LIKE '%money%';
 
 -- ==========================================================================
 
SELECT country_code,
       SUM(funding_total) AS total_funding
FROM company
GROUP BY country_code
ORDER BY total_funding DESC;

 -- ==========================================================================
 
SELECT funded_at,
       MIN(raised_amount),
       MAX(raised_amount)
FROM funding_round
GROUP BY funded_at
HAVING MIN(raised_amount) != 0
   AND MIN(raised_amount) != MAX(raised_amount);
   
 -- ==========================================================================
 
SELECT *,
       CASE
           WHEN invested_companies >= 100 THEN 'high_activity'
           WHEN invested_companies >= 20 THEN 'middle_activity'
           ELSE 'low_activity'
       END
FROM fund;

 -- ==========================================================================
 
SELECT CASE
           WHEN invested_companies>=100 THEN 'high_activity'
           WHEN invested_companies>=20 THEN 'middle_activity'
           ELSE 'low_activity'
       END AS activity,
       ROUND(AVG(investment_rounds)) AS avg_investment_rounds
FROM fund
GROUP BY activity
ORDER BY avg_investment_rounds;

 -- ==========================================================================
 
SELECT country_code,
       MIN(invested_companies),
       MAX(invested_companies),
       AVG(invested_companies)
FROM fund
WHERE EXTRACT(YEAR FROM CAST(founded_at AS date)) BETWEEN 2010 AND 2012
GROUP BY country_code
HAVING MIN(invested_companies) != 0
ORDER BY AVG(invested_companies) DESC
LIMIT 10;

 -- ==========================================================================
 
SELECT p.first_name,
       p.last_name,
       e.instituition
FROM people AS p
LEFT JOIN education AS e 
       ON p.id = e.person_id;

 -- ==========================================================================
 
WITH 
-- people_education
pe AS
  (SELECT p.company_id AS company_id,
          e.instituition AS instituition
   FROM people AS p
   LEFT JOIN education AS e ON p.id = e.person_id)

SELECT c.name AS company_name,
       COUNT(DISTINCT pe.instituition) AS instituition_count
FROM company AS c
LEFT JOIN pe 
       ON c.id = pe.company_id
GROUP BY company_name
ORDER BY instituition_count DESC
LIMIT 5;

 -- ==========================================================================
 
WITH 
--companies where first round is last round
one_round_companies AS 
  (SELECT company_id
   FROM funding_round
   WHERE is_first_round = 1
     AND is_last_round = 1)
  
SELECT DISTINCT name
FROM company
WHERE id IN (SELECT * FROM one_round_companies)
  AND status = 'closed';
  
 -- ==========================================================================
 
SELECT DISTINCT p.id
FROM company AS c
JOIN people AS p 
  ON c.id = p.company_id
LEFT JOIN funding_round AS fr 
       ON c.id = fr.company_id
WHERE fr.is_first_round = 1 
  AND fr.is_last_round = 1
  AND c.status = 'closed';

 -- ==========================================================================
 
WITH 
--companies where first round is last round
one_round_companies AS 
  (SELECT company_id
   FROM funding_round
   WHERE is_first_round = 1
     AND is_last_round = 1),

companies_selected AS 
  (SELECT DISTINCT id
   FROM company
   WHERE id IN (SELECT * FROM one_round_companies)
     AND status = 'closed')

SELECT DISTINCT p.id, e.instituition 
FROM people AS p
JOIN education AS e 
  ON p.id = e.person_id
WHERE company_id IN (SELECT * FROM companies_selected);

 -- ==========================================================================
 
WITH 
--companies where first round is last round
one_round_companies AS 
  (SELECT company_id
   FROM funding_round
   WHERE is_first_round = 1
     AND is_last_round = 1),

companies_selected AS 
  (SELECT DISTINCT id
   FROM company
   WHERE id IN (SELECT * FROM one_round_companies)
     AND status = 'closed')

SELECT p.id, 
       COUNT(e.instituition) 
FROM people AS p
JOIN education AS e 
  ON p.id = e.person_id
WHERE company_id IN (SELECT * FROM companies_selected)
GROUP BY p.id;

 -- ==========================================================================
 
WITH 
--companies where first round is last round
one_round_companies AS 
  (SELECT company_id
   FROM funding_round
   WHERE is_first_round = 1
     AND is_last_round = 1),

companies_selected AS 
  (SELECT DISTINCT id
   FROM company
   WHERE id IN (SELECT * FROM one_round_companies)
     AND status = 'closed'),

people_ed_count AS
  (SELECT p.id, 
          COUNT(e.instituition) AS ed_count
   FROM people AS p
   JOIN education AS e 
     ON p.id = e.person_id
   WHERE company_id IN (SELECT * FROM companies_selected)
   GROUP BY p.id)

SELECT AVG(ed_count)
FROM people_ed_count;

 -- ==========================================================================
 
WITH 
company_selected AS 
  (SELECT DISTINCT id
   FROM company
   WHERE name = 'Facebook'),

people_ed_count AS
  (SELECT p.id, 
          COUNT(e.instituition) AS ed_count
   FROM people AS p
   JOIN education AS e 
     ON p.id = e.person_id
   WHERE company_id IN (SELECT * FROM company_selected)
   GROUP BY p.id)

SELECT AVG(ed_count)
FROM people_ed_count;

 -- ==========================================================================
 
WITH
company_funding_rounds AS
  (SELECT fr.id AS funding_round_id,
          c.name AS name_of_company,
          fr.raised_amount AS amount
   FROM company AS c
   LEFT JOIN funding_round AS fr 
          ON c.id = fr.company_id
   WHERE milestones > 6
     AND EXTRACT(YEAR FROM CAST(funded_at AS date)) BETWEEN 2012 AND 2013)

SELECT f.name AS name_of_fund,
       cfr.name_of_company,
       cfr.amount
FROM fund AS f
JOIN investment AS i 
  ON f.id = i.fund_id
JOIN company_funding_rounds AS cfr 
  ON i.funding_round_id = cfr.funding_round_id;

 -- ==========================================================================
 
WITH 
-- отбор компаний и инвестиций в них
acquired_companies_investments AS
  (SELECT id AS acquired_company_id,
          name AS acquired_company_name,
          funding_total
   FROM company), 
   
-- словарь названий компаний
company_names AS
  (SELECT id,
          name
   FROM company)

SELECT cn.name AS acquiring_company_name,
       acq.price_amount AS acquisition_price,
       aci.acquired_company_name,
       aci.funding_total,
       ROUND(acq.price_amount / aci.funding_total) AS proportion
FROM acquisition AS acq
LEFT JOIN company_names AS cn 
       ON acq.acquiring_company_id = cn.id
LEFT JOIN acquired_companies_investments AS aci 
       ON acq.acquired_company_id = aci.acquired_company_id
WHERE acq.price_amount > 0
  AND aci.funding_total > 0
ORDER BY acquisition_price DESC,
         aci.acquired_company_name
LIMIT 10;

 -- ==========================================================================
 
WITH
-- getting social companies
social_company AS
  (SELECT id,
          name AS company_name
   FROM company
   WHERE category_code = 'social'),

-- getting funding rounds between 2010 and 2013
funding_rounds AS
  (SELECT company_id,
          EXTRACT(MONTH FROM CAST(funded_at AS date)) AS round_month
   FROM funding_round
   WHERE EXTRACT(YEAR FROM CAST(funded_at AS date)) BETWEEN 2010 AND 2013)

SELECT sc.company_name,
       fr.round_month
FROM social_company AS sc
JOIN funding_rounds AS fr 
  ON sc.id = fr.company_id;

 -- ==========================================================================
 
WITH
-- getting USA funds
usa_funds AS
  (SELECT id AS fund_id,
          name AS fund_name
   FROM fund
   WHERE country_code = 'USA'),

-- getting USA funds investments
usa_invest AS
  (SELECT i.funding_round_id,
          i.company_id,
          uf.fund_name
   FROM investment AS i
   JOIN usa_funds AS uf 
     ON i.fund_id = uf.fund_id),

-- monthly count of USA funds invested in 2010-2013
usa_monthly_invested AS
  (SELECT EXTRACT(MONTH FROM CAST(funded_at AS date)) AS round_month,
          COUNT(DISTINCT ui.fund_name) AS unique_usa_funds_count
   FROM funding_round AS fr
   JOIN usa_invest AS ui 
     ON fr.id = ui.funding_round_id 
    AND fr.company_id = ui.company_id
   WHERE EXTRACT(YEAR FROM CAST(funded_at AS date)) BETWEEN 2010 AND 2013
   GROUP BY round_month),

-- monthly acquisition data in 2010-2013
monthly_acquisition AS
  (SELECT EXTRACT(MONTH FROM CAST(acquired_at AS date)) AS acq_month,
          COUNT(acquired_company_id) AS acquired_company_count,
          SUM(price_amount) AS total_price_amount
   FROM acquisition
   WHERE EXTRACT(YEAR FROM CAST(acquired_at AS date)) BETWEEN 2010 AND 2013
   GROUP BY acq_month)

SELECT umi.round_month AS month,
       umi.unique_usa_funds_count,
       ma.acquired_company_count,
       ma.total_price_amount
FROM usa_monthly_invested AS umi
LEFT JOIN monthly_acquisition AS ma 
       ON umi.round_month = ma.acq_month;

 
 -- ==========================================================================
 
WITH
funding_11 AS
  (SELECT country_code AS country,
          AVG(funding_total) AS avg_funding_2011
   FROM company
   WHERE EXTRACT(YEAR FROM CAST(founded_at AS date)) = 2011
   GROUP BY country),

funding_12 AS
  (SELECT country_code AS country,
          AVG(funding_total) AS avg_funding_2012
   FROM company
   WHERE EXTRACT(YEAR FROM CAST(founded_at AS date)) = 2012
   GROUP BY country),

funding_13 AS
  (SELECT country_code AS country,
          AVG(funding_total) AS avg_funding_2013
   FROM company
   WHERE EXTRACT(YEAR FROM CAST(founded_at AS date)) = 2013
   GROUP BY country)

SELECT f11.country,
       f11.avg_funding_2011,
       f12.avg_funding_2012,
       f13.avg_funding_2013
FROM funding_11 AS f11
JOIN funding_12 AS f12 
  ON f11.country = f12.country
JOIN funding_13 AS f13 
  ON f11.country = f13.country
ORDER BY f11.avg_funding_2011 DESC;

