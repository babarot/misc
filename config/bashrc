#       ___           ___           ___           ___           ___           ___      
#      /\  \         /\  \         /\  \         /\__\         /\  \         /\  \     
#     /::\  \       /::\  \       /::\  \       /:/  /        /::\  \       /::\  \    
#    /:/\:\  \     /:/\:\  \     /:/\ \  \     /:/__/        /:/\:\  \     /:/\:\  \   
#   /::\~\:\__\   /::\~\:\  \   _\:\~\ \  \   /::\  \ ___   /::\~\:\  \   /:/  \:\  \  
#  /:/\:\ \:|__| /:/\:\ \:\__\ /\ \:\ \ \__\ /:/\:\  /\__\ /:/\:\ \:\__\ /:/__/ \:\__\ 
#  \:\~\:\/:/  / \/__\:\/:/  / \:\ \:\ \/__/ \/__\:\/:/  / \/_|::\/:/  / \:\  \  \/__/ 
#   \:\ \::/  /       \::/  /   \:\ \:\__\        \::/  /     |:|::/  /   \:\  \       
#    \:\/:/  /        /:/  /     \:\/:/  /        /:/  /      |:|\/__/     \:\  \      
#     \::/__/        /:/  /       \::/  /        /:/  /       |:|  |        \:\__\     
#      ~~            \/__/         \/__/         \/__/         \|__|         \/__/     
#                                                                                      

# Initial. {{{

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export OS=$(uname | awk '{print tolower($1)}')
export BIN="$HOME/.bin"
export PATH="$BIN:$PATH"
# Search executable file in $PATH.
function search()
{
	local    IFS=$'\n'
	local -i i=0
	local -a TARGET=( `echo $PATH | tr ':' "\n" | sort | uniq` )

	for ((i=0; i<${#TARGET[@]}; i++)); do
		if [ -f ${TARGET[i]}/"$1" ]; then
			echo "${TARGET[i]}/$1"
		fi
	done
}

# EDITOR
all_vim_path=( `search vim` )
for ((i=0; i<${#all_vim_path[@]}; i++)); do
	if ${all_vim_path[i]} --version 2>/dev/null | grep -qi '+clipboard'; then
		clipboard_vim_path=${all_vim_path[i]}
		break
	fi
done
unset i all_vim_path clipboard_vim_path
export EDITOR="${clipboard_vim_path:-vim}"

export PAGER=less
export LESS='-f -N -X -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
export LESS='-f -X -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
export LESSCHARSET=utf-8

all_ls_path=( `search ls` )
for ((i=0; i<${#all_ls_path[@]}; i++)); do
	if ${all_ls_path[i]} --version 2>/dev/null | grep -qi "GNU"; then
		export LSPATH="${all_ls_path[i]}"
		break
	fi
done
unset i all_ls_path

# Linux.
if [ "$OS" = "linux" ]; then
	[ -f ~/.bashrc.unix ] && source ~/.bashrc.unix

	# Max OSX.
elif [ "$OS" = "darwin" ]; then
	[ -f ~/.bashrc.mac ] && source ~/.bashrc.mac
fi

# Local PC.
if [ -f ~/.bashrc.local ]; then
	source ~/.bashrc.local
fi

# Loads the file except executable one.
test -d $BIN || mkdir -p $BIN
if [ -d $BIN ]; then
	if ls -A1 $BIN | grep -q '.sh'; then
		echo ""
		for f in $BIN/*.sh ; do
			[ ! -x "$f" ] && . "$f" && echo "load $f"
		done
		echo ""
		unset f
	fi
fi
#}}}

# Utilities. {{{

# richpager.
# By the file number of lines, switch using cat or less.
# If the pygmentize exists, use it instead of cat.
function richpager()
{
	# Use cat as default pager.
	Pager='cat'
	if type pygmentize >/dev/null 2>&1; then
		# Use pygmentize, if exist.
		Pager='pygmentize'
	fi
	# Less option.
	Less='less -R +Gg'
	# Get display lines.
	DispLines=$[ $( stty 'size' < '/dev/tty' | cut -d' ' -f1 ) - 2 ]

	# Normal case.
	# Can use pygmentize to syntax highlight, if exist.
	# ex) user$ ./richpager file
	if [ $# -eq 1 ]; then
		if [ -f $1 ]; then
			Filename="$1"
			FileLines=$(wc -l <$Filename)
			if (( FileLines > DispLines )); then
				export LESSOPEN='| pygmentize %s'
				${Less} $Filename
				unset LESSOPEN
			else
				${Pager} $Filename
			fi
		fi
		return 0
	else
		# Many argument.
		# Cannot use pygmentize bacause cannot judge filetype from extension.
		# ex) user$ ./richpager file1 file2
		while (( $# > 0 )) ; do
			# Directory.
			if [[ -d "$1" ]] ; then
				ls "$1"
				exit 0

				# Readable files.
			elif [[ -r "$1" ]] ; then
				List[${#List[@]}]=$( < "$1" )

				# Enigma.
			else
				List[${#List[@]}]=$1
			fi

			shift
		done

		# Get file contents.
		if (( ${#List[@]} > 0 )) ; then
			File=$( for i in "${List[@]}" ; do echo "$i"; done )

			# No argument, no pipe.
		elif [[ -t 0 ]] ; then
			echo "error: No argument." 1>&2
			return 1

			# Pipe detected.
			# Cannot use pygmentize even if it exists.
			# See also pygmentize -h (help file).
		else
			File=$( cat - )
		fi

		# Count file chars.
		FileLines=$( echo -n "$File" | grep -c '' )

		# File is empty.
		if (( FileLines < 0 )); then
			echo "error: No entry." 1>&2
			return 1
		fi
	fi

	# Judgement cat or less.
	if (( FileLines > DispLines )); then
		echo "$File" |${Less}
	else
		echo "$File"
	fi

	return 0
}

function tac()
{
	[ -z "$1" ] && exit 1
	`which ex` -s "${1}" <<-EOF
	g/^/mo0
	%p
	EOF
}

function deadlink()
{
	local f=

	for f in `command ls -A "${1:-$PWD}"`; do
		local fpath="${1:-$PWD}/$f"
		if [ -h "$fpath" ]; then
			[ -a "$fpath" ] || command rm -i "$fpath"
		fi
	done

	unset f fpath
}

function is_exist()
{
	type $1 >/dev/null 2>&1; return $?;
}

function abs_path()
{
	if [ -z "$1" ]; then
		return 1
	fi

	if [ `expr x"$1" : x'/'` -ne 0 ]; then
		local rel="$1"
	else
		local rel="$PWD/$1"
	fi

	local abs="/"
	local _IFS="$IFS"; IFS='/'

	for comp in $rel; do
		case "$comp" in
			'.' | '')
				continue
				;;
			'..'	)
				abs=`dirname "$abs"`
				;;
			*		)
				[ "$abs" = "/" ] && abs="/$comp" || abs="$abs/$comp"
				;;
		esac
	done
	echo "$abs"
	IFS="$_IFS"
}

function rel_path()
{
	if [ -z "$1" ]; then
		return 1
	fi

	if [ `expr x"$1" : x'/'` -eq 0 ]; then
		echo "$1: not an absolute path"
		return 1
	fi

	local org=`expr x"$PWD" : x'/\(.*\)'`
	local abs=`expr x"$1"   : x'/\(.*\)'`
	local rel="."
	local org1=""
	local abs1=""

	while true; do
		org1=`expr x"$org" : x'\([^/]*\)'`
		abs1=`expr x"$abs" : x'\([^/]*\)'`

		[ "$org1" != "$abs1" ] && break

		org=`expr x"$org" : x'[^/]*/\(.*\)'`
		abs=`expr x"$abs" : x'[^/]*/\(.*\)'`
	done

	if [ -n "$org" ]; then
		local _IFS="$IFS"; IFS='/'
		for c in $org; do
			rel="$rel/.."
		done
		IFS="$_IFS"
	fi

	if [ -n "$abs" ]; then
		rel="$rel/$abs"
	fi

	rel=`expr x"$rel" : x'\./\(.*\)'`
	echo "$rel"
}

function is_pipe()
{
	if [ -p /dev/stdin ]; then
		#if [ -p /dev/fd/0  ]; then
		#if [ -p /proc/self/fd/0 ]; then
		#if [ -t 0 ]; then
		# echo a | is_pipe
		return 0
	elif [ -p /dev/stdout ]; then
		# is_pipe | cat
		return 0
	else
		# is_pipe (Only!)
		return 1
	fi
}

function nonewline()
{
	if [ "$(echo -n)" = "-n" ]; then
		echo "${@:-> }\c"
	else
		echo -n "${@:-> }"
	fi
}

function is_num()
{
	expr "$1" \* 1 >/dev/null 2>&1
	if [ $? -ge 2 ]; then
		return 1
	else
		return 0
	fi
}

function strcmp()
{
	# abc == abc (return  0)
	# abc =< def (return -1)
	# def >= abc (return  1)
	if [ $# -ne 2 ]; then
		echo "Usage: strcmp string1 string2" 1>&2
		exit 1
	fi
	if [ "$1" = "$2" ]; then
		#return 0
		echo "0"
	else
		local _TMP=`{ echo "$1"; echo "$2"; } | sort -n | sed -n '1p'`

		if [ "$_TMP" = "$1" ]; then
			#return -1
			echo "-1"
		else
			#return 1
			echo "1"
		fi
	fi
}

function strlen()
{
	local length=`echo "$1" | wc -c | sed -e 's/ *//'`
	echo `expr $length - 1`
}

function sort()
{
	if [ "$1" = '--help' ]
	then
		command sort --help
		echo -e '\n\nOptions that are described below is an additional option that was made by b4b4r07.\n'
		echo -e '  -p, --particular-field    sort an optional field; if not given arguments, 2 as a default\n'
		return 0
	elif [ "$1" = '-p' -o "$1" = '--particular-field' ]
	then
		shift
		gawk '
		{
			line[NR] = $'${1:-2}' "\t" $0;
		}

		END {
		asort(line);
		for (i = 1; i <= NR; i++) {
			print substr(line[i], index(line[i], "\t") + 1);
		}
	}' 2>/dev/null
	return 0
fi
command sort "$@"
}
#}}}

# Appearance. {{{
export CR="$(echo -ne '\r')"
export LF="$(echo -ne '\n')"
export TAB="$(echo -ne '\t')"
export ESC="$(echo -ne '\033')"
export COLOUR_BLACK="${ESC}[30m"
export COLOUR_RED="${ESC}[31m"
export COLOUR_GREEN="${ESC}[32m"
export COLOUR_YELLOW="${ESC}[33m"
export COLOUR_BLUE="${ESC}[34m"
export COLOUR_CYAN="${ESC}[35m"
export COLOUR_MAGENTA="${ESC}[36m"
export COLOUR_WHITE="${ESC}[37m"
export COLOUR_HIGHLIGHT_BLACK="${ESC}[30;1m"
export COLOUR_HIGHLIGHT_RED="${ESC}[31;1m"
export COLOUR_HIGHLIGHT_GREEN="${ESC}[32;1m"
export COLOUR_HIGHLIGHT_YELLOW="${ESC}[33;1m"
export COLOUR_HIGHLIGHT_BLUE="${ESC}[34;1m"
export COLOUR_HIGHLIGHT_CYAN="${ESC}[35;1m"
export COLOUR_HIGHLIGHT_MAGENTA="${ESC}[36;1m"
export COLOUR_HIGHLIGHT_WHITE="${ESC}[37;1m"
export COLOUR_DEFAULT="${ESC}[m"

PS_HOST="\[${COLOUR_GREEN}\]\h\[${COLOUR_DEFAULT}\]"
PS_USER="\[${COLOUR_GREEN}\]\u\[${COLOUR_DEFAULT}\]"
PS_WORK="\[${COLOUR_HIGHLIGHT_YELLOW}\]\w\[${COLOUR_DEFAULT}\]"
PS_HIST="\[${COLOUR_RED}\](\!)\[${COLOUR_DEFAULT}\]"

if [ -n "${WINDOW}" ] ; then
	PS_SCREEN="\[${COLOUR_CYAN}\]#${WINDOW}\[${COLOUR_DEFAULT}\]"
else
	PS_SCREEN=""
fi

if [ -n "${TMUX}" ] ; then
	TMUX_WINDOW=$(tmux display -p '#I-#P')
	PS_SCREEN="\[${COLOUR_CYAN}\]#${TMUX_WINDOW}\[${COLOUR_DEFAULT}\]"
else
	PS_SCREEN=""
fi

if [ -n "${SSH_CLIENT}" ] ; then
	PS_SSH="\[${COLOUR_MAGENTA}\]/$(echo ${SSH_CLIENT} | sed 's/ [0-9]\+ [0-9]\+$//g')\[${COLOUR_DEFAULT}\]"
else
	PS_SSH=""
fi

PS1=
if type __git_ps1 >/dev/null 2>&1; then
	GIT_PS1_SHOWDIRTYSTATE=true
	GIT_PS1_SHOWSTASHSTATE=true
	GIT_PS1_SHOWUNTRACKEDFILES=true
	GIT_PS1_SHOWUPSTREAM=auto
	PS_GIT="${COLOUR_RED}"'$(__git_ps1)'"${COLOUR_DEFAULT}"

	PS1+="${PS_USER}@${PS_HOST}:${PS_WORK}${PS_GIT}"
	PS1+='$ '
else
	PS1+="[${PS_USER}${PS_ATODE}@${PS_HOST}${PS_SCREEN}${PS_SSH}:${PS_WORK}]\[\033[01;32m\]"
	PS1+='$(if git status &>/dev/null;then echo git[branch:$(git branch | cut -d" "  -f2-) change:$(git status -s |wc -l)];fi)\[\033[00m\]'
	PS1+='$ '
fi
export PS1;
#}}}

# Mappings. {{{

alias vi="$EDITOR"
alias vim="$EDITOR"

if $(is_exist 'gls'); then
	alias ls="gls --color=auto -F -b"
else
	alias ls="$LSPATH --color=auto -F -b"
fi

# Git.
if $(is_exist 'git'); then
	alias gst='git status'
fi

# function
alias cl="richpager"

# Common aliases
alias ..="cd .."
alias ld="ls -ld"          # show info about the directory
alias lla="ls -lAF"        # show hidden all files
alias ll="ls -lF"          # show long file information
alias la="ls -AF"          # show hidden files
alias lx="ls -lXB"         # sort by extension
alias lk="ls -lSr"         # sort by size, biggest last
alias lc="ls -ltcr"        # sort by and show change time, most recent last
alias lu="ls -ltur"        # sort by and show access time, most recent last
alias lt="ls -ltr"         # sort by date, most recent last
alias lm="ls -al | more"   # pipe through 'more'
alias lr="ls -lR"          # recursive ls
alias cp="cp -i"
alias mv="mv -i"
alias du="du -h"
alias jobs="jobs -l"
alias temp="test -e ~/temporary && command cd ~/temporary || mkdir ~/temporary && cd ~/temporary"
alias untemp="command cd $HOME && rm ~/temporary && ls"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
# Use if colordiff exists
alias diff='diff -u'
if $(is_exist 'colordiff'); then
	alias diff='colordiff -u'
fi
# Use plain vim.
alias nvim='vim -N -u NONE -i NONE'

# The first word of each simple command, if unquoted, is checked to see 
# if it has an alias. [...] If the last character of the alias value is 
# a space or tab character, then the next command word following the 
# alias is also checked for alias expansion
alias sudo='sudo '
#}}}

# Misc. {{{
if [ ! -f $BIN/cdhist.sh ]; then
	function cd()
	{
		builtin cd "$@" && ls;
	}
fi

# history {{{
HISTSIZE=50000
HISTFILESIZE=50000

export MYHISTFILE=$HOME/.bash_myhistory
function show_exit()
{
if [ "$1" -eq 0 ]; then return; fi
echo -e "\007exit $1"
}

function log_history()
{
echo "$(date '+%Y-%m-%d %H:%M:%S') $HOSTNAME:$$ $PWD ($1) $(history 1)" >> $MYHISTFILE
}

function prompt_cmd()
{
local s=$?
show_exit $s;
log_history $s;
}

function end_history()
{
log_history $?;
echo "$(date '+%Y-%m-%d %H:%M:%S') $HOSTNAME:$$ $PWD (end)" >> $MYHISTFILE
}

echo "$(date '+%Y-%m-%d %H:%M:%S') $HOSTNAME:$$ $PWD (start)" >> $MYHISTFILE
trap end_history EXIT
PROMPT_COMMAND="prompt_cmd;$PROMPT_COMMAND"
#}}}

# vim:fdm=marker fdc=3 ft=sh ts=2 sw=2 sts=2:
#}}}
