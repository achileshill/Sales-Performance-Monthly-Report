# **Sales Performance Monthly Report**

Challenge by [Danny Ma – 8 Week SQL Challenge](https://8weeksqlchallenge.com/case-study-7/?fbclid=IwY2xjawO2tMFleHRuA2FlbQIxMABicmlkETFEWVEwTW82MWlDcHBOMTNGc3J0YwZhcHBfaWQQMjIyMDM5MTc4ODIwMDg5MgABHtEuho4OJcpR-bJxowFT8pyyMatIGvR04bgbOnZqs9twxau0DF8vdhH-BeFd_aem_GJB33sogINro_6JdwUxq6g)

## 📊 **Project Overview**
This project analyzes monthly sales performance using a relational database containing product information and transaction summaries. The goal is to generate insights into revenue, product categories, customer behavior, and financial performance.

The challenge is part of the **8 Week SQL Challenge** series and focuses on building analytical queries to answer business questions related to sales trends and product performance.

---

## 🗄️ **Database Structure**

### **1. `product_details`**
Primary key: `product_id`  
Contains:
- Product name  
- Category  
- Segment  
- Style  
- Price  

### **2. `sales`**
Primary key: `prod_id`  
Contains:
- Transaction summaries  
- Quantity sold  
- Price
- Discount  
- Date and time  

---

All questions can be found in the official challenge link above, or in the `queries.sql` file included in this repository.

---

## 📁 **Repository Contents**
- `queries.sql` — All SQL queries used to answer the challenge questions  
- `sales_summary.md` — Sales and financial summary

---

## 🧠 **Skills Demonstrated**
- SQL querying, subquerying, & data manipulation  
- CTE, Window functions, aggregations, and joins  
- Business intelligence reasoning  
- Financial performance analysis  
- Schema understanding  
- Insight communication through markdown reporting  

---

## 🛠️ **Tools & Technologies**
- SQL (PostgreSQL)
- Markdown for reporting  
- Git & GitHub for version control  

---

## 📈 **Key Insights**
- Strong multi-item baskets (avg 6 products/transaction).
- Members dominate transactions but spend only slightly more.
- Shirts and Jackets are the biggest revenue drivers.
- Socks surprisingly generate high revenue due to volume.
- Men’s category contributes more revenue overall.
- Discounts reduce revenue by ~12%, a significant margin.
- Product penetration is evenly distributed, indicating a balanced product mix.

 

---
