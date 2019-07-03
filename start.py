#!/usr/bin/env python3
# set server timezone in UTC before time module imported
import os
import sys
__import__('os').environ['TZ'] = 'UTC'

LIB_PATH = os.path.join(os.path.abspath(os.sep), '.', 'odoo')
sys.path.append(LIB_PATH)
import odoo

if __name__ == "__main__":
    odoo.cli.main()
