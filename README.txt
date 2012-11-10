

よくあるミュージックモードを実装する

もしも使いたい人がいたなら好きに使っていいです。
改変、再配布は自由
使用を明記する必要も報告する必要もないですが、
報告をくれるとうれしいです。
当然なにかあっても責任は取れないけど
スライダーには色々な墓場のKLayers.ksを利用しています。


全部入りサンプルをskydriveで公開中
https://skydrive.live.com/#cid=8F8EF4D2142F33D4&id=8F8EF4D2142F33D4!257

機能
一度聞いた曲だけ表示する
タイトル数に合わせて、自動でぺージを調整する
タイトルに合わせて、背景をトランジション
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
まずAfterinit.tjs(なければつくる)につぎの文をくわえる
kag.onCloseQuery = function ()
{
	saveSystemVariables();
	if(!askOnClose) { global.Window.onCloseQuery(true); return; }
	delete music.timer if music.timer !== void;
	global.Window.onCloseQuery(askYesNo("終了しますか？"));
} incontextof kag;

music_mode.ksのラベル*backの右クリックの設定を環境にあわせてかえる
music_mode_init.ksの18行目からの各変数を書きかえる

music.base = 'black'; //背景画像
music.playmark = 'checked'; //再生中のマークを表示する画像
music.line   = 7;  //再生タイトルを表示する列数
music.column = 3;  //再生タイトルを表示する行数
music.base_x = 50; //再生タイトルの初期x座標
music.base_y = 35; //再生タイトルの初期y座標
music.width  = (kag.scWidth - music.base_x*2)\music.column; //列の幅
music.height = 50; //行の幅
music.page_basex = 500; //ページボタンの初期x座標
music.page_basey = 0;   //ページボタンの初期y座標
music.page_width = 20;  //ページボタン間の幅
music.page_height = 0;  //ページボタン間の高さ
music.page_font = %['italic' => true];  //ページボタンのフォント
music.music_storage = []; //音楽ファイル名を入れる
music.music_caption = []; //ミュージックモードに表示されるタイトルを入れる
music.music_cg_on = 0; //曲に合わせて背景を変更するか
music.music_cg = []; //表示するCG

music_storage, music_caption, music_cgの配列は同じ順番でなくてはならない
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
