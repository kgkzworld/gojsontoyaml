package main

import (
	"flag"
	"io/ioutil"
	"os"

	"github.com/ghodss/yaml"
	goyaml "gopkg.in/yaml.v2"
)

func main() {
	// variables declaration
	var path string
	var outBytes []byte

	// flags declaration using flag package
	yamltojson := flag.Bool("oj", false, "Output yaml to json instead of the default json to yaml.")
	flag.StringVar(&path, "p", "", "Specify the full path to the file.")

	flag.Parse() // after declaring flags we need to call it

	// Don't wrap long lines
	goyaml.FutureLineWrap()

	if path != "" {
		inBytes, err := ioutil.ReadFile(path)
		if err != nil {
			panic(err)
		}

		if *yamltojson {
			outBytes, err = yaml.YAMLToJSON(inBytes)
			if err != nil {
				panic(err)
			}
		} else {
			outBytes, err = yaml.JSONToYAML(inBytes)
			if err != nil {
				panic(err)
			}
		}
	} else {
		inBytes, err := ioutil.ReadAll(os.Stdin)
		if err != nil {
			panic(err)
		}

		if *yamltojson {
			outBytes, err = yaml.YAMLToJSON(inBytes)
			if err != nil {
				panic(err)
			}
		} else {
			outBytes, err = yaml.JSONToYAML(inBytes)
			if err != nil {
				panic(err)
			}
		}
	}

	os.Stdout.Write(outBytes)
}
