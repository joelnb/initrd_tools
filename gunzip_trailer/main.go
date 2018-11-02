package main

import (
	"bytes"
	"compress/gzip"
	"fmt"
	"io/ioutil"
	"os"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func gUnzipDataTrailer(data []byte) ([]byte, []byte, error) {
	b := bytes.NewBuffer(data)

	fmt.Println(b.Len())

	// var r io.Reader
	r, err := gzip.NewReader(b)
	if err != nil {
		return []byte{}, []byte{}, err
	}

	r.Multistream(false)

	var resB bytes.Buffer
	_, err = resB.ReadFrom(r)
	if err != nil {
		return []byte{}, []byte{}, err
	}

	resData := resB.Bytes()

	fmt.Println(b.Len())

	trailData, err := ioutil.ReadAll(b)
	if err != nil {
		return []byte{}, []byte{}, err
	}

	return resData, trailData, nil
}

func main() {
	argv := os.Args[1:]
	if len(argv) != 1 {
		fmt.Printf("Usage: %s GZIP_FILE OUTFILE TRAILER\n", os.Args[0])
		os.Exit(1)
	}

	data, err := ioutil.ReadFile(argv[0])
	check(err)

	resData, trailData, uncompressedDataErr := gUnzipDataTrailer(data)
	check(uncompressedDataErr)

	err = ioutil.WriteFile(argv[1], resData, 0644)
	check(err)

	err = ioutil.WriteFile(argv[2], trailData, 0644)
	check(err)
}
