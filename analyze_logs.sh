#!/bin/bash

gen() {
  ips=(192.168.1.10 10.0.0.5 172.16.0.3 192.168.1.20 10.0.0.9 203.0.113.7)
  m=(GET POST PUT DELETE)
  p=(/api/users /api/login /api/orders /api/items /health /api/search)
  c=(200 200 200 201 204 301 400 401 403 404 500 502 503)

  : > $f
  for i in {1..400}; do
    ip=${ips[$((RANDOM % ${#ips[@]}))]}
    mm=${m[$((RANDOM % ${#m[@]}))]}
    pp=${p[$((RANDOM % ${#p[@]}))]}
    cc=${c[$((RANDOM % ${#c[@]}))]}
    s=$((i % 60))
    printf '%s - - [15/Aug/2026:10:15:%02d] "%s %s HTTP/1.1" %s\n' "$ip" "$s" "$mm" "$pp" "$cc" >> $f
  done

  echo "File '$f' has been generated"
}

if [ "$1" = "-g" ]; then
  f=access.log
  gen
elif [ -f "$1" ]; then
  f=$1
else
  echo "Usage: $0 -g | <log file path>"
  exit 1
fi

echo -n "Total requests: "
grep -cE '^([0-9]{1,3}\.){3}[0-9]{1,3} ' $f

echo "Top 3 IPs:"
grep -oE '^([0-9]{1,3}\.){3}[0-9]{1,3}' $f | sort | uniq -c | sort -rn | head -3

echo -n "4xx and 5xx requests: "
awk '$NF ~ /^[45][0-9][0-9]$/' $f | wc -l
