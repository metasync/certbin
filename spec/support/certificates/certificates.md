# Notes on Sample Certificates

This folder contains sample certificates for test purpose. Dont use them in any production environments. 

## Generate certificate in pfx format

Run the following command to generate certificate in crt format into pfx format:

```
openssl pkcs12 -export -out alice.pfx -inkey alice.key -in alice.crt -certfile ca.crt
```
Then you will be prompted to input password ("certman"). This password is used to protect the pfx certifcate generated
