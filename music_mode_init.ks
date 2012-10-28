
;storageから番号を探し
;flagを記録する
;マクロの間に入れて使ってくれ
;例
;@macro name=pl
;@playbgm *
;@flagmusic *
;@endmacro

@macro name=flagmusic        
@eval exp="sf.music_flag[music.music_storage.find(mp.storage)] = true"
@endmacro

;前処理と設定
@iscript
var music = %[];
music.base = 'black'; //背景画像
music.playmark = 'checked'; //再生中のマーク
music.line   = 7; //横の数
music.column = 3; //縦の数
music.base_x = 50; //初期x座標
music.base_y = 35; //初期y座標
music.page_basex = 500; //ページボタンの初期x座標
music.page_basey = 0;   //ページボタンの初期y座標
music.page_width = 20;  //ページボタン間の幅
music.page_height = 0;  //ページボタン間の高さ
music.width  = (kag.scWidth - music.base_x*2)\music.column; //幅
music.height = 50; //高さ
music.music_storage = []; //音楽ファイル名を入れる
music.music_caption = []; //ミュージックモードに表示されるタイトルを入れる
music.music_storage = [   //2つの配列は同じ順番でなくてはならない
'kb1',
'kb2',
'kkhk',
'kkn1',
'knsm1',
'knsm2',
'knsm3',
'ntj1',
'ntj2',
'ntj3',
'ntj4',
'ntj5',
'rck2',
'rck3',
'rck4',
'sekai1',
'sjk1',
'sr1',
'sr2',
'sr3',
'srs1',
'srs2',
'ttl',
'ynt1',
'yss1',
'yss2',
'yss3'
];
music.music_caption = [
'kb1',
'kb2',
'kkhk',
'kkn1',
'knsm1',
'knsm2',
'knsm3',
'ntj1',
'ntj2',
'ntj3',
'ntj4',
'ntj5',
'rck2',
'rck3',
'rck4',
'sekai1',
'sjk1',
'sr1',
'sr2',
'sr3',
'srs1',
'srs2',
'ttl',
'ynt1',
'yss1',
'yss2',
'yss3'
];
if (sf.music_mode_init === void){
	//最初に一度だけ実行
	//聞いたかどうかのフラグ
	sf.music_flag = %[];
	for (var i = 0; i < music.music_storage.count; i++){
		sf.music_flag[i] = false;
	}
	sf.music_mode_init = 1;
}
if (0){ //全ての曲を聞いたことにする
	for (var i=0; i < music.music_storage.count; i++){
		sf.music_flag[i]=true;
	}
}
music.page = 0;
music.maxpage = music.music_caption.count%(music.column*music.line) == 0 ? music.music_caption.count\(music.column*music.line) - 1 : music.music_caption.count\(music.column*music.line);
@endscript

@return
