# Exploratory SQL Data Analysis – Global Layoffs Dataset

## 📌 Project Overview
This project performs an exploratory data analysis (EDA) on a global layoffs dataset using SQL.  
The objective is to uncover trends, patterns, and insights related to workforce reductions across companies, industries, countries, and time periods.

The analysis focuses on understanding:
- Which companies and industries were most impacted
- How layoffs evolved over time
- Geographic and funding-related patterns
- Year-over-year and month-over-month trends

---

## 🎯 Problem Statement
Mass layoffs have become a recurring global phenomenon, particularly in technology and venture-backed industries.  
However, raw datasets alone do not clearly explain:
- Who was affected the most
- When layoffs peaked
- Which sectors and regions were disproportionately impacted

This project transforms raw layoff data into **actionable analytical insights** using SQL.

---

## 💡 Solution Approach
Using structured SQL queries, the project:
- Aggregates layoffs by company, industry, country, and stage
- Analyzes temporal trends by year and month
- Identifies peak layoff periods
- Ranks companies by layoffs within each year
- Calculates rolling (cumulative) layoff totals

Window functions (`DENSE_RANK`, `SUM() OVER`) and Common Table Expressions (CTEs) are used extensively to support advanced analytical queries.

---

## 🔍 Key Analyses Performed
- Total layoffs by company, industry, and country
- Companies with 100% workforce layoffs
- Layoff trends by year and month
- Rolling cumulative layoffs over time
- Top 5 companies by layoffs per year
- Industry and company-stage impact analysis

---

## 🧠 Why This Project Matters
This project demonstrates how SQL can be used not just for querying data, but for **real-world exploratory analysis**, similar to what data analysts and BI professionals perform in production environments.

It highlights:
- Analytical thinking
- Time-series analysis
- Ranking and trend detection
- Clean, readable SQL practices

---

## ⭐ What Makes This Project Unique
- Focuses on **exploration**, not just reporting
- Uses **window functions and CTEs** for advanced insights
- Demonstrates multiple analytical perspectives (company, industry, geography, time)
- Structured in a way that mirrors real business analytics workflows

---

## 🛠️ Tools & Technologies
- SQL (MySQL)
- Window Functions
- Common Table Expressions (CTEs)
- Exploratory Data Analysis (EDA)

---

## 🚀 Future Enhancements
- Visualization using Power BI or Tableau
- Industry-specific trend comparisons
- Predictive analysis using Python
- Integration with macroeconomic indicators

---

## 📫 Author
**Daniel Dadzie Appiah**  
Data & Analytics | SQL | Exploratory Analysis  

