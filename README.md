# RemoteNgrok
### Prise de contrôle distant derrière un routeur 4G via un tunnel ngrok en version free

Bonjour à tous, le but de ce tuto est de réalisé un tunnel via une solution gratuite derrière un routeur 4G. 
Lorsque l'on est en 4G, on ne sort pas directement sur Internet, on est sur le réseau privé de l'opérateur et le trafic est ensuite routé vers Internet. 
La conséquence est que l'on ne peut pas ouvrir de ports sur ce point de sortie et que le trafic entrant n'est pas possible :( 
Une solution pour contourner ce problème est d'utiliser un service tunnel comme ngrok. 
Le principe est d'initier une connexion permanente à un serveur externe (ngrok) depuis son LAN pour ouvrir un tunnel, cela permettra au trafic entrant de rentrer sur le serveur ngrok, passer dans le tunnel pour arriver sur son LAN.

Ayant depuis peu de temps fait l'acquisition d'un [M5Stack](https://m5stack.com/) dans le but d'y installer le projet [RRFRemote](https://github.com/armel/RRFRemote) de Armel F4HWN, ceci afin de pouvoir suivre l'activité du [RRF](https://f5nlg.wordpress.com/2015/12/28/nouveau-reseau-french-repeater-network/) (Réseau des Répéteurs Francophones) et de piloter mon link [F1ZUJ](https://www.qrz.com/db/F1ZUJ) à distance, j'ai rapidement été confronter au problème de l'impossibilité d'accéder a mon LAN derrière un routeur 4G.

Ce tunnel bien entendu est dédié dans le cadre du projet RRFRemote mais pourrait tout aussi bien être utilisé pour d'autres besoins, ex: un tunnel ssh ou pour votre serveur web héberger sur votre LAN etc.

### Mise en place du tunnel [NGROK](https://dashboard.ngrok.com/get-started/setup)

Après avoir créé un compte sur ngrok, procédure qui est extrêmement simplifié, vous pouvez bénéficier d'un service de tunnel gratuit.

Télécharger la version correspondant à votre architecture, installé ngrok sur votre système dans le répertoire de votre choix, pour ma part j'ai opté pour le répèrtoire /root/

Sur votre compte ngrok, une [clé d'authentification](https://dashboard.ngrok.com/get-started/setup) a été créée

Ensuite, depuis la console ssh, exécuter la commande dans le répertoire d'installation ngrok afin de le rendre executable :

`chmod +x ngrok`

Saisir dans votre console ssh votre clé d'authentification :

`./ngrok authtoken VOTRE_CLE`

Ne poursuivez pas la suite du tuto de ngrok, le script [RemoteNgr.sh](https://github.com/F4ICR/RemoteNgrok/blob/main/RemoteNgrok.sh) que j'ai écrit va se charger du reste, j'explique :

Le script va d'abord vérifier la présence du tunnel, en son absence le tunnel sera activé, ensuite il créera un fichier mail.txt avec les entêtes nécessaires pour expédition ultérieur, puis via l'api de ngrok on récupère l'url du tunnel dont nous aurons besoin et je ne conserve que l'adresse http que j'insère dans le mail.txt que j'ai préparé au préalable et pour finir j'envoie le fichier mail.txt sur votre adresse mail que vous aurez configurer.

Afin d'automatiser ce tunnel, j'ai créé dans le crontab une tache, ce qui permet de l'exécuter automatiquement à chaque démarrage de votre HotSpot ou de votre Link RRF et de le relancer en cas de défaillance du processus uniquement.

Depuis la console ssh exécutez la commande suivante :

`nano /etc/crontab`

Insèrez à la fin du fichier :

`* * * * * root /root/RemoteNgrok.sh >/dev/null 2>&1`

faites au clavier CTRL + X pour sortir de l'éditeur, confirmez les modifications apportées par OUI et ENTER, ensuite relancez le service cron avec la commande :

`service cron restart`

Puisque tout ceci à été développé dans le cadre du projet [RRFRemote](https://github.com/armel/RRFRemote) de F4HWN, il vous appartiendra ensuite de modifier le fichier settings.h du projet avec l'url du tunnel ngrok que vous aurez reçu par mail, puis de compiler et uploader à nouveau via [PlateformIO for VSCode](https://platformio.org/install/ide?install=vscode), vous devrez effectivement répéter cette opération uniquement si vous redémarrez votre HotSpot ou votre Link, sans quoi à défaut de recevoir un mail avec la nouvelle url du tunnel, vous n'aurez rien à faire, c'est que tout fonctionne bien.

La configuration à été tester avec gmail et est fonctionnelle a 100%, il sera évidemment nécessaire de créer un mot de passe application dans votre espace sécurité de gmail afin que le script RemoteNgrok puisse expédier le mail.

73's QRO à tous et un merci particulier à Armel pour ses éclaircissements lorsque j'en ai eu besoin
