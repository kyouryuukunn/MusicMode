*music_mode


@tempsave
@stopbgm

;��p�̃��C�������
@laycount layers="&kag.numCharacterLayers + 2" messages="&kag.numMessageLayers + 2"
;���ׂẴ��C������ɕ\��
;�w�i�A���݃y�[�W
@layopt index="&2000000+100" layer="&kag.numCharacterLayers-2"
;�Đ��}�[�N
@layopt index="&2000000+101" layer="&kag.numCharacterLayers-1"
;�Đ��ʒu��`��
@layopt index="&2000000+102" layer="&'message' + (kag.numMessageLayers-2)"
;�^�C�g���A�y�[�W�A����p�{�^����`��
@layopt index="&2000000+103" layer="&'message' + (kag.numMessageLayers-1)"

@backlay
;�w�i�̐ݒ�
@image layer="&kag.numCharacterLayers-2" storage=&music.base page=back visible=true
@stoptrans
@trans method=crossfade time=300
@wt

@iscript
//�ŏ��͍Đ��ʒu�̕\����ς��Ȃ�����
music.playing = 0;
// �}�E�X�z�C�[���̓�����ꎞ�I�ɕς���
music.onMouseWheel_org = kag.onMouseWheel;
kag.onMouseWheel = function (shift, delta, x, y)
{
	music.onMouseWheel_org(...);
	music.wheel(...);
} incontextof kag;
// �S�Ẵ��b�Z�[�W���C�����\���ɂ��܂�
for(var i=0;i<kag.numMessageLayers;i++)
	kag.fore.messages[i].setOptions(%['visible' => false]);
//���̉��ʂ��o�b�N�A�b�v
var tempvolume = kag.bgm.buf1.volume2;
// ���X���C�_�[�̐ݒ�
music.slider = new Array();
for (var i=0; i < 2; i++){
	music.slider[i] = new KSliderLayer(kag, kag.fore.layers[kag.numCharacterLayers - 2]);
	with(music.slider[i]){
		.setOptions(%['graphic' => music.slider_base, 'tabgraphic' => music.slider_tab]);
	}
}
// ���X���C�_�[0�̐ݒ� - (BGM���ʒ���)
with(music.slider[0]){
	.left = music.volumeslider_pos[0];
	.top =  music.volumeslider_pos[1];
	.hval = kag.bgm.buf1.volume2 / 100000;
	.updateState();
	.onchangefunc = 'music.volumeslider';
}
// ���X���C�_�[1�̐ݒ� - (�Đ��ʒu����)
with(music.slider[1]){
	.left = music.positionslider_pos[0];
	.top =  music.positionslider_pos[1];
	.hval = 0;
	.onchangefunc = 'music.positionslider';
}
// �Đ��ʒu��ύX����
music.gettime = function ()
{
	if (kag.bgm.currentBuffer.status == 'play')
	{
		with(music.slider[1]){
			//�ύX���Ă�onchangefunc�����s���Ȃ�
			.hval = kag.bgm.buf1.position/kag.bgm.buf1.totalTime;
			// ���݂̒l�ɂ��킹��tab�̈ʒu���ړ�����
			.tab.setPos((.width-.tab.width)*.hval, (.height-.tab.height)*(1-.vval));
			kag.process('music_mode.ks', '*redraw');
		}
	}
};
music.timer = new Timer(music.gettime, '');
music.timer.interval = 1000;
music.timer.enabled = true;
//�~���[�W�b�N���[�h�ŃQ�[���I�������Ƃ��̃^�C�}�[�������p��
//�ꎞ�I�ɏI��������u���ւ���
music.onCloseQuery_org = kag.onCloseQuery;
kag.onCloseQuery = function ()
{
	invalidate music.timer;
	music.onCloseQuery_org();
} incontextof kag;
@endscript

;���b�Z�[�W���C���̐ݒ�
@current layer="&'message' + (kag.numMessageLayers - 1)"
@position opacity=0 width=&kag.scWidth height=&kag.scHeight top=0 left=0 visible=true marginb=0 marginl=0 marginr=0 margint=0
@current layer="&'message' + (kag.numMessageLayers - 2)"
@position opacity=0 width=&kag.scWidth height=&kag.scHeight top=0 left=0 visible=true marginb=0 marginl=0 marginr=0 margint=0
;�E�N���b�N�̐ݒ�
@rclick enabled=true jump=true storage=music_mode.ks target=*back
;�����̋֎~
@history enabled=false output=false


@nowait
@current layer="&'message' + (kag.numMessageLayers - 2)"
@locate x=&music.position_pos[0] y=&music.position_pos[1]
@eval exp="kag.tagHandlers.font(music.music_position_font)"
00:00/00:00
@resetfont
@endnowait
;�`��
@call storage=music_mode.ks target=*draw
@s

; �Đ��ʒu��`�悷��T�u���[�`��
*redraw
@current layer="&'message' + (kag.numMessageLayers - 2)"
@er
@locate x=&music.position_pos[0] y=&music.position_pos[1]
@nowait
@eval exp="kag.tagHandlers.font(music.music_position_font)"
@emb exp="'%02d:%02d/%02d:%02d'.sprintf((kag.bgm.buf1.totalTime*music.slider[1].hval)\60000, (int)(((kag.bgm.buf1.totalTime*music.slider[1].hval)%60000)/1000), kag.bgm.buf1.totalTime\60000, (int)((kag.bgm.buf1.totalTime%60000)/1000))"
@resetfont
@endnowait
@s

*play
@unlocklink
;�Đ����̃`�F�b�N������
@iscript
//�Đ����̋Ȃ̃y�[�W�ƈʒu�𒲂ׂĕK�v�Ȃ�y�[�W�ړ�
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
;�X���C�_�[������������
@playbgm storage=&music.music_storage[music.playing] loop=false
;�n�[�h�E�F�A��O���o��
;@eval exp="music.slider[1].position=0"
@call storage=music_mode.ks target=*draw
@image layer="&kag.numCharacterLayers-1" visible=true storage=&music.playmark left=&music.check_x+music.playmark_x top=&music.check_y+music.playmark_y
@if exp="music.music_cg_on" 
	@backlay
	@image layer="&kag.numCharacterLayers-2" visible=true page=back storage=&music.music_cg[music.playing]
	@pimage dx="&music.page_basex + music.page_width * music.page" dy="&music.page_basey + music.page_height * music.page" storage=&music.nowpage_cg[music.page] layer="&kag.numCharacterLayers-2" page=back
	@stoptrans
	@trans method=crossfade time=300 layer="&kag.numCharacterLayers-2" children=false
	@wt
@endif
@jump storage=music_mode.ks target=*redraw
@s

;��~
*stop
@unlocklink
@stopbgm cond="kag.bgm.currentBuffer.status == 'play'"
@call storage=music_mode.ks target=*draw
@s
;�Đ�
*start
@unlocklink
@if exp="!music.temp_start"
	;�������Ȃ�
@elsif exp="kag.bgm.currentBuffer.status == 'stop'"
	;��~�ʒu����Đ�
	@eval exp="music.temp_position = kag.bgm.buf1.totalTime*music.slider[1].hval"
	@playbgm storage=&music.music_storage[music.playing] loop=false
	@eval exp="kag.bgm.buf1.position = music.temp_position"
@endif
@call storage=music_mode.ks target=*draw
@s

*sub_draw
@call storage=music_mode.ks target=*draw
@s

;�^�C�g���`��
*draw
;pimage���g�p���Ă���̂Ŕw�i���ĕ`�悵�Ȃ��Ƃ����Ȃ�
@image layer="&kag.numCharacterLayers-2" storage=&music.music_cg[music.playing] page=fore visible=true
@image layer="&kag.numCharacterLayers-2" storage=&music.base page=fore visible=true cond="!music.temp_start"
@current layer="&'message' + (kag.numMessageLayers - 1)"
@er
@layopt layer="&kag.numCharacterLayers-1" visible="&music.checkedpage == music.page"
@eval exp="music.temp_column = 0"
*column_loop
	@eval exp="music.temp_line = 0"
*line_loop
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
	@jump storage=music_mode.ks target=*line_loop cond="++music.temp_line < music.line"
@jump storage=music_mode.ks target=*column_loop cond="++music.temp_column < music.column"

;�؁[�W�ԍ��`��
;�y�[�W��������������
@if exp="music.maxpage > 0"
	@eval exp="music.pagecount = 0"
*page_loop
		@locate x="&music.page_basex + music.page_width * music.pagecount" y="&music.page_basey + music.page_height * music.pagecount"
		@nowait
		@if exp="music.pagecount != music.page"
			@if exp="music.page_cg.count > 0"
				@button storage=music_mode.ks target=*sub_draw exp="&'music.page = ' + music.pagecount" graphic=&music.page_cg[music.pagecount]
			@else
				@link storage=music_mode.ks target=*sub_draw exp="&'music.page = ' + music.pagecount"
				@eval exp="kag.tagHandlers.font(music.page_font)"
				@emb exp="music.pagecount + 1"
				@resetfont
				@endlink
			@endif
		@else
			;���݃y�[�W�̐F��ς���
			@if exp="music.page_cg.count > 0"
				@pimage dx="&music.page_basex + music.page_width * music.pagecount" dy="&music.page_basey + music.page_height * music.pagecount" storage=&music.nowpage_cg[music.pagecount] layer="&kag.numCharacterLayers-2"
			@else
				@eval exp="kag.tagHandlers.font(music.page_font)"
				@font color=0x666666
				@emb exp="music.pagecount + 1"
				@resetfont
			@endif
		@endif
		@endnowait
	@jump storage=music_mode.ks target=*page_loop cond="++music.pagecount < (music.maxpage + 1)"
@endif

@eval exp="kag.tagHandlers.font(music.music_panel_font)"
@nowait
@locate x=&music.music_panel_pos[0][0] y=&music.music_panel_pos[0][1]
@if exp="music.music_panel_cg.count > 0"
	@button storage=music_mode.ks target=*backpage graphic=&music.music_panel_cg[0]
@else
	@link storage=music_mode.ks target=*backpage
	�O�̋�
	@endlink
@endif

@locate x=&music.music_panel_pos[1][0] y=&music.music_panel_pos[1][1]
@if exp="kag.bgm.currentBuffer.status == 'stop' || !music.temp_start"
	@if exp="music.music_panel_cg.count > 0"
		@button storage=music_mode.ks target=*start graphic=&music.music_panel_cg[1]
	@else
		@link storage=music_mode.ks target=*start
		�Đ�
	@endif
@else
	@if exp="music.music_panel_cg.count > 0"
		@button storage=music_mode.ks target=*stop graphic=&music.music_panel_cg[2]
	@else
		@link storage=music_mode.ks target=*stop
		��~
	@endif
@endif
@endlink

@locate x=&music.music_panel_pos[2][0] y=&music.music_panel_pos[2][1]
@if exp="music.music_panel_cg.count > 0"
	@button storage=music_mode.ks target=*nextpage graphic=&music.music_panel_cg[3]
@else
	@link storage=music_mode.ks target=*nextpage
	���̋�
	@endlink
@endif

@locate x=&music.music_panel_pos[3][0] y=&music.music_panel_pos[3][1]
@if exp="music.music_panel_cg.count > 0"
	@button storage=music_mode.ks target=*back graphic=&music.music_panel_cg[4]
@else
	@link storage=music_mode.ks target=*back
	�߂�
	@endlink
@endif


@endnowait
@resetfont
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
@iscript
// �}�E�X�z�C�[���̓����߂�
kag.onMouseWheel = music.onMouseWheel_org;
//�I��������߂�
kag.onCloseQuery = music.onCloseQuery_org;
// �^�C�}�[�J��
invalidate music.timer if music.timer !== void;
@endscript
;�o�b�N�A�b�v�������ʂ�߂�
@eval exp="kag.tagHandlers.bgmopt(%['gvolume' => tempvolume/1000])"
@eval exp="music.temp_start=0"
@tempload
;�e���Őݒ�
;@history enabled=true output=true
@rclick enabled=false

@return
