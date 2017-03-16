all:
	jbuilder build @install src/btpump.exe

.PHONY: clean
clean:
	rm -rf _build
