# Apache load balancer segfault case

Original ticket: https://bz.apache.org/bugzilla/show_bug.cgi?id=59864

Description: when there are multiple backends in the load balancer, and some of the backends reference each other as backup backends, HTTPD may run into infinite recurssion.

Effect: This will cause segmentation fault, and all other running requests within the same HTTPD worker will drop connection.

## Generate config files

Assume we are in the orbit root directory. Run the following to generate the config files that can trigger the issue.
```bash
cd apps/httpd/
./gen_config.sh $PWD/rel-watchdog/ $PWD/config-appendix-segfault
./gen_config.sh $PWD/rel-orig/ $PWD/config-appendix-segfault
```
Note that the config files could be overwritten when running other evaluation tasks. Therefore, re-run the above commands every time before running the reproduction commands below.

## Reproducing original issue

First start the Apache server that reverted the fix.
```bash
systemctl stop nginx
module load httpd/segfault
apachectl -k start
```

Start a simple python3 backend server:
```bash
mkdir -p /tmp/www; cd /tmp/www; echo hello > hello; python3 -m http.server 1115
```

In one tmux pane, continuously issue normal GET requests.
```bash
while curl localhost:8080/hello/hello; do true; done
```

In another tmux pane, run the following command to make a problematic request that triggers one segfault:
```bash
curl -H 'Cookie: ROUTEID=.fe02' localhost:8080/somepath/index.html
```
This command will fail with curl error message:
```
curl: (52) Empty reply from server
```

Meanwhile, the `while` loop in the first pane will also show a curl error message (this may need several trials of the second-pane command to show up):
```
curl: (52) Empty reply from server
```
which should not occur since those normal request are not problematic.

Stop Apache by running
```bash
apachectl -k stop
```

## Isolation with orbit

First start the orbit version Apache server.
```bash
module unload httpd
systemctl stop nginx
module load httpd/proxy
apachectl -k start
```

Same as the reproduction, run the following set of commands separately.
```bash
mkdir -p /tmp/www; cd /tmp/www; echo hello > hello; python3 -m http.server 1115
```

```bash
while curl localhost:8080/hello/hello; do true; done
```

```bash
curl -H 'Cookie: ROUTEID=.fe02' localhost:8080/somepath/index.html
```

Each time the problematic request triggers a segfault, Apache will return "503 Service Unavailable" instead of resulting a curl error. It will also not affect the correct requests in the `while` loop. Then orbit is re-spawned, and all requests proceeds as normal.

Stop Apache server by running
```bash
apachectl -k stop
killall -9 httpd
```
