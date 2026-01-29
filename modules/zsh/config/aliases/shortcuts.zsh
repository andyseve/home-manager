# useful shortcuts
alias showuser='cut -d: -f1 /etc/passwd'
alias my-ip="curl http://ipecho.net/plain; echo"
alias fetch="neofetch"

alias viml="vim -u $HOME/.config/home-manager/modules/vim/config/vimrc.lite"
alias vimn="vim -u $HOME/.config/home-manager/modules/vim/config/vimrc.noplugin"
alias vimt="vim -u $HOME/.config/home-manager/modules/vim/config/vimrc.testing"

alias rtorrent-attach="tmux -L rtorrent -S /tmp/rtorrent attach -t rtorrent"

# directories
alias cmu='cd ~/Documents/cmu'
alias books='cd ~/Documents/Books'
alias dotfiles='cd ~/.config/home-manager'

# files
alias zshrc='source ~/.config/zsh/.zshrc'
alias edit-vim='$EDITOR ~/.vimrc'
alias edit-latex='$EDITOR ~/texmf/tex/latex/local/anishs.sty'
alias edit-zsh='$EDITOR ~/.config/zsh/.zshrc'
