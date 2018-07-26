rdb-docker
===============

Docker образ для RedDatabase версий 2.6 и 3.0

Сборка образа из Dockerfile
------------

Собираем образ командой билд с именем centos-rdb-2.6 для версии RDB 26:
```
$ docker build . -t centos-rdb-2.6 --host
```
Перед сборкой образа нужно проверить доступность URL сборок RDB: `http://builds.red-soft.biz/release_hub/rdb26`
В Docker файле образа можно настроить параметры дистрибутива, такие как версия релиза (RELEASE), сборка (BUILD) и архитектура проуессора (ARCH).
Параметр `--host` позволяет запустить сборку в сети хост машины (необходимо для доступности ресурса сборок).

Проверим что образ в реестре:
```
$ docker images | grep centos-rdb
centos-rdb-2.6                            latest              942a733054d3        1 hours ago        281MB
```

Запуск контейнерa
--------------

Запустим контейнер командой с пробросом портов и привязкой каталога с файлами БД:
```
$ docker run -itd --rm --name centos-rdb-26 -p 4050:3050 -v /srv/db/fb26:/data -e ALIAS_DB=test_db=test.fdb centos-rdb-2.6
```
Проверим что контйнер запущен командой:
```
$ docker ps
CONTAINER ID  IMAGE            COMMAND                  CREATED             STATUS              PORTS                    NAMES
8aa7e8c66627  centos-rdb-2.6   "/docker-entrypoin..."   About an hour ago   Up About an hour    0.0.0.0:4050->3050/tcp   centos-rdb-26
``` 
Проверим утилитой `isql` что есть доступ к БД по порту 4050:
```
$ ./isql 'localhost/4050:test_db' -u sysdba -p masterkey
```

Загрузка образа в репозитарий DockerHub
--------------------------------------

Перед загрузкой авторизуемся командой `docker login`.
После проставим тэг образу:
```
$ docker tag centos-rdb-2.6 javaronok/centos-rdb-2.6
```
и загрузим в репозиторий:
``` 
$ docker push javaronok/centos-rdb-2.6
```

Запуск контейнера на основе образа из DockerHub
------------------------------------

Загружаем образ командой: `docker pull javaronok/centos-rdb-2.6`
и запускаем контейнер:
```
$ docker run -itd --name centos-rdb-26 -p 4050:3050 -v /srv/db/fb26:/data -e ALIAS_DB=test_db=test.fdb javaronok/centos-rdb-2.6
```
