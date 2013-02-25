#!/bin/bash
PATH=/usr/local/bin:/usr/local/Cellar/ruby/1.9.3-p327/bin:/usr/local/sbin:$PATH
# PATH=/Users/bar/bin:/usr/local/mysql/bin:/usr/local/bin:/usr/local/sbin:/Developer/Tools:/sw/bin:/usr/share/teTeX/bin:$PATH
PYTHONPATH=~/cherrypy:$PYTHONPATH
# VARTEXMF=/usr/TeX/texmf-var
# MANPATH=$MANPATH:/usr/TeX/man:/opt/local/man

export PATH VARTEXMF
FCEDIT=/usr/bin/emacs

# export CLICOLOR="exfxcxdxbxegedabagacad"
HISTFILESIZE=1000


PS1="\j jobs @ \H, \@, in \w, \!:
>> "
PS2="> "
# PS4="+" this is for tracing, and this is the default.

# my cdable_vars
shopt -s cdable_vars
export GIT_EDITOR=emacsclient
export tmp=~/temp
export ds=~/Downloads
# aliases
export w=~/wrg
export c=~/c++/15/sales
# emacs related:
# alias ee="lsl /Users/bar/mail/incoming/*.spool | grep 'bar *staff *[1-9]' | perl -ne 's/.*incoming\/(.*)\.spool/\$1/ && print;'"
# alias spool="lsl ~/mail/incoming/*.spool"

# convenience:
# alias ithp2="iThief p $(iThief lsp $1 | grep $2 | cut -c 3-)"
alias ij="/Applications/IntelliJ\ IDEA\ 11\ CE.app/Contents/MacOS/idea &"
alias aq="/Applications/Aquamacs.app/Contents/MacOS/Aquamacs &"
alias scpr="rsync --partial --progress --rsh=ssh"
alias sage='/Applications/sage/sage'
alias mountu='mkdir ubuntu; sshfs u:/home/bar ubuntu -oauto_cache,reconnect'
alias mountul='mkdir ubuntu; sshfs ul:/home/bar ubuntu -oauto_cache,reconnect'
alias mountu_='mkdir ubuntu_; sshfs bar@bar-ubuntu.local:/home/bar ubuntu_ -oauto_cache,reconnect'
alias mountwf='mkdir wf; sshfs cinayakoshka@cinayakoshka.webfactional.com:/home/cinayakoshka wf -oauto_cache,reconnect'
alias mountkl='sshfs bar@192.168.1.34:/home/bar kirilov -oauto_cache,reconnect,volname="kvlmount"'
alias mountk='sshfs -p 3340 bar@adaptive.cs.unm.edu:/home/bar kirilov -oauto_cache,reconnect,volname="kvlmount"'
alias topten='ps -eo user,pcpu,pid,command | sort -r -k2 | head -11'
alias lsl='ls -aGlTu'
alias lss='ls -AaG'
alias pd='pushd'
alias synergy-tunnel='ssh -f -v -N -L localhost:24800:kvl:24800 kvl'
function hoo
{
    T=$1
    hoogle T | less
}
# alias cs=' cf -s'
# alias cd=' cf -d'
# alias cz=' cf -?'
# function cf
# {
#         chelper "$OLDPWD" "$@"
#         if [ $? -eq 0 ]
#         then
#                 source ~/temp/newdir;
#                 command cd "$NEWDIR"
#         fi
# }

# alias foo='echo "$@"; echo "1 2 3"'
function lsd
# list files matching a given date, formatted as in 'ls -l'.
{
	DATE=$1
	ls -l | grep -i "^.\{31\}$DATE" | cut -c44-
}

function nnokia
# send file notes.txt to my phone
{
    IP=$1
    scp ~/notes.txt root@$IP:/home/user/MyDocs/.documents/
}

function dnokia
# send a document to my phone
{
    IP=$1
    DOC=$2
    scp -r $DOC root@$IP:/home/user/MyDocs/.documents/
}

# eval `python ~/Projects/Divmod/trunk/Combinator/environment.py`


#         # reverse a file
#         cat  -n $HISTORY_FILE | sort -nr | cut -d "/" -f 2- - | sed "\:^:s:^:/:g" | while IFS=: read line
alias cfr="cfx run -p ~/Library/Application\ Support/Firefox/Profiles/9zsvc9i6.dev"
function breakvpn() {
    gw=`netstat -arn | grep ^default | awk '{print $2}'`
    while (("$#")); do
	sudo route delete $1
	sudo route add $1 $gw
	shift
    done
}

eval "$(rbenv init -)"

alias gitup="git remote update; git pull --rebase upstream master"

function overflow {
    find ~/projects/kb -iname "*$1*md" | xargs -n1 open
}
