/*Package cmd heart of cobra

Copyright © 2020 Lionel Félicité <deogracia@free.fr>
This file is licensed under the BSD 3-Clause Clear License.
The full text can also be found:
  * in the LICENSE file at the root directory of this project
  * at https://spdx.org/licenses/BSD-3-Clause-Clear.html

*/
package cmd

import (
	"github.com/deogracia/jntpdn/internal/app"
	"github.com/spf13/cobra"
)

func docsCmd() *cobra.Command {

	a := app.New()
	// completionCmd represents the completion command
	var docsCmd = &cobra.Command{
		Use:   "docs [subcommand]",
		Short: "Generate documentation",
		Long:  "Generate documentation in MarkDown and manual pages",
		RunE: func(cmd *cobra.Command, args []string) error {
			return a.DocsGeneration(cmd, args)
		},
	}

	docsCmd.PersistentFlags().StringVarP(&a.Params.DocOutputDirectory, "dir", "d", "./jntpdn-docs", "Destination directory for docs. Default to './jntpdn-docs'")

	return docsCmd
}
