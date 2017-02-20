hostlist : ip+space+user+space+passwd+space+address
Don't appear error messages and blank lines
all files need under the same path
chmod 755 *.sh

Don't want to send mail can be directly run 
sh ogg_ssh_status.sh hostlist ogg_status.sh



In the docker :
/etc/init.d/crond status
query status , if crond is stoped you should
/etc/init.d/crond start


0 8 * * * sh /opt/ogg_status/emain_ogg_ssh.sh
#Run the script at 8 o'clock every day



