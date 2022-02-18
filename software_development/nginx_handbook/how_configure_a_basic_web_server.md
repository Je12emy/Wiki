# How to Configure a Basic Web Server

Let's start editing our main configuration file with the best editor: vim :), add the following changes.

```
events {

}

http {

    server {

        listen 80;
        server_name nginx-handbook.test;

        return 200 "Bonjour, mon ami!\n";
    }

}
```

In here we configured NGINX to respond to return a status code 200 with a given message.

## Reloading Configuration Files

We can check whether our configuration has a valid syntax, this can be done with the included nginx binaries.

``` bash
sudo nginx -t

nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

Even if our configuration is valid, nginx won't use it. We need to instruct it to reload the configuration file. This can be done in two ways:

* Restart the NGINX service with: `sudo systemctl restart nginx`.
* Dispatch a reload signal to NGINX with: `sudo nginx -s reload`

Here the `s` flag is used to dispatch signals to NGINX, the available signals are `stop`, `quit`, `reload` and `reopen`.

## How to Understand Directives and Contexts in NGINX

The last few lines of code we wrote introduce two important concepts: directives and contexts. Everything inside a NGINX File is a **directive**, there are two types:

* Simple Directives.
* Block Directives.

**Simple directives** consist of the directive name and the space delimiter parameters, like `listen`, `return` and others. These simple directives end in semicolons. **Block directives** are similar, but they end with a pair of curly braces `{}` enclosing additional instructions.

A **block directive** capable of containing other directives inside it, is called a _context_. There are four core contexts in NGINX.

* `events`: This context is used for setting global configuration regarding how nginx is going to handle request on a general level. **There can be only one event's context on a configuration file**.
* `http`: This context is used for defining configuration regarding how the server is going to handle HTTP and HTTPS requests. **There can be only one HTTP context on a configuration file.**
* `server`: This context is nested inside the ´http´ context, and it is used for configuring specific virtual servers in a single host. **There can be multiple server contexts** nested inside the `http` context, here each server context is considered a virtual host.
* `main`: This context is the configuration file itself, anything outside the 3 previous context is on the `main` context.

Let's visit the configuration on the previous chapter.

```
events {

}

http {

    server {

        listen 80;
        server_name nginx-handbook.test;

        return 200 "Bonjour, mon ami!\n";
    }
    
    server {
        listen 8008;
        server_name nginx-handbook.test;
        
        return 200 "Hello from post 8080\n";
    }

}
```

This produces the following outputs with the `curl` command.

```
curl -i nginx-handbook.test:80
HTTP/1.1 200 OK
Server: nginx/1.18.0 (Ubuntu)
Date: Thu, 17 Feb 2022 21:59:49 GMT
Content-Type: text/plain
Content-Length: 18
Connection: keep-alive

Bonjour, mon ami!

curl -i nginx-handbook.test:8080
HTTP/1.1 200 OK
Server: nginx/1.18.0 (Ubuntu)
Date: Thu, 17 Feb 2022 21:59:51 GMT
Content-Type: text/plain
Content-Length: 21
Connection: keep-alive

Hello from port 8080
```

Here both servers are listening for requests on different ports, their numbers are defined in the `listen` directive. There's also the `server_name` directive, look at the following sample configuration.

```
http {
    server {
        listen 80;
        server_name library.test;

        return 200 "your local library!\n";
    }


    server {
        listen 80;
        server_name librarian.library.test;

        return 200 "welcome dear librarian!\n";
    }
}
```

To make this configuration work, use the following config on the hosts file.

```
http {
    server {
        listen 80;
        server_name library.test;

        return 200 "your local library!\n";
    }


    server {
        listen 80;
        server_name librarian.library.test;

        return 200 "welcome dear librarian!\n";
    }
}
```

This is the basic idea of **virtual hosts**, we are running two different applications under different server names in the same server.

```console
$ curl library.test
your local library!
$ curl librarian.library.test
welcome dear librarian!
```

## How to Server Static Content Using NGINX

The `/srv` directory is meant to contain site specific data, in here we will serve a simple static site.

```
cd /srv
sudo git clone https://github.com/fhsinchy/nginx-handbook-projects.git
```

Now we will update our nginx config to server the static assets.

```
events {}

http {
    server {
        listen 80;
        server_name nginx-handbook.test;

        root /srv/nginx-handbook-projects/static-demo/;
    }
}
```

The config looks pretty similar to what we have done before, but now we are using the `root` directive, this directive is used for **declaring the root directory for a site**. This means that we are telling NGINX to look for files inside the `/srv/nginx-handbook-projects/static-demo/` directory if any request to this specific server. Here NGINX is smart enough to server the `index.html` file by default.

```
├── about.html
├── index.html
├── mini.min.css
└── the-nginx-handbook.jpg

0 directories, 4 files
```

There's still an issue with the CSS file in this site.

## Static File Type Handling in NGINX

Let's debug this issue by sending a request to the CSS file.

```
curl -I http://nginx-handbook/mini.min.css

HTTP/1.1 200 OK
Server: nginx/1.18.0 (Ubuntu)
Date: Thu, 17 Feb 2022 22:57:25 GMT
Content-Type: text/plain <-- This
Content-Length: 46887
Last-Modified: Thu, 17 Feb 2022 22:39:53 GMT
Connection: keep-alive
ETag: "620eceb9-b727"
Accept-Ranges: bytes
```

Check the `Content-Type` response header, it says this is a `text/plain` instead of a `text/css`. This means that NGINX is serving this as a plain text files rather than a stylesheet. We can fix this with the following configuration.

```
events {

}

http {

    types {
        text/html html;
        text/css css;
    }

    server {

        listen 80;
        server_name nginx-handbook.test;

        root /srv/nginx-handbook-projects/static-demo;
    }
}
```

With the `types` block directive we configure file types, in here we tell NGINX to parse any file as `text/html` that ends with the `html` extension. However, by introducing this directive we need to specify parsing for all other file types.

# How to Include Partial Config Files

Mapping file types with the `types` context may only be viable on smaller projects, but at scale it's an error-prone solution. Nginx provides a solution for this issue. Inside the nginx directory we will find a `mime.types` with an extensive list of file format mappings. We can include this configuration in our nginx configuration.

```
http {
    
    include /etc/nginx/mime.types;

    server {

        listen 80;
        server_name nginx-handbook.test;

        root /srv/nginx-handbook-projects/static-demo;
    }
}

```
