

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



### Golang settings ###
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin:$GOBIN


### AWS settings ###
export AWS_PROFILE="561400411346_PowerUserAccess"



### Alias some commands ###
alias beautify="autopep8 -i"
alias ls="ls --color=always"
alias pip="/opt/homebrew/bin/pip3"
alias python="/Library/Frameworks/Python.framework/Versions/3.13/bin/python3"
alias teleport="/usr/bin/python3 /Users/cliffsu/scripts/productivity_tools/teleport.py"


### Alias more complex commands ###
aws() {
    if [[ $@ == "status" ]]; then
        ### Shorten commands ###
        #
        echo -e "$fg[red]Alias command: aws sts get-caller-identity$reset_color"
        command aws sts get-caller-identity
    elif [[ $@ == "update" ]]; then
        ### Call python script to auto-update AWS key ###
        #
        command /usr/bin/python3 $HOME/scripts/autoUpdateAWS.py --login
    else
        command aws "$@"
    fi
}
bundle_api() {
    ### Convert .yml files for SwaggerEditor
    #
    command swagger-cli bundle --dereference -o mgmtb.yml -t yaml mgmt.yml
    command swagger-cli bundle --dereference -o capib.yml -t yaml capi.yml
    command swagger-cli bundle --dereference -o ottb.yml -t yaml ott.yml
    command swagger-cli bundle --dereference -o cmamb.yml -t yaml cmam.yml
    command swagger-cli bundle --dereference -o event-serverb.yml -t yaml event-server.yml
    command swagger-cli bundle --dereference -o bss-integrationsb.yml -t yaml bss-integrations.yml
    command swagger-cli bundle --dereference -o webhook-eventb.yml -t yaml webhook-event.yml
}
diff() {
    ### Just a mention that there's a command wdiff for word diff. ###
    #
    echo -e "$fg[red]If you want to diff words. Please use customized command: wdiff file1 file2$reset_color"
    command diff "$@"
}
git() {
    if [[ $1 == "update" ]]; then
        ### Shorten commands ###
        #
       echo -e "$fg[red]Alias command: git fetch upstream; git rebase upstream/\$branch"
       command git fetch upstream
       command git rebase upstream/$2
   else
       command git "$@"
   fi
}
goman() {
    if [[ $@ == "update" ]]; then
        ### Shorten commands ###
        #
        command cd $HOME/github/goman
        echo "Updating goman..."
        command git fetch upstream; git rebase upstream/master
        echo "Building goman..."
        command go build github.com/tbcasoft/goman/cmd/goman/
        command go install github.com/tbcasoft/goman/cmd/goman/
    else
        echo -e "$fg[red]Reminder: Please make sure one of ccps VM of HA was closed.$reset_color"
        command goman "$@"
    fi
}
onall () {
    if [[ $1 == "--help" ]]; then
        echo "Usage: onall <command>"
        return 0
    fi
    osascript -e "tell application \"Terminal\"
        repeat with w in windows
            repeat with t in tabs of w
                do script \"${1//\"/\\\"}\" in t
            end repeat
        end repeat
    end tell"
}
sshp() {
    ### Auto get IPs of AWS vm, then ssh ###
    #
    echo -e "$fg[yellow]usage: ssh qa211ac JKO ccp0$reset_color"
    local pubIp
    local priIp
    read pubIp priIp < <(getAWSInstance $1 $2 $3)
    
    echo "PublicIP:  ${pubIp}"
    echo "PrivateIP: ${priIp}"

    command ssh ubuntu@${priIp} -i "~/.ssh/key.pem" -o StrictHostKeyChecking=no -o "ProxyCommand ssh -i ~/.ssh/key.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ubuntu@${pubIp} -W %h:%p"
}
wdiff() {
    ### word diff and show the color ###
    #
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
    ### echo some reminder when call which ###
    #
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

