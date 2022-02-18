# How to Use NGINX as a Reverse Proxy

When configured as a reverse proxy, NGINX sits between the client and a back end server, the client sends requests to NGINX, then NGINX passed the requests to the back end. Once the backend is done processing the request, it sends it back to NGINX and NGINX returns the response to the client.

With the following config we should be accessible to access NGINX's site.

```
events {

}

http {

    include /etc/nginx/mime.types;

    server {
        listen 80;
        server_name nginx.test;

        location / {
                proxy_pass "https://nginx.org/";
        }
    }
}
```

The `proxy_pass` directive simply passes client's request to a third party server and reverse proxies the response to the client.

## Node.js with NGINX

Serving a Node.js application follows the same principle, we will find a demo application in `/srv/nginx-handbook-projects/node-js-demo`. First start the Node.js server with `node app.js`.

```bash
curl -i localhost:3000

# HTTP/1.1 200 OK
# X-Powered-By: Express
# Content-Type: application/json; charset=utf-8
# Content-Length: 62
# ETag: W/"3e-XRN25R5fWNH2Tc8FhtUcX+RZFFo"
# Date: Sat, 24 Apr 2021 12:09:55 GMT
# Connection: keep-alive
# Keep-Alive: timeout=5

# { "status": "success", "message": "You're reading The NGINX Handbook!" }
```

We can now configure the reverse proxy on NGINX just as we did before.

```
events {

}
  
http {
    listen 80;
    server_name nginx-handbook.test

    location / {
        proxy_pass http://localhost:3000;
    }
}
```
