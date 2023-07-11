# zsh install shell

## install

```sh
curl -fsSL https://raw.githubusercontent.com/lautumn1990/zsh/main/zsh.sh -o zsh.sh && bash zsh.sh
# theme
# curl -fsSL https://raw.githubusercontent.com/lautumn1990/zsh/main/zsh.sh -o zsh.sh && bash zsh.sh -t ys
```

## uninstall

```sh
curl -fsSL https://raw.githubusercontent.com/lautumn1990/zsh/main/zsh.sh -o zsh.sh && bash zsh.sh -u
```

## attention

- after install or uninstall you should restart your terminal

- install or uninstall process maybe need your input password

- don't use `sudo` to run this script

## use proxy

```sh
PROXY=socks5://127.0.0.1:1080 && https_proxy=$PROXY curl -fsSL https://raw.githubusercontent.com/lautumn1990/zsh/main/zsh.sh -o zsh.sh && https_proxy=$PROXY bash zsh.sh
```

## config

this script will install oh-my-zsh and set zsh as default shell, default theme is `ys`, you can change it in `~/.zshrc` file.

## plugins

- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
  - add `shift`+`tab` to accept suggestion [Use <tab> to choose autosuggestion](https://github.com/zsh-users/zsh-autosuggestions/issues/532#issuecomment-637832244)
- [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search)
- [sudo](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo)
- [colored-man-pages](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/colored-man-pages)
- [extract](https://github.com/le0me55i/zsh-extract)
- [autojump](https://github.com/wting/autojump)
- [jsontools](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/jsontools)
- [last-working-dir](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/last-working-dir)

## reference

- [thinkycx-zsh.sh](https://gist.github.com/thinkycx/2e21c3572a8d1fde21aad07a58fcf940/)
- [aiktb/dotzsh](https://github.com/aiktb/dotzsh)