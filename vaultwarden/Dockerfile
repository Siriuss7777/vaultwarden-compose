FROM ubuntu

# Mise à jour des paquets
RUN DEBIAN_FRONTEND=noninteractive apt update -y && \
	apt upgrade -y

# Installation des paquets nécessaires au fonctionnement du serveur Vaultwarden
RUN DEBIAN_FRONTEND=noninteractive apt install \
	libmysqlclient-dev \
	pkg-config \
	libssl-dev \
	build-essential \
	default-libmysqlclient-dev -y

# Montage de l'exécutable du serveur
COPY vaultwarden /bin/vaultwarden
# Montage du dossier des données Vaultwarden
COPY data /data
# Montage du dossier contenant les fichiers du front-end
COPY web-vault /web-vault

# Exposition des ports 8000 et 3012
EXPOSE 8000
EXPOSE 3012

# Commande exécutée au démarrage du conteneur
CMD ["vaultwarden"]
