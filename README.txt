赤恐竜	http://akakyouryuu.blog.fc2.com/


よくあるミュージックモードを実装する

もしも使いたい人がいたなら好きに使っていいです。
改変、再配布は自由
使用を明記する必要も報告する必要もないですが、
報告をくれるとうれしいです。
当然なにかあっても責任は取れないけど
スライダーには色々な墓場のKLayers.ksを利用しています。
http://www.geocities.jp/keep_creating/krkrplugins/

全部入りサンプルをホームページ、ブログで公開中

機能
一度聞いた曲だけ表示する
タイトル数に合わせて、自動でぺージを調整する
タイトルに合わせて、背景をトランジション
マウスホイールでページ移動
再生位置表示、調整スライダー
一時的な音量変更
ある程度レイアウトも変更出来る

使っている変数
sf.music_flag
sf.music_mode_init
global.music

使い方
設定後、first.ksでmusic_mode_init.ksを読み込む
例
@call music_mode_init.ks
後はmusic_mode.ksをサブルーチンとして呼べばよい
例
[link exp="kag.callExtraConductor('music_mode.ks', '*music_mode')"]ミュージックモード[endlink]

設定方法


music_mode.ksのラベル*backの右クリックの設定を環境にあわせてかえる。
music_mode_init.ksの18行目からの各コメントを参照しながら変数を書きかえる。
また、music.complete()を実行することで全ての曲を聞いたことにできる

次にflagmusicを曲を演奏するマクロに組み込む
例
@macro name=pl
@playbgm *
@flagmusic *
@endmacro
これでいちど聞いた曲は記録される
ただし、storageで指定された文字列をmusic.music_storageから探して
記録しているので拡張子の有無は統一しなければならない
