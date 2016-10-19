./r4st-loader.sh  > ../logs/r4st-loader.log 2>&1 
egrep -i '(error|fatal|hint)' ../logs/r4st-loader.log 
echo "You can view the r4st PRD database at: http://localhost/r4stdb/dbkiss.php"
