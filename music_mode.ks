*music_mode


@tempsave
;�w�i�̐ݒ�
@image layer=base storage=&music.base page=fore
@freeimage layer=0
@stopbgm
@iscript
music.playing = 0;
var elm = %["visible" => false];
// �S�Ă̑O�i���C�����\���ɂ��܂�
for(var i=0;i<kag.numCharacterLayers;i++)
	kag.fore.layers[i].setOptions(elm);
// �S�Ẵ��b�Z�[�W���C�����\���ɂ��܂�
for(var i=0;i<kag.numMessageLayers;i++)
	kag.fore.messages[i].setOptions(elm);
//���̉��ʂ��o�b�N�A�b�v
var tempvolume = kag.bgm.buf1.volume2;
// �X���C�_�[�̐ݒ�
function myValueChangeHook(num, page) {
	if (!kag.inSleep) { return; } // s�^�O�Ŏ~�܂��Ă��Ȃ������牽�����Ȃ��B
	
	tf.name = "f.slider[" + num + "]";
	skn_slider.getSliderValue(%["slider"=>num, "name"=>tf.name]); // [getSliderValue slider="&num" name="&tf.name"]�Ɠ���
	// �������f.slider�̒l�͏�ɍŐV�̒l�ɂȂ遣
		
	if (num == 0 && page == "fore") { // �X���C�_0�̕\��ʂ̒l���ς�����B
		kag.process("music_mode.ks", "*playvolume");
	} else if (num == 1 && page == "fore") {// �X���C�_1�̕\��ʂ̒l���ς����	
		kag.process("music_mode.ks","*playposition");
	}
}
skn_slider.valueChangeHook.add(myValueChangeHook); // ��������֐�(myValueChangeHook)��valueChangeHook�ɓo�^��  �i�l���ς�������ɓo�^�����֐����Ă΂��B�j

// ���A���^�C���ōĐ��ʒu�𔽉f����
function onTimer()
{
	if (kag.bgm.currentBuffer.status == 'play')
	{
		skn_slider.setSliderValue(%['slider' => 1, 'value' => kag.bgm.buf1.position*100/kag.bgm.buf1.totalTime]);
		kag.process('music_mode.ks', '*redraw'); 
	}
}
tf.timer = new Timer(onTimer, '');
tf.timer.interval = 1000; //1�b����
tf.timer.enabled = true;
@endscript


;���b�Z�[�W���C���̐ݒ�
;�e���b�Z�[�W���C���ɃX���C�_�[��u��
@laycount messages="&kag.numMessageLayers + 3"
@current layer="&'message' + (kag.numMessageLayers - 1)"
@position opacity=0 width=&kag.scWidth height=&kag.scHeight top=0 left=0 visible=true layer=message marginb=0 marginl=0 marginr=0 margint=0
@current layer="&'message' + (kag.numMessageLayers - 2)"
@position opacity=0 width=&kag.scWidth height=&kag.scHeight top=0 left=0 visible=true layer=message marginb=0 marginl=0 marginr=0 margint=0
@current layer="&'message' + (kag.numMessageLayers - 3)"
@position opacity=0 width=&kag.scWidth height=&kag.scHeight top=0 left=0 visible=true layer=message marginb=0 marginl=0 marginr=0 margint=0
;�E�N���b�N�̐ݒ�
@rclick enabled=true jump=true storage=music_mode.ks target=*back

; ���X���C�_�[�̐�
@setSliderCount sliders="2"
; ���X���C�_�[�̒l������z��
@eval exp="f.slider = [ (int)(kag.bgm.buf1.volume2 / 1000), 0]"
; ���X���C�_�[0�̐ݒ� - (BGM���ʒ���)
@current layer="&'message' + (kag.numMessageLayers - 2)"
@setSliderImages slider="0" forebase="base_white" forethumb="thumb_gray"
@setSliderOptions slider="0" page="fore" visible="true" left="190" top="&kag.scHeight-110" changing="203" max="100" min="0" visible="true" scale="2" hit="true" cursor="true"
; ���X���C�_�[1�̐ݒ� - (�Đ��ʒu����)
@current layer="&'message' + (kag.numMessageLayers - 3)"
@setSliderImages slider="1" forebase="base_white" forethumb="thumb_gray"
@setSliderOptions slider="1" page="fore" visible="true" left="190" top="&kag.scHeight-60" changing="203" max="100" min="0" visible="true" scale="2" hit="true" cursor="true"
; ���X���C�_�̒l�������ݒ�
@setSliderValue slider="0" value="&f.slider[0]"
@setSliderValue slider="1" value="&f.slider[1]"


@call storage=music_mode.ks target=*draw
@s

; ��BGM���ʒ����̃X���C�_���������Ƃ��̏���
*playvolume
@setSliderEnabled enabled="false"
@bgmopt gvolume="&f.slider[0]"
; �X���C�_�̒l�\���X�V
@current layer="&'message' + (kag.numMessageLayers - 2)"
@er
@current layer="&'message' + (kag.numMessageLayers - 1)"
@setSliderEnabled enabled="true"
@s

; �Đ��ʒu�̃X���C�_���������Ƃ��̏���
*playposition
@if  exp="kag.bgm.currentBuffer.status != 'unload'"
	@setSliderEnabled enabled="false"
	@eval exp="kag.bgm.buf1.position = kag.bgm.buf1.totalTime*f.slider[1]/100"
	; �X���C�_�̒l�\���X�V
	@current layer="&'message' + (kag.numMessageLayers - 3)"
	@er
	@current layer="&'message' + (kag.numMessageLayers - 1)"
	@setSliderEnabled enabled="true"
	@jump storage=music_mode.ks target=*redraw
@endif
@s

; �Đ��ʒu��`�悷��
*redraw
@current layer="&'message' + (kag.numMessageLayers - 3)"
@er
@locate x=450 y="&kag.scHeight-80"
@nowait
@if  exp="kag.bgm.currentBuffer.status != 'stop'"
	@emb exp="'%02d:%02d/%02d:%02d'.sprintf(kag.bgm.buf1.position\60000, (int)((kag.bgm.buf1.position%60000)/1000), kag.bgm.buf1.totalTime\60000, (int)((kag.bgm.buf1.totalTime%60000)/1000))"
@else
	@emb exp="'%02d:%02d/%02d:%02d'.sprintf((kag.bgm.buf1.totalTime*f.slider[1]/100)\60000, (int)(((kag.bgm.buf1.totalTime*f.slider[1]/100)%60000)/1000), kag.bgm.buf1.totalTime\60000, (int)((kag.bgm.buf1.totalTime%60000)/1000))"
@endif
@current layer="&'message' + (kag.numMessageLayers - 1)"
@endnowait
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
@endscript
@image layer=0 visible=true storage=&music.playmark left=&music.check_x-30 top=&music.check_y+15
;�X���C�_�[������������
@setSliderValue slider="1" value="0"
@playbgm storage=&music.music_storage[music.playing] loop=false
@setSliderEnabled enabled="true"
@call storage=music_mode.ks target=*draw
@jump storage=music_mode.ks target=*redraw
@s

;��~
*stop
@unlocklink
@stopbgm cond="kag.bgm.currentBuffer.status == 'play'"
@s
;�Đ�
*start
@unlocklink
@if exp="kag.bgm.currentBuffer.status == 'stop'"
	@eval exp="music.temp_position = kag.bgm.buf1.totalTime/100*f.slider[1]"
	@playbgm storage=&music.music_storage[music.playing] loop=false
	@eval exp="kag.bgm.buf1.position = music.temp_position"
@endif
@s

*sub_draw
@call storage=music_mode.ks target=*draw
@s

;�`��
*draw
@current layer="&'message' + (kag.numMessageLayers - 1)"
@er
@layopt layer=0 visible="&music.checkedpage == music.page"
@eval exp="music.temp_column = 0"
*column
	@eval exp="music.temp_line = 0"
*line
		@if exp="sf.music_flag[music.page*music.column*music.line + music.temp_column*music.line + music.temp_line]"
			@if exp="music.page*music.column*music.line + music.temp_column*music.line + music.temp_line < music.music_storage.count"
				@link storage=music_mode.ks target=*play exp="&'music.playing = ' + ( music.page*music.column*music.line + music.temp_column*music.line + music.temp_line )"
				@locate x="&music.base_x + music.temp_column * music.width" y="&music.base_y + music.temp_line * music.height"
				@nowait
				@emb exp="music.music_caption[music.page*music.column*music.line + music.temp_column*music.line + music.temp_line]"
				@endnowait
				@endlink
			@endif
		@endif
	@jump storage=music_mode.ks target=*line cond="++music.temp_line < music.line"
@jump storage=music_mode.ks target=*column cond="++music.temp_column < music.column"

;�؁[�W�ԍ��`��
@if exp="music.maxpage > 0"
	@locate x=500 y=0
	@nowait
	�y�[�W
	@endnowait
	@eval exp="music.pagecount = 0"
*pagedraw
		@if exp="music.pagecount != music.page"
			@link storage=music_mode.ks target=*sub_draw exp="&'music.page = ' + music.pagecount"
			@locate x="&600 + 20 * music.pagecount" y=0
			@nowait
			@emb exp="music.pagecount + 1"
			@endnowait
			@endlink
		@else
			@locate x="&600 + 20 * music.pagecount" y=0
			@nowait
			@font color=0x666666
			@emb exp="music.pagecount + 1"
			@resetfont
			@endnowait
		@endif
	@jump storage=music_mode.ks target=*pagedraw cond="++music.pagecount < (music.maxpage + 1)"
	;@image storage=checked layer=1 left="&600 + 20 * music.page" top=0 visible=true opacity=255
@endif


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
@current layer="&'message' + (kag.numMessageLayers - 3)"
@locate x=450 y=&kag.scHeight-80
00:00/00:00
@current layer="&'message' + (kag.numMessageLayers - 1)"
@endnowait
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
@tempload
@eval exp="kag.bgm.buf1.volume2 = tempvolume"
@rclick enabled=true jump=true storage=title.ks target=*title
@return
