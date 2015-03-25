# dub.vim
Vim Pluginの [Syntastic](https://github.com/scrooloose/syntastic)では、  
デフォルトで `$HOME/.dub/packages` の中身をシンタックスチェック時に使ってくれるけど  
dub.json で「ローカルにしかないライブラリをインポートした時(subPakcagesとか)」 に  
そのライブラリを見つけてくれなくて困った。
だからやっつけで書いた。

syntastic使ってない人にはメリット無い。
vim使ってない人にもメリット無い。

永遠のβ版。

** Requirements **
- vim
- syntastic
- dub (検索パスを `dub describe` コマンドで探す為)
