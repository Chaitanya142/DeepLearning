# ML1 - Lead Scoring
LEAD SCORING CASE STUDY

# X Education Lead Conversion Case Study

## Problem Statement

X Education, an education company, sells online courses to industry professionals. Many professionals interested in the courses land on their website and browse for courses. The company markets its courses on several websites and search engines like Google. Once these individuals land on the website, they might browse the courses, fill up a form for the course, or watch some videos. When they fill up a form providing their email address or phone number, they are classified as leads. Additionally, the company also gets leads through past referrals.

Once these leads are acquired, the sales team starts making calls, writing emails, etc. Some of the leads get converted, while most do not. The typical lead conversion rate at X Education is around 30%. Although X Education gets many leads, its lead conversion rate is poor. For instance, if they acquire 100 leads in a day, only about 30 are converted. To make this process more efficient, the company wishes to identify the most potential leads, also known as ‘Hot Leads’. Identifying this set of leads should increase the lead conversion rate, as the sales team will focus more on communicating with potential leads rather than making calls to everyone.

### Lead Conversion Process

The lead conversion process can be represented as a funnel, where a lot of leads are generated in the initial stage (top) but only a few come out as paying customers (bottom). In the middle stage, potential leads need to be nurtured well (i.e., educating the leads about the product, constantly communicating, etc.) to achieve a higher lead conversion rate.

X Education has appointed you to help them select the most promising leads, i.e., the leads most likely to convert into paying customers. The company requires you to build a model to assign a lead score to each lead. Customers with a higher lead score should have a higher conversion chance, while customers with a lower lead score should have a lower conversion chance. The CEO aims for a target lead conversion rate of around 80%.

## Data

You have been provided with a leads dataset from the past with around 9000 data points. This dataset consists of various attributes such as Lead Source, Total Time Spent on Website, Total Visits, Last Activity, etc., which may or may not be useful in deciding whether a lead will be converted or not. The target variable is the column ‘Converted’, which indicates whether a past lead was converted or not, where 1 means it was converted, and 0 means it wasn’t. Further details about the dataset are available in the data dictionary provided in the zip folder at the end of the page.

### Data Handling

Another aspect to consider is the levels present in the categorical variables. Many of the categorical variables have a level called 'Select', which needs to be handled because it is as good as a null value.

## Goals of the Case Study

The goals for this case study are:

1. Build a logistic regression model to assign a lead score between 0 and 100 to each lead. This score can be used by the company to target potential leads. A higher score would indicate a hot lead (most likely to convert), whereas a lower score would indicate a cold lead (less likely to convert).
2. Address additional problems presented by the company that the model should handle if the company's requirements change in the future. These problems are provided in a separate doc file. Fill it based on the logistic regression model you build in the first step and include it in your final presentation where you'll make recommendations.

## Results Expected

You need to submit the following components:

1. **Python Commented File**: A well-commented Jupyter notebook with at least the logistic regression model, conversion predictions, and evaluation metrics. The notebook should include detailed comments and not contain unnecessary code.
2. **Word File**: Answer all the questions asked by the company in the provided word document.
3. **Presentation**: Make a presentation to present your analysis to the chief data scientist of your company, including both technical and business aspects. The presentation should be concise, clear, and to the point. Submit the presentation after converting it into PDF format.
4. **PDF File**: Write a summary report in a word file and submit it as a PDF. The report should be a brief 500-word summary explaining how you proceeded with the assignment and the learnings you gathered.

Download:
Data File: https://learn.upgrad.com/course/5705/segment/53361/326667/989233/4943881
 
<p align="center">
  <img src="ML1-LeadScoring.png" alt="Problem Statement" width="700">
</p>
<p align="center">
  <img src="ML1-LeadScoring2.png" alt="Problem Statement" width="700">
</p>