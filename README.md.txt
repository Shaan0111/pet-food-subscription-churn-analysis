

# Pet Food Subscription Churn & Revenue Analysis

## Introduction

In subscription-based businesses, growth is not just about acquiring customers—it’s about retaining them. This project analyzes a pet food subscription model to understand customer behavior, identify churn patterns, and evaluate revenue performance.

The goal is simple:
Why are customers leaving, and how can the business improve retention?

---

## Purpose

This project aims to:

* Analyze customer churn and retention
* Understand customer behavior and engagement
* Evaluate product performance (recipes)
* Measure the impact of churn on revenue
* Provide actionable business insights

---

## Dataset

The dataset used in this project is available here:

👉 [https://docs.google.com/spreadsheets/d/1cF8Wvivlx6WxGo2esc_YDXLtIgrRrwN4/edit?usp=sharing&ouid=117840103703193638205&rtpof=true&sd=true](https://docs.google.com/spreadsheets/d/1cF8Wvivlx6WxGo2esc_YDXLtIgrRrwN4/edit?usp=sharing&ouid=117840103703193638205&rtpof=true&sd=true)

It contains customer-level and order-level data used for churn, revenue, and behavioral analysis.

---

## Dataset Overview

* Total Customers: 200
* Total Orders: 575
* Business Model: Subscription-based pet food delivery

---

## Key Findings

### 1. High Churn Rate

* Churn Rate: ~98%
* Active Customers: 3
* Churned Customers: 197

This indicates a serious retention problem.

---

### 2. Revenue vs Churn Impact

* Total Revenue: ₹594,491
* Revenue loss is significant across segments:

  * Dog Customers: ₹296,601
  * Cat Customers: ₹274,064

The business generates strong initial revenue but fails to retain customers.

---

### 3. Customer Behavior

* Average Orders per Customer: ~3
* Customers churn:

  * Early (1–2 orders): 96 customers
  * Later (>2 orders): 101 customers

Churn occurs across the entire customer lifecycle.

---

### 4. Spending and Retention

* Active Customers Average Spend: ₹7,942
* Churned Customers Average Spend: ₹2,896

Higher spending is strongly associated with better retention.

---

### 5. Revenue Concentration

* High Value Customers: ₹507,124
* Low Value Customers: ₹85,367
* Medium Value Customers: ₹2,000

A small group of customers contributes the majority of revenue.

---

### 6. Product (Recipe) Insights

* Highest Churn: Beef (149 customers)
* Highest Revenue: Beef (₹163,176)
* Lowest Retention: Beef and Chicken

Customers prefer the Beef recipe initially, but it does not sustain long-term satisfaction.

---

### 7. Quantity Impact

Churn remains above 96% across all order quantities.

Order quantity does not significantly influence retention.

---

### 8. Average Order Value

* Average Order Value: ₹1033

Pricing appears reasonable; the issue lies elsewhere.

---

## Overall Insight

Customers are willing to try the product but do not continue using it.
The problem is not pricing or order quantity—it is product experience and long-term satisfaction.

---

## Business Recommendations

### Improve Product Quality

* Rework Beef and Chicken recipes
* Collect customer feedback
* Offer greater variety

### Enhance Onboarding Experience

* Introduce trial packs
* Improve first-time user experience
* Provide clear product guidance

### Retain High-Value Customers

* Implement loyalty programs
* Offer personalized incentives
* Prioritize engagement with high-value users

### Convert Low-Value Customers

* Offer discounts and bundles
* Run targeted engagement campaigns
* Improve early-stage customer experience

---

## How to Use This Project

1. Load the dataset from the link provided
2. Import data into SQL (PostgreSQL or MySQL)
3. Run queries from `pet_food_analysis.sql`
4. Analyze results and insights
5. (Optional) Build dashboards using Power BI or Tableau

---

## Conclusion

This project highlights a critical business challenge: high customer acquisition but very low retention.

While customers show initial interest, they do not continue long-term. The key to growth lies in improving product satisfaction and overall customer experience rather than focusing only on acquiring new users.

---

## Final Thought

Customers do not leave because of price.
They leave because the product does not become part of their routine.
