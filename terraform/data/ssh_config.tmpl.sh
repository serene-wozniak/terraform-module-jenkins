#!/bin/bash
SYSTEM_USER="gg-infrabot"

adduser $${SYSTEM_USER}
mkdir -p /home/$${SYSTEM_USER}/.ssh

# Put the private key for our system user in place
cat << EOF > /home/$${SYSTEM_USER}/.ssh/id_rsa
${github_privatekey}
EOF
ssh-keyscan github.com > /home/$${SYSTEM_USER}/.ssh/known_hosts
chown -R $${SYSTEM_USER}:$${SYSTEM_USER} /home/$${SYSTEM_USER}/.ssh
chmod -R 600 /home/$${SYSTEM_USER}/.ssh

# Put the public key of our user CA in place.
cat << EOF > /etc/ssh/users_ca.pub
${users_ca_publickey}
EOF

# Ensure the centos user is the only user that can be accessed via certificate
cat << EOF > /etc/ssh/authorized_principals
centos
EOF

# Line return is important!
cat << EOF >> /etc/ssh/sshd_config

TrustedUserCAKeys /etc/ssh/users_ca.pub
AuthorizedPrincipalsFile  /etc/ssh/authorized_principals
EOF

# Restart the ssh server
systemctl restart sshd.service

