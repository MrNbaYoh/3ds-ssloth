# SSLoth

SSLoth is an "exploit" for the SSL system module of the Nintendo 3DS.  
It makes it possible for anyone to create fake certificates for Nintendo 3DS servers, thus allowing to spoof official servers and perform MitM attacks.

## How does it work?

It is quite simple. Before version 9217, the SSL system module does not validate the certificate signatures when validating a certificate chain. Consequently, anyone can generate private/public key pairs and create their own CA certificates from already existing ones.

## Affected versions

| Firmware | Version | N3DS/N2DS | O3DS/2DS |
| --- | --- | --- | --- |
| SAFE_FIRM | all  | ✓ | ✓ |
| NATIVE_FIRM | 1.0-11.13 | ✓ | ✓ |
| NATIVE_FIRM | > 11.13  | ✗ | ✗ |

## How do I create my own certificates?

This section describes how to create a fake CA which can then be used to fake sign your own children certificates.  
You need:
- OpenSSL
- shell

Then execute this command:
```
sh make_fake_ca.sh <input_certificate> <output_certificate> <output_key_file> <key_size> <days>
```

with:
- `input_certificate`: path to the original CA certificate
- `output_certificate`: path for the newly created CA certificate
- `output_key_file`: path for the generated private RSA key of the newly created CA certificate
- `key_size`: size in bits of the generated private RSA key
- `days`: period of validity (in days) of the created CA certificate
