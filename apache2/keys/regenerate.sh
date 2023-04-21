#!/bin/sh
openssl req -nodes -new -x509 -days 7777 -keyout server.key -out server.crt -subj "/C=FR/ST=./L=./O=IUT Lyon 1 G3S4/CN=localhost.vaultwarden"
