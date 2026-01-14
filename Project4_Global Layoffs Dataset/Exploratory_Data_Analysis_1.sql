-- Exploratory Data Analysis (EDA)
-- Review the full dataset structure and contents
SELECT *
FROM layoffs_staging2;


-- Identify the maximum values for total layoffs and layoff percentages
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;


-- Identify companies that experienced complete workforce layoffs (100%)
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1;


-- Analyze companies with 100% layoffs, ordered by total number of employees laid off
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;


-- Analyze companies with 100% layoffs, ordered by funds raised (in millions)
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


-- Aggregate total layoffs by company to identify the most impacted organizations
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


-- Identify the overall date range covered in the dataset
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;


-- Analyze total layoffs by industry to determine which sectors were most impacted
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;


-- Calculate each company's contribution to overall layoffs as a percentage
SELECT 
    company,
    SUM(total_laid_off) AS total_layoffs,
    ROUND(
        SUM(total_laid_off) / (SELECT SUM(total_laid_off) FROM layoffs_staging2) * 100, 2
    ) AS layoff_percentage
FROM layoffs_staging2
GROUP BY company
ORDER BY total_layoffs DESC;


-- Analyze layoffs by country to assess geographic impact
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;


-- Aggregate layoffs by date to identify peak layoff periods
SELECT `date`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `date`
ORDER BY 2 DESC;


-- Aggregate layoffs by date, ordered chronologically
SELECT `date`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `date`
ORDER BY 1 DESC;


-- Analyze layoffs by year to understand annual trends
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;


-- Explore layoffs by month name (categorical view)
SELECT MONTHNAME(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY MONTHNAME(`date`)
ORDER BY 1 DESC;


-- Explore layoffs by month name in ascending order
SELECT MONTHNAME(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY MONTHNAME(`date`)
ORDER BY 1 ASC;


-- Explore layoffs by numeric month to support time-series analysis
SELECT MONTH(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY MONTH(`date`)
ORDER BY 1 ASC;


-- Analyze layoffs by company stage (e.g., startup, growth, post-IPO)
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 1 DESC;


-- Aggregate layoff percentages by company (note: useful for directional insight)
SELECT company, SUM(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 1 DESC;


-- Initial monthly aggregation using month only (not year-specific; limited analytical value)
SELECT SUBSTRING(`date`, 6, 2) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `MONTH`;


-- Improved monthly aggregation using year-month format for accurate time-series analysis
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;


-- Compute rolling total of layoffs over time (cumulative analysis)
WITH Rolling_total AS 
(
    SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, 
           SUM(total_laid_off) AS total_off
    FROM layoffs_staging2
    WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
    GROUP BY `MONTH`
)
SELECT `MONTH`, 
       SUM(total_off) OVER (ORDER BY `MONTH`) AS rolling_total
FROM Rolling_total;


-- Enhanced rolling total output showing both monthly and cumulative layoffs
WITH Rolling_total AS 
(
    SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, 
           SUM(total_laid_off) AS total_off
    FROM layoffs_staging2
    WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
    GROUP BY `MONTH`
)
SELECT `MONTH`, 
       total_off, 
       SUM(total_off) OVER (ORDER BY `MONTH`) AS rolling_total
FROM Rolling_total;


-- Aggregate layoffs by company (revalidation query)
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


-- Analyze company-level layoffs by year
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY company ASC;


-- Aggregate layoffs by company and formatted year-month
SELECT company, DATE_FORMAT(`date`, '%Y-%m') AS month,
       SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, `date`;


-- Identify companies with the highest layoffs by year
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;


-- Create a company-year summary table for ranking analysis
WITH Company_Year (company, years, total_laid_off) AS 
(
    SELECT company, YEAR(`date`), SUM(total_laid_off)
    FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
)
SELECT *
FROM Company_Year;


-- Rank companies by total layoffs within each year using DENSE_RANK
WITH Company_Year (company, years, total_laid_off) AS 
(
    SELECT company, YEAR(`date`), SUM(total_laid_off)
    FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
)
SELECT *, 
       DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
WHERE years IS NOT NULL;


-- Rank companies by layoffs per year and order by ranking
WITH Company_Year (company, years, total_laid_off) AS 
(
    SELECT company, YEAR(`date`), SUM(total_laid_off)
    FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
)
SELECT *, 
       DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY ranking ASC;


-- Retrieve top 5 companies with the highest layoffs per year
WITH Company_Year (company, years, total_laid_off) AS 
(
    SELECT company, YEAR(`date`), SUM(total_laid_off)
    FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
), 
Company_Year_Rank AS
(
    SELECT *, 
           DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
    FROM Company_Year
    WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE ranking <= 5;
