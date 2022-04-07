#!/usr/bin/bash
PID_file="/home/uriel/workspace/werc-1.5.0/bin/pid"
start() {
	PID_spawn="$(/usr/bin/spawn-fcgi -a 127.0.0.1 -p 9000 -f /usr/sbin/fcgiwrap)"
  echo "$PID_spawn" > "$PID_file"
}

stop() {
	kill -15 "$(cat "$PID_file")"
}

case $1 in
  start|stop) "$1" ;;
esac


