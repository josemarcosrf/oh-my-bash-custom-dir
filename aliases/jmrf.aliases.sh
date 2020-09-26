# Add your own custom alias in the custom/aliases directory. Aliases placed
# here will override ones with the same name in the main alias directory.

docks() {
          docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Ports}}"
  }

alias ls='ls --color -h --group-directories-first'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

export f docks
