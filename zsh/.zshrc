# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# enable git completion
autoload -Uz compinit && compinit

# opam configuration
[[ ! -r /Users/silvus/.opam/opam-init/init.zsh ]] || source /Users/silvus/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
eval $(opam env) > /dev/null 2> /dev/null

# set up opam variables when cd-ing into directory with _opam file
autoload -U add-zsh-hook
_opam_cd_hook() {
  if [[ -e _opam ]]; then
    eval $(opam env)
  fi
}
add-zsh-hook chpwd _opam_cd_hook


source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH=/Users/silvus/Library/Python/3.9/bin/:$PATH
