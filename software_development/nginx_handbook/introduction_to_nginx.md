# Introduction to NGINX

NGINX is a web server designed from the ground with a focus on high performance, high concurrency and low resource usage, though mostly known as a web server at its core NGINX is a reverse proxy server. Though not the only web server on the market, one of it's biggest competitors Apache HTTP Server (httpd) was first released on 1995, though most admins favor NGINX due to two main reasons:

* It can handle a higher number of concurrent requests.
* It has faster static content delivery with a low resource usage.

Here are two awesome quotes regarding Nginx's inner workings

> Nginx was designed from the ground up to use an asynchronous, non-blocking, event-driven connection handling algorithm.

> Nginx spawns worker processes, each of which can handle thousands of connections. The worker processes accomplish this by implementing a fast looping mechanism that continuously checks for and processes events. Decoupling actual work from connections allows each worker to concern itself with a connection only when a new event has been triggered.

- [Justin Ellingwood](https://www.digitalocean.com/community/tutorials/apache-vs-nginx-practical-considerations)

Let's dive into NGINX's inner workings, it is faster in _static content delivery_ while staying light on resource usage because it **doesn't embed a dynamic programming language processor**. When a request for static content comes, NGINX simply responds with the file without any additional processes.

This doesn't mean that NGINX can't handle a request which requires a dynamic programming language processor, in these cases it will simply delegate the task to separate processes such has Node.js. Once this process is done, NGINX proxies the response back to the client.

![NGINX Proxy](https://www.freecodecamp.org/news/content/images/2021/04/_nT7rcdjG.png)

Its configuration is rather easy, with a syntax inspired by other scripting languages, this results in compact and easily maintainable configuration files.
