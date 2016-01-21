# sourced by each bash shell that is started:  ~/.bashrc
# this is by Eric Harrison ericjharrison@gmail.com
# last edited 07/03/09 12:54:40 Fri
#

#if [ $SHLVL -gt 6 -o "$TERM" = "" -o "$TERM" = "dumb" ]; then  #don't source if..
#        return 0 # STOP! this should not be run right now...
#        # this is usefull for less (see LESSPIPE vars)
#        # for scp'ing a file to this box, otherwise these apps fail
#fi

project() {
    PROJ=~/Projects/$1
    if [ ! -d $PROJ ] ; then
        echo "$PROJ must exist and be a project directory"
        return
    fi
    pushd $PROJ
    for e in ./ENV ./platform/OPG_ENV/bin/activate ./MY_ENV/bin/activate ../IS_ENV/bin/activate; do
        test -e $e && . $e
    done
}
#alias f='project FeedBack'
#alias p='project EZQuoter'
alias i='project instasong/is_webapp'
alias o='project opg'
alias project_o='tmux source-file .tmux/opg.tmux'
#alias m=p
#alias om='project MobilProject/MobilSentry_OM'
alias jsonlint='python -mjson.tool'

s1() { h=`cat ~/.workhost|grep -v '^ *#'`; ssh "t${h}"; }
s2() { h=`cat ~/.workhost|grep -v '^ *#'`; ssh $h; }

# ----- shell functions 
syn_kill() {
    pkill synergyc
    pkill synergys
}

syn_s() {
    syn_kill
    synergys --restart --daemon

    #pkill synergyc
    #synergyc --restart --daemon 192.168.1.17
}
keepalive() {    # keep alive function
    unset autologout
    echo -ne "starting keep alive: "
    if [ ! -x ~/bin/sendnulls ]; then
        echo "We need to create your sendnulls file the first time..."
        cat <<EOF > ~/bin/sendnulls
:
set -e
while true; do
    dd if=/dev/zero count=1 bs=1 2>/dev/null
    sleep 300
done
EOF
        chmod a+rx ~/bin/sendnulls
    fi
    ~/bin/sendnulls&
}

key_send() {    # send sshkey to another host
    if [ -z "$*" ] ; then
        echo "key_send hostname [ -replace ]"
    else
        local host=$1 ; shift
        local DIR="~/.ssh"
        local FILE="$DIR/authorized_keys"
        case $1 in 
        replace|-replace|-r)
        cat ~/.ssh/identity.pub.send |                      \
            ssh $host \ "(                                  \
            [ -d $DIR ] || mkdir $DIR;                      \
            sed 's/$USER@.*$/$USER@`uname -n`/'  >$FILE;    \
            chmod 700 $DIR;                                 \
            chmod 600 $FILE                                 \
            )"
        ;;
        *)
        cat ~/.ssh/identity.pub.send |                      \
            ssh $host \ "(                                  \
            [ -d $DIR ] || mkdir $DIR;                      \
            sed 's/$USER@.*$/$USER@`uname -n`/' >>$FILE;    \
            chmod 700 $DIR;                                 \
            chmod 600 $FILE                                 \
            )"
        ;;
        esac
    fi
}

unknow() {        # forget about a host in your known_hosts? files
    HOST=$1
    FILE="$HOME/.ssh/known_hosts $HOME/.ssh/known_hosts2"
    if [ -z $HOST ]; then echo "syntax: unknow host" ; return; fi
    for i in $FILE ; do
        if [ ! -f $i ] ; then echo "$i must exist" ; return; fi
        if ! grep $HOST $i >/dev/null 2>&1 ;then
            echo "$i contains no entry for $HOST"; continue
        fi
        cat $i|grep -v $HOST > $i.tmp
        mv -f $i $i.old && mv -f $i.tmp $i
        echo "$HOST removed from $i"
    done
}

agent_restart() {    # restart the ssh agent
    echo "ssh-agent: restarting"
    killall ssh-agent > /dev/null 2>&1
    /usr/bin/ssh-agent > $HOME/.ssh-agent
    . $HOME/.ssh-agent > /dev/null 2>&1
    #ssh-add # this requires user interaction to add key
    for f in ${HOME}/.ssh/*id_rsa ${HOME}/.ssh/*id_dsa; do 
        #if [ `echo $f|grep '\.pub'` ]; then 
            #continue
        #fi
        test -f $f && ssh-add $f
    done
}

file_send() {
    local host=$1 ; shift
    if [ -z "$*" ] ; then
        echo "file_send hostname /file1 /file2"
        echo "will move destination files to /file1.orig"
    else
        local LIST=$*
        for i in $LIST ; do
            test -r $i || local error=$i" $error"
        done
        if [ -n "$error" ]; then
            echo "unfortunately I can't read $error"
            return 1
        fi
        tar -cf - $@ |                  \
        ssh $host "(                    \
            for x in $LIST; do          \
                if [ -f \$x ]; then     \
                    mv -f \$x \$x.old ; \
                fi                      \
            done;                       \
            tar -xvf -                  \
        )"
    fi
}

# ps only outputs 8 characters of the username!
TRUNCATED=`echo $USER|\
sed 's/\([[:alnum:]][[:alnum:]][[:alnum:]][[:alnum:]]\
[[:alnum:]][[:alnum:]][[:alnum:]][[:alnum:]]\).*$/\1/'`

# ---- set up environment

# if there is an ssh-agent file, then grab the specs, and manage agent
if [ -f ~/.ssh-agent ]; then
    . ~/.ssh-agent > /dev/null 
    if [ -z $SSH_AGENT_PID ]; then
        agent_restart
    elif  ! ( ps -efa|grep [sS]sh-agent|grep $TRUNCATED >/dev/null 2>&1 ); then
        agent_restart
    else
        if ! /bin/pidof ssh-agent|grep $SSH_AGENT_PID >/dev/null 2>&1 ; then
            agent_restart
        fi
    fi
fi

## if there is a fetchmailrc file, then manage fetchmail...
#if [ -f ~/.fetchmailrc ]; then
#    ps -eaf|grep $TRUNCATED|awk '{print $8}'|grep [Ff]etchmail >/dev/null 2>&1
#    if [ $? -ne 0 ]; then
#        echo "staring fetchmail..."
#        #fetchmail -d 30
#        fetchmail
#    fi
#fi

# mention any open screen sessions
SCREEN=`which screen 2>/dev/null`
[ ! -z "${SCREEN}" ] && ${SCREEN} -list |grep -v "^$"|grep -v "No Sockets found"

trim() {
    echo $1
}

restore_next_screen() {
    #NEXT=`${SCREEN} -list |grep -v "^$"|grep 'Detached'|grep -v "No Sockets found" | head | awk '{print $1}'`
    #if [ "X" != "X${NEXT}" ]; then
    #    screen -r $NEXT
    #else
    #    echo "no session to connect to, run screen"
    #fi
    if echo "$TERM" | grep "screen" >/dev/null 2>&1 ; then
        echo "Refusing to enter screen while in a screen already..."
    else
        session=$(trim `screen -list|grep '[dD]etached'|sed 's# *(.*##g; s#^   *##; s#  *$##; s#^ *##; s# *$##'|head -1`)
        if [ "${session}X" != "X" ] ; then
            echo "attaching to screen..."
            screen -r "$session"
        else
            echo "Nothing to attach to!"
        fi
    fi
}
alias s=restore_next_screen

detach_all_sessions() {
    for s in `screen -list|grep 'Attached'|grep -v "No Sockets found" | awk '{print $1}'`; do
        screen -d $s
    done
}
alias da=detach_all_sessions

detach_one_session() {
    shellnum=$1
    export IFS="
"
    count=1
    if [ "${shellnum}X" == "X" ] ; then
        echo "Please specify the shell number in the list to detach from"
        for line in `screen -list|grep '[Aa]ttached'`; do
            echo "${count} ${line}"
            count=$[count+1]
        done
    else
        for line in `screen -list|grep '[aA]ttached'`; do
            if [ $shellnum == $count ]; then
                shell=`echo $line|awk '{print $1}'`
                echo "detaching from ${shell}"
                screen -D $shell
                break
            fi
            count=$[count+1]
        done
        
    fi
}



## if there is a keepalive file, then run keepalive in the background
#if [ -f ~/.keepalive ]; then
#    # make sure that we don't start another one! Don't start one locally
#    if [ "$KEEP_ALIVE" != "true" -a "$SSH_CLIENT" != "" ]; then
#        keepalive 120 &
#        export KEEP_ALIVE=true
#    fi
#fi
#

# ----- aliases 
#alias gvim=kvim
#alias gideonprep=kbuildsycoca
alias scheme=guile
#alias rm='rm -i'        # interactive rm
alias ls='ls --color'
alias ll='ls -la'
alias mv='mv -i'        # interactive mv
alias cp='cp -i'        # interactive cp
alias ssh='ssh -P'        # use a high source port
alias pdf=xpdf            # I always forget
alias ftp=ncftp            # much better
alias grep='grep --color'
alias lynx='lynx -accept_all_cookies'
#alias mutt='mutt -y'        # watch all defined 'mailboxes'
which vim   >/dev/null 2>&1 && alias vi=vim    # win with vim
which ncftp >/dev/null 2>&1 && alias ftp=ncftp # NCftp
#alias wget='wget --referer="http://www.google.com" --user-agent="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6" --header="Accept: text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5" --header="Accept-Language: en-us,en;q=0.5" --header="Accept-Encoding: gzip,deflate" --header="Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7" --header="Keep-Alive: 300"'
alias wget='wget --referer="http://www.google.com" --user-agent="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6" --header="Accept: text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5" --header="Accept-Language: en-us,en;q=0.5" --header="Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7" --header="Keep-Alive: 300"'

# Need for a xterm & co if we don't make a -ls
[ -n $DISPLAY ] && {
    [ -f /etc/profile.d/color_ls.sh ] && source /etc/profile.d/color_ls.sh
     # WARNING: this will override the gdm server's setting of XAUTHORITY
     #export XAUTHORITY=$HOME/.Xauthority
}

# Read first /etc/inputrc if the variable is not defined, and after the /etc/inputrc 
# include the ~/.inputrc
[ -z $INPUTRC ] && export INPUTRC=/etc/inputrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

#set -o vi
#HISTCONTROL="ignoredups"

ANDROID_SDK_HOME=/usr/local/adt-bundle-linux/sdk
EDITOR=vim
#JAVA_HOME=/usr/java/latest
#ANT_HOME=/usr/local/netbeans-6.9.1/java/ant
#JAVA_HOME=/usr/local/jdk1.6.0_21/
#JAVA_HOME=/usr/local/jdk1.6.0_37/
#JAVA_HOME=/usr/local/jdk1.7.0_10
JAVA_HOME=/usr/local/jdk1.7.0_51/
CLASSPATH=${CLASSPATH}:.:${JAVA_HOME}/lib/tools.jar
PATH=${JAVA_HOME}/bin/:${PATH}
PATH=${PATH}:${JAVA_HOME}/bin
PATH=${PATH}:${HOME}/bin:/sbin:/usr/sbin
PATH=${PATH}:${HOME}/local/bin/
PATH=${PATH}:${ANDROID_SDK_HOME}/platform-tools/
#PATH=${PATH}:/usr/local/eclipse/
#PATH=${PATH}:/usr/local/kde/bin/
PATH=${PATH}:/usr/local/sbin
PATH=${PATH}:${ANT_HOME}/bin
#PATH=${PATH}:/usr/games/bin
#PATH=${PATH}:${HOME}/local/android-sdk-linux_86/tools
PATH=${PATH}:/usr/lib/postgresql/9.3/bin/
PATH=${PATH}:/opt/bin/

#PS1="[\u@\h \W] # "
#PS1="[\u@\h \W]\\$ "
GRAY="\[\033[01;30m\]"
RED="\[\033[01;31m\]"
GREEN="\[\033[01;32m\]"
YELLOW="\[\033[01;33m\]"
BLUE="\[\033[01;34m\]"
SALMON="\[\033[01;35m\]"
TEAL="\[\033[01;36m\]"
WHITE="\[\033[00m\]"

#case $TERM in
#    xterm*)
#        #PROMPT_COMMAND='echo -ne "\0337\033[2;999r\033[1;1H\033[00;44m\033[K"`date`"\033[00m\0338"'
#        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD} `date`\007"'
#        PS1="${TEAL}[${YELLOW}\u${GRAY}@${GREEN}\h ${SALMON}\W${TEAL}]${GREEN}$ ${WHITE}"
#    ;;
#    screen)
#        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD} `date`\007"'
#        PS1="${TEAL}[${GREEN}\u${GRAY}@${RED}\h ${SALMON}\W${TEAL}]${GREEN}$ ${WHITE}"
#    ;;
#        *)
#        # nothing doing
#    ;;
#esac

. ~/bin/git-completion.bash

case $TERM in
    xterm*)
        PS1="${TEAL}[${GREEN}\u${GRAY}@${BLUE}\h "'$(__git_ps1 "[%s]")'"${SALMON}\W${TEAL}]${GREEN}$ ${WHITE}"
        #PS1="${TEAL}[${GREEN}\u${GRAY}@${GREEN}\h ${SALMON}\W${TEAL}]${GREEN}$ ${WHITE}"
    ;;
    screen*)
        #PS1="${TEAL}[${GREEN}\u${GRAY}@${RED}\h ${SALMON}\W${TEAL}]${GREEN}$ ${WHITE}"
        PS1="${TEAL}[${GREEN}\u${GRAY}@${RED}\h "'$(__git_ps1 "[%s]")'"${SALMON}\W${TEAL}]${GREEN}$ ${WHITE}"
    ;;
        *)
        # nothing doing
    ;;
esac

a() {
    if [ -f aliases.sh ] ; then
        . aliases.sh
    fi
}



# set ulimit for core files
ulimit -c 1000000    # 1 meg

export XSESSION=kde-3.2.3

export PYTHONPATH=~/lib/mechanize-0.1.6b:~/lib/ClientForm-0.2.6:~/lib/pullparser-0.1.0:~/lib/beautifulsoup-3.0.4/

export PATH EDITOR PS1 PROMPT_COMMAND CLASSPATH JAVA_HOME 
#export CVS_RSH CVSROOT LD_LIBRARY_PATH KDEDIRS P4PORT 
#export P4USER P4CLIENT P4PASSWD ANT_HOME


# mute out that ANNOYING beep on every mistake!
#which xset >/dev/null && { [ -n $DISPLAY ] && xset b off ; }  # X
#which setterm >/dev/null 2>&1  && setterm -blength 1 # console


# Bring in node stuff..
export PATH=/home/eric/.npm-packages/bin:${PATH}
export NODE_PATH=$NODE_PATH:/home/eric/.npm-packages/lib/node_modules
# should these 2 lines be here?
#export GEM_HOME=$HOME/gems
#export GEM_PATH=$HOME/gems:/usr/lib/node_modules/npm/bin
export DIGITAL_OCEAN_TOKEN=06f2a31e59258f43aa59daa971220ab2eecd259eff9c4d6f78aefc22f68af298

# trying to fix broken java 8 with awesomewm... 
_JAVA_AWT_WM_NONREPARENTING=1; export _JAVA_AWT_WM_NONREPARENTING


. ~/.nvm/nvm.sh


alias n5="nvm use v5.1.0"
alias n0="nvm use v0.10.32"

n5

