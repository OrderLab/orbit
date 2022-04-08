# Nginx WebDAV segfault case

Original ticket: https://trac.nginx.org/nginx/ticket/238

Description: When issuing a PUT request with empty HTTP body to a WebDAV location, Nginx will segmentation fault due to NULL pointer dereference. The reason is the lack of NULL pointer check in WebDAV PUT handler.

Effect: This not only affects the PUT request itself, but also affects other running requests inside the same nginx worker.

## Reproducing original issue

First start the Nginx server version that reverted the fix in the ticket.
```bash
systemctl stop nginx
module load nginx/segfault
nginx
```

In one tmux pane, run the following command to continuously issue simple GET requests. This loop will stop once `curl` returns error.
```bash
while curl -sS localhost/ > /dev/null; do echo -n; done
```

In another tmux pane, run the following payload that can trigger the segfault.
```bash
while ! curl -I -X PUT http://127.0.0.1/dd/a.txt; do echo -n; done
```

Soon after the second `while` loop starts running, the first pane should have stopped the loop, with error message showing:
```
curl: (56) Recv failure: Connection reset by peer
```

This shows that the segfault can affects other requests within the same nginx worker.

Stop nginx by running
```bash
nginx -s stop
```

## Isolation with orbit

First start the orbit version Nginx server.
```bash
module unload nginx
systemctl stop nginx
module load nginx/orbit
nginx
```

In one tmux pane, run
```bash
while curl -sS localhost/ > /dev/null; do echo -n; done
```

In another tmux pane, run
```bash
while curl -sS -X PUT http://127.0.0.1/dd/a.txt > /dev/null; do echo -n; done
```

Both loops should be able to run for a long period of time. Each time the second command triggers a segfault, the server will be non-responsive for a short period of time. Then the orbit will be re-spawned, and all requests can proceed as normal.

Stop Nginx by running
```bash
nginx -s stop
killall -9 nginx  # to also stop orbit instance
```
