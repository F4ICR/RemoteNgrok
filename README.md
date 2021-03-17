# RemoteNgrok
Prise de contrôle distant derrière un routeur 4G via ngrok en version free

Bonjour à tous, le but de ce tuto est de réalisé un tunnel via une solution gratuite derrière un routeur 4G. 
Lorsque l'on est en 4G, on ne sort pas directement sur Internet. on es sur le réseau privé de l'opérateur et le trafic est ensuite routé vers Internet. 
La conséquence est que l'on ne peut pas ouvrir de ports sur ce point de sortie et que le trafic entrant n'est pas possible :( 
Une solution pour contourner ce problème est d'utiliser un service tunnel comme ngrok. 
Le principe est d'initier une connexion permanente à un serveur externe (ngrok) depuis son LAN pour ouvrir un tunnel. 
Cela permettra au trafic entrant de rentrer sur le serveur ngrok, passer dans le tunnel pour arriver sur son LAN
