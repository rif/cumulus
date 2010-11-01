#!/usr/bin/env sh

USER=horia
HOST=loose.upt.ro
PORT=22022
DEST=public_html

rm cumulodata.zip
zip -9r cumulodata.zip cumulodata/ && shasum cumulodata.zip|sed 's/\([a-z0-9]*\).*/\1/' > version.txt && scp -P$PORT cumulodata.zip version.txt $USER@$HOST:$DEST/

