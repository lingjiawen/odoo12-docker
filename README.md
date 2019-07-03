HOW TO USE IT?
============== 
created by misterling 
### 1、Install docker、docker-compose and run
  
### 2、Build image for project
docker build -t core-12:12.0.1 .  

### 3、create volumes for project
docker volume create --name=odoo_volume  
docker volume create --name=core-12_volume_app  
docker volume create --name=core-12_volume_log  
docker volume create --name=core-12_volume_data  

### 4、Copy config/prod.conf to Volume "core-12_volume_data"
Linux:  
mkdir /var/lib/docker/volumes/core-12_volume_data/_data/config  
cp config/prod.conf /var/lib/docker/volumes/core-12_volume_data/_data/config/  

### 5、Copy odoo12 to Volume odoo_volume
You should download odoo12 at first: https://github.com/odoo/odoo  
And then copy all contents to odoo_volume/_data:  
mv odoo12/* /var/lib/docker/volumes/odoo_volume/_data/
  
ACTIONS:  
After that, the list in /var/lib/docker/volumes/odoo_volume/_data/ must be look like this:  
  
-rwxr-xr-x   1 501 wheel   803 Jun 28 12:15 CONTRIBUTING.md 
-rwxr-xr-x   1 501 wheel   433 Jun 28 12:15 COPYRIGHT  
-rwxr-xr-x   1 501 wheel 43529 Jun 28 12:15 LICENSE  
-rwxr-xr-x   1 501 wheel  1491 Jun 28 12:15 MANIFEST.in  
-rwxr-xr-x   1 501 wheel  1917 Jun 28 12:15 README.md  
-rwxr-xr-x   1 501 wheel  1734 Jun 28 12:15 SECURITY.md  
drwxr-xr-x 291 501 wheel 20480 Jul  3 14:33 addons  
drwxr-xr-x   3 501 wheel  4096 Jul  3 14:33 debian  
drwxr-xr-x  10 501 wheel  4096 Jul  3 14:33 doc  
drwxr-xr-x  11 501 wheel  4096 Jul  3 14:33 odoo  
-rwxr-xr-x   1 501 wheel   180 Jun 28 12:15 odoo-bin  
-rwxr-xr-x   1 501 wheel  1051 Jun 28 12:15 requirements.txt  
drwxr-xr-x   4 501 wheel  4096 Jul  3 14:33 setup  
-rwxr-xr-x   1 501 wheel   854 Jun 28 12:15 setup.cfg  
-rwxr-xr-x   1 501 wheel  1684 Jun 28 12:15 setup.py  
  
### 6、Run ODOO  
docker-compose -f docker-compose-db.yaml up -d  
docker-compose up  
  
ACTIONS:  
Before that, you should have downloaded postgres:9.6.9  

YOUR PROJECT IS RUNNING!  
PORT 8123      
ENJOY IT!   


