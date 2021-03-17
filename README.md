# RemoteNgrok
### Prise de contrôle distant derrière un routeur 4G via ngrok en version free

Bonjour à tous, le but de ce tuto est de réalisé un tunnel via une solution gratuite derrière un routeur 4G. 
Lorsque l'on est en 4G, on ne sort pas directement sur Internet, on es sur le réseau privé de l'opérateur et le trafic est ensuite routé vers Internet. 
La conséquence est que l'on ne peut pas ouvrir de ports sur ce point de sortie et que le trafic entrant n'est pas possible :( 
Une solution pour contourner ce problème est d'utiliser un service tunnel comme ngrok. 
Le principe est d'initier une connexion permanente à un serveur externe (ngrok) depuis son LAN pour ouvrir un tunnel, cela permettra au trafic entrant de rentrer sur le serveur ngrok, passer dans le tunnel pour arriver sur son LAN.

Ayant depuis peu de temps fait l'acquisition d'un [M5Stack](https://m5stack.com/) dans le but d'y installer le projet [RRFRemote](https://github.com/armel/RRFRemote) de Armel F4HWN afin de pouvoir suivre l'activité du [RRF](https://f5nlg.wordpress.com/2015/12/28/nouveau-reseau-french-repeater-network/) (Réseau des Répéteurs Francophones) et de piloter mon link [F1ZUJ](https://www.qrz.com/db/F1ZUJ) à distance, j'ai rapidement été confronter au problème de l'impossibilté d'accéder a mon LAN dérriere un routeur 4G.

### Mise en place du tunnel [NGROK](https://dashboard.ngrok.com/get-started/setup)

Après avoir créer un compte sur ngrok, procédure qui est extrèmement simplifié, vous pouvez bénéficier d'un service de tunnel gratuit.

Télécharger la version correspondant à votre architecture, installé ngrok sur votre système dans le répertoire de votre choix, pour ma part j'ai opté pour le répèrtoire /root/

Sur votre compte ngrok, une [clé d'authentification](https://dashboard.ngrok.com/get-started/setup) a été créée

Ensuite, depuis la console ssh, executer la commande dans répertoire d'installation ngrok afin de le rendre executable :

`chmod +x ngrok`

Saisir dans votre console ssh votre clé d'authentification :

`./ngrok authtoken VOTRE_CLE`

Ne poursuivez pas la suite du tuto de ngrok, le script que j'ai écrit va se charger du reste, j'explique :
