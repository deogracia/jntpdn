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

func completionCmd() *cobra.Command {

	a := app.New()
	// completionCmd represents the completion command
	var completionCmd = &cobra.Command{
		Use:   "completion [bash|zsh|fish|powershell]",
		Short: "Generate completion script",
		Long: `To load completions:

Bash:

$ source <(jntpdn completion bash)

# To load completions for each session, execute once:
Linux:
  $ jntpdn completion bash > /etc/bash_completion.d/jntpdn
MacOS:
  $ jntpdn completion bash > /usr/local/etc/bash_completion.d/jntpdn

Zsh:

# If shell completion is not already enabled in your environment you will need
# to enable it.  You can execute the following once:

$ echo "autoload -U compinit; compinit" >> ~/.zshrc

# To load completions for each session, execute once:
$ jntpdn completion zsh > "${fpath[1]}/_jntpdn"

# You will need to start a new shell for this setup to take effect.

Fish:

$ jntpdn completion fish | source

# To load completions for each session, execute once:
$ jntpdn completion fish > ~/.config/fish/completions/jntpdn.fish
`,
		DisableFlagsInUseLine: true,
		ValidArgs:             []string{"bash", "zsh", "fish", "powershell"},
		Args:                  cobra.ExactValidArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			return a.ShellCompletion(cmd, args)
		},
	}

	return completionCmd
}
