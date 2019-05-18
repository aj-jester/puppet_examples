#!/bin/bash

#clear sssd cache
echo "Clearing sss_cache" >> /var/log/fix_ipa_homedir.log
/sbin/sss_cache -E

for i in `ls /home`;
  do
  user_owned_by=`ls -lad /home/$i | awk '{print $3}'`
  group_owned_by=`ls -lad /home/$i | awk '{print $4}'`
  if [ ${user_owned_by} = ${i} ]; then
    echo "/home/${i} is correctly owned by ${user_owned_by}" >> /var/log/fix_ipa_homedir.log
  else
    getent_user=`getent passwd -s sss $i | cut -d: -f 1`
    if [ ${getent_user} = ${i} ]; then
      # We have a match from sssd, lets modify the ownership
      ipa_uid=`getent passwd -s sss $getent_user | cut -d: -f 3`
      ipa_gid=`getent passwd -s sss $getent_user | cut -d: -f 4`
      echo "changing recursive ownership of /home/$i to be owned by uid:${ipa_uid}/${ipa_gid}" >> /var/log/fix_ipa_homedir.log
      chown -R ${ipa_uid}:${ipa_gid} /home/${getent_user}
    else
      echo "I was unable to look up the entry for ${i} in the getent sss table" >> /var/log/fix_ipa_homedir.log
    fi
  fi
done
