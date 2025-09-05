# ML2-TelecomChurnCaseStudy

## 📊 Telecom Churn Prediction Project

In the competitive telecom industry, customer churn—where users switch from one service provider to another—is a major concern, with annual rates ranging from 15–25%. Since acquiring new customers costs 5–10 times more than retaining existing ones, telecom firms prioritize customer retention, especially among high-value users who contribute disproportionately to revenue.

This project focuses on predicting churn among prepaid customers in the Indian and Southeast Asian markets, where prepaid models dominate. Unlike postpaid users who formally terminate services, prepaid users may silently stop usage, making churn harder to detect. Therefore, a **usage-based definition** of churn is adopted: customers who show zero activity (calls or mobile internet) in the final month are tagged as churners.

The dataset spans four months—June to September—encoded as months 6 to 9. The customer lifecycle is segmented into:
- **Good phase (months 6 & 7)**: Normal usage
- **Action phase (month 8)**: Behavioral changes due to dissatisfaction or competitor offers
- **Churn phase (month 9)**: No usage, indicating churn

The business objective is to predict churn in month 9 using data from months 6–8. High-value customers are defined as those whose average recharge in the good phase is above the 70th percentile. After filtering, the dataset contains ~29.9k high-value users.

### 🔧 Data Preparation Steps
1. **Feature Engineering**: Derive new features using domain knowledge to enhance model performance.
2. **High-Value Filtering**: Select users based on recharge thresholds.
3. **Churn Tagging**: Label churners using zero usage indicators and remove churn-phase attributes.

### 🤖 Modeling Strategy
Two models are built:
- **Predictive Model**: Uses PCA for dimensionality reduction followed by classification algorithms to predict churn. Due to class imbalance (5–10% churn rate), techniques like resampling or weighted loss functions are applied. Evaluation metrics prioritize identifying churners accurately.
- **Interpretive Model**: A logistic regression or tree-based model is used to identify key churn predictors. This model avoids PCA to retain interpretability and handles multicollinearity.

### 📈 Insights & Recommendations
Important predictors identified from the interpretive model help explain churn behavior. Visualizations such as bar charts or feature importance plots are used to communicate findings. Based on these insights, strategies like targeted offers, service quality improvements, and proactive engagement can be recommended to reduce churn.

All analysis, modeling, and visualizations are to be compiled into a single Jupyter notebook for submission.


<p align="center">
  <img src="ML2-TelecomChurnCaseStudy.png" alt="Problem Statement" width="700">
</p>
<p align="center">
  <img src="ML2-TelecomChurnCaseStudy2.png" alt="Problem Statement" width="700">
</p>

- Download Data Set : https://drive.google.com/file/d/1SWnADIda31mVFevFcfkGtcgBHTKKI94J/view?usp=sharing
