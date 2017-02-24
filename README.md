#构建docker
docker build -t  镜像名称 .  
docker network create --driver=bridge --subnet=192.168.0.0/24 --gateway=192.168.0.1 mynet
docker run --ip=192.168.0.10 --net=mynet -ti some_image
docker run -it -d --name pushmedia  abulo/lnmp
docker run -it -d -p 80:80 -v /Users/abulo/Work/php/:/home/work/  --name pushmedia  abulo/lnmp
docker run -id -p 80:80 -v /Users/abulo/Work/php:/home/work/  --name pushmedia  abulo/lnmp:1.0
docker run --name lnmp -dit -p 80:80 -p 3306:3306  -v /Users/abulo/Work/php/:/home/work/ abulo/lnmp
docker exec -it pushmedia /bin/bash
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)
