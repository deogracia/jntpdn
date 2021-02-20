package cmd

import (
	"log"
	"reflect"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestDumb(t *testing.T) {
	if true != true {
		t.Error("everything I know is wrong")
	}

}

func TestRootCmd(t *testing.T) {
	wanted := "*cobra.Command"
	cmd := RootCmd()

	if assert.NotNil(t, cmd) {
		if got := reflect.TypeOf(cmd).String(); got != wanted {
			log.Fatalf("Expected \"%s\"; but got \"%s\" variable", wanted, got)
		}
	}
}
