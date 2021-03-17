#!/bin/bash
# F4ICR 2021

# On verifie la presence du processus
testNGROK=$(pgrep -f ngrok |wc -l)

# Si different de 1
if [ $testNGROK != 1 ]
then
echo "ngrok arreter"

# On redemarre le tunnel ngrok
cd /root/
nohup ./ngrok http -config=.ngrok2/ngrok.yml 3000 &
sleep 5

# Ceation entete mail.txt pour l'envoi de la nouvelle URL du tunnel
truncate -s 0 /root/mail.txt
echo 'From: "ngrok" <ngrok@ngrok.com>' > mail.txt
echo 'To: "VOTRE_PRENOM" <VOTRE_MAIL>' >> mail.txt
echo 'Subject: Tunnel ngrok' >> mail.txt
echo '.' >> mail.txt

# On recupere l'URL via l'api et on decoupe la partie necessaire que l'on insere au fichier mail.txt qui sera envoyer
curl http://127.0.0.1:4040/api/tunnels |grep -o '"public_url":"http://*.*.io"'>> mail.txt
sleep 5

# On envoi le mail via curl avec pour contenu le ficher mail.txt
curl --url 'smtps://smtp.gmail.com:465' --ssl-reqd --mail-from 'VOTRE_MAIL_EXPEDITEUR'\
 --mail-rcpt 'VOTRE_MAIL_RECEPTION' --upload-file mail.txt --user 'VOTRE_MAIL_ISP:VOTRE_MOT_DE_PASSE' --insecure

else
echo "ngrok en fonction"
fi
