CREATE USER IF NOT EXISTS 'vwarden'@'172.18.0.3' IDENTIFIED BY 'Qk7oUcxhWANv3whcjVMrdO4wl9tFLJAE';
CREATE DATABASE IF NOT EXISTS vaultwarden;
GRANT ALL PRIVILEGES ON vaultwarden.* TO 'vwarden'@'172.18.0.3';
