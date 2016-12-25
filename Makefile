all: hello-world

hello-world: hello-world.c example-code-signing-crt.pem
	gcc -Os -o $@ $<
	./sign.sh
	./$@

example-code-signing-crt.pem:
	./create-example-code-signing-certificate.sh

clean:
	rm -f hello-world example-code-signing*
	security delete-keychain example-code-signing.keychain || true

.PHONY: all clean
