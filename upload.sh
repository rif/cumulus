zip -9r cumulodata.zip cumulodata/ && mv cumulodata.zip ~/Sites/ && shasum ~/Sites/cumulodata.zip|sed 's/\([a-z0-9]*\).*/\1/' > ~/Sites/version.txt

