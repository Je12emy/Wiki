# Introduction to NGINX Configuration Files

As a web server, NGINX's job is to serve static or dynamic content to the client, how that content is going to be served is usually controlled by configuration files. These configuration files end with the extension `.conf`, and they decide inside the `/etc/nginx` directory.

```
.
├── conf.d
├── fastcgi.conf
├── fastcgi_params
├── koi-utf
├── koi-win
├── mime.types
├── modules-available
├── modules-enabled
│   ├── 50-mod-http-image-filter.conf -> /usr/share/nginx/modules-available/mod-http-image-filter.conf
│   ├── 50-mod-http-xslt-filter.conf -> /usr/share/nginx/modules-available/mod-http-xslt-filter.conf
│   ├── 50-mod-mail.conf -> /usr/share/nginx/modules-available/mod-mail.conf
│   └── 50-mod-stream.conf -> /usr/share/nginx/modules-available/mod-stream.conf
├── nginx.conf
├── proxy_params
├── scgi_params
├── sites-available
│   └── default
├── sites-enabled
│   └── default -> /etc/nginx/sites-available/default
├── snippets
│   ├── fastcgi-php.conf
│   └── snakeoil.conf
├── uwsgi_params
└── win-utf

6 directories, 18 files
```

In here we will find the ´nginx.conf´ which contains the main configuration file, it's a bit lengthy so start off with an empty configuration.

```bash
sudo mv nginx.conf nginx.conf.backup
sudo touch nginx.conf
```
