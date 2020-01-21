./r4st-loader.sh  > r.log 2>&1 
egrep -i '(error|fatal|hint|No such file or directory)' r.log 
