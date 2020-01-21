./ipc-loader.sh  > ipc.log 2>&1 
egrep -i '(error|fatal|hint|No such file or directory)' ipc.log 
