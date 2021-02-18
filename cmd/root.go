/*Package cmd heart of cobra

Copyright © 2020 Lionel Félicité <deogracia@free.fr>
This file is licensed under the BSD 3-Clause Clear License.
The full text can also be found:
  * in the LICENSE file at the root directory of this project
  * at https://spdx.org/licenses/BSD-3-Clause-Clear.html

*/
package cmd

import (
	"github.com/spf13/cobra"
)

// RootCmd is a root Cobra command that gets called
// from the main func.
// All other sub-commands should be registered here.
func RootCmd() *cobra.Command {

	var rootCmd = &cobra.Command{
		Use:   "jntpdn",
		Short: "HTTP serves files & directory on a specified port",
		Long: `jntpn serves through HTTP on a specified port (8080, by default)
  specified files or directories (curent directory by defaut). `,
		Version: "0.0.1",
		// Uncomment the following line if your bare application
		// has an action associated with it:
		//	Run: func(cmd *cobra.Command, args []string) { },
	}

	versionTemplate := `{{printf "%s: %s - version %s\n" .Name .Short .Version}}`
	rootCmd.SetVersionTemplate(versionTemplate)

	rootCmd.AddCommand(

		completionCmd(),
	)

	return rootCmd

}
