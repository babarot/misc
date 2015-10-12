#!/bin/bash

function richpager()
# By the file number of lines, switch using cat or less.
# If the pygmentize exists, use it instead of cat.
{
	# Use cat as default pager.
	Pager='cat'
	if type pygmentize >/dev/null 2>&1; then
		# Use pygmentize, if exist.
		Pager='pygmentize -O style=monokai -f console256 -g'
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
				export LESSOPEN="| $Pager %s"
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
			case "$1" in
				'-n')
					nflag='-n'
					shift && continue
					;;
			esac

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
		echo "$File" | cat ${nflag} |${Less}
	else
		echo "$File" | cat ${nflag}
	fi

	return 0
}
richpager "$@"
