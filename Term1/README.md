# Data Engineering 1 Term Project 1

### Data
This dataset lists facts about the Department of Computer Science and Engineering at the University of Washington (UW-CSE). 
The source is 
https://relational.fit.cvut.cz/dataset/UW-CSE

## Files  
1. `uw_study.sql` - SQL data dump file for schema and table creation along with all data insertions
2. `etl.sql` - SQL file showing ETL and EVENT

## Analytics Plan
This plan is about the Department of Computer Science and Engineering at the University of Washington (UW-CSE), such as entities (e.g., Student, Professor) and their relationships (i.e. AdvisedBy, Publication).

### Analytical Layer using Stored procedures
Data transformations in the analytical phase are the following:
1. Linking of `person`, which is a student or professor in UW and `advisedBy`, which means an adviser of the person.
2. Linking of `person` and `taughtBy`, which means a certain course.
3. Linking of `person` and `course`, which means a level of the course.
   
### Data Marts
The following data marts were created from the `data_warehouse` table:
1. `Post_Generals` - The characteristics of students who are at the phase of Post_Generals
2. `Level_500` - The characteristics of students who are taught by the course of level 500 course

### EVENT
An event `UWStudyEvent` is set up to run at current time and every minute for 5 minutes after initialized. This event calls the `CreateUWStudent` and `DataMarts` procedures to generate and update the analytical tables if an insertiowere to occur. The event also creates a message into the message_log every time an interval is run.  