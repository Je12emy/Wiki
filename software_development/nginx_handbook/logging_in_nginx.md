# Logging in NGINX

Log files are stores by default at `/var/log/nginx`.

```bash
ls -lh /var/log/nginx/

# -rw-r----- 1 www-data adm     0 Apr 25 07:34 access.log
# -rw-r----- 1 www-data adm     0 Apr 25 07:34 error.log
```

Let's clear out those logs.

```bash
# delete the old files
sudo rm /var/log/nginx/access.log /var/log/nginx/error.log

# create new files
sudo touch /var/log/nginx/access.log /var/log/nginx/error.log

# reopen the log files
sudo nginx -s reopen
```

> If you do not dispatch a reopen signal to NGINX, it'll keep writing logs to the previously open streams and the new files will remain empty.

To generate a new entry, let's access our server.

```bash
curl -I http://nginx-handbook.test

# HTTP/1.1 200 OK
# Server: nginx/1.18.0 (Ubuntu)
# Date: Sun, 25 Apr 2021 08:35:59 GMT
# Content-Type: text/html
# Content-Length: 960
# Last-Modified: Sun, 25 Apr 2021 08:35:33 GMT
# Connection: keep-alive
# ETag: "608529d5-3c0"
# Accept-Ranges: bytes
```

If we check the contents of `access.log`, any request to the server will be logged into this file by default.

```
cat /var/log/nginx/access.log
192.168.20.1 - - [18/Feb/2022:20:38:27 +0000] "GET / HTTP/1.1" 200 960 "-" "curl/7.74.0"
```

However, we can change this behavior in the configuration with the `access_log` directive.

```
server {
    listen 80;
    server_name nginx-handbook.test;
    
    location = / {
        return 200 "This will be logged to the default file\n";
    }
    
    location = /admin {
        access_log /var/logs/nginx/admin.log;
        return 200 "This will be logged to the admin log file\n";
    }
    
    location = /no_logging {
        access_log off;
        return 200 "This will not be logged\n";
    }
}
```

If we visit each resource, the access log files for each specified location will be populated. The error log however is only populated if we trigger an error in nginx, an invalid configuration is enough. The error logs have different error messages.

* `debug`: Useful debugging information to help determine where the problem lies.
* `info`: Informational messages that aren't necessary to read but may be good to know.
* `notice`: Something normal happened that is worth noting.
* `warn`: Something unexpected happened, however is not a cause for concern.
* `error`: Something was unsuccessful.
* `crit`: There are problems that need to be critically addressed.
* `alert`: Prompt action is required.
* `emerg`: The system is in an unusable state and requires immediate attention.

By default, all these error messages are logged, we can set the minimum level message to be warned like so:

```
 server {

        listen 80;
        server_name nginx-handbook.test;
	
    	error_log /var/log/error.log warn;

        return 200 "..." "...";
    }
```
