# initrd tools

Some golang tools for working with initrd files. An example script using the available tools is provided which should be capable of extracting any initrd and reconstructing it (most likely with some changes).

## gunzip_trailer

Extract a gzipped data file (`GZIP_FILE`) to `OUTFILE` and put and trailing data in `TRAILER` for further processing.

```
Usage: gunzip_trailer GZIP_FILE OUTFILE TRAILER
```

## gzip_length

Get the length of gzip data before any trailing data in `FILENAME`.

```
Usage: gzip_length FILENAME
```
