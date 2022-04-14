# Apache lock watchdog diagnosis

We added a newly-implemented task (t3) in Apache that periodically checks for long mutex lock waits. When a lock has been held for a period of time longer than a threshold, it will output notifications to the log.

## Producing a long holding time

We inject a 25s sleep right after a request's mutex lock has been held. For easier demonstration, we use a 10s threshold instead of the 60s mentioned in the paper.

Start the Apache server:
```bash
module load httpd/watchdog-inject
apachectl -X -k start
```

To start monitoring the logs, in another pane, run (suppose we are in the orbit root directory)
```bash
tail -f apps/httpd/rel-watchdog-inject/logs/error_log
```

Make a simple request
```bash
curl http://127.0.0.1:8080/
```
After 10s, the watchdog will find the lock has been held for too long time. The log will show information about the lock creation location and holder location:
```
orbit: counter 1 has been occupied by lock 15 for 10 checks
counter info: id=1, counter=0, holder=1
lock info: id=15, tid=309
         time=0, slotidx=1 mutex=0x7ff2fc004240
         creator = http_request.c:448:ap_process_async_request
         holder = http_request.c:449:ap_process_async_request
orbit: counter 1 has been occupied by lock 15 for 20 checks
...
```
and after another 15s, the lock will be released, and `curl` will return a webpage.

Stop by CTRL-C on the Apache server and the `cat`, and run
```bash
pkill -9 httpd
```
