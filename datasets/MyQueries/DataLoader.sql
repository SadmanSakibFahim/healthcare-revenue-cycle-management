LOAD DATA INFILE "E:\\Data\\healthcare-revenue-cycle-management\\datasets\\MyQueries\\AgeOfAccountsReceiveable.csv"
 INTO TABLE ageofaccountsreceiveable
 FIELDS TERMINATED BY ','
 ENCLOSED BY ''
 LINES TERMINATED BY '\n'
 IGNORE 1 LINES;