.DEFAULT_GOAL: all

all: gzip-length gunzip-trailer

gzip-length:
	go build -o gzip-length ./gzip_length

gunzip-trailer:
	go build -o gunzip-trailer ./gunzip_trailer

.PHONY: clean
clean:
	rm -f gzip-length gunzip-trailer