export PATH=~/.conda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('~/.conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "~/.conda/etc/profile.d/conda.sh" ]; then
        . "~/.conda/etc/profile.d/conda.sh"
    else
        export PATH="~/.conda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
