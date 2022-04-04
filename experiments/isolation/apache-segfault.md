# Apache load balancer segfault case

Original ticket: https://bz.apache.org/bugzilla/show_bug.cgi?id=59864

Description: when there are multiple backends in the load balancer, and some of the backends reference each other as backup backends, HTTPD may run into infinite recurssion.

Effect: This will cause segmentation fault, and all other running requests within the same HTTPD worker will drop connection.

## Reproducing original issue

First start the Apache server that reverted the fix.
```bash
module load httpd/segfault
apachectl -k start
```

Start a simple python3 backend server:
```bash
mkdir -p /tmp/www; cd /tmp/www; echo hello > hello
python3 -m http.server 1115
```

In one tmux pane, run the following command to continuously issue simple GET requests.
```bash
while curl localhost:8088/hi/hello; do true; done
```

In another tmux pane, run the following command to trigger one segfault:
```bash
curl -H 'Cookie: ROUTEID=.fe02' localhost:8088/images/a
```

The first command line will show a failed request with curl message:
```
curl: (52) Empty reply from server
```

Stop Apache by running
```bash
apachectl -k stop
```

## Isolation with orbit

First start the orbit version Apache server.
```bash
module unload httpd
module load httpd/proxy
apachectl -k start
```

Same as the reproduction, run the following set of commands separately.
```bash
mkdir -p /tmp/www; cd /tmp/www; echo hello > hello
python3 -m http.server 1115
```

```bash
while curl localhost:8088/hi/hello; do true; done
```

```bash
curl -H 'Cookie: ROUTEID=.fe02' localhost:8088/images/a
```

Each time the last command trigger a segfault, the server will be unresponsive for a short time. Then orbit is re-spawned, and all requests proceeds as normal.

Stop Apache server by running
```bash
apachectl -k stop
killall -9 httpd
```
