# Deploying a Containerized App

In this module we will see how to package our application, upload an image into a container registry and run our container.

## Warp Speed Run-through

The aim here is just to grasp the basic flow with Docker, we will be going step by step on the other sections. Here we will take some source code, package it into a single image, upload it into a container registry and run this image in a container. Try just to watch for now.

-   With a `DockerImage` we pull all the needed dependencies and package our application.
-   We push our image into a container registry like Dockerhub.
-   With `docker container run` we run our image in a container, which should be available in `localhost`

> Simple is the new normal with Docker

## Containerizing an App

The app we are building is a Linux app, on Windows we need to switch to Linux containers. We will find some pre made apps in [this Github repository](https://github.com/nigelpoulton/gsd), since Docker is language agnostic we don't need to worry about code. For our first app we just need to worry about the port our app listens to. The `Dockerfile` is composed of a set of steps for building an image for our application with all it's dependencies so we can share it and run it. Let's take a look at this `Dockerfile`

This image is build using a special container image with Nodejs tools which we will use as a base for our image, this is not a complete Linux distribution with a kernel, it's more like a set of file system constructs which uses the host's kernel.

```dockerfile
FROM node:current-alpine
```

Next we setup some metadata about this image's author.

```dockerfile
LABEL org.opencontainers.image.title="Hello Docker Learners!" \
      org.opencontainers.image.description="Web server showing host that responded" \
      org.opencontainers.image.authors="@nigelpoulton"
```

Next we run a Unix command, where we create a new directory.

```dockerfile
RUN mkdir -p /usr/src/app
```

Next we copy our application's source code into the directory we just created. Here the `.` means we will copy all files and subdirectories from whenever we run the build command.

```dockerfile
COPY . /usr/src/app
```

Next we set the working directory onto where we copied the app.

```dockerfile
WORKDIR /usr/src/app
```

Next the install the project's dependencies with Nodejs' package manager.

```dockerfile
RUN npm install
```

Finally we pass the command to startup our application.

```dockerfile
ENTRYPOINT ["node", 'app.js']
```

To build this image, move into the direcotry with the application's source code and run the following command.

```sh
docker image build -t je12emy/dgs:first_container .
```

In here there are a few considerations:

-   The `-t` flag allows us to tag our image with a name.
-   The tag we provide to our image should align with our Dockerhub id, this will allow us to upload this image.
-   The `.` is needed to run this build command in the current working directory.

When we run this command docker goes through each instruction in the Dockerfile, we may list all the available images with `docker image ls`.

```
docker image ls
REPOSITORY    TAG               IMAGE ID       CREATED         SIZE
je12emy/gsd   first_container   4db286da13f9   3 minutes ago   124MB
node          current-alpine    996519d8e181   8 hours ago     112MB
hello-world   latest            d1165f221234   5 months ago    13.3kB
```

## Hosting on a Registry

In the real world we may want to host our images somewhere else, in order to share it and run it in other environments, this is where container registries like Dockerhub are useful. If we used our own Dockerhub id when we tagged our image, we are able to push directly into Duckerhub. First we may need to login by using `docker login`, afterwards we may push this image by using `docker image push`.

```
docker image push je12emy/gsd:first_container
The push refers to repository [docker.io/je12emy/gsd]
68c974b385f9: Pushed
9f6f5fac5bb4: Pushed
bcd8b3c45710: Pushed
7f7248f9f3be: Mounted from library/node
e3fd12a6db37: Mounted from library/node
021cb993e87c: Mounted from library/node
b2d5eeeaba3a: Mounted from library/node
first_container: digest: sha256:25df283a6650b15ea4d6de5833c99ea6a649819cda6e29020e602b8bb0dd1050 size: 1785
```

If we check our Dockerhub repositories, we will see the repository has already been created.

## Running a Containerized App

Think of an image as a stopped container, and thus a container is a running image. To run our image use the following command.

```
docker container run -d --name web -p 8000:8080 je12emy/gsd:first_container
9332d7c6338285db179a4d8953a4e0cb992d3f671444a3a0709e2d826b8e8d75
```

In this command there are some considerations.

-   The `-d` flag instructs the container to run in the background in detached mode.
-   The `-p` allows us to map a port on our local machine with the container, in here we should map a port with the one the application is listening to.
-   Docker is opinionated, if we don't give it a specific URL, it will asume we should pull the image directly from Dockerhub.

When can check which containers are currently running with `docker ps` or `docker container ls`

```
docker container ls
CONTAINER ID   IMAGE                         COMMAND         CREATED         STATUS         PORTS                                       NAMES
9332d7c63382   je12emy/gsd:first_container   "node app.js"   2 minutes ago   Up 2 minutes   0.0.0.0:8000->8080/tcp, :::8000->8080/tcp   web
```

We can also check this app in our browser, just visit `localhost:8000`.

## Managing a Containerized App

We now have what we may call a "Containerized App", which is like a super lightweight virtual machine.

> An application that runs inside a container.

To stop a container use the stop command, where we can either pass the container's id or name, this may take a bit to allow the app inside to gracefully shutdown.

```
docker container stop web
```

If we list our running container with the `-a` flag we will see the containers which where recently shutdown.

```
docker container ls -a
CONTAINER ID   IMAGE                         COMMAND         CREATED          STATUS                            PORTS     NAMES
9332d7c63382   je12emy/gsd:first_container   "node app.js"   10 minutes ago   Exited (137) About a minute ago             web
```

With can restart the application with the start command.

```
docker container start web
web
```

And we will see it in our running container.s

```
docker container ls
CONTAINER ID   IMAGE                         COMMAND         CREATED          STATUS         PORTS                                       NAMES
9332d7c63382   je12emy/gsd:first_container   "node app.js"   11 minutes ago   Up 3 seconds   0.0.0.0:8000->8080/tcp, :::8000->8080/tcp   web
```

We can delete a container by using the `rm` command, though we first need to stop it.

```
docker container rm web
web
```

This means it will not even show up when we list all our containers.

```
docker container ls -a
CONTAINER ID   IMAGE         COMMAND    CREATED        STATUS                    PORTS     NAMES
5017c886a614   hello-world   "/hello"   21 hours ago   Exited (0) 21 hours ago             condescending_benz
d9cfcdd76f65   hello-world   "/hello"   21 hours ago   Exited (0) 21 hours ago             frosty_newton
```

When we ran this container we used the `-d` flag to run this container detached from our terminal in the background. There are cases on which we may want to run a container attached to our terminal. In this case we will use the `-it` flag which stands for "interactive" and "terminal", we will create this container based on the [alpine](https://hub.docker.com/_/alpine/) image and we will run sh inside this container.

```
docker container run -it --name test alpine sh
Unable to find image 'alpine:latest' locally
latest: Pulling from library/alpine
29291e31a76a: Pull complete
Digest: sha256:eb3e4e175ba6d212ba1d6e04fc0782916c08e1c9d7b45892e9796141b1d379ae
Status: Downloaded newer image for alpine:latest
```

This will change our shell, and we will be inside our container where we may run any commands.

```
# ls
bin    dev    etc    home   lib    media  mnt    opt    proc   root   run    sbin   srv    sys    tmp    usr    var
```

In this container, if we run `exit`, this will exit the container and kill the container.

```
docker container ls -a
CONTAINER ID   IMAGE         COMMAND    CREATED         STATUS                      PORTS     NAMES
0a20e516ee84   alpine        "sh"       4 minutes ago   Exited (0) 23 seconds ago             test
```

We may also exit from this container without killing it, by pressing `CTL + P + Q`, in case we want to kill the container without stopping it first, use the `-f` flag on the remove command.

```
docker container ls -a
CONTAINER ID   IMAGE         COMMAND    CREATED         STATUS                      PORTS     NAMES
0a20e516ee84   alpine        "sh"       4 minutes ago   Exited (0) 23 seconds ago             test
```

## Recap

-   Containers are the future for virtualization, they virtualise operating system, where each container is it's own OS, they are smaller and faster than regular virtual machines.
-   Containers allow developers to develop apps locally with the security they will work on production.
