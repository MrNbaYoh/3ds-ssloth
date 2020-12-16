# SSLoth

SSLoth is an "exploit" for the SSL system module of the Nintendo 3DS.  
It makes it possible for anyone to create fake certificates for Nintendo 3DS servers, thus allowing to spoof official servers and perform MitM attacks.

## Affected versions

| Firmware | Version | N3DS/N2DS | O3DS/2DS |
| --- | --- | --- | --- |
| SAFE_FIRM | all  | ✓ | ✓ |
| NATIVE_FIRM | 1.0-11.13 | ✓ | ✓ |
| NATIVE_FIRM | > 11.13  | ✗ | ✗ |

## General Q&A
#### What does it mean?
SSL/TLS are network protocols that encrypt data and ensure the authenticity of the servers you connect to. Initially, the SSL system module on 3DS did not properly verify the authenticity of servers, thus allowing attackers to spoof official servers.

#### What could an attacker actually do with SSLoth?
A lot of network services use the SSL system module on 3DS.
Here is a non-exhaustive list of what can be done:
- Spoofing game servers to exploit potential vulnerabilities in games or spy on communications.
- Spoofing eShop servers to exploit potential vulnerabilities in the eShop application, spy on commercial transactions, get users information and tokens.
- Spoofing Nintendo Network servers (Friends & ACT) to exploit potential vulnerabilities in the Friends and ACT modules, spy on communications and get users information, tokens and credentials.
- Spoofing system update servers (NIM) to exploit potential vulnerabilities in the NIM module, provide fake update packages, and bypass the system update verification.
- Spoofing any other connection that goes through the SSL system module to exploit potential vulnerabilities in client applications.

#### Should I update?
If you are neither using a custom untrusted DNS nor connected to an unknown untrusted proxy server, you are probably safe. Anyway, if you do not plan to play with SSLoth or use exploits that are based on it, or if you do not understand anything to what I am saying, you should probably update your console.
#### Can we exploit SSLoth for harmless homebrew-related reasons?
Yes of course! Here are some exploits based on SSLoth:
- [safecerthax](https://safecerthax.rocks/): a remote full chain exploit that uses old vulnerabilities in the SAFE_FIRM to get ARM9 and ARM11 kernel code execution and install B9S.
- [trailerhax](): a userland remote code execution exploit for the eShop media player.

#### Why SSLoth?
It is quite simple, sloths are lazy, just like the SSL system module that does not completely verify the server certificates.

## Technical Q&A
#### How does it work?

In firmware versions lower than 11.14, the SSL system module does not validate certificate signatures when validating a certificate chain. Consequently, anyone can create fake certificates by injecting their own keys into already existing public certificates.

The SSL system module uses the RSA BSAFE MES library to implement SSL/TLS communications. This library is very customizable, and a lot of options can be turned on/off at multiple levels. In particular, according to the documentation, the library requires a "resource list" to be provided. The meaning of this list is to describe which aspects of the library will be activated or not.

Again, according to the documentation, the `R_VERIFY_RES_SIGNATURE` "resource" is needed to perform certificate signatures validation. However, this specific "resource" is not present in the list provided by the SSL module to the library. Hence, it does not validate certificate signatures even though the verification flag is set when creating SSL contexts, for example.

#### How do I create my own certificates?

This section describes how to create a fake CA certificate which you can then use to issue fake signed certificates. To do so you need:
- OpenSSL
- shell
- the original public CA certificate you want to mimic

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

This script creates a certificate with the same information as the original certificate but with customized keys. It also generates the private key file associated with the newly created certificate.  
You can then issue some children certificates with the new key and the new CA certificate. The 3DS will accept those certificates as if the original CA issued them.
