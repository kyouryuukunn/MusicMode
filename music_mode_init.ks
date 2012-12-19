
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
//ここを書き換える↓------------------------------------------------------- 
music.base = 'black'; //背景画像、透明部分がある場合は、直前のゲーム画面が見える
music.slider_base = 'slider_base';	//スライダーの背景画像
music.slider_tab = 'slider_tab';	//スライダーのつまみ用ボタン画像
music.playmark = 'playing'; //再生中マークの画像
music.playmark_x = -37; //再生中マークのタイトルからの相対x座標
music.playmark_y = 8; //再生中マークのタイトルからの相対y座標
music.line   = 2;  //再生タイトルを表示する列数
music.column = 2;  //再生タイトルを表示する行数
music.base_x = 50; //再生タイトルの初期x座標
music.base_y = 35; //再生タイトルの初期y座標
music.width  = (kag.scWidth - music.base_x*2)\music.column; //列の幅
music.height = 50; //行の幅
music.page_basex = 500; //ページボタンの初期x座標
music.page_basey = 0;   //ページボタンの初期y座標
music.page_width = 20;  //ページボタン間の幅
music.page_height = 0;  //ページボタン間の高さ
music.page_cg = ['1', '2'];  	//ページボタンに使用するボタン画像, この配列が空なら文字そうでないなら画像を表示する
			//例 music.page_cg = ['1', '2'] 前から順に使用する分だけ指定する
music.nowpage_cg = ['off_1', 'off_2'];	//ページボタンに画像を使用するときはここに現在のページの画像を指定する
music.page_font = %['italic' => true];  //ページボタンに文字を使うときのフォント
					//(ユーザーがフォントを変更すると不味いのでちゃんと指定すること)
music.music_caption_font = %['italic' => true];	//曲タイトルのフォント
						//(ユーザーがフォントを変更すると不味いのでちゃんと指定すること)
music.music_panel_cg = [];  	//操作用リンクに使用するボタン画像, この配列が空なら文字そうでないなら画像を表示する
				//前から順に	/前の曲/再生/停止/ランダム/次の曲/戻る/ループon/ループoff/連続再生on/連続再生off
music.music_panel_font = %[];	//操作用リンクに文字を使うときのフォント
				//(ユーザーがフォントを変更すると不味いのでちゃんと指定すること)
music.music_panel_nofont = %[];	//操作用リンクに文字を使うときのフォント
				//(ユーザーがフォントを変更すると不味いのでちゃんと指定すること)
music.music_panel_pos = [	//操作用リンクの位置, 前から順に/前の曲/再生(停止)/ランダム/次の曲/戻る/ループ/連続再生
				[30, kag.scHeight-180], 
				[140, kag.scHeight-180], 
				[230, kag.scHeight-180], 
				[350, kag.scHeight-180],
				[450, kag.scHeight-180],
				[550, kag.scHeight-180],
				[550, kag.scHeight-130]
			];
music.volumeslider_pos   = [90, kag.scHeight-110];	//音量調整スライダーの位置
music.positionslider_pos = [90, kag.scHeight-60];	//再生操作スライダーの位置
music.position_pos = [450, kag.scHeight-80];		//再生位置表示の位置
music.music_position_font = %[];			//再生位置表示のフォント
music.music_storage = []; //音楽ファイル名を入れる
music.music_caption = []; //ミュージックモードに表示されるタイトルを入れる
//music_storage, music_caption, music_cgの配列は同じ順番でなくてはならない
music.music_storage = [   
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
music.music_cg_on = 1; //曲に合わせて背景を変更するか

music.music_cg = [ //表示するCG
'細かいひし形(左から右へ)',
'細かいひし形(左上から右下へ)',
'放射状(時計回り)',
'左下から右上へ',
'こすり(左から右へ)',
'爆発'
];
//ここを書き換える↑------------------------------------------------------- 

if (sf.music_mode_init === void){
	//最初に一度だけ実行
	//聞いたかどうかのフラグ
	sf.music_flag = %[];
	for (var i = 0; i < music.music_storage.count; i++){
		sf.music_flag[i] = false;
	}
	sf.music_mode_init = 1;
}
music.complete = function (){ //全ての曲を聞いたことにする
	for (var i=0; i < music.music_storage.count; i++){
		sf.music_flag[i]=true;
	}
} incontextof global;
// スライダーの関数
music.volumeslider = function (hval,vval,drag){
	kag.tagHandlers.bgmopt(%['gvolume' => hval*100]);
} incontextof global;
music.positionslider = function (hval,vval,drag){
	if  (music.temp_start){
		kag.bgm.buf1.position = kag.bgm.buf1.totalTime * hval;
		kag.process('music_mode.ks', '*redraw');
	}
} incontextof global;
//マウスホイール用の設定
music.wheel = function(shift, delta, x, y){
	if (delta < 0){
		if  (music.page >= music.maxpage){
			music.page = 0;
		}else{
			music.page += 1;
		}
		kag.process('music_mode.ks', '*sub_draw');
	}else if(delta > 0){
		if  (music.page <= 0){
			music.page = music.maxpage;
		}else{
			music.page -= 1;
		}
		kag.process('music_mode.ks', '*sub_draw');
	}
} incontextof global;
music.page = 0;
music.maxpage = music.music_caption.count%(music.column*music.line) == 0 ? music.music_caption.count\(music.column*music.line) - 1 : music.music_caption.count\(music.column*music.line);
@endscript
@call storage=KLayers.ks
@call storage=TJSFunctions.ks

@return
