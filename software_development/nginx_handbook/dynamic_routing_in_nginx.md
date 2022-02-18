# Dynamic Routing in Nginx

Our configuration so far is a very simple static content server configuration, we are matching a file from the site root corresponding to the URL in the client visits and respond back. If the client asks for `index.html`, `about.html` or `mini.min.css` our server will respond with the file. If we were to visit `/nothing` our server would respond with the default 404 pages

## Location Matches

We will now use the `location` directive in our configuration like so:

```
server {

        listen 80;
        server_name nginx-handbook.test;

        location /agatha {
            return 200 "Miss Marple.\nHercule Poirot.\n";
        }
    }
```

Now if we were to visit `http://nginx-handbook.test/agatha` we will receive a 200 Ok response with the specific message, the `location` context is usually nested inside a `server` block and there can be multiple `locations` contexts. 

```
curl -i http://nginx-handbook.test/agatha
HTTP/1.1 200 OK
Server: nginx/1.18.0 (Ubuntu)
Date: Fri, 18 Feb 2022 15:53:48 GMT
Content-Type: text/plain
Content-Length: 29
Connection: keep-alive

Miss Marple.
Hercule Poirot.
```

If we were to visit `http://nginx-handbook.test/agatha-chistie` we would receive the same response.

```
curl -i http://nginx-handbook.test/agatha-christie
HTTP/1.1 200 OK
Server: nginx/1.18.0 (Ubuntu)
Date: Fri, 18 Feb 2022 15:53:54 GMT
Content-Type: text/plain
Content-Length: 29
Connection: keep-alive

Miss Marple.
Hercule Poirot.
```

This happens because where are telling nginx to match any URI starting with "agatha" with this response, this is known as a **prefix match**. To perform an **exact match** we do the following.


```
server {

        listen 80;
        server_name nginx-handbook.test;

        location = /agatha {
            return 200 "Miss Marple.\nHercule Poirot.\n";
        }
    }
```

Another kind of matching is known as **regex matching**, here we match our location URLs against regex regular expressions.

```
server {

        listen 80;
        server_name nginx-handbook.test;

        location ~ /agatha[0-9] {
            return 200 "Miss Marple.\nHercule Poirot.\n";
        }
    }
```

Here we can visit `/agatha` of `/agatha` filled by any number from 0 to 9.

```
curl -i http://nginx-handbook.test/agatha2
HTTP/1.1 200 OK
Server: nginx/1.18.0 (Ubuntu)
Date: Fri, 18 Feb 2022 16:06:15 GMT
Content-Type: text/plain
Content-Length: 29
Connection: keep-alive

Miss Marple.
Hercule Poirot.
```

The regex matches are case-sensitive, in order to turn them into case-insensitive we insert an asterisk before the tilde.

```
location *~ /agatha[0-9] {
    return 200 "Miss Marple.\nHercule Poirot.\n";
}
```

We can now capitalize any word in our request.

```
curl -i http://nginx-handbook.test/Agatha2
HTTP/1.1 200 OK
Server: nginx/1.18.0 (Ubuntu)
Date: Fri, 18 Feb 2022 16:10:53 GMT
Content-Type: text/plain
Content-Length: 29
Connection: keep-alive

Miss Marple.
Hercule Poirot.
```

Nginx does apply priority to these matches and a *regex match* has a higher priority than a *prefix match*.

```
location /Agatha8 {
    return 200 "prefix matched.\n";
}

location ~* /agatha[0-9] {
    return 200 "regex matched.\n";
}
```

Here even though we match with the prefix match on `agatha8`, the regex match has a higher priority.

```
curl -i http://nginx-handbook.test/agatha8
HTTP/1.1 200 OK
Server: nginx/1.18.0 (Ubuntu)
Date: Fri, 18 Feb 2022 16:21:33 GMT
Content-Type: text/plain
Content-Length: 29
Connection: keep-alive

Miss Marple.
Hercule Poirot.
```

We can still modify this priority with a **preferential prefix match**, to turn our prefix match into a preferential match we simply use `^~`.

```
location ^~ /Agatha8 {
        	return 200 "prefix matched.\n";
}
        
location ~* /agatha[0-9] {
    return 200 "regex matched.\n";
}
```

Now we can visit the `/Agatha8` endpoint.

```
curl -i http://nginx-handbook.test/Agatha8
HTTP/1.1 200 OK
Server: nginx/1.18.0 (Ubuntu)
Date: Fri, 18 Feb 2022 16:26:53 GMT
Content-Type: text/plain
Content-Length: 16
Connection: keep-alive

prefix matched.
```

Here's a table with each match ordered by priority.


| Match               | Modifier |
|---------------------|----------|
| Exact               | =        |
| Preferential Prefix | ^=       |
| REGEX               | ~ pr ~*  |
| Prefix              | None     |


## Variables in Nginx

Variables in nginx work are similar to variables in any other programming language, we can create new variables with the `set` directive.

```
set $<variable_name> <variable_value>;

# set name "Jermy"
# set age 25
# set is_working true
```

Aside from user defined variables, there are embedded variables within NGINX modules, to see these variables in action use the following configuration.

```
events {}

http {
    listen 80;
    server_name nginx-handbook.test;
    
    return 200 "Host - $host\n $url\nArgs - $args\n";
}
```

Let's visit this site and check the embedded variables.

```
curl http://nginx-handbook.test/user?name=Jeremy
Host - nginx-handbook.test
URI - /user
Args - name=Jeremy
```

We can also print the query variable itself

```
server {

        listen 80;
        server_name nginx-handbook.test;
        
        set $name $arg_name; # $arg_<query string name>

        return 200 "Name - $name\n";
    }
```

If we visit the site with the following query, our name will be printed.

```
curl http://nginx-handbook.test/user?name=Jeremy
Name - Jeremy
```

## Redirects and Rewrites

A redirect in Nginx is the same as redirects in any other platform, update your configuration like so:

```
server {
    listen 80;
    server_name nginx-handbook.test;
    
    root /srv/nginx-handbook-projects/static-demo;
    
    location = /index_page {
        return 307 /index.html;
    }
    
    location = /about_page {
        return 307 /about.html;
    }
}
```

If we visit the `/about_page` endpoint we will be redirected to the `about.html` resource.

```
curl -i  http://nginx-handbook.test/about_page
HTTP/1.1 307 Temporary Redirect
Server: nginx/1.18.0 (Ubuntu)
Date: Fri, 18 Feb 2022 17:43:21 GMT
Content-Type: text/html
Content-Length: 180
Location: http://nginx-handbook.test/about.html
Connection: keep-alive
```

The **rewrite** directive works differently, it changes the URI without letting the user know.

```
server {
    listen 80;
    server_name nginx-handbook.test;
    
    root /srv/nginx-handbook-projects/static-demo;
    
    rewrite /index_page /index.html
    rewrite /about_page /about.html
}
```

Now when visiting the `/about_page` endpoint, the user receives a 200 Ok and the HTML for `about.html`, also the URL on the browser does not change.

```
curl -i  http://nginx-handbook.test/about_page
HTTP/1.1 200 OK
Server: nginx/1.18.0 (Ubuntu)
Date: Fri, 18 Feb 2022 17:48:19 GMT
Content-Type: text/html
Content-Length: 960
Last-Modified: Thu, 17 Feb 2022 22:39:53 GMT
Connection: keep-alive
ETag: "620eceb9-3c0"
Accept-Ranges: bytes
```

The rewrite however is still an expensive operation

> When a rewrite happens, the server context gets re-evaluated by NGINX. So, a rewrite is a more expensive operation than a redirect.

## How to Try for Multiple Files

With the `try_files` directive we can check the existence of multiple files.


```
server {
    listen 80;
    server_name nginx-handbook.test;
    
    root /srv/nginx-handbook-projects/static-demo;
    try_fles /the-nginx-handbook.jpg /not_found
    
    location /not_found {
        return 404 "sadly, you've git a brick wall buddy!\n"
    }
}
```

With the `try_files` directive we instruct nginx to look for this file in the `root` whenever a request is received, if it doesn't exist, go the `not_found` location. Now if we visit the server, the image is returned. If we update the `try_files` directive with a non-existent file, then the `/not_found` location will be used.

This directive is mostly used along with the `$uri` variable.

```
server {
    listen 80;
    server_name nginx-handbook.test;
    
    root /srv/nginx-handbook-projects/static-demo;
    try_files $uri /not_found
    
    location /not_found {
        return 404 "sadly, you've git a brick wall buddy!\n"
    }
}
```

Now if we visit `/index.html` or `/about.html` we will be presented with each corresponding HTML, other resources will be directed to the `/not_found` location we configured. Still if we want to visit the index by just visiting `/` we need to update our configuration like so.

```
server {
    listen 80;
    server_name nginx-handbook.test;
    
    root /srv/nginx-handbook-projects/static-demo;
    try_files $uri $uri/ /not_found
    
    location /not_found {
        return 404 "sadly, you've git a brick wall buddy!\n"
    }
}
```

> By writing try_files $uri $uri/ /not_found; you're instructing NGINX to try for the requested URI first. If that doesn't work then try for the requested URI as a directory, and whenever NGINX ends up into a directory it automatically starts looking for an index.html file.
