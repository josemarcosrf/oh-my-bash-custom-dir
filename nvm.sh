# Add yarn global to the path
export PATH=$PATH:~/.yarn/bin

# load some bash function defintions
if [[ -f ~/bin/bash_functions.sh ]]; then
    . ~/bin/bash_functions.sh
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


