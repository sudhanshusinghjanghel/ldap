#!/bin/bash
read -p "Enter your first name : " firstname
read -p "Enter your last name : " lastname
read -p "Enter your user name to be created in the LDAP:" username
read -p "Enter your password:" password
#echo "$firstname , $lastname, $username, $password"

if [ -s /tmp/adduser.ldif ]
then
   echo "File Exists in path Deleting the temp file if prompted please select Y/Yes"
   rm /tmp/adduser.ldif
else
   echo "File does not exist Downloading the template and creating the user in LDAP"
fi
wget -O /tmp/adduser.ldif https://raw.githubusercontent.com/sudhanshusinghjanghel/ldap/master/adduser.ldif

sed -i "s/uid=ali/uid=$username/g" /tmp/adduser.ldif
sed -i "s/cn: ali/cn: $username/g" /tmp/adduser.ldif
sed -i "s/uid: ali/uid: $username/g" /tmp/adduser.ldif
sed -i "s/sn: Bajwa/sn: $lastname/g" /tmp/adduser.ldif
sed -i "s/home\/ali/home\/$username/g" /tmp/adduser.ldif
sed -i "s/75000010/$(shuf -i 10001-75000010 -n 1)/g" /tmp/adduser.ldif
sed -i "s/userPassword:hortonworks/userPassword:$password/g" /tmp/adduser.ldif

printf " Creating the user in LDAP ... \n"

ldapadd -H ldap://54.38.36.186:389 -x -a -D "cn=Manager,dc=orwellg,dc=local" -f /tmp/adduser.ldif -w ldapservice1029
