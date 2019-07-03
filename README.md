HOW TO USE IT?
==============

### 1、Install docker and run

### 2、Build image for project
docker build -t core-12:12.0.1 .

### 3、create volumes for project
docker volume create --name odoo_volume
docker volume create --name=core-12_volume_app
docker volume create --name=core-12_volume_log
docker volume create --name=core-12_volume_data

### 4、Copy config/prod.conf to Volume "core-12_volume_data"
Linux:
mkdir /var/lib/docker/volumes/core-12_volume_data/_data/config
cp config/prod.conf /var/lib/docker/volumes/core-12_volume_data/_data/config/

### 5、Copy odoo12 to Volume odoo_volume
You should download odoo12 at first: https://github.com/odoo/odoo
And then copy all content to odoo_volume/_data
ACTIONS:
After that, the list in /var/lib/docker/volumes/odoo_volume/_data/ is look like this:

### 6、Run ODOO  
docker-compose -f docker-compose-db.yaml up -d
docker-compose up
ACTIONS:
Before that, you should have downloaded postgres:9.6.9

YOUR PROJECT IS RUNNING IN PORT 8123!  
ENJOY IT!


