--Q1

SELECT *
FROM prescription;

SELECT p1.npi,p2.nppes_provider_first_name AS first_name,p2.nppes_provider_last_org_name AS last_name,specialty_description, total_claim_count
FROM prescription AS p1
LEFT JOIN prescriber AS p2 ON p1.npi = p2.npi
ORDER BY total_claim_count DESC;

--Q2
--A

SELECT DISTINCT specialty_description,SUM(total_claim_count) AS claim_count_sum
FROM prescription AS p1
LEFT JOIN prescriber AS p2 USING(npi)
GROUP BY DISTINCT specialty_description
ORDER BY claim_count_sum DESC;

-- Family Practice-9,752,347 claims

--B

SELECT DISTINCT (specialty_description), SUM(total_claim_count) AS claim_count_sum, d.opioid_drug_flag
FROM prescription AS p1
LEFT JOIN prescriber AS p2 USING(npi)
LEFT JOIN drug AS d ON p1.drug_name = d.drug_name
WHERE d.opioid_drug_flag ILIKE '%Y%'
GROUP BY DISTINCT (specialty_description),d.opioid_drug_flag
ORDER BY claim_count_sum DESC;

--Nurse Practitioner-900,845 claims

--C-not finished...yet.

SELECT specialty_description,SUM(total_claim_count) AS total_claim_sum
FROM prescriber AS p1
LEFT JOIN prescription AS p2 USING(npi)
WHERE total_claim_count IS NULL
GROUP BY specialty_description;

--D-Difficult BONUS



--Q3

SELECT generic_name, SUM(total_drug_cost) AS total_drug_sum
FROM prescription AS p
LEFT JOIN drug as d USING(drug_name)
GROUP BY generic_name
ORDER BY total_drug_sum DESC;

--Insulin-104,264,066.35

--B

SELECT generic_name, ROUND(SUM(total_drug_cost)/365,2) AS total_drug_sum_per_day
FROM prescription AS p
LEFT JOIN drug as d USING(drug_name)
GROUP BY generic_name
ORDER BY total_drug_sum_per_day DESC;

--Insulin-285,654.98

--Q4

--A

SELECT generic_name,opioid_drug_flag,antibiotic_drug_flag,
CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic' 
WHEN opioid_drug_flag = 'N' THEN 'neither'
WHEN antibiotic_drug_flag = 'N' THEN 'neither'END AS drug_type
FROM drug
ORDER BY generic_name ASC;

SELECT generic_name, opioid_drug_flag,antibiotic_drug_flag,
CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
	 WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	 ELSE 'neither' END AS drug_type
FROM drug
ORDER BY generic_name ASC;
	 

--B

SELECT drug_type, SUM(total_drug_cost)::money AS individual_drug_total_cost
FROM (SELECT drug_name, opioid_drug_flag,antibiotic_drug_flag,
	 CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
	 WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	 ELSE 'neither' END AS drug_type
	 FROM drug
	 ORDER BY generic_name ASC) AS drug_comparison
LEFT JOIN prescription AS p
USING(drug_name)
WHERE drug_type NOT ILIKE '%neither%'
GROUP BY drug_type
ORDER BY individual_drug_total_cost DESC;

--Opioid- $105,080,626.37

--Q5

--A

SELECT COUNT(*) AS tn_cbsa_count
FROM cbsa
LEFT JOIN fips_county
USING(fipscounty)
WHERE state ILIKE '%TN%';

--B

SELECT cbsaname, SUM(population) AS population_sum
FROM cbsa
LEFT JOIN fips_county
USING(fipscounty)
LEFT JOIN population
USING(fipscounty)
WHERE population IS NOT NULL
GROUP BY cbsaname 
ORDER BY population_sum DESC
LIMIT 1;

--Most_pop-Nashville-Davidson-Murfreesboro-Franklin, TN - 1,830,410

SELECT cbsaname, SUM(population) AS population_sum
FROM cbsa
LEFT JOIN fips_county
USING(fipscounty)
LEFT JOIN population
USING(fipscounty)
WHERE population IS NOT NULL
GROUP BY cbsaname 
ORDER BY population_sum ASC
LIMIT 1;

--Least_pop-Morristown,TN-116,352

--C

SELECT county, SUM(population) AS population_sum
FROM population 
LEFT JOIN fips_county
USING(fipscounty)
WHERE population IS NOT NULL
GROUP BY county
ORDER BY population_sum DESC
LIMIT 1;

SELECT county, SUM(population) AS population_sum
FROM population 
LEFT JOIN fips_county
USING(fipscounty)
LEFT JOIN cbsa
USING(fipscounty)
WHERE population IS NOT NULL
AND cbsa IS NULL
GROUP BY county
ORDER BY population_sum DESC
LIMIT 1;

--Sevier-95,523

--Q6

--A








