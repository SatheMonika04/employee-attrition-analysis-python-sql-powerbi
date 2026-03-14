# 📊 HR Attrition Analysis Dashboard

> **Identifying workforce segments at risk of turnover using Python, SQL, and Power BI**

---

## 🧾 Overview

Employee attrition is one of the most critical challenges HR teams face. This project analyzes attrition patterns across an organization to help HR professionals understand **which employee groups are most likely to leave — and why**.

By combining exploratory data analysis, SQL-based feature engineering, and interactive Power BI dashboards, this project delivers actionable insights to support data-driven retention strategies.

---

## 🛠️ Tools & Technologies

| Layer | Tools |
|---|---|
| Data Analysis & EDA | Python (Pandas, NumPy, Seaborn), Jupyter Notebook |
| Data Modeling | SQL Server |
| Visualization | Power BI |

---

## 🔄 Project Workflow

### 1. 🐍 Data Cleaning & Exploratory Data Analysis (Python)

The raw dataset was analyzed and cleaned in a Jupyter Notebook before any modeling.

**Steps performed:**
- Removed irrelevant or redundant columns
- Identified and handled missing values
- Detected outliers using boxplots
- Explored distributions of income, age, and tenure
- Analyzed workforce composition by department

**Key observations:**
- Monthly income distribution is right-skewed — a small group earns significantly more
- Most employees have relatively low tenure, suggesting early-stage workforce
- Workforce is concentrated in a few specific departments

---

### 2. 🗄️ Feature Engineering & Data Modeling (SQL)

The cleaned dataset was imported into SQL Server to create structured analytical features.

**Key transformations:**
- `AttritionFlag` — binary label: `1` = left, `0` = stayed
- `AgeGroup` — bucketed age segments for demographic analysis
- `IncomeQuartile` — quartile segmentation using `NTILE(4)`
- `TenureBand` — tenure ranges (e.g., 0–2 yrs, 3–5 yrs, 6–10 yrs, 10+)
- Aggregated attrition metrics — pre-built summary tables for efficient reporting

These transformations prepared a clean, analysis-ready dataset for Power BI.

---

### 3. 📈 Data Visualization (Power BI)

An interactive Power BI dashboard was built on top of the SQL-modeled data to surface attrition trends clearly.

**Core KPIs:**

| Metric | Description |
|---|---|
| Total Employees | Headcount across the organization |
| Total Leavers | Employees who have left |
| Attrition Rate | % of workforce that departed |

**Main Visualizations:**
- Attrition by Department
- Attrition by Tenure Band
- Attrition by Income Band
- Overtime vs. Attrition comparison
- Risk Segmentation Matrix

**Interactive Slicers (Filters):**
Department · Age Group · Income Band · Tenure Band · Overtime Status

---

## 💡 Key Insights

1. **Early-tenure employees churn most** — Employees with 0–5 years of tenure show the highest attrition rates, suggesting early-career retention is a key challenge.

2. **Overtime is a red flag** — Employees who regularly work overtime tend to leave more frequently, pointing to potential workload-driven burnout or dissatisfaction.

3. **Compensation matters** — Attrition is slightly higher among lower income quartiles, suggesting that pay competitiveness may influence an employee's decision to stay.

4. **Departmental differences exist** — Certain departments consistently show higher attrition, which may reflect differences in management style, workload, or culture.

---

## 📸 Dashboard Preview

> *Screenshot coming soon — add your Power BI dashboard image here.*

```
[ Insert Dashboard Screenshot ]
```

---

## 🚀 Future Improvements

- 🤖 Build a **machine learning attrition prediction model** (e.g., logistic regression, random forest)
- 🔍 Perform **deeper workforce segmentation** using clustering techniques
- 📋 Incorporate **employee satisfaction scores** and engagement survey data
- 🔗 Connect the dashboard to a **live data source** for real-time monitoring

---

## 📁 Repository Structure

```
hr-attrition-analysis/
│
├── data/                  # Raw and cleaned datasets
├── notebooks/             # Jupyter Notebooks for EDA
├── sql/                   # SQL scripts for feature engineering
├── dashboard/             # Power BI (.pbix) file
└── README.md
```

---

## 📬 Contact

Feel free to reach out or raise an issue if you have questions or suggestions!

---

*Built with ❤️ using Python · SQL · Power BI*
