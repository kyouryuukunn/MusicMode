

よくあるミュージックモードを実装する

もしも使いたい人がいたなら好きに使っていい
改変、再配布は自由
使用を明記する必要も報告する必要もない
けど報告をくれるとうれしい

機能
一度聞いた曲だけ表示する
タイトル数に合わせて、自動でぺージを調整する
再生位置表示、調整スライダー
一時的な音量変更
使い方
設定後、first.ksでmusic_mode_init.ksを読み込む
例
@call music_mode_init.ks
後はmusic_mode.ksをサブルーチンとして呼べばよい
例
[link exp="kag.callExtraConductor('music_mode.ks', '*music_mode')"]ミュージックモード[endlink]

設定方法
まずAfterinit.tjs(なければつくる)につぎのくわえる
kag.onCloseQuery = function ()
{
	saveSystemVariables();
	if(!askOnClose) { global.Window.onCloseQuery(true); return; }
	tf.timer.enabled=false if tf.timer !== void;
	global.Window.onCloseQuery(askYesNo("終了しますか？"));
} incontextof kag;

293行目の右クリックの設定を環境にあわせてかえる
music_mode_init.ksの18行目からの各変数を書きかえる

music.base = 'black'; //背景画像
music.playmark = 'checked'; //再生中のマーク
music.line   = 7;  //ミュージックタイトルを表示する横の数
music.column = 3;  //ミュージックタイトルを表示する縦の数
music.base_x = 50; //ミュージックタイトルを表示する初期x座標
music.base_y = 35; //ミュージックタイトルを表示する初期y座標
music.width  = (kag.scWidth - music.base_x*2)\music.column; //ミュージックタイトル間の幅
music.height = 50; //ミュージックタイトル間の高さ
music.music_storage = []; //音楽ファイル名を入れる
music.music_caption = []; //ミュージックモードに表示されるタイトルを入れる
2つの配列は同じ順番でなくてはならない
また、95行目の0を1にすることで全ての曲を聞いたことにできる

次にflagmusicを曲を演奏するマクロに組み込む
例
@macro name=pl
@playbgm *
@flagmusic *
@endmacro
これでいちど聞いた曲は記録される
ただし、storageで指定された文字列をmusic.music_storageから探して
記録しているので拡張子の有無は統一しなければならない
