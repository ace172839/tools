# zshrc


### Define functions in ~/.zshrc_functions ###
source ~/.zshrc_functions


### Auto-complete history command with up-arrow or down-arrow key ###
#
# Some useful link:
#   https://superuser.com/questions/585003/searching-through-history-with-up-and-down-arrow-in-zsh
#
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search


### AWS settings ###
export AWS_PROFILE="561400XXXXXX_PowerUserAccess"


### Alias, simple commands ###
alias beautify="autopep8 -i"
alias ls="ls --color=always"
alias pip="/usr/bin/python3 -m pip"
alias python="/usr/bin/python3"


### Alias, complex commands ###
aws() {
    if [[ $@ == "status" ]]; then
        # Shorten commands
        echo -e "$fg[red]Alias command: aws sts get-caller-identity$reset_color"
        command aws sts get-caller-identity
    elif [[ $@ == "update" ]]; then
        # Call python script to auto-update AWS key
        command /usr/bin/python3 $HOME/scripts/autoUpdateAWS.py --login
    else
        command aws "$@"
    fi
}
diff() {
    # Just a mention that there's a command wdiff for word diff.
    echo -e "$fg[red]If you want to diff words. Please use customized command: wdiff file1 file2$reset_color"
    command diff "$@"
}
git() {
    if [[ $1 == "update" ]]; then
       # Shorten commands
       echo -e "$fg[red]Alias command: git fetch upstream; git rebase upstream/\$branch"
       command git fetch upstream
       command git rebase upstream/$2
   else
       command git "$@"
   fi
}
wdiff() {
    # word diff and show the color ###
    # Link:
    #   https://unix.stackexchange.com/questions/11128/diff-within-a-line
    #
    if [[ $# -eq 2 ]]; then
        echo -e "$fg[red]Alias command: wdiff -w \'\$\(tput bold;tput setaf 1\)\' -x \'\$\(tput sgr0\)\' -y \'\$\(tput bold;tput setaf 2\)\' -z \'\$\(tput sgr0\)\' \n\
                                <(echo \$\(sed -e 's/,/ /g' \$\{file1\}\)) <(echo \$\(sed -e 's/,/ /g' \$\{file2\}\))$reset_color"
        echo -e "$fg[red]               The red words are from the former file.$reset_color"
        echo -e "$fg[green]               The green words are from the latter file.$reset_color"
        command wdiff -w "$(tput bold;tput setaf 1)" -x "$(tput sgr0)" -y "$(tput bold;tput setaf 2)" -z "$(tput sgr0)"  <(cat $1) <(cat $2)
    else
        command wdiff "$@"
    fi
}
which() {
    # echo some reminder when call which
    echo -e "$fg[yellow]For more details,you can try 'type -a \$COMMAND' for alias names or functions.$reset_color"
    command type "$@"
}


### Change the font color ###
#
# Some useful link:
#   https://stackoverflow.com/questions/689765/how-can-i-change-the-color-of-my-prompt-in-zsh-different-from-normal-text
#   https://unix.stackexchange.com/questions/273529/shorten-path-in-zsh-prompt/273567#273567
#
autoload -U colors && colors

### Change %PROMPT% style ###
PS1="%{%B$fg[magenta]%}%n%{$fg[white]%}@%{$fg[blue]%}%m %{$fg[yellow]%}%(5~|%-1~/…/%3~|%4~) %{$fg[white]%}%%%{$reset_color%}%b %{$fg[cyan]%}"
preexec () { echo -ne "\e[0m" }


### For Python ###
# Python settings
export PATH=$PATH:/Users/cliffsu/Library/Python/3.9/bin


# Activate virtual environment for Python.
alias venv="source $HOME/python/path/to/venv/bin/activate"
