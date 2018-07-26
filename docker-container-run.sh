#!/bin/bash
docker run -it --rm --name centos-rdb-30 -p 5050:3050 -p 6061:6061 -v /srv/db/fb30:/data -e ALIAS_DB="test_db=test.fdb" -e REMOTE_AUX_PORT=6061 centos-rdb-3.0 bash
