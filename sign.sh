#!/bin/bash
set -eux

keychain='example-code-signing.keychain'
password='password'
identity='Rui Lopes'

security unlock-keychain -p "$password" $keychain
security find-identity -p codesigning $keychain
# TODO add something like " and identifier com.foo.bar" to the designated requirements.
# see Table 2 The requirement language syntax on the macOS Code Signing In Depth document available
#     at https://developer.apple.com/library/content/technotes/tn2206/_index.html
codesign -s "$identity" -fv '-r=designated => anchor trusted' --keychain $keychain hello-world 
codesign -d -r- hello-world
codesign -vvvv hello-world
