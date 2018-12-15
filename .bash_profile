set_title() {
  echo -ne "\033]0;${1}\007"
}

env_india() {
  export country=IN
  export NODE_ENV=development
}

print_path() {
  echo $PATH | jq -CRs 'split(":")'
}

# docker_login() {
#     $(aws ecr get-login --region us-west-2 | sed s/-e.none.//)
# }

# docker_winston() {
#     local begin_log="node app.js"
#     docker logs $1 2>&1 | sed -n "/${begin_log}/,\$p" | tail -n +2
# }

docker_ps_json() {
  docker ps --all --no-trunc --format '{{ json . }}' | jq '{names: .Names, cmd: .Command, status: .Status, id: .ID }'
}

docker_bash() {
    docker exec -it $1 bash
}

config_aws() {
  which aws >> /dev/null
  if [ $? -eq 0 ]; then return 0; fi

  which aws_completer >> /dev/null
  if [ $? -eq 0 ]; then return 0; fi

  complete -C $(which aws_completer) aws
}

config_go() {
  local dir=/usr/local/go/bin
  if [ -d "${dir}" ]; then
    export GOPATH=${HOME}/.go
    export PATH=${dir}:${GOPATH}:${PATH}
  fi

  local jiq_dir=${GOPATH}/src/github.com/fiatjaf/jiq/cmd/jiq
  if [ -d "${jiq_dir}" ]; then
    export PATH=${jiq_dir}:${PATH}
  fi
}

config_chrome() {
  local dir=/Applications/Google\ Chrome.app/Contents/MacOS
  if [ -d "${dir}" ]; then
    export PATH=${dir}:${PATH}
    alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
  fi
}

config_blender() {
  local dir=/Applications/Blender/blender.app/Contents/MacOS
  if [ -d ${dir} ]; then
    export PATH=${dir}:${PATH}
  fi
}

# config_make() {
#   # NOTE: something wrong with syntax probably bash4
#   local make_completion=${HOME}/.bash_completion.d/make
#   if [ -f ${make_completion} ]; then
#     source ${make_completion}
#   fi
# }

config_brew() {
  which brew >> /dev/null
  if [ $? -eq 0 ]; then return 0; fi
  which ruby >> /dev/null
  if [ $? -eq 0 ]; then return 0; fi

  local brew_url="https://raw.githubusercontent.com/Homebrew/install/master/install"
  ruby -e "$(curl -fsSL ${brew_url})"
}

config_python() {
  local python2_path=${HOME}/Library/Python/2.7/bin
  if [ -d ${python2_path} ] && [[ "$PATH" != *"${python2_path}"* ]]; then
    export PATH=${python2_path}:$PATH
  fi

  local python3_system_path=/Library/Frameworks/Python.framework/Versions/3.7/bin
  if [ -d ${python3_system_path} ]; then
    export PATH=${python3_system_path}:${PATH}
  fi

  local python3_path=${HOME}/Library/Python/3.7/bin
  if [ -d ${python3_path} ] && [[ "$PATH" != *"${python3_path}"* ]]; then
    export PATH=${python3_path}:$PATH
  fi
}

config_docker() {
  local docker_machine_completion=${HOME}/.bash_completion.d/docker-machine.bash
  local docker_compose_completion=${HOME}/.bash_completion.d/docker-compose

  if [ -f ${docker_machine_completion} ]; then
    source ${docker_machine_completion}
  fi
  if [ -f ${docker_compose_completion} ]; then
    source ${docker_compose_completion}
  fi
}

config_git() {
  local git_core=/Library/Developer/CommandLineTools/usr/share/git-core
  local git_prompt=${git_core}/git-prompt.sh
  if [ -f ${git_prompt} ]; then
    source ${git_prompt}
    export GIT_PS1_SHOWDIRTYSTATE=1
    export PS1='🌀\u@\h[\[\033[34m\]\w\[\033[m\]\[\033[31m\]$(__git_ps1 "(%s)")\[\033[m\]]% '
  fi
  local dotfiles=${HOME}/dotfiles
  local git_completion=${dotfiles}/git-completion.bash
  if [ -f ${git_completion} ]; then
    source ${git_completion}
  fi
}

config_code() {
  local code_path=/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin
  if [ -d "${code_path}" ] && [[ "$PATH" != *"${code_path}"* ]]; then
    export PATH="${code_path}":$PATH
  fi
}

config_user() {
  alias tree='\tree -C -L 2'
  alias ls='\ls -FG'
  alias git_branch="git branch 2>/dev/null | grep '^*' | colrm 1 2"
  export PS1="🌀\u@\h[\[\033[34m\]\\w\[\033[m\]]\[\033[31m\]\$(git_branch)\[\033[m\]% "

  # brew install bash-completion
  local brew_path=$(brew --prefix)
  if [ -f ${brew_path}/etc/bash_completion ]; then
    . ${brew_path}/etc/bash_completion
  fi

}

config_npm() {
  local npm_completion=${HOME}/.bash_completion.d/npm.bash
  if [ -e "${npm_completion}" ]; then
    source ${npm_completion}
  fi

  local nvm_dir=$(brew --prefix nvm)
  local nvm_completion=${nvm_dir}/bash_completion
  if [ -f ${nvm_dir}/nvm.sh ]; then
    export NVM_DIR=${nvm_dir}
    source ${nvm_dir}/nvm.sh
  fi
  if [ -s "${nvm_dir}/bash_completion" ]; then
    source "${nvm_dir}/bash_completion"
  fi

  local npm_packages=$HOME/.npm-packages
  if [ -d ${npm_packages} ]; then
    export PATH=${npm_packages}/bin:${PATH}
    # export MANPATH="${npm_packages}/share/man:$(manpath)"
  fi
}

config_cassandra() {
  local cassandra_path=$HOME/opt/cassandra/bin
  if [ -d ${cassandra_path} ] && [[ "$PATH" != *${cassandra_path}* ]]; then
      export PATH=${cassandra_path}:$PATH
  fi
}

config_iterm2() {
  local iterm2=${HOME}/.bash_iterm2_integration
  if [ -f ${iterm2} ]; then
    source ${iterm2}
  fi
}

config_all() {
  # config_blender
  # config_cassandra
  # config_make
  config_brew
  config_npm
  config_user
  config_git
  config_code
  config_docker
  config_python
  config_chrome
  config_go
  config_iterm2
  config_aws
}

config_all

