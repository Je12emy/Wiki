# How to use NGINX as a Load Balancer

Thanks to NGINX's design it can be easily configured as a load balancer. On the included demo projects you will find the directory `load-balancer-demo` and run the following commands.

```bash
pm2 start /srv/nginx-handbook-projects/load-balancer-demo/server-1.js
pm2 start /srv/nginx-handbook-projects/load-balancer-demo/server-2.js
pm2 start /srv/nginx-handbook-projects/load-balancer-demo/server-3.js
```

Now update the NGINX configuration like so:

```
events {
}

http {

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

The configuration inside the `upstream` context is a collection of servers that **can be treated as a single backend**, to test this out run the following script inside the server.

```bash
while sleep 0.5; do curl http://nginx-handbook.test; done
```
