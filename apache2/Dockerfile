FROM ubuntu

# Mise à jour des paquets
RUN DEBIAN_FRONTEND=noninteractive apt update -y && \
	apt upgrade -y

# Installaiton du paquet apache2
RUN DEBIAN_FRONTEND=noninteractive apt install apache2 -y

# Activation des paquets nécessaires au fonctinnement du reverse proxy
RUN a2enmod ssl \
	    headers \
	    proxy \
	    rewrite \
	    proxy_http \
	    proxy_wstunnel

# Montage de l'exécutable sur le conteneur
COPY ./apache2-foreground /usr/bin/apache2-foreground

# Exposition des ports 80 et 443
EXPOSE 80
EXPOSE 443

# Commande exécutée au démarrage du conteneur
CMD ["apache2-foreground"]
