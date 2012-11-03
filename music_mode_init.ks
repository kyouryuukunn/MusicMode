
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
music.base = 'black'; //背景、透明部分がある場合は、直前のゲーム画面が見える
music.playmark = 'checked'; //再生中のマーク
music.line   = 1; //横の数
music.column = 2; //縦の数
music.base_x = 50; //初期x座標
music.base_y = 35; //初期y座標
music.width  = (kag.scWidth - music.base_x*2)\music.column; //タイトル間の幅
music.height = 50; //タイトル間の高さ
music.page_basex = 500; //ページボタンの初期x座標
music.page_basey = 0;   //ページボタンの初期y座標
music.page_width = 20;  //ページボタン間の幅
music.page_height = 0;  //ページボタン間の高さ
music.page_font = %['italic' => true];  //ページボタンのフォント
music.music_storage = []; //音楽ファイル名を入れる
music.music_caption = []; //ミュージックモードに表示されるタイトルを入れる
music.music_storage = [   //2つの配列は同じ順番でなくてはならない
'tw039', 
'tw043', 
'tw044', 
'tw045', 
'tw042', 
'tw041' 
];
music.music_caption = [
'tw039', 
'tw043', 
'tw044', 
'tw045', 
'tw042', 
'tw041' 
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
function music_mode_complete(){ //全ての曲を聞いたことにする
	for (var i=0; i < music.music_storage.count; i++){
		sf.music_flag[i]=true;
	}
}
music.page = 0;
music.maxpage = music.music_caption.count%(music.column*music.line) == 0 ? music.music_caption.count\(music.column*music.line) - 1 : music.music_caption.count\(music.column*music.line);
Scripts.evalStorage("SliderLayer.tjs");
@endscript

@return
