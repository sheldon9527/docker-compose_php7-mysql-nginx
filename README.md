#安装VirtualBox

- [Docker](https://www.docker.com) 是运行在虚拟机上的所以第一步先先安装虚拟机。
- [VirtualBox](https://www.virtualbox.org/) 现在地址选择合适的版本，下载，安装即可(傻瓜式安装。。。。。。)

#安装Docker

- Install Docker for Mac

    - 在这里[https://www.docker.com/products/docker-toolbox](https://www.docker.com/products/docker-toolbox)选择对应的系统下载

- Install Docker for Windows

    - 在这里[https://www.docker.com/products/docker-toolbox](https://www.docker.com/products/docker-toolbox)选择对应的系统下载

#安装后检查

- 各个组件的版本

    - `docker --version`  
    - `docker-compose --version`  
    - `docker-machine --version`

#初始化VirtualBox的default虚拟机

- 执行Docker Quickstart Terminal 来创建 default 虚拟机. 我在Launchpad中点击Docker Quickstart Terminal后没什么效果, 所以是直接执行相应的命令文件

    `/Applications/Docker/Docker\ Quickstart\ Terminal.app/Contents/Resources/Scripts/start.sh`

#初始化环境变量

- 执行`docker-machine env default`出现类似的配置

        `export DOCKER_TLS_VERIFY="1"
        export DOCKER_HOST="tcp://192.168.99.100:2376"
        export DOCKER_CERT_PATH="/Users/Sheldon/.docker/machine/machines/default"
        export DOCKER_MACHINE_NAME="default"`

- Run this command to configure your shell

    - `eval $(docker-machine env default)`
    - 或者使用bash则加一行`eval $(docker-machine env default)`到`~/.bash_profile`中

#构建docker
- docker build -t  镜像名称 .  
