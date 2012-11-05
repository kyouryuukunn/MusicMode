*music_mode


@tempsave
@stopbgm

@laycount layers="&kag.numCharacterLayers + 2" messages="&kag.numMessageLayers + 2"
;すべてのレイヤより上に表示
@layopt index="&2000000+100" layer="&kag.numCharacterLayers-2"
@layopt index="&2000000+101" layer="&kag.numCharacterLayers-1"
@layopt index="&2000000+102" layer="&'message' + (kag.numMessageLayers-2)"
@layopt index="&2000000+103" layer="&'message' + (kag.numMessageLayers-1)"
@iscript
kag.fore.messages[kag.numMessageLayers - 1].onMouseWheel = function(shift, delta, x, y){
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
};
music.playing = 0;
// 全てのメッセージレイヤを非表示にします
for(var i=0;i<kag.numMessageLayers;i++)
	kag.fore.messages[i].setOptions(%['visible' => false]);
//元の音量をバックアップ
var tempvolume = kag.bgm.buf1.volume2;
// ◇スライダーの設定
tf.slider = new Array();
for (var i=0; i < 2; i++){
	tf.slider[i] = new KSliderLayer(kag, kag.fore.layers[kag.numCharacterLayers - 2]);
	with(tf.slider[i]){
		.setOptions(%['graphic' => 'slider_base', 'tabgraphic' => 'slider_tab']);
	}
}
// ◇スライダー0の設定 - (BGM音量調整)
with(tf.slider[0]){
	.left = 190;
	.top = kag.scHeight - 110;
	.hval = kag.bgm.buf1.volume2 / 100000;
	.updateState();
	.onchangefunc = 'music_bgmslider';
}
// ◇スライダー1の設定 - (再生位置調整)
with(tf.slider[1]){
	.left = 190;
	.top = kag.scHeight - 60;
	.hval = 0;
	.onchangefunc = 'music_bgmposition';
}
// 再生位置を変更する
function Music_GetTime()
{
	if (kag.bgm.currentBuffer.status == 'play')
	{
		with(tf.slider[1]){
			//変更してもonchangefuncを実行しない
			.hval = kag.bgm.buf1.position/kag.bgm.buf1.totalTime;
			// 現在の値にあわせてtabの位置を移動する
			.tab.setPos((.width-.tab.width)*.hval, (.height-.tab.height)*(1-.vval));
			kag.process('music_mode.ks', '*redraw');
		}
	}
}
tf.timer = new Timer(Music_GetTime, '');
tf.timer.interval = 1000;
tf.timer.enabled = true;
@endscript

;背景の設定
@image layer="&kag.numCharacterLayers-2" storage=&music.base page=fore visible=true

;メッセージレイヤの設定
@current layer="&'message' + (kag.numMessageLayers - 1)"
@position opacity=0 width=&kag.scWidth height=&kag.scHeight top=0 left=0 visible=true marginb=0 marginl=0 marginr=0 margint=0
@current layer="&'message' + (kag.numMessageLayers - 2)"
@position opacity=0 width=&kag.scWidth height=&kag.scHeight top=0 left=0 visible=true marginb=0 marginl=0 marginr=0 margint=0
;右クリックの設定
@rclick enabled=true jump=true storage=music_mode.ks target=*back
@history enabled=false output=false

@nowait
@current layer="&'message' + (kag.numMessageLayers - 2)"
@locate x=450 y=&kag.scHeight-80
00:00/00:00
@current layer="&'message' + (kag.numMessageLayers - 1)"
@endnowait

@call storage=music_mode.ks target=*draw
@s

; 再生位置を描画する
*redraw
@current layer="&'message' + (kag.numMessageLayers - 2)"
@er
@locate x=450 y="&kag.scHeight-80"
@nowait
@emb exp="'%02d:%02d/%02d:%02d'.sprintf((kag.bgm.buf1.totalTime*tf.slider[1].hval)\60000, (int)(((kag.bgm.buf1.totalTime*tf.slider[1].hval)%60000)/1000), kag.bgm.buf1.totalTime\60000, (int)((kag.bgm.buf1.totalTime%60000)/1000))"
@endnowait
@current layer="&'message' + (kag.numMessageLayers - 1)"
@s

*play
@unlocklink
;再生中のチェックをする
@iscript
// ページチェック
	music.page = ( (1 + music.playing)%(music.column*music.line) ) == 0 ? ( (1 + music.playing)\(music.column*music.line) - 1) : (1 + music.playing)\(music.column*music.line);
// 再生中チェック
music.check_x = (1 + music.playing - music.page*music.column*music.line)%music.line == 0 ? ( (1 + music.playing - music.page*music.column*music.line)\music.line - 1 ) : (1 + music.playing - music.page*music.column*music.line)\music.line;
music.check_y = (1 + music.playing - music.page*music.column*music.line)%music.line == 0 ? ( music.line - 1 ) : ( (1 + music.playing - music.page*music.column*music.line)%music.line - 1 );
music.check_x = music.base_x + music.check_x * music.width;
music.check_y = music.base_y + music.check_y * music.height;
music.checkedpage = music.page;
music.temp_start = 1;
@endscript
@image layer="&kag.numCharacterLayers-1" visible=true storage=&music.playmark left=&music.check_x-30 top=&music.check_y+15
;スライダーを初期化する
@playbgm storage=&music.music_storage[music.playing] loop=false
;ハードウェア例外が出る
;@eval exp="tf.slider[1].position=0"
@call storage=music_mode.ks target=*draw
@jump storage=music_mode.ks target=*redraw
@s

;停止
*stop
@unlocklink
@stopbgm cond="kag.bgm.currentBuffer.status == 'play'"
;マウスホイールを使うために、フォーカス設定
@eval exp="kag.fore.messages[kag.numMessageLayers - 1].focus()"
@s
;再生
*start
@unlocklink
@if exp="kag.bgm.currentBuffer.status == 'stop'"
	@eval exp="music.temp_position = kag.bgm.buf1.totalTime*tf.slider[1].hval"
	@playbgm storage=&music.music_storage[music.playing] loop=false
	@eval exp="kag.bgm.buf1.position = music.temp_position"
@endif
;マウスホイールを使うために、フォーカス設定
@eval exp="kag.fore.messages[kag.numMessageLayers - 1].focus()"
@s

*sub_draw
@call storage=music_mode.ks target=*draw
@s

;描画
*draw
@current layer="&'message' + (kag.numMessageLayers - 1)"
@er
@layopt layer="&kag.numCharacterLayers-1" visible="&music.checkedpage == music.page"
@eval exp="music.temp_column = 0"
*column
	@eval exp="music.temp_line = 0"
*line
		@if exp="sf.music_flag[music.page*music.column*music.line + music.temp_column*music.line + music.temp_line]"
			@if exp="music.page*music.column*music.line + music.temp_column*music.line + music.temp_line < music.music_storage.count"
				@link storage=music_mode.ks target=*play exp="&'music.playing = ' + ( music.page*music.column*music.line + music.temp_column*music.line + music.temp_line )"
				@locate x="&music.base_x + music.temp_column * music.width" y="&music.base_y + music.temp_line * music.height"
				@nowait
				@eval exp="kag.tagHandlers.font(music.music_caption_font)"
				@emb exp="music.music_caption[music.page*music.column*music.line + music.temp_column*music.line + music.temp_line]"
				@resetfont
				@endnowait
				@endlink
			@endif
		@endif
	@jump storage=music_mode.ks target=*line cond="++music.temp_line < music.line"
@jump storage=music_mode.ks target=*column cond="++music.temp_column < music.column"

;ぺージ番号描画
@if exp="music.maxpage > 0"
	@eval exp="music.pagecount = 0"
	;@locate x="&music.page_basex + music.page_width * music.pagecount" y="&music.page_basey + music.page_height * music.pagecount"
	;@nowait
	;@eval exp="kag.tagHandlers.font(music.page_font)"
	;page
	;@resetfont
	;@endnowait
*pagedraw
		@locate x="&music.page_basex + music.page_width * music.pagecount + 100" y="&music.page_basey + music.page_height * music.pagecount"
		@nowait
		@if exp="music.pagecount != music.page"
			@link storage=music_mode.ks target=*sub_draw exp="&'music.page = ' + music.pagecount"
			@eval exp="kag.tagHandlers.font(music.page_font)"
			@emb exp="music.pagecount + 1"
			@resetfont
			@endlink
		@else
			@eval exp="kag.tagHandlers.font(music.page_font)"
			@font color=0x666666
			@emb exp="music.pagecount + 1"
			@resetfont
		@endif
		@endnowait
	@jump storage=music_mode.ks target=*pagedraw cond="++music.pagecount < (music.maxpage + 1)"
	;@image storage=checked layer=1 left="&600 + 20 * music.page" top=0 visible=true opacity=255
@endif

@eval exp="kag.tagHandlers.font(music.music_font)"
@nowait
@link storage=music_mode.ks target=*backpage
@locate x=30 y=&kag.scHeight-180
前の曲
@endlink

@link storage=music_mode.ks target=*stop
@locate x=150 y=&kag.scHeight-180
停止
@endlink

@link storage=music_mode.ks target=*start
@locate x=230 y=&kag.scHeight-180
再生
@endlink

@link storage=music_mode.ks target=*nextpage
@locate x=330 y=&kag.scHeight-180
@ch text=次の曲
@endlink

@link storage=music_mode.ks target=*back
@locate x=430 y=&kag.scHeight-180
戻る
@endlink

@locate x=30 y=&kag.scHeight-130
音量
@locate x=30 y=&kag.scHeight-80
再生位置
@endnowait
@resetfont

;マウスホイールを使うために、フォーカス設定
@eval exp="kag.fore.messages[kag.numMessageLayers - 1].focus()"

@return

*nextpage
@unlocklink
@iscript
while(music.playing < music.music_caption.count){
	music.playing+=1;
	if (sf.music_flag[music.playing])
		break;
}
if (music.playing == music.music_caption.count){
	for (music.playing = 0; music.playing < music.music_caption.count; music.playing++){
		if (sf.music_flag[music.playing])
			break;
	}
}
@endscript
@jump storage=music_mode.ks target=*play cond="music.playing != music.music_caption.count"
@s

*backpage
@unlocklink
@iscript
while(music.playing >= 0){
	music.playing-=1;
	if (sf.music_flag[music.playing])
		break;
}
if (music.playing == -1){
	for (music.playing = music.music_caption.count - 1; music.playing >= 0; music.playing--){
		if (sf.music_flag[music.playing])
			break;
	}
}
@endscript
@jump storage=music_mode.ks target=*play cond="music.playing != -1"
@s

; ミュージックモードを閉じる
*back
; タイマー停止
@eval exp="tf.timer.enabled=false"
;バックアップした音量を戻す
@eval exp="kag.tagHandlers.bgmopt(%['gvolume' => tempvolume/1000])"
@eval exp="music.temp_start=0"
@tempload
@history enabled=true output=true
;各自で設定
;@rclick enabled=false
@return
