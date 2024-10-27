
{ upkgs, ...}: {
	home.packages = [
	    (upkgs.vscode-with-extensions.override {
              vscodeExtensions = with upkgs.vscode-extensions; [
                jnoortheen.nix-ide
                # ms-python.python
                # ms-pyright.pyright
                # ms-python.flake8
                # ms-vscode.cpptools
                # ms-vscode-remote.remote-ssh
                github.copilot
		catppuccin.catppuccin-vsc
		catppuccin.catppuccin-vsc-icons
              ];
            })
	];
}
