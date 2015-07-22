#!/bin/bash

### Yapodu
### Ryo Tamura

USER="yp-study"
GROUP="yapodu"
PASSWORD="Ch@ngeme!"
DATE=`date +%Y%m%d%H%M`
USER_DIR=~${USER}
CREATE_LOG=create-yp-study.sh.log

USER_SSH_DIR=".ssh"
USER_SSH_AUTHKEY="authorized_keys"
USER_SSH_AUTHPATH=${USER_SSH_DIR}/${USER_SSH_AUTHKEY}

SSHD_CONFIG="/etc/ssh/sshd_config"

SUDOERS="/etc/sudoers"

# ユーザー存在確認と作成
grep ${USER} /etc/passwd

if [ "$?" -eq 0 ]
then
        echo "yp-study not create ${DATE}" >> ~yp-study/${CREATE_LOG}
else
        useradd -g ${GROUP} ${USER}
        echo ${USER}:${PASSWORD} | chpasswd
        echo "yp-study create ${DATE}" >> ~yp-study/${CREATE_LOG}
fi

# sshd設定変更

grep  ^AllowUsers ${SSHD_CONFIG} | grep ${USER}

if [ "$?" -eq 0 ]
then
        echo "not change sshd_config AllowUsers ${DATE}" >> ~yp-study/${CREATE_LOG}
else
        grep ^AllowUsers ${SSHD_CONFIG}

        if [ "$?" -eq 0 ]
        then
                sed -i.${DATE} -e "/^AllowUsers/ s/$/ ${USER}/g"  ${SSHD_CONFIG}
                echo "add sshd_config AllowUsers ${DATE}" >> ~yp-study/${CREATE_LOG}
                # sshd reload
                service sshd reload
        else
                echo "do not use sshd_config AllowUsers ${DATE}" >> ~yp-study/${CREATE_LOG}
        fi

fi


# sudoers設定変更
# シェルスクリプト内で visudo を実行する方法もあるが /etc/sudoers の編集で実施する

grep  ${USER} ${SUDOERS}

if [ "$?" -eq 0 ]
then
        echo "not change sudoers ${DATE}" >> ~yp-study/${CREATE_LOG}
else
        cp -p ${SUDOERS} ${SUDOERS}.${DATE}
	sed -i 's/Defaults.*requiretty/#Default\trequiretty/g' ${SUDOERS}
	echo "yp-study ALL=(ALL) NOPASSWD:ALL" >> ${SUDOERS}
        echo "add yp-study ${SUDOERS} ${DATE}" >> ~yp-study/${CREATE_LOG}
fi

# 作成ユーザーでの鍵作成
sudo -u ${USER} /tmp/key-gen.sh

# 作成キーのコピーと名称変更
cp /home/yp-study/.ssh/id_rsa /tmp/`uname -n`.pem
chmod 660 /tmp/`uname -n`.pem
chown ${USER}:${GROUP} /tmp/`uname -n`.pem
