
;storage����ԍ���T��
;flag���L�^����
;�}�N���̊Ԃɓ���Ďg���Ă���
;��
;@macro name=pl
;@playbgm *
;@flagmusic *
;@endmacro

@macro name=flagmusic        
@eval exp="sf.music_flag[music.music_storage.find(mp.storage)] = true"
@endmacro

;�O�����Ɛݒ�
@iscript
var music = %[];
//���������������遫------------------------------------------------------- 
music.base = 'black'; //�w�i�摜�A��������������ꍇ�́A���O�̃Q�[����ʂ�������
music.playmark = 'playing'; //�Đ����}�[�N�̉摜
music.playmark_x = -37; //�Đ����}�[�N�̃^�C�g������̑���x���W
music.playmark_y = 8; //�Đ����}�[�N�̃^�C�g������̑���y���W
music.line   = 2;  //�Đ��^�C�g����\�������
music.column = 2;  //�Đ��^�C�g����\������s��
music.base_x = 50; //�Đ��^�C�g���̏���x���W
music.base_y = 35; //�Đ��^�C�g���̏���y���W
music.width  = (kag.scWidth - music.base_x*2)\music.column; //��̕�
music.height = 50; //�s�̕�
music.page_basex = 500; //�y�[�W�{�^���̏���x���W
music.page_basey = 0;   //�y�[�W�{�^���̏���y���W
music.page_width = 20;  //�y�[�W�{�^���Ԃ̕�
music.page_height = 0;  //�y�[�W�{�^���Ԃ̍���
music.page_cg = ['1', '2'];  	//�y�[�W�{�^���Ɏg�p����{�^���摜, ���̔z�񂪋�Ȃ當�������łȂ��Ȃ�摜��\������
								//�O���珇�Ɏg�p���镪�����w�肷��
music.nowpage_cg = ['off_1', 'off_2'];	//�y�[�W�{�^���ɉ摜���g�p����Ƃ��͂����Ɍ��݂̃y�[�W���摜���w�肷��
music.page_font = %['italic' => true];  //�y�[�W�{�^���ɕ������g���Ƃ��̃t�H���g
					//(���[�U�[���t�H���g��ύX����ƕs�����̂ł����Ǝw�肷�邱��)
music.music_caption_font = %['italic' => true];	//�ȃ^�C�g���̃t�H���g
						//(���[�U�[���t�H���g��ύX����ƕs�����̂ł����Ǝw�肷�邱��)
music.music_panel_cg = [];  	//����p�����N�Ɏg�p����{�^���摜, ���̔z�񂪋�Ȃ當�������łȂ��Ȃ�摜��\������
				//�O���珇��	/�O�̋�/�Đ�/��~/���̋�/�߂�
music.music_panel_font = %[];	//����p�����N�ɕ������g���Ƃ��̃t�H���g
				//(���[�U�[���t�H���g��ύX����ƕs�����̂ł����Ǝw�肷�邱��)
music.music_storage = []; //���y�t�@�C����������
music.music_caption = []; //�~���[�W�b�N���[�h�ɕ\�������^�C�g��������
//music_storage, music_caption, music_cg�̔z��͓������ԂłȂ��Ă͂Ȃ�Ȃ�
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
music.music_cg_on = 1; //�Ȃɍ��킹�Ĕw�i��ύX���邩

music.music_cg = [ //�\������CG
'�ׂ����Ђ��`(������E��)',
'�ׂ����Ђ��`(���ォ��E����)',
'���ˏ�(���v���)',
'��������E���',
'������(������E��)',
'����'
];
//���������������遪------------------------------------------------------- 

if (sf.music_mode_init === void){
	//�ŏ��Ɉ�x�������s
	//���������ǂ����̃t���O
	sf.music_flag = %[];
	for (var i = 0; i < music.music_storage.count; i++){
		sf.music_flag[i] = false;
	}
	sf.music_mode_init = 1;
}
music.complete = function (){ //�S�Ă̋Ȃ𕷂������Ƃɂ���
	for (var i=0; i < music.music_storage.count; i++){
		sf.music_flag[i]=true;
	}
} incontextof global;
// �X���C�_�[�̊֐�
music.volumeslider = function (hval,vval,drag){
	kag.tagHandlers.bgmopt(%['gvolume' => hval*100]);
} incontextof global;
music.positionslider = function (hval,vval,drag){
	if  (music.temp_start){
		kag.bgm.buf1.position = kag.bgm.buf1.totalTime * hval;
		kag.process('music_mode.ks', '*redraw');
	}
} incontextof global;
//�}�E�X�z�C�[���p�̐ݒ�
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
