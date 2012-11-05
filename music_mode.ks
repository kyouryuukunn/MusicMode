*music_mode


@tempsave
@stopbgm

@laycount layers="&kag.numCharacterLayers + 2" messages="&kag.numMessageLayers + 2"
;���ׂẴ��C������ɕ\��
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
// �S�Ẵ��b�Z�[�W���C�����\���ɂ��܂�
for(var i=0;i<kag.numMessageLayers;i++)
	kag.fore.messages[i].setOptions(%['visible' => false]);
//���̉��ʂ��o�b�N�A�b�v
var tempvolume = kag.bgm.buf1.volume2;
// ���X���C�_�[�̐ݒ�
tf.slider = new Array();
for (var i=0; i < 2; i++){
	tf.slider[i] = new KSliderLayer(kag, kag.fore.layers[kag.numCharacterLayers - 2]);
	with(tf.slider[i]){
		.setOptions(%['graphic' => 'slider_base', 'tabgraphic' => 'slider_tab']);
	}
}
// ���X���C�_�[0�̐ݒ� - (BGM���ʒ���)
with(tf.slider[0]){
	.left = 190;
	.top = kag.scHeight - 110;
	.hval = kag.bgm.buf1.volume2 / 100000;
	.updateState();
	.onchangefunc = 'music_bgmslider';
}
// ���X���C�_�[1�̐ݒ� - (�Đ��ʒu����)
with(tf.slider[1]){
	.left = 190;
	.top = kag.scHeight - 60;
	.hval = 0;
	.onchangefunc = 'music_bgmposition';
}
// �Đ��ʒu��ύX����
function Music_GetTime()
{
	if (kag.bgm.currentBuffer.status == 'play')
	{
		with(tf.slider[1]){
			//�ύX���Ă�onchangefunc�����s���Ȃ�
			.hval = kag.bgm.buf1.position/kag.bgm.buf1.totalTime;
			// ���݂̒l�ɂ��킹��tab�̈ʒu���ړ�����
			.tab.setPos((.width-.tab.width)*.hval, (.height-.tab.height)*(1-.vval));
			kag.process('music_mode.ks', '*redraw');
		}
	}
}
tf.timer = new Timer(Music_GetTime, '');
tf.timer.interval = 1000;
tf.timer.enabled = true;
@endscript

;�w�i�̐ݒ�
@image layer="&kag.numCharacterLayers-2" storage=&music.base page=fore visible=true

;���b�Z�[�W���C���̐ݒ�
@current layer="&'message' + (kag.numMessageLayers - 1)"
@position opacity=0 width=&kag.scWidth height=&kag.scHeight top=0 left=0 visible=true marginb=0 marginl=0 marginr=0 margint=0
@current layer="&'message' + (kag.numMessageLayers - 2)"
@position opacity=0 width=&kag.scWidth height=&kag.scHeight top=0 left=0 visible=true marginb=0 marginl=0 marginr=0 margint=0
;�E�N���b�N�̐ݒ�
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

; �Đ��ʒu��`�悷��
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
;�Đ����̃`�F�b�N������
@iscript
// �y�[�W�`�F�b�N
	music.page = ( (1 + music.playing)%(music.column*music.line) ) == 0 ? ( (1 + music.playing)\(music.column*music.line) - 1) : (1 + music.playing)\(music.column*music.line);
// �Đ����`�F�b�N
music.check_x = (1 + music.playing - music.page*music.column*music.line)%music.line == 0 ? ( (1 + music.playing - music.page*music.column*music.line)\music.line - 1 ) : (1 + music.playing - music.page*music.column*music.line)\music.line;
music.check_y = (1 + music.playing - music.page*music.column*music.line)%music.line == 0 ? ( music.line - 1 ) : ( (1 + music.playing - music.page*music.column*music.line)%music.line - 1 );
music.check_x = music.base_x + music.check_x * music.width;
music.check_y = music.base_y + music.check_y * music.height;
music.checkedpage = music.page;
music.temp_start = 1;
@endscript
@image layer="&kag.numCharacterLayers-1" visible=true storage=&music.playmark left=&music.check_x-30 top=&music.check_y+15
;�X���C�_�[������������
@playbgm storage=&music.music_storage[music.playing] loop=false
;�n�[�h�E�F�A��O���o��
;@eval exp="tf.slider[1].position=0"
@call storage=music_mode.ks target=*draw
@jump storage=music_mode.ks target=*redraw
@s

;��~
*stop
@unlocklink
@stopbgm cond="kag.bgm.currentBuffer.status == 'play'"
;�}�E�X�z�C�[�����g�����߂ɁA�t�H�[�J�X�ݒ�
@eval exp="kag.fore.messages[kag.numMessageLayers - 1].focus()"
@s
;�Đ�
*start
@unlocklink
@if exp="kag.bgm.currentBuffer.status == 'stop'"
	@eval exp="music.temp_position = kag.bgm.buf1.totalTime*tf.slider[1].hval"
	@playbgm storage=&music.music_storage[music.playing] loop=false
	@eval exp="kag.bgm.buf1.position = music.temp_position"
@endif
;�}�E�X�z�C�[�����g�����߂ɁA�t�H�[�J�X�ݒ�
@eval exp="kag.fore.messages[kag.numMessageLayers - 1].focus()"
@s

*sub_draw
@call storage=music_mode.ks target=*draw
@s

;�`��
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

;�؁[�W�ԍ��`��
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
�O�̋�
@endlink

@link storage=music_mode.ks target=*stop
@locate x=150 y=&kag.scHeight-180
��~
@endlink

@link storage=music_mode.ks target=*start
@locate x=230 y=&kag.scHeight-180
�Đ�
@endlink

@link storage=music_mode.ks target=*nextpage
@locate x=330 y=&kag.scHeight-180
@ch text=���̋�
@endlink

@link storage=music_mode.ks target=*back
@locate x=430 y=&kag.scHeight-180
�߂�
@endlink

@locate x=30 y=&kag.scHeight-130
����
@locate x=30 y=&kag.scHeight-80
�Đ��ʒu
@endnowait
@resetfont

;�}�E�X�z�C�[�����g�����߂ɁA�t�H�[�J�X�ݒ�
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

; �~���[�W�b�N���[�h�����
*back
; �^�C�}�[��~
@eval exp="tf.timer.enabled=false"
;�o�b�N�A�b�v�������ʂ�߂�
@eval exp="kag.tagHandlers.bgmopt(%['gvolume' => tempvolume/1000])"
@eval exp="music.temp_start=0"
@tempload
@history enabled=true output=true
;�e���Őݒ�
;@rclick enabled=false
@return
