# Microservices and the Real World

We will learn about terms such as "Cloud-native Microservices", we will learn about Docker Compose to create multi container apps, then we'll talk about "Docker Swarn" a nice alternative to Kubernetes and finnally we will learn about "Docker Stacks" for production level multi container apps.

## Cloud-native Microservices

A traditional app is composed out of many smaller services, this means applying patches may cause downtime, scalling is also much harder since the whole application needs to be scalled. In microservices, each service is split into it's own application, this allows each microservice to scalle and be patched independently withouth affecting the other services, this is what it means for an application to be cloud-native.

## Multi-container Apps with Docker Compose

So far we have seen how to package our app into a reusable image, these docker commands are not enough to tell what the app does nor does it show how each app component connect, we need a more declarative way.

> Describimg the desired state of your applicatoin in a config file that you use to deploy and manage the app.

The `docker-compose.yml` file defines a multi-container or microservices app, in our case the application uses a web front-end and a redis backend. This file can be read by docker to pull all needed dependencies, wire up all the needed networking to allow our containers to comunicate.

In the `multi-container` project, we will find the usual `Dockerfile` but we will see a new kind of file for docker, `docker-compose.yml`. This compose file defines two application microservices.

The first service called web-fe is a python flask app which calls the docker file to build an image and sets a command to execute when the container starts, it also maps the port on the container with a port on our host machine. We could do this on the command line, but this is a much cleaner way.

```yml
version: "3.8"
services:
  web-fe:
    build: .
    command: python app.py
    ports:
      - target: 5000
        published: 5000
    networks:
      - counter-net
    volumes:
      - type: volume
        source: counter-vol
        target: /code
```

The seccond service is a redis backend, which just pulls the base image and ataches it to the same nerwork. We will also find some other commands to tell docker to create a network and a volume.

```yml
version: "3.8"
services:
  redis:
    image: "redis:alpine"
    networks:
      counter-net:

networks:
  counter-net:

volumes:
  counter-vol:
```

The power behind this aproach, is avoiding to use a bunch of docker specific commands and document our application state in a file like this, here we delegate to docker to configure features such as networking and storage. This is a better aproach for developers who don't need to wory about alot of docker commands and for an operations perspective, this is alot of documentation.

To start this multi-container app just use the command `docker-compose up`, aditionally use the `-d` flag to run this on the background. If we check our docker images, we will find the python and redis images needed for this application.

```
docker image ls
REPOSITORY               TAG               IMAGE ID       CREATED          SIZE
multi-container_web-fe   latest            8a899915ef65   15 seconds ago   57.5MB <--
je12emy/gsd              first_container   4db286da13f9   3 hours ago      124MB
node                     current-alpine    996519d8e181   11 hours ago     112MB
python                   alpine            d4d6be1b90ec   5 days ago       45.1MB <--
redis                    alpine            814803e951a7   11 days ago      32.3MB <--
alpine                   latest            021b3423115f   12 days ago      5.6MB
hello-world              latest            d1165f221234   5 months ago     13.3kB
```

Now let's check our running containers.

```
docker container ls
CONTAINER ID   IMAGE                    COMMAND                  CREATED              STATUS              PORTS                                       NAMES
fb0d1f9386c9   redis:alpine             "docker-entrypoint.s…"   About a minute ago   Up About a minute   6379/tcp                                    multi-container_redis_1
7a891575ec6c   multi-container_web-fe   "python app.py pytho…"   About a minute ago   Up About a minute   0.0.0.0:5000->5000/tcp, :::5000->5000/tcp   multi-container_web-fe_1
```

Now checkout `localhost:5000` to visit this multi-container application. To shutdown this application use `docker-compose down` to send a shutdown signal.

```
docker-compose down
Stopping multi-container_redis_1  ... done
Stopping multi-container_web-fe_1 ... done
Removing multi-container_redis_1  ... done
Removing multi-container_web-fe_1 ... done
Removing network multi-container_counter-net
```

## Taking Things to the Next Level

Docker has a mode called `Swarm mode` which allows it to cluster multiple docker hosts into a secure, highly available cluster. The cluster comprises managers and workers, it is called a swarm since it has one or more manager nodes and some worker nodes. 

- Managers host the control plane features such as as scheduling and persisting the cluster and the hosted application state. It is recomened to host an odd number of managers like 3 o 5, in order the avoid a "split-brain condition" where there is a network issue and we endup with an equal number of managers on both sides of the split, where neither side knows it has a majority to update the workers.

This nodes may be any kind of machines, they just need docker. With docker on our local machines we may operate in swarm mode, but we are limited to a single manager. The swarm mode also enables other features such as services.

To start our own first swarm, let's initialize the swarm with `swarm init`. This will create a new manager.

```
docker swarm init
Swarm initialized: current node (r9nhblzo7ie5jcbz9nlwudy4r) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-58f2nh16ay6eydr2oxgkkunip5w3ashogxg46fvtwveimbstsq-6vtgmlkhbbc2qxjp7x3dhmyg0 192.168.1.108:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

To create a new worker, we are given a command to add it, though we would need to do this on another docker instance.

```
docker swarm join-token worker

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-58f2nh16ay6eydr2oxgkkunip5w3ashogxg46fvtwveimbstsq-6vtgmlkhbbc2qxjp7x3dhmyg0 192.168.1.108:2377
```

We may check the nodes in this cluster with the following command.

```
docker node ls
ID                            HOSTNAME   STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
r9nhblzo7ie5jcbz9nlwudy4r *   pop-os     Ready     Active         Leader           20.10.8
```

## Microservices and Docker Services

With our swarm up and running we have access to other features, like docker services and the stack command. A docker service maps back to an individual service in a microservices app like a web frontend. If we would like to scale up a microservice we just need to scale up the maped service. First let's learn in a imperative way via the cli and then in a declarative way with a `yml` file.

To create a new docker service, using the base image we have used so far, execute the following command.

```
docker service create --name web -p 8080:8080 --replicas 3 je12emy/gsd:first_container
odsxin6lio95bffm7s3rs0z1m
overall progress: 3 out of 3 tasks
1/3: running   [==================================================>]
2/3: running   [==================================================>]
3/3: running   [==================================================>]
verify: Service converged
```

In here we are defining 3 replicas for this container, let's check this service with the following command.

```
docker service ls
ID             NAME      MODE         REPLICAS   IMAGE                         PORTS
odsxin6lio95   web       replicated   3/3        je12emy/gsd:first_container   *:8080->8080/tcp
```

We can also see this containers running with the commands we have seen so far.

```
docker container ls
CONTAINER ID   IMAGE                         COMMAND         CREATED         STATUS         PORTS     NAMES
f0fa7a900747   je12emy/gsd:first_container   "node app.js"   2 minutes ago   Up 2 minutes             web.3.vfpa9v24z30tp1o6r6z636krm
972c5787f4f2   je12emy/gsd:first_container   "node app.js"   2 minutes ago   Up 2 minutes             web.1.o6wn2h884egfivvkzdfch8o4b
dab95b9592b7   je12emy/gsd:first_container   "node app.js"   2 minutes ago   Up 2 minutes             web.2.r1vg26rkk6oh3g2pzpkjab8gw
```

If we where running this command on a multi-node swarm, this command will only show the containers running on the local node. A more apropiate command would be using `docker service ps`.

```
docker service ps web
ID             NAME      IMAGE                         NODE      DESIRED STATE   CURRENT STATE           ERROR     PORTS
o6wn2h884egf   web.1     je12emy/gsd:first_container   pop-os    Running         Running 4 minutes ago
r1vg26rkk6oh   web.2     je12emy/gsd:first_container   pop-os    Running         Running 4 minutes ago
vfpa9v24z30t   web.3     je12emy/gsd:first_container   pop-os    Running         Running 4 minutes ago
```

Now if we check this app in our browser at `localhost:8080` the service id is displayed at the bottom by refreshing or opening another browser, the id changes and it should match this listed services.

This is great, we can also scale up a service with `docker service scale`.

```
docker service scale web=5
web scaled to 5
overall progress: 5 out of 5 tasks
1/5: running   [==================================================>]
2/5: running   [==================================================>]
3/5: running   [==================================================>]
4/5: running   [==================================================>]
5/5: running   [==================================================>]
verify: Service converged
```

If we check the containers, the replicas increased.

```
docker container ls
CONTAINER ID   IMAGE                         COMMAND         CREATED          STATUS          PORTS     NAMES
54a765a8cd21   je12emy/gsd:first_container   "node app.js"   55 seconds ago   Up 53 seconds             web.5.qn2kub59b2y4n6t9qgyw5r7f0
b543006252b4   je12emy/gsd:first_container   "node app.js"   55 seconds ago   Up 53 seconds             web.4.vw63asxc76hdto9g2efq1gbi8
f0fa7a900747   je12emy/gsd:first_container   "node app.js"   15 minutes ago   Up 15 minutes             web.3.vfpa9v24z30tp1o6r6z636krm
972c5787f4f2   je12emy/gsd:first_container   "node app.js"   15 minutes ago   Up 15 minutes             web.1.o6wn2h884egfivvkzdfch8o4b
dab95b9592b7   je12emy/gsd:first_container   "node app.js"   15 minutes ago   Up 15 minutes             web.2.r1vg26rkk6oh3g2pzpkjab8gw

docker service ls
ID             NAME      MODE         REPLICAS   IMAGE                         PORTS
odsxin6lio95   web       replicated   5/5        je12emy/gsd:first_container   *:8080->8080/tcp
```

Let's take down some individual containers.

```
docker container rm 54a765a8cd21 b543006252b4  -f
54a765a8cd21
b543006252b4
```

The swarm will create new containers, based on the amount of replicas we specified, do check the uptime.

```
docker container ls
CONTAINER ID   IMAGE                         COMMAND         CREATED          STATUS          PORTS     NAMES
654ede127a7e   je12emy/gsd:first_container   "node app.js"   56 seconds ago   Up 50 seconds             web.4.p4mbznmbv981akseyc301fmv2
4a1741f2e4a9   je12emy/gsd:first_container   "node app.js"   56 seconds ago   Up 50 seconds             web.5.xhb6zc3kus2kc7xj9qodkj5z5
f0fa7a900747   je12emy/gsd:first_container   "node app.js"   17 minutes ago   Up 17 minutes             web.3.vfpa9v24z30tp1o6r6z636krm
972c5787f4f2   je12emy/gsd:first_container   "node app.js"   17 minutes ago   Up 17 minutes             web.1.o6wn2h884egfivvkzdfch8o4b
dab95b9592b7   je12emy/gsd:first_container   "node app.js"   17 minutes ago   Up 17 minutes             web.2.r1vg26rkk6oh3g2pzpkjab8gw
```

## Multi-container APps with Docker Stacks

Let's do that again in a declarative way with a `.yml` file, first lets clean clean the the running services with `docker service rm`.

```
docker service rm web
web
```

Let's use the app located in the `swarm-stack`, in here the `docker-compose.yml` is pretty similar to the one before. In here stacks **do not allow creating images on the fly**, which means the images need to be published on a container registry so all nodes may pull it.


```yml
version: "3.8"
services:
  web-fe:
    image: nigelpoulton/gsd:swarm-stack <-- Download the image from dockerhub
    command: python app.py
    deploy:
      replicas: 10 <-- Specify how many replicas we want.
    ports:
      - target: 8080
        published: 5000
    networks:
      - counter-net
    volumes:
      - type: volume
        source: counter-vol
        target: /code
  redis:
    image: "redis:alpine"
    networks:
      counter-net:

networks:
  counter-net:

volumes:
  counter-vol:
```

Let's build this image and publish it to our repo.

```
docker image build -t je12emy/gsd:swarm-stack .
docker image push je12emy/gsd:swarm-stack
```

Let's deploy this stack.

```
docker stack deploy -c docker-compose.yml counter
Creating network counter_counter-net
Creating service counter_web-fe
Creating service counter_redis
```

We chan check this stack with the following command.

```
docker stack ls
NAME      SERVICES   ORCHESTRATOR
counter   2          Swarm
```
Check the stack's service.

```
docker stack services counter
ID             NAME             MODE         REPLICAS   IMAGE                     PORTS
11ku85fch6wd   counter_redis    replicated   1/1        redis:alpine
mh5c7t4391pb   counter_web-fe   replicated   10/10      je12emy/gsd:swarm-stack   *:5000->8080/tcp
```

And check each container in this stack.

```
docker stack ps counter
ID             NAME                IMAGE                     NODE      DESIRED STATE   CURRENT STATE                ERROR     PORTS
awtk7w04vtun   counter_redis.1     redis:alpine              pop-os    Running         Running about a minute ago
uar6jaghmi00   counter_web-fe.1    je12emy/gsd:swarm-stack   pop-os    Running         Running about a minute ago
hrry00boyznf   counter_web-fe.2    je12emy/gsd:swarm-stack   pop-os    Running         Running about a minute ago
zm7p34t8gnli   counter_web-fe.3    je12emy/gsd:swarm-stack   pop-os    Running         Running about a minute ago
uqkppb3yo1rc   counter_web-fe.4    je12emy/gsd:swarm-stack   pop-os    Running         Running about a minute ago
wo38jdbndbhh   counter_web-fe.5    je12emy/gsd:swarm-stack   pop-os    Running         Running about a minute ago
5czgmtmhj2jq   counter_web-fe.6    je12emy/gsd:swarm-stack   pop-os    Running         Running about a minute ago
1wq3fax60ybk   counter_web-fe.7    je12emy/gsd:swarm-stack   pop-os    Running         Running about a minute ago
1mrr7vy70sav   counter_web-fe.8    je12emy/gsd:swarm-stack   pop-os    Running         Running about a minute ago
tsa67tvuv5ic   counter_web-fe.9    je12emy/gsd:swarm-stack   pop-os    Running         Running about a minute ago
98fxzm8a8xhr   counter_web-fe.10   je12emy/gsd:swarm-stack   pop-os    Running         Running about a minute ago
```

Check this app in `localhost:500`, the container id will change and requests are balanced between containers in the stack. A recomended way to alter the stack would be to alter this `docker-compose.yml` and changing the desired change, run the deploy command and docker will update the stack as needed.

Shutdown this stack with the following command,

```
docker stack rm counter
Removing service counter_redis
Removing service counter_web-fe
Removing network counter_counter-net
```
