#! /bin/bash
set -e
chown -R odoo /data
chown -R odoo /log
# move config to data volume
exec gosu odoo python /core/start.py -c /data/config/prod.conf
