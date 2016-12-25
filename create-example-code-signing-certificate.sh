#!/bin/bash
set -eux

ca_file_name=example-code-signing-ca
ca_common_name='Example Code Signing CA'

file_name=example-code-signing
common_name='Rui Lopes'
email_address='rgl@example.com'

# create code signing CA certificate.
openssl genrsa \
    -out $ca_file_name-keypair.pem \
    2048 \
    2>/dev/null
chmod 400 $ca_file_name-keypair.pem
openssl req -new \
    -sha256 \
    -subj "/CN=$ca_common_name" \
    -key $ca_file_name-keypair.pem \
    -out $ca_file_name-csr.pem
openssl x509 -req -sha256 \
    -signkey $ca_file_name-keypair.pem \
    -extensions a \
    -extfile <(echo "[a]
        basicConstraints=critical,CA:TRUE,pathlen:0
        keyUsage=critical,digitalSignature,keyCertSign,cRLSign
        ") \
    -days 365 \
    -in  $ca_file_name-csr.pem \
    -out $ca_file_name-crt.pem
openssl x509 -noout -text -in $ca_file_name-crt.pem

# create code signing certificate.
openssl genrsa \
    -out $file_name-keypair.pem \
    2048 \
    2>/dev/null
chmod 400 $file_name-keypair.pem
openssl req -new \
    -sha256 \
    -subj "/CN=$common_name/emailAddress=$email_address" \
    -key $file_name-keypair.pem \
    -out $file_name-csr.pem
openssl x509 -req -sha256 \
    -CA $ca_file_name-crt.pem \
    -CAkey $ca_file_name-keypair.pem \
    -CAcreateserial \
    -extensions a \
    -extfile <(echo "[a]
        keyUsage=critical,digitalSignature
        extendedKeyUsage=critical,codeSigning
        ") \
    -days 365 \
    -in  $file_name-csr.pem \
    -out $file_name-crt.pem

# import into a new keychain.
# TODO only allow /usr/bin/codesign to access the private key.
certtool i $file_name-crt.pem k=$file_name.keychain r=$file_name-keypair.pem c p=password
security list-keychains -d user -s login.keychain $file_name.keychain
security show-keychain-info $file_name.keychain

# add the CA to the System keychain as a trusted root.
# NB this is not really needed for signing, only to verifying.
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain $ca_file_name-crt.pem
