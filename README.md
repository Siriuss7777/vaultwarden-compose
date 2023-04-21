# Vaultwarden

*Bastien Le Gall, G3S4*

Vaultwarden est un gestionnaire de mots de passe développé en Rust, basé sur l'API open-source de la solution commerciale Bitwarden. 

Ce conteneur permet d'héberger une instance Vaultwarden, permettant l'accès à un gestionnaire de mots de passe complet et simple d'utilisation.

Il est composé de trois containers: mysql pour les données, apache2 pour le front-end et vaultwarden pour le back-end (et le websocket pour les notifications, si elles sont activées).

## Démarrage

Avant le premier démarrage, il faut se placer dans le dossier racine (contenant le docker-compose.yml) et exécuter le script pull-vault.sh, qui va installer Rust (utilisé pour compiler le back-end), télécharger le front et le back-end, et compiler le back-end. Cette étape nécessite un minimum d'environ 1.5Go de RAM, et devrait durer entre 5 et 10 minutes.

Une fois cette étape faite, il suffit simplement d'exécuter la commande docker-compose up -d pour lancer l'application. 

## Configuration commune

La configuration commune aux containers est située dans ./common.conf.
Ce fichier contient des variables d’environnement utilisées dans au moins deux conteneurs.

- Variable DOMAIN: domaine utilisé pour accéder à Vaultwarden (par défaut: localhost)

Au cas où le domaine doit être changé (par défaut: localhost) il faudra le renseigner. 

## vaultwarden-server

La configuration de ce container est située dans ./vaultwarden/vaultwarden.env
Ce fichier contient les variables d’environnement nécessaires au bon fonctionnement du serveur

- ADMIN_TOKEN: jeton de connexion à la page d’administration. Ne pas renseigner cette variable désactive la page d’administration. Pour en générer un, deux options:
    - openssl rand -base64 [nb] pour générer un token qui sera utilisé comme mots de passe, de longueur [nb]
    - vaultwarden/vaultwarden hash: génère un hash depuis un mot de passe qui pourra être utilisé comme token. Pour se connecter, le mot de passe uniquement devra être utilisé et non le token
- SIGNUPS_ALLOWED: booléen, autorise ou non les utilisateurs à s’inscrire (cette variable peut être définie à false, il est toujours possible d’ajouter des comptes depuis la page d’administration)
- WEBSOCKET_ENABLED: active/désactive le websocket utilisé pour les notifications
- WEBSOCKET_ADDRESS: Adresse utilisée pour le websocket.
- ROCKET_ADDRESS: Adresse utilisée pour accéder au serveur web
- ROCKET_PORT: Port utilisé pour accéder au serveur web
- DATABASE_URL: URL vers la base de données MySQL. Sous la forme suivante: 
mysql://[user]:[password]@[server(:port)]/[database]
- La configuration du SMTP (envoi de mails) dépend du fournisseur de services mail utilisé, détail de la configuration ici: [https://github.com/dani-garcia/vaultwarden/wiki/SMTP-configuration](https://github.com/dani-garcia/vaultwarden/wiki/SMTP-configuration) (en)

Plus de paramètres disponibles sur [https://github.com/dani-garcia/vaultwarden/blob/main/.env.template](https://github.com/dani-garcia/vaultwarden/blob/main/.env.template) (en)

En cas de déploiement sur Internet, il est important de noter que générer un certificat SSL plus sécurisé est fortement recommandé.

Le serveur est encore maintenu. Le script ./vaultwarden/build/build.sh pull les fichiers depuis Github et le build. Le reste est automatique, il suffit simplement d’exécuter le script. 

Build args pour mettre à jour VWarden

## mysql

Ce conteneur hébergera la base de données utilisée par Vaultwarden pour sauvegarder ses données. 

Son fichier env est situé à ./mysql/mysql.env.

Il contient les variables suivantes:

- MYSQL_ROOT_PASSWORD: Mot de passe de l’utilisateur root de mysql.

Le fichier init.sql est un script permettant l’initialisation de l’utilisateur utilisé par vaultwarden-server, la base de données vaultwarden et de lui accorder les privilèges nécessaires. Il sera exécuté au démarrage du conteneur.

## apache2

Apache2 sera utilisé comme reverse proxy, pour accéder à Vaultwarden.

Apache2 ne nécessite pas de variables d’environnement spécifique, et sera configuré comme un serveur apache régulier, à l’aide des fichiers apache2.conf, sites-available/*.

Cependant, pour activer tous les modules nécessaires au fonctionnement du SSL, reverse proxy et réécriture d’URL, l’utilisation d’un Dockerfile est nécessaire afin de pouvoir build l’image avec les modules acitvés par défaut. 

Le serveur sera démarré à l’aide d’apache2-foreground, script récupéré de l’image officielle d’apache2.
