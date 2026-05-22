/* =========================================================
   DATA CLEANING WORKFLOW – LAYOFFS DATASET
   Objective:
   - Create a clean, analysis-ready dataset
   - Preserve original raw data
   ========================================================= */


/* ---------------------------------------------------------
   Initial Data Inspection
   --------------------------------------------------------- */
SELECT *
FROM layoffs;

/* =========================================================
   DATA CLEANING PLAN
   1. Remove duplicate records
   2. Standardize text-based fields
   3. Handle NULL and blank values
   4. Remove unnecessary columns
   ========================================================= */

/* ---------------------------------------------------------
   Create a staging copy of the raw table
   (Best practice: never modify raw data directly)
   --------------------------------------------------------- */
CREATE TABLE layoffs_staging
like layoffs;

--- Verify staging table structure (should be empty initially)
SELECT * 
FROM layoffs_staging;

--- Populate staging table with raw data
INSERT layoffs_staging
SELECT *
FROM layoffs;

/* ---------------------------------------------------------
   Identify potential duplicate records
   (Initial attempt using a limited set of columns)
   --------------------------------------------------------- */
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

what this code does?
SELECT * 
FROM layoffs_staging;
whats does this sql do

This SQL statement simply retrieves and displays data from a table. Let’s break it down clearly 

SELECT * 
FROM layoffs_staging;
What each part means
SELECT
Tells the database you want to read data.

* (asterisk)
Means all columns in the table.
👉 If the table has 10 columns, all 10 will be returned.

FROM layoffs_staging
Specifies the table name the data is coming from.

What this query does overall
✅ Returns every row and every column from the table called layoffs_staging.

In plain English:

“Show me everything stored in the layoffs_staging table.”

Common use cases
Inspecting raw data after loading it

Verifying a staging table during data cleaning

Quickly checking if data exists in a table

Practical example
If layoffs_staging contains:

company	industry	total_laid_off	date
Meta	Tech	11000	2023
This query will return all of that information.

Best practice tip ⚠️
On large tables, SELECT * can be slow and inefficient. It’s often better to specify columns:

SELECT company, total_laid_off
FROM layoffs_staging;
If you want, I can also explain:

How to filter rows (WHERE)

How to limit results (LIMIT)

How to sort data (ORDER BY)

Why this is often used in data cleaning pipelines

Just tell me 👍

You said:

what these commands all do 
ChatGPT said:
I just need a tiny bit of clarification 👍

When you say “what these commands all do”, do you mean:

The parts of this query specifically?

SELECT *
FROM layoffs_staging;
(i.e., SELECT, *, FROM, table name)

or

A group of SQL commands you’re using in your data-cleaning work (for example: SELECT, WHERE, ORDER BY, LIMIT, DISTINCT, etc.)?

If you meant the parts of the query you already shared, here’s a clear breakdown:
SELECT * 
FROM layoffs_staging;
Command	What it does
SELECT	Tells the database you want to retrieve (read) data
*	Means all columns in the table
FROM	Specifies which table the data comes from
layoffs_staging	The table name being queried
👉 Overall meaning:

“Show me every column and every row in the layoffs_staging table.”

If you meant multiple SQL commands, paste them here (or a screenshot), and I’ll explain each one line-by-line, especially in the context of data cleaning and analysis, which I know you’re working on.
Just send the commands 👌

You said:
INSERT layoffs_staging
SELECT *
FROM layoffs;
ChatGPT said:
Here’s exactly what each part of this SQL does, step by step 👇

INSERT layoffs_staging
SELECT *
FROM layoffs;
What this command does (in plain English)
👉 Copies all rows and all columns from the layoffs table into the layoffs_staging table.

This is very common in data cleaning workflows.

Breakdown of each command
1️⃣ INSERT layoffs_staging
Tells the database you want to add (insert) data into the table called layoffs_staging.

This table is usually a staging or working copy.

2️⃣ SELECT *
Selects all columns from the source table.

The column order must match the destination table.

3️⃣ FROM layoffs
Specifies the source table.

Data is being copied from layoffs → layoffs_staging.

Visual flow
layoffs  ───────────▶  layoffs_staging
        (all rows & columns)
Why this is commonly used
✔ Create a safe copy of raw data
✔ Perform data cleaning without touching original data
✔ Prepare data for transformations (removing duplicates, trimming text, fixing dates, etc.)

⚠️ Important things to watch out for
Column structure must match
Same number of columns

Same order

Compatible data types

Otherwise, you’ll get an error.

Duplicate data risk 🚨
If you run this command more than once, you’ll insert duplicates.

Safer approach:

INSERT INTO layoffs_staging
SELECT *
FROM layoffs
WHERE NOT EXISTS (
    SELECT 1
    FROM layoffs_staging
);
(or truncate the staging table first)

Best practice (recommended)
TRUNCATE TABLE layoffs_staging;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;
This ensures a clean, fresh copy every time.

If you want, I can next explain:

How to remove duplicates

How to standardize columns

How to clean dates

How to compare source vs staging

Just tell me what step you’re on next 👍

You said:
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, date) AS row_num
FROM layoffs_staging;
ChatGPT said:
Great question — this is a very important query for data cleaning. Let’s walk through it slowly and clearly 👇

SELECT *, 
ROW_NUMBER() OVER(
    PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`
) AS row_num
FROM layoffs_staging;
What this query does (big picture)
👉 It adds a row number to each row
👉 The numbering restarts for each group of duplicate records
👉 This helps you identify duplicate rows in layoffs_staging

Step-by-step breakdown
1️⃣ SELECT *
Selects all columns from the table.

2️⃣ ROW_NUMBER()
A window function that assigns a sequential number to rows.

Starts at 1, then 2, 3, …

3️⃣ OVER ( ... )
Defines how the row numbers are calculated.

4️⃣ PARTITION BY company, industry, total_laid_off, percentage_laid_off, date
Groups rows that have the same values in these columns.

Each group is treated as a separate partition.

Inside each partition, row numbers restart at 1.

👉 If two or more rows have the same:

company

industry

total_laid_off

percentage_laid_off

date

They are considered duplicates.

5️⃣ AS row_num
Names the new calculated column row_num.

Example (simplified)
Original data
company	industry	total_laid_off	%	date
Meta	Tech	11000	0.13	2023-01-01
Meta	Tech	11000	0.13	2023-01-01
Amazon	Tech	18000	0.06	2023-01-02
Result of your query
company	industry	total_laid_off	%	date	row_num
Meta	Tech	11000	0.13	2023-01-01	1
Meta	Tech	11000	0.13	2023-01-01	2
Amazon	Tech	18000	0.06	2023-01-02	1
How this is used in practice 🔧
Identify duplicates
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`
           ) AS row_num
    FROM layoffs_staging
) t
WHERE row_num > 1;
Delete duplicates (common next step)
DELETE
FROM layoffs_staging
WHERE (company, industry, total_laid_off, percentage_laid_off, `date`) IN (
    SELECT company, industry, total_laid_off, percentage_laid_off, `date`
    FROM (
        SELECT *,
               ROW_NUMBER() OVER(
                   PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`
               ) AS row_num
        FROM layoffs_staging
    ) t
    WHERE row_num > 1
);
Why this query is powerful
✔ Finds hidden duplicates
✔ Non-destructive (just viewing data)
✔ Industry-standard data cleaning approach
✔ Much safer than DISTINCT

If you want, next I can explain:

Why ROW_NUMBER() is better than COUNT(*)

How to keep the latest row using ORDER BY

How this differs from RANK() and DENSE_RANK()

How to permanently remove duplicates safely

Just tell me 👍

You said:
--- Data cleaning
SELECT *
FROM layoffs;
--- 1. Remove Duplicates
--- 2. Standadize the Data
--- 3. Null value or Blank values
--- 4. Remove Any Column

/* Creation of a copy of table to be worked on */
CREATE TABLE layoffs_staging
like layoffs;

--- checking for data in the layoffs_staging table
SELECT * 
FROM layoffs_staging;

--- Adding a database to the layoffs_staging
INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, date) AS row_num
FROM layoffs_staging;


WITH duplicate_cte AS 
(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, date) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

--- After running this query, we noticed it captured rows that were not really duplicates
SELECT * 
FROM layoffs_staging
WHERE company = "Oda";

--- Repeating to capture real duplicates
WITH duplicate_cte AS 
(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, date, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT * 
FROM layoffs_staging
WHERE company = "Casper";


WITH duplicate_cte AS 
(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, date, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE layoffs_staging2 (
  company text,
  location text,
  industry text,
  total_laid_off int DEFAULT NULL,
  percentage_laid_off text,
  date text,
  stage text,
  country text,
  funds_raised_millions int DEFAULT NULL,
  row_num INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, date, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT * 
FROM layoffs_staging2;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

--- Standadizing data
 SELECT company, TRIM(company)
 FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2;

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';


UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry
FROM layoffs_staging2;

--- focusing location
SELECT DISTINCT location
FROM layoffs_staging2;

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

--- For country
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;




SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%'
ORDER BY 1;

--- trim only could not fix the '.' issue
SELECT DISTINCT country, TRIM(country)
FROM layoffs_staging2
ORDER BY 1;

--- trying to fix issue
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

--- confirm if the 'United states.' is fixed
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

--- Working on the "Time Series"
SELECT *
FROM layoffs_staging2;

--- Changing date from text to real date. The syntax '%m/%d/%Y' is key sensitive.
SELECT date,
STR_TO_DATE(date, '%m/%d/%Y' )
FROM layoffs_staging2;


--- Updating the'date' information into the database
UPDATE layoffs_staging2
SET date = STR_TO_DATE(date, '%m/%d/%Y');

--- Checking if the update command worked
SELECT date
FROM layoffs_staging2;

--- After funning the above command, by updating the4 date, the date format 
--- remians "Text". we want to change that by running the below query
ALTER TABLE layoffs_staging2
MODIFY COLUMN date DATE;


--- validating our table
SELECT *
FROM layoffs_staging2;

--- Cleaning "Null" and "blank data"
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL;

--- locating cells having Null in them for total_laid_of and percentage..
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

--- data checking
SELECT DISTINCT industry 
FROM layoffs_staging2;

--- CHECKING for blanks or the Null
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';


--- serching for the one that has higher population
SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

--- updating role with 'travel'
SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

--- IT DID NOT WORK FOR THE EMPTY OR BLANKS
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry =t2.industry
WHERE (t1.industry IS NULL OR t1.industry ='')
AND t2.industry IS NOT NULL;


--- changing the blanks into null (ficus is to change the nulls into being filled
UPDATE layoffs_staging2
SET industry = null
WHERE industry ='';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry =t2.industry
WHERE (t1.industry IS NULL OR t1.industry ='')
AND t2.industry IS NOT NULL;

--- checking to see if worked
SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

--- we have null in the "bally's interactions" 
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry ='';

--- fixing null in the bally interaction
SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

--- Checking th4e final edited value
SELECT *
FROM layoffs_staging2;

--- we still see null but pretty difficult to populate
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

--- Delete roll
DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


--- Getting rid of a column "row_num" 
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

--- checking to confirm if column is deleted
SELECT *
FROM layoffs_staging2;

rephrase my comments in a professional way. even add comements where needed that i ignored
ChatGPT said:
Below is your same SQL workflow, but with the comments rewritten professionally, clarified, and with additional comments added where steps were implied or important but not explicitly explained.
I did not change your logic — only improved clarity, consistency, and documentation quality (as you’d expect in a portfolio or GitHub project).

/* =========================================================
   DATA CLEANING WORKFLOW – LAYOFFS DATASET
   Objective:
   - Create a clean, analysis-ready dataset
   - Preserve original raw data
   ========================================================= */

/* ---------------------------------------------------------
   Initial Data Inspection
   --------------------------------------------------------- */
SELECT *
FROM layoffs;


/* =========================================================
   DATA CLEANING PLAN
   1. Remove duplicate records
   2. Standardize text-based fields
   3. Handle NULL and blank values
   4. Remove unnecessary columns
   ========================================================= */


/* ---------------------------------------------------------
   Create a staging copy of the raw table
   (Best practice: never modify raw data directly)
   --------------------------------------------------------- */
CREATE TABLE layoffs_staging
LIKE layoffs;


/* ---------------------------------------------------------
   Verify staging table structure (should be empty initially)
   --------------------------------------------------------- */
SELECT *
FROM layoffs_staging;


/* ---------------------------------------------------------
   Populate staging table with raw data
   --------------------------------------------------------- */
INSERT INTO layoffs_staging
SELECT *
FROM layoffs;


/* ---------------------------------------------------------
   Identify potential duplicate records
   (Initial attempt using a limited set of columns)
   --------------------------------------------------------- */
SELECT *, 
ROW_NUMBER() OVER (
    PARTITION BY company, industry, total_laid_off, 
                 percentage_laid_off, `date`
) AS row_num
FROM layoffs_staging;


/* ---------------------------------------------------------
   Use a CTE to isolate duplicate rows
   --------------------------------------------------------- */
WITH duplicate_cte AS 
(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

/* ---------------------------------------------------------
   Manual inspection revealed false positives
   Example: Oda records were not true duplicates
   --------------------------------------------------------- */
--- After running this query, we noticed it captured rows that were not really duplicates
SELECT * 
FROM layoffs_staging
WHERE company = "Oda";

/* ---------------------------------------------------------
   Refine duplicate detection using all relevant columns
   --------------------------------------------------------- */
--- Repeating to capture real duplicates
WITH duplicate_cte AS 
(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;


/* ---------------------------------------------------------
   Manual validation of confirmed duplicates
   --------------------------------------------------------- */
SELECT * 
FROM layoffs_staging
WHERE company = "Casper";


/* ---------------------------------------------------------
   MySQL does not allow DELETE directly from a CTE.
   Create a second staging table to safely remove duplicates.
   --------------------------------------------------------- */
WITH duplicate_cte AS 
(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


/* ---------------------------------------------------------
   Populate second staging table with row numbers
   --------------------------------------------------------- */
SELECT * 
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT * 
FROM layoffs_staging2;


/* ---------------------------------------------------------
   Remove duplicate rows (retain first occurrence only)
   --------------------------------------------------------- */
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

 SELECT company, TRIM(company)
 FROM layoffs_staging2;

/* =========================================================
   DATA STANDARDIZATION
   ========================================================= */

/* ---------------------------------------------------------
   Trim extra spaces from company names
   --------------------------------------------------------- */
UPDATE layoffs_staging2
SET company = TRIM(company);


/* ---------------------------------------------------------
   Review industry values for inconsistencies
   --------------------------------------------------------- */
SELECT DISTINCT industry
FROM layoffs_staging2;

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

/* ---------------------------------------------------------
   Standardize Crypto-related industry labels
   --------------------------------------------------------- */
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry
FROM layoffs_staging2;

--- focusing location
SELECT DISTINCT location
FROM layoffs_staging2;

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;
/* ---------------------------------------------------------
   Review and standardize country names
   --------------------------------------------------------- */
--- For country
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;


/* ---------------------------------------------------------
   Remove trailing punctuation from country values
   (e.g., "United States.")
   --------------------------------------------------------- */
SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%'
ORDER BY 1;

--- trim only could not fix the '.' issue
SELECT DISTINCT country, TRIM(country)
FROM layoffs_staging2
ORDER BY 1;

--- trying to fix issue
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

/* ---------------------------------------------------------
   Remove trailing punctuation from country values
   (e.g., "United States.")
   --------------------------------------------------------- */
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

--- confirm if the 'United states.' is fixed
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

--- Working on the "Time Series"
SELECT *
FROM layoffs_staging2;

--- Changing `date` from text to `real date`. The syntax '%m/%d/%Y' is key sensitive.
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y' )
FROM layoffs_staging2;

/* =========================================================
   DATE CONVERSION (Time-Series Preparation)
   ========================================================= */
/* ---------------------------------------------------------
   Convert date from TEXT to proper DATE format
   --------------------------------------------------------- */
--- Updating the'date' information into the database
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

--- Checking if the update command worked
SELECT `date`
FROM layoffs_staging2;

/* ---------------------------------------------------------
   Change column data type to DATE
   --------------------------------------------------------- */
--- After funning the above command, by updating the4 date, the date format 
--- remians "Text". we want to change that by running the below query
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


--- validating our table
SELECT *
FROM layoffs_staging2;

--- Cleaning "Null" and "blank data"
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL;


/* =========================================================
   NULL AND BLANK VALUE HANDLING
   ========================================================= */

/* ---------------------------------------------------------
   Identify records with missing layoff metrics
   --------------------------------------------------------- */
--- locating cells having Null in them for total_laid_of and percentage..
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

--- data checking
SELECT DISTINCT industry 
FROM layoffs_staging2;

/* ---------------------------------------------------------
   Identify blank or NULL industry values
   --------------------------------------------------------- */
--- CHECKING for blanks or the Null
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';


--- serching for the one that has higher population
SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

--- updating role with 'travel'
SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


/* ---------------------------------------------------------
   Populate missing industry values using self-join
   Assumption: Same company + location implies same industry
   --------------------------------------------------------- */
SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

/* ---------------------------------------------------------
   Populate missing industry values using self-join
   Assumption: Same company + location implies same industry
   --------------------------------------------------------- */
--- IT DID NOT WORK FOR THE EMPTY OR BLANKS
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry =t2.industry
WHERE (t1.industry IS NULL OR t1.industry ='')
AND t2.industry IS NOT NULL;


--- changing the blanks into null (ficus is to change the nulls into being filled
UPDATE layoffs_staging2
SET industry = null
WHERE industry ='';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry =t2.industry
WHERE (t1.industry IS NULL OR t1.industry ='')
AND t2.industry IS NOT NULL;

/* ---------------------------------------------------------
   Validate industry backfill using Airbnb as a test case
   --------------------------------------------------------- */
--- checking to see if worked
SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

--- we have null in the "bally's interactions" 
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry ='';

--- fixing null in the bally interaction
SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

--- Checking th4e final edited value
SELECT *
FROM layoffs_staging2;

--- we still see null but pretty difficult to populate
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


/* ---------------------------------------------------------
   Remove records with no usable layoff information
   --------------------------------------------------------- */
--- Delete roll
DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

/* =========================================================
   FINAL CLEANUP
   ========================================================= */

/* ---------------------------------------------------------
   Remove helper column used for de-duplication
   --------------------------------------------------------- */
--- Getting rid of a column "row_num" 
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

--- checking to confirm if column is deleted
SELECT *
FROM layoffs_staging2;
