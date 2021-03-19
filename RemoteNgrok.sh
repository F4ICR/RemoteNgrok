#!/bin/bash
# F4ICR 2021

# Verification de la presence du processus
testNGROK=$(pgrep -f "ngrok.yml 3000" |wc -l)

# Si different de 1
if [ $testNGROK != 1 ]
then
echo "ngrok arreter"

# Demarrage du tunnel ngrok
cd /root/
nohup ./ngrok http -config=.ngrok2/ngrok.yml 3000 &
sleep 5

# Creation entete mail.txt pour l'envoi de la nouvelle URL du tunnel
echo 'From: "ngrok" <ngrok@ngrok.com>' > mail.txt
echo 'To: "VOTRE_PRENOM_OU_AUTRE" <VOTRE_MAIL>' >> mail.txt
echo 'Subject: Tunnel ngrok' >> mail.txt
echo '.' >> mail.txt

# Recuperation de l'URL via l'api et on decoupe la partie necessaire que l'on insere au fichier mail.txt qui sera envoyer
curl http://127.0.0.1:4040/api/tunnels | grep -o '"public_url":"http://*.*.io"' | cut -d ":" -f 2,3 >> mail.txt
sleep 5

# Envoie le mail via curl avec pour contenu le ficher mail.txt
curl --url 'smtps://smtp.gmail.com:465' --ssl-reqd --mail-from 'ngrok@ngrok.com'\
 --mail-rcpt 'MAIL_DESTINATAIRE' --upload-file mail.txt --user 'VOTRE_MAIL_DE_CONNEXION:MOT_DE_PASSE' --insecure

else
echo "ngrok en fonction"
fi
