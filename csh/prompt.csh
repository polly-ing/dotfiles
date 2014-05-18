# The various escape codes that we can use to color our prompt.
         RED="\[\033[0;31m\]"
      YELLOW="\[\033[0;33m\]"
LIGHT_YELLOW="\[\033[4;33m\]"
       GREEN="\[\033[0;32m\]"
        BLUE="\[\033[0;34m\]"
   LIGHT_RED="\[\033[1;31m\]"
 LIGHT_GREEN="\[\033[1;32m\]"
       WHITE="\[\033[1;37m\]"
  LIGHT_GRAY="\[\033[0;37m\]"
        CYAN="\[\033[0;36m\]"
  COLOR_NONE="\[\e[0m\]"
     PURPLE="\[\033[0;35m\]"

function set_py_venv {
  virtualenv="$(awk 'BEGIN{split(ENVIRON["VIRTUAL_ENV"], a, /\//); print a[5]}')"
  # virtualenv="$(awk 'BEGIN{print ENVIRON[\"VIRTUAL_ENV\"]}' | awk 'BEGIN {FS=\"/\"} {print \$NF}'))"
  PY_VENV="${LIGHT_YELLOW}${virtualenv}${COLOR_NONE}"
}
# Detect whether the current directory is a git repository.
function is_git_repository {
  git branch > /dev/null 2>&1
}

function set_git_repo {
  repo="$(git remote -v 2> /dev/null | awk '/origin.*fetch/  { print $2 }' | awk 'BEGIN {FS="/"} {print $2}' | awk 'BEGIN {FS=".git"} {print $1}')"
  # Set the repo string.
  REPO="${CYAN}${repo}${COLOR_NONE}"
  OPEN_BRACKET="${CYAN}[${COLOR_NONE}"
  CLOSE_BRACKET="${CYAN}]${COLOR_NONE}"
  REPO_NEWLINE='\n'
  REPO_SEPARTOR=':'
}

# Determine the branch/state information for this git repository.
function set_git_branch {
  # Capture the output of the "git status" command.
  git_status="$(git status 2> /dev/null)"

  # Set color based on clean/staged/dirty.
  if [[ ${git_status} =~ "working directory clean" ]]; then
    state="${GREEN}"
  elif [[ ${git_status} =~ "Changes to be committed" ]]; then
    state="${YELLOW}"
  else
    state="${RED}"
  fi

  # Set arrow icon based on status against remote.
  remote_pattern="# Your branch is (.*) of"
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
      remote="↑"
    else
      remote="↓"
    fi
  else
    remote=""
  fi
  diverge_pattern="# Your branch and (.*) have diverged"
  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="↕"
  fi

  # Get the name of the branch.
  branch_pattern="^# On branch ([^${IFS}]*)"
  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${BASH_REMATCH[1]}
  fi

  # Set the final branch string.
  BRANCH="${state}${branch}${remote}${COLOR_NONE}"
}

# Return the prompt symbol to use, colorized based on the return value of the
# previous command.
function set_prompt_symbol () {
  if test $1 -eq 0 ; then
      PROMPT_SYMBOL="\$"
  else
      PROMPT_SYMBOL="${RED}\$${COLOR_NONE}"
  fi
}

# Set the full bash prompt.
function set_bash_prompt () {
  # Set the PROMPT_SYMBOL variable. We do this first so we don't lose the
  # return value of the last command.
  set_prompt_symbol $?

  set_cloud
  set_py_venv
  # Set the BRANCH variable.
  if is_git_repository ; then
    set_git_branch
    set_git_repo
  else
    BRANCH=''
    REPO=''
    OPEN_BRACKET=''
    CLOSE_BRACKET=''
    REPO_NEWLINE=''
    PROMPT_SYMBOL='\$'
  fi

  # Set the bash prompt variable.
  # PS1="$GREEN\u@\h$COLOR_NONE:\w ${REPO_NEWLINE}${REPO}${OPEN_BRACKET}${BRANCH}${CLOSE_BRACKET}${PROMPT_SYMBOL}$COLOR_NONE "
  PS1="${REPO}${OPEN_BRACKET}${BRANCH}${CLOSE_BRACKET}$COLOR_NONE${REPO_NEWLINE}"
  PS1="$PS1$GREEN\u@\h$COLOR_NONE:\w ${PROMPT_SYMBOL}$COLOR_NONE "
  PS1="$YELLOW${PY_VENV} $PS1"
  PS1="$YELLOW[\$(~/.rvm/bin/rvm-prompt v p g)] $PS1"
  PS1="\n$PURPLE\t $PS1"
}

# Tell bash to execute this function just before displaying its prompt.
PROMPT_COMMAND=set_bash_prompt
