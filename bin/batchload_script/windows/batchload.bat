for /f %%f in ('dir /b %1\*.sql') do mysql --user=%2 --password=%3 %4 < %1\%%f
