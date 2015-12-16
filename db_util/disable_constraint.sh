for sql_file in `ls ~/sql/*.sql`; do sed -i '1iSET FOREIGN_KEY_CHECKS=0;' $sql_file; echo 'SET FOREIGN_KEY_CHECKS=1;' >> $sql_file;done
