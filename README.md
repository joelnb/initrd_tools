# initrd tools

Some golang tools for working with initrd files. An example script using the available tools is provided which should be capable of extracting any (gzipped) initrd and reconstructing it (most likely with some changes).

## Building

A Makefile is provided for easier building - simply type `make` to build both binaries.

## gunzip-trailer

Extract a gzipped data file (`GZIP_FILE`) to `OUTFILE` and put and trailing data in `TRAILER` for further processing.

```
Usage: gunzip-trailer GZIP_FILE OUTFILE TRAILER
```

## gzip-length

Get the length of gzip data before any trailing data in `FILENAME`.

```
Usage: gzip-length FILENAME
```
