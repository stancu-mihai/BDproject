# BDproject
University project showcasing SQL queries using Oracle.
## Connect to existing db
* Open Oracle SQL Developer (this is the db client)
* Create new connection:
  - Connection name: grupa34
  - User name: grupa34
  - Password: grupa34
  - Hostname: 193.226.51.37
  - Port: 1521
  - SID: o11g
## Create new local db
* Open Oracle Database 18c Express Edition for Windows x64 (this is the db server)
  - The password set while installing Database 18c Express Edition will be required
  - In case the following steps lead to problems, try deleting existing databases
  - Click "Create the database" then "Next"
  - Select "Advanced" mode
  - Set "Global database name" to "Testdb"
  - Uncheck "Create as container database"
  - Click "Next" until "User Credentials" is reached
  - Check "Use the same administrative password for all accounts", enter a password
  - Click "Next" or "Finish" until the database is created
  - Connect to the new database