# RemoteNgrok (Ne fonctionne plus de façon optimal avec le plan gratuit)
### Trop de changement dans la politique de Ngrok, donc voir le projet Localtunnel pour une utilisation avec le projet RRFRemote de F4HWN
### Prise de contrôle distant derrière un routeur 4G via un tunnel ngrok en version gratuite

Bonjour à tous, 

le but de ce tuto est de réaliser un tunnel via une solution gratuite derrière un routeur 4G. 
Lorsque l'on est en 4G, on ne sort pas directement sur Internet, on est sur le réseau privé de l'opérateur et le trafic est ensuite routé vers Internet. 

La conséquence est que l'on ne peut pas ouvrir de ports sur ce point de sortie et que le trafic entrant n'est pas possible :(
Une solution pour contourner ce problème est d'utiliser un service tunnel comme ngrok. 
Le principe est d'initier une connexion permanente à un serveur externe (ngrok) depuis son LAN pour ouvrir un tunnel, cela permettra au trafic entrant de rentrer sur le serveur ngrok, passer dans le tunnel pour arriver sur son LAN.

Ayant depuis peu de temps fait l'acquisition d'un [M5Stack](https://m5stack.com/) dans le but d'y installer le projet [RRFRemote](https://github.com/armel/RRFRemote) de Armel F4HWN, ceci afin de pouvoir suivre l'activité du [RRF](https://f5nlg.wordpress.com/2015/12/28/nouveau-reseau-french-repeater-network/) (Réseau des Répéteurs Francophones) et de piloter mon link [F1ZUJ](https://www.qrz.com/db/F1ZUJ) à distance, j'ai rapidement été confronté au problème d'accéder a mon LAN derrière un routeur 4G.

Ce tunnel bien entendu est dédié dans le cadre du projet RRFRemote mais pourrait tout aussi bien être utilisé pour d'autres besoins, ex: un tunnel ssh ou pour votre serveur web héberger sur votre LAN etc.

### Mise en place du tunnel [NGROK](https://dashboard.ngrok.com/get-started/setup)

Après avoir créé un compte sur ngrok, procédure qui est extrêmement simplifié, vous pouvez bénéficier d'un service de tunnel gratuit.

Télécharger la version NGROK correspondant à votre architecture depuis votre console ssh avec la commande wget : 

`wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip` (Linux ARM32 bits)

`wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm64.tgz` (Linux ARM 64 bits)

Décompresser l'archive ngrok en .zip ou .tgz sur votre système depuis le répertoire ou elle a été téléchargé, pour ma part j'ai opté pour le répèrtoire /root/

`unzip VOTRE_ARCHIVE.zip` ou `tar xzf VOTRE_ARCHIVE.tgz`

Ensuite, depuis la console ssh, exécuter la commande suivante dans le répertoire d'installation ngrok afin de le rendre executable :

`chmod +x ngrok`

Sur votre compte ngrok, une [clé d'authentification](https://dashboard.ngrok.com/get-started/setup) a été créée

Saisir dans votre console ssh votre clé d'authentification avec la commande suivante :

`./ngrok authtoken VOTRE_CLE`

Téléchargez le script RemoteNgrok.sh que j'ai écrit avec wget depuis votre répertoire de travail qui est /root/ dans notre exemple, (dans la mesure ou il n'y a qu'un seul fichier, je ne vois pas la nécéssité d'utiliser les commandes GIT)

`wget https://github.com/F4ICR/RemoteNgrok/blob/main/RemoteNgrok.sh`

Ne poursuivez pas la suite du tuto sur le site de ngrok, le script [RemoteNgrok.sh](https://github.com/F4ICR/RemoteNgrok/blob/main/RemoteNgrok.sh) que j'ai écrit va se charger du reste, j'explique :

Le script va d'abord vérifier la présence du tunnel, en son absence le tunnel sera activé, ensuite il créera un fichier mail.txt avec les entêtes nécessaires pour expédition ultérieur, puis via l'api de ngrok on récupère l'url du tunnel dont nous aurons besoin et je ne conserve que l'adresse http que j'insère dans le mail.txt que j'ai préparé au préalable.

Pour finir le script envoie le fichier mail.txt sur votre adresse mail que vous aurez configurer.

Afin d'automatiser ce tunnel, je crée dans le crontab une tache qui vérifiera régulièrement si le tunnel est actif entre autre et qui permet également de l'exécuter automatiquement à chaque démarrage de votre HotSpot ou de votre Link RRF.

Depuis la console ssh éditez le crontab avec la commande suivante :

`nano /etc/crontab`

Insèrez à la fin du fichier la ligne qui suit :

`* * * * * root /root/RemoteNgrok.sh >/dev/null 2>&1`

faites au clavier CTRL + X pour sortir de l'éditeur, confirmez les modifications apportées par OUI et ENTER, ensuite relancez le service cron avec la commande :

`service cron restart`

Puisque tout ceci à été développé dans le cadre du projet [RRFRemote](https://github.com/armel/RRFRemote) de F4HWN, il vous appartiendra ensuite de modifier le fichier settings.h du projet avec l'url du tunnel ngrok que vous aurez reçu par mail, puis de compiler et uploader à nouveau via [PlateformIO for VSCode](https://platformio.org/install/ide?install=vscode), vous devrez effectivement répéter cette opération uniquement si vous redémarrez votre HotSpot ou votre Link, sans quoi à défaut de recevoir un mail avec la nouvelle url du tunnel, vous n'aurez rien à faire, c'est que tout fonctionne bien.

La configuration a été tester avec gmail et est fonctionnelle a 100%, il sera évidemment nécessaire de créer un mot de passe application dans votre espace sécurité de gmail afin que le script RemoteNgrok puisse expédier le mail.

# Autres paramétrages

Dans l'éventualité où vous voudriez mettre en place un tunnel ssh, modifiez les lignes 5 et 14 pour le port 22 ainsi que la 24 pour le découpage.

> `testNGROK=$(pgrep -f 'ngrok.yml 22' |wc -l)` (ligne 5)

> `nohup ./ngrok tcp -config=.ngrok2/ngrok.yml 22 &` (ligne 14)

> `curl http://127.0.0.1:4040/api/tunnels |grep -o '"public_url":"tcp://.*"'|cut -d ":" -f 2,3,4|cut -d "," -f 1 >> mail.txt` (ligne 24)

Concernant la ligne 24, il peut y avoir un port différent pour l'api tel que 4041 au lieu du 4040, afin d'en être sûr testez en ligne de commande : 

> `curl http://127.0.0.1:4040/api/tunnels` si elle ne retourne pas d'erreur c'est parfait, sinon essayez avec :

> `curl http://127.0.0.1:4041/api/tunnels` et modifiez en conséquence.

Pour ma part j'utilise 2 tunnels, le HTTP utilse le port 4040 de l'api et le SSH utilise le 4041 de l'api, d'ou ce petit complément.



73s à tous et un merci particulier à Armel pour ses éclaircissements lorsque j'en ai eu besoin
