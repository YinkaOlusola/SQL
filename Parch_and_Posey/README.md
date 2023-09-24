# Parch and Posey
Parch & Posey is a Hypothetical Paper company with 50 sales representatives spread across the United States in four regions.

There are three types of paper
 - Regular
 - Poster
 - Glossy
 
They supply to a client that is a Fortune 100 company.

Using SQL, tricky business questions were answered.

An entity relationship diagram (ERD) is a common way to view data in a database. Below is the ERD for the database used from Parch & Posey. These diagrams helps to visualize the data you are analyzing including:

The names of the tables.
The columns in each table.
The way the tables work together.

In the Parch & Posey database there are five tables:

 - web_events
 - accounts
 - orders
 - sales_reps
 - region

The Objective was to create a SQLite database file that is available locally to be used for the SQL exercises from the 
Udacity SQL course

The dataset was obtained in a text format, it was pasted in SQL Server Management Studio (SSMS) to create a database.

The tables in the created database were saved as CSV files giving two options of creating a SQLite database file.

One option is to use the CSV files to create the SQLite db files. Another option is to connect directly to the SQL Server Management Studio and then, through some interpolation, create the db file. The second option seems to be more efficient in terms of time and space.

The database file was created using SQL Server Management Studio and the read into a Jupyter Notebook.

The Entity Relationship Diagram of the database is shown below

![ERD of Parch and Posey](ERD_for_parch_and_porsey.png)