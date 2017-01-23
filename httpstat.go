package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"strings"
	"text/template"
)

const https = `
  DNS Lookup   TCP Connection   SSL Handshake   Server Processing   Content Transfer
[   {-.a000} |    {-.a001}    |   {-.a002}    |     {-.a003}      |     {-.a004}     ]
             |                |               |                   |                  |
    namelookup:{.b000}        |               |                   |                  |
                        connect:{.b001}       |                   |                  |
                                    pretransfer:{.b002}           |                  |
                                                      starttransfer:{.b003}          |
                                                                                 total:{.b004}
`

const http = `
   DNS Lookup    TCP Connection    Server Processing    Content Transfer
[   {{ .a000 | printf "%6s"}}    |     {{ .a001 | printf "%6s"}}      |      {{ .a003 | printf "%6s"}}         |      {{ .a004 | printf "%6s"}}       ]
              |                 |                     |                   |
    namelookup:{{.b000}}             |                     |                   |
                          connect:{{.b001}}                |                   |
                                         starttransfer:{{.b003}}               |
                                                                     total:{{.b004}}
`

func minus(arg1, arg2 interface{}) float64 {
	return arg1.(float64) - arg2.(float64)
}

func main() {
	bodyf, err := ioutil.TempFile(os.TempDir(), "httpstat")
	if err != nil {
		panic(err)
	}

	headf, err := ioutil.TempFile(os.TempDir(), "httpstat")
	if err != nil {
		panic(err)
	}

	curlArgs := os.Args[2:]
	excludeOptions := []string{"-w", "-D", "-o", "-s"}

	for _, ext := range excludeOptions {
		for _, arg := range curlArgs {
			if ext == arg {
				log.Fatal("no")
			}
		}
	}

	curlFormat := `{
    "time_namelookup": %{time_namelookup},
    "time_connect": %{time_connect},
    "time_appconnect": %{time_appconnect},
    "time_pretransfer": %{time_pretransfer},
    "time_redirect": %{time_redirect},
    "time_starttransfer": %{time_starttransfer},
    "time_total": %{time_total},
    "speed_download": %{speed_download},
    "speed_upload": %{speed_upload}
}
`
	cmd := exec.Command("curl", "-w", curlFormat, "-D", headf.Name(), "-o", bodyf.Name(), "-s", "-S", os.Args[1])
	var stdout bytes.Buffer
	cmd.Stdout = &stdout

	if err := cmd.Run(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	resp := []byte(stdout.String())
	var data map[string]interface{}
	if err := json.Unmarshal(resp, &data); err != nil {
		panic(err)
	}

	for k, v := range data {
		if strings.HasPrefix(k, "time_") {
			data[k] = v.(float64) * 1000
		}
	}
	data["range_dns"] = data["time_namelookup"]
	data["range_connection"] = minus(data["time_connect"], data["time_namelookup"])
	data["range_ssl"] = minus(data["time_pretransfer"], data["time_connect"])
	data["range_server"] = minus(data["time_starttransfer"], data["time_pretransfer"])
	data["range_transfer"] = minus(data["time_total"], data["time_starttransfer"])
	fmt.Printf("%#v\n", data)

	data["a000"] = fmt.Sprintf("%2.0fms", data["range_dns"])
	data["a001"] = fmt.Sprintf("%2.0fms", data["range_connection"])
	data["a002"] = fmt.Sprintf("%2.0fms", data["range_ssl"])
	data["a003"] = fmt.Sprintf("%2.0fms", data["range_server"])
	data["a004"] = fmt.Sprintf("%2.0fms", data["range_transfer"])
	data["b000"] = fmt.Sprintf("%2.0fms", data["time_namelookup"])
	data["b001"] = fmt.Sprintf("%2.0fms", data["time_connect"])
	data["b002"] = fmt.Sprintf("%2.0fms", data["time_pretransfer"])
	data["b003"] = fmt.Sprintf("%2.0fms", data["time_starttransfer"])
	data["b004"] = fmt.Sprintf("%2.0fms", data["time_total"])

	tmpl, err := template.New("test").Parse(http)
	if err != nil {
		panic(err)
	}

	var doc bytes.Buffer
	if err := tmpl.Execute(&doc, data); err != nil {
		panic(err)
	}
	s := doc.String()
	fmt.Printf("Result: %s\n", s)
}
