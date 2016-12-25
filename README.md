Example macOS Code Signing using a custom Code Signing Certification Authority.

Run `make` to:

1. Create an example certificate:
    1. Create a Custom Certification Authority (CA).
    1. Create a RSA KeyPair and a Certificate Signing Request (CSR).
    1. Create a Certificate for the CSR.
    1. Import the RSA KeyPair and Certificate into a new Keychain.
    1. Register the Keychain.
1. Sign the `hello-world` application.

For more information see [macOS Code Signing In Depth](https://developer.apple.com/library/content/technotes/tn2206/_index.html).
