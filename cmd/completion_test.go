package cmd

import (
	"log"
	"reflect"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestCompletionCmd(t *testing.T) {
	wanted := "*cobra.Command"
	cmd := completionCmd()

	if assert.NotNil(t, cmd) {
		if got := reflect.TypeOf(cmd).String(); got != wanted {
			log.Fatalf("Expected \"%s\"; but got \"%s\" variable", wanted, got)
		}
	}
}
