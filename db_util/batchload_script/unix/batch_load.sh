for sql_file in `ls ~/sql/*.sql`; do mysql -u root -p123456 --force=TRUE pbs < $sql_file >> $sql_file.txt 2>&1; done
