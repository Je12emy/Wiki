# How to Optimize NGINX for Maximum Performance

Running NGINX is very specific to each application, but these are some general configurations.

## How to Configure Worker Processes and Worker Connections

The amount of spawned processes can be modified with the following change on the configuration file.

```
worker_processes 2;

events {

}

http {

    server {

        listen 80;
        server_name nginx-handbook.test;

        return 200 "worker processes and worker connections configuration!\n";
    }
}
```

Though this is a simple change, determining the optimal number of workers is far more complicated. The worker processes are asynchronous in nature, which means they will process incoming requests as fast as the hardware can.

> Now consider that your server runs on a single core processor. If you set the number of worker processes to 1, that single process will utilize 100% of the CPU capacity. But if you set it to 2, the two processes will be able to utilize 50% of the CPU each. So increasing the number of worker processes doesn't mean better performance.

A good rule is the to keep the amount of CPU cores and the worker processes equal.

```
number of worker process = number of CPU cores
```

The number of cores can be determined like so in Linux.

```bash
nproc

# 1
```

If we were to vertically scale our server then would need to update our config manually, we can ask NGINX to follow the previous formulla on it's own.

```
worker_processes auto;

events {}

http {
        include /etc/nginx/mime.types;

        upstream backend_servers {
                server localhost:3001;
                server localhost:3002;
                server localhost:3003;
        }

        server {
                listen 80;
                server_name nginx-handbook.test;

                location / {
                    proxy_pass http://backend_servers;
                }
        }
}
```

And if we check the process we will see the amount of processes running.

```bash
sudo systemctl status nginx

# ● nginx.service - A high performance web server and a reverse proxy server
#      Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
#      Active: active (running) since Tue 2022-02-22 19:11:36 UTC; 4min 25s ago
#        Docs: man:nginx(8)
#    Main PID: 665 (nginx)
#       Tasks: 2 (limit: 1131)
#      Memory: 3.0M
#      CGroup: /system.slice/nginx.service
#              ├─ 665 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
#              └─1929 nginx: worker process <-- Just 1 worker process
```

There's also the worker connection, it indicates the highest number of connections **a single worker process can handle**. This number is also related to the number of CPU cores on the server and the number of files the OS is allowed to open per core.

```bash
ulimit -n

# 1024
```

This directive goes inside the `events` context.

```
worker_processes auto;

events {
        worker_connections 1024;
}

http {
        include /etc/nginx/mime.types;

        upstream backend_servers {
                server localhost:3001;
                server localhost:3002;
                server localhost:3003;
        }

        server {
                listen 80;
                server_name nginx-handbook.test;

                location / {
                    proxy_pass http://backend_servers;
                }
        }
}
```

Remember the `events` context is used for setting values used by NGINX on a general level.

**Unfinished**
