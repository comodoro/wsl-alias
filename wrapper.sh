#!/bin/bash

# getting the arguments

uri="$1"
shift
cmd="$@"

# loading the custom environment

wsl_dir="$HOME/.wsl"
wsl_interactive="0"

if [ -z "$cmd" ]; then
  wsl_interactive="1"
fi

wsl_sudo () {
  sudo -u "wsl" sudo $1
}

if [ -f "$wsl_dir/env.sh" ]; then
  source "$wsl_dir/env.sh"
fi

# parsing the uri

uri=$(echo "$uri" | sed 's/\\/\//g')
uri=$(echo "$uri" | sed 's/://g')
uri=$(echo "$uri" | sed 's/^./\L&\E/')
uri="/mnt/$uri"



cd "$uri"

if [ -z "$cmd" ]; then
  cmd="bash"
fi

eval "$cmd"
