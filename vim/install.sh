#!/usr/bin/env bash

vim +PlugInstall +qall
cd ~/.vim/bundle/YouCompleteMe
./install.py --clang-completer --js-completer --enable-coverage --enable-debug  && cd -
