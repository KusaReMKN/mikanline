# mikanline.vim

ファイルに指定された自動コマンドを自動的に設定する Vim プラグイン

## 概要

**mikanline** は、ファイルの先頭や末尾の数行に配置された、modeline のような行に記述された一連の指示に従って自動コマンド（autocmd）を自動的に設定する Vim プラグインです。

このプラグインは、もともと、ファイルに含まれる句読点（、。）をカンマとピリオド（，．）に置き換える処理を、ファイル書き込み前に自動的に行いたいという思いから開発されました。

## 例

詳しい説明は doc/mikanline.jax にありますが、長い説明を読むよりも体験したほうが早いと思います（説明力が足りない）。

まず、vimrc に次のように記述してみてください。
この記述によって **forceComma** と **forcePeriod** の mikanline コマンドが定義されます。
**forceComma** はバッファ保存時に全ての読点をカンマに置換する機能を、**forcePeriod** はバッファ保存時に全ての句点をピリオドに置換する機能を提供します。

```vim
let g:mikanline = {
    \ 'forceComma': {
        \ 'BufWrite': [
            \ "let s:curpos = getpos('.')",
            \ 'silent! g/、/s//，/eg',
            \ "call setpos('.', s:curpos)",
            \ 'unlet s:curpos'
        \ ]
    \ },
    \ 'forcePeriod': {
        \ 'BufWrite': [
            \ "let s:curpos = getpos('.')",
            \ 'silent! g/。/s//．/eg',
            \ "call setpos('.', s:curpos)",
            \ 'unlet s:curpos'
        \ ]
    \ }
\ }
```

そして、内容が変更されても問題ないようなファイルを用意します。
ファイルには以下のような内容を保存します。
`mkn:` から始まる行が句読点をカンマとピリオドに置換する機能を利用することを示しています。

```text
このファイルに含まれる句読点は、保存時に自動的にカンマとピリオドに置き換えられます。

mkn: forceComma forcePeriod :
```

最後に、上のファイルを開き直します（上のファイルを開いている状態であるならば `:e` を実行すれば良いです）。
この時に **modeline** が有効になっている必要があります。
このファイルを保存すると（`:w` を実行すると）ファイルに含まれる句読点はカンマとピリオドに置換されます。

## License

The 2-Clause BSD License
