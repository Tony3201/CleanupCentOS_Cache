#########################################################################
# Name: CleanupCentOS7Cache
# Version: 0.1
# Author: tony3201
# Created Time: June 08 2019		
#########################################################################
#!/bin/bash
if [ $USER != "root" ] # only runs if logged in as root
then
 echo "You must be logged in as root." >&2
 exit 1
fi

#Have to install yum-utils 
dnf -y install yum-utils   

#To find more than 7 days and beyond 50m or 30 days files from the path *.log/var
find /var -name "*.log" \( \( -size +50M -mtime +7 \) -o -mtime +30 \) -exec truncate {} --size 0 \; 

#clean the cache
dnf clean all

#check the alone package
package-cleanup --quiet --leaves  --exclude-bin

#clean the alone package 
package-cleanup --quiet --leaves --exclude-bin |xargs yum remove -y

#clean up older kernel only keep 2 new
package-cleanup --oldkernels --count=2

#clean up error_log files
find /home/*/public_html/ -name error_log -delete

