select * from layoffs;
-- DATA CLEANING PRACTICE --
-- 1. REMOVE DUPLICATES
-- 2. STANDARDIZE THE DATA
-- 3. NULL VALUES OR BLANK VALUES
-- 4. REMOVE ROWS AND COLUMNS


CREATE TABLE layoffs02 LIKE layoffs;  -- creat the head
select * from layoffs02;            
INSERT layoffs02 SELECT * FROM layoffs;       -- import data

select * from layoffs02;   

-- select company, location, industry, total_laid_off, percentage_laid_off,`date`,stage,country,funds_raised_millions, COUNT(*) FROM layoffs02 
-- GROUP BY company, location, industry, total_laid_off, percentage_laid_off,`date`,stage,country,funds_raised_millions HAVING COUNT(*) > 1;






-- 1. REMOVE DUPLICATES

-- SELECT *,
-- ROW_NUMBER() OVER(
-- PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
-- FROM layoffs02;

WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs02
)
SELECT * FROM duplicate_cte WHERE row_num > 1; 



SELECT * FROM layoffs02 WHERE company = 'Casper';   -- for double checking
DELETE FROM layoffs02 WHERE  row_num >1; 

-- AGAIN CREATE A NEW TABLE 

CREATE TABLE `layoffs03` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- INSERT DATA FROM LAYOFFS02 TABLE 
insert into layoffs03
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs02;


SELECT * FROM layoffs03 WHERE row_num >1;   -- CHECK DUPLICATE ROWS

DELETE FROM layoffs03 WHERE  row_num >1;    -- DELETE CUPLICATE ROWS

SELECT * FROM layoffs03;



-- 02 STANDARDIZING DATA --

SELECT company, (TRIM(company)) FROM layoffs03;   -- trim spacing
UPDATE layoffs03 SET company = TRIM(company);     -- upadte table 

SELECT DISTINCT	industry FROM layoffs03 ORDER BY 1;  -- TO LOOK UP THE INDUSTRY COLUMN DATA
SELECT * FROM layoffs03 WHERE industry LIKE 'Crypto%';
UPDATE layoffs03 SET industry = 'Crypto' WHERE industry LIKE 'Crypto%';

SELECT DISTINCT	country, TRIM(TRAILING '.' FROM country)  FROM layoffs03 ORDER BY 1;
UPDATE layoffs03 SET country = TRIM(TRAILING '.' FROM country) WHERE country LIKE 'United States%';


SELECT 	`date`,
STR_TO_DATE(`date`, '%m/%d/%Y') FROM layoffs03;

UPDATE layoffs03 SET `date` =  STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs03 MODIFY COLUMN `date` DATE;




DELETE FROM layoffs03 WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs03 DROP COLUMN row_num;






