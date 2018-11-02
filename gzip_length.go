package main

import (
    "bytes"
    "compress/gzip"
    "fmt"
    "os"
    "io/ioutil"
)

func check(e error) {
    if e != nil {
        panic(e)
    }
}

func getGzipLength(data []byte) int {
    b := bytes.NewBuffer(data)

    totalSize := b.Len()

    r, err := gzip.NewReader(b)
    check(err)

    // Don't error when we find trailing data
    r.Multistream(false)

    // Read the first gzip file
    var resB bytes.Buffer
    _, err = resB.ReadFrom(r)
    check(err)

    remainingSize := b.Len()

    return totalSize - remainingSize
}

func main() {
    argv := os.Args[1:]
    if len(argv) != 1 {
        fmt.Printf("Usage: %s FILENAME\n", os.Args[0])
        os.Exit(1)
    }

    data, err := ioutil.ReadFile(argv[0])
    check(err)

    nBytes := getGzipLength(data)
    fmt.Println(nBytes)
}
