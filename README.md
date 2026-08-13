# Jasperes Dotfiles

Look at files in `.config/mise` to see what it will install and configure.

## Requirements

- [mise-en-place](https://mise.jdx.dev/installing-mise.html)

## Installing

- Save this project to `~/.dotfiles`
- Copy folder `~/.dotiles/.config/mise` to `~/.config/mise`
- Run `mise bootstrap`

## Customize

This project import `.env` from HOME to shell profile,
wich can be created on dotfiles folder.

To select mise profiles, add something like this:

```env
MISE_ENV="cachyos,kde,amd"
```

Then run again `mise bootstrap` to update.
