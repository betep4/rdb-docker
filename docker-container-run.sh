#!/bin/bash
docker run -it --rm --name centos-rdb-26 -p 4050:3050 -v /srv/db/fb26:/data -e ALIAS_DB="test_db=test.fdb" centos-rdb-2.6 bash
