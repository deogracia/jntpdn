package app

import (
	"bytes"
	"log"
	"reflect"
	"testing"

	"github.com/spf13/cobra"
	"github.com/stretchr/testify/assert"
)

// Utility functions
func getCmd() *cobra.Command {
	return &cobra.Command{
		Use:  "root",
		Args: cobra.ExactArgs(0),
		Run:  func(_ *cobra.Command, _ []string) {},
	}
}

func executeCommand(root *cobra.Command, args ...string) (output string, err error) {
	_, output, err = executeCommandC(root, args...)
	return output, err
}

func executeCommandC(root *cobra.Command, args ...string) (c *cobra.Command, output string, err error) {
	buf := new(bytes.Buffer)
	root.SetOut(buf)
	root.SetErr(buf)
	root.SetArgs(args)

	c, err = root.ExecuteC()

	return c, buf.String(), err
}

// Tests function
func TestNewApp(t *testing.T) {
	wanted1 := "*app.App"
	wanted2 := "*app.Params"
	cmd := new(App)

	if assert.NotNil(t, cmd) {
		if got := reflect.TypeOf(cmd).String(); got != wanted1 {
			log.Fatalf("Expected \"%s\"; but got \"%s\" variable", wanted1, got)
		}
		if got := reflect.TypeOf(cmd.Params).String(); got != wanted2 {
			log.Fatalf("Expected \"%s\"; but got \"%s\" variable", wanted2, got)
		}
	}
}
func TestShellCompletion(t *testing.T) {
	var cmd *cobra.Command
	var app *App
	app = new(App)
	cmd = getCmd()
	var testValues = []struct {
		format string
		output string
		app    *App
		cmd    *cobra.Command
	}{
		{"bash", "sh", app, cmd},
		{"zsh", "zsh", app, cmd},
		{"fish", "fish", app, cmd},
		{"powershell", "powershell", app, cmd},
		{"invalid", "invalid", app, cmd},
	}

	for _, tt := range testValues {
		t.Run(tt.format, func(t *testing.T) {

			err := tt.app.ShellCompletion(tt.cmd, []string{tt.format})
			//			if output != tt.output {
			//				t.Errorf("%s unexpected output: %s", tt.format, output)
			//			}

			if err != nil {
				t.Errorf("%s unexpected error: %s", tt.format, err)
			}
		})
	}
}
