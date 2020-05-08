#! /bin/sh

openssl genrsa -out $3 1024
openssl x509 -signkey $3 -inform der -in $1 -outform der -out tmp.der
openssl x509 -signkey $3 -x509toreq -inform der -in tmp.der -out tmp.csr
openssl x509 -req -days 365 -in tmp.csr -signkey $3 -out $2
rm tmp.der tmp.csr
