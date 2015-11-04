#PBSProject

## Batch load script
Auto load all sql files in a directory to a certain database.

### Usage
#### For windows:
    //Be sure to set the PATH env variable to include the MySQL bin folder!
    batchload.bat <SQL_FILE_DIR> <MYSQL_USERNAME> <MYSQL_PASSWORD> <MYSQL_DBNAME>



# XMLtoSQLite Python Script
Parses each file in a directory, converts to Pandas dataframe and then to a table in the PBS DB on SQLite 
Drop all XML files of interest into a folder, copy the path (Use forward slashes)
And pass this path as argument to xml_to_sqlite function on the script. 
Requirements: SQLite, Python (Pandas, sqlite3) 
