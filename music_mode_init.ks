
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
music.base = 'black'; //�w�i�摜
music.playmark = 'checked'; //�Đ����̃}�[�N
music.line   = 7; //���̐�
music.column = 3; //�c�̐�
music.base_x = 50; //����x���W
music.base_y = 35; //����y���W
music.width  = (kag.scWidth - music.base_x*2)\music.column; //�^�C�g���Ԃ̕�
music.height = 50; //�^�C�g���Ԃ̍���
music.page_basex = 500; //�y�[�W�{�^���̏���x���W
music.page_basey = 0;   //�y�[�W�{�^���̏���y���W
music.page_width = 20;  //�y�[�W�{�^���Ԃ̕�
music.page_height = 0;  //�y�[�W�{�^���Ԃ̍���
music.page_font = %['italic' => true];  //�y�[�W�{�^���̃t�H���g
music.music_storage = []; //���y�t�@�C����������
music.music_caption = []; //�~���[�W�b�N���[�h�ɕ\�������^�C�g��������
music.music_storage = [   //2�̔z��͓������ԂłȂ��Ă͂Ȃ�Ȃ�
'music0',
'music1',
'music2',
'music3',
'music4',
'music5',
'music6',
'music7',
'music8',
'music9',
'music10',
'music11',
'music12',
'music13',
'music14',
'music15',
'music16',
'music17',
'music18',
'music19',
'music20',
'music21',
'music22',
'music23',
'music24',
'music25',
'music26'
];
music.music_caption = [
'music0',
'music1',
'music2',
'music3',
'music4',
'music5',
'music6',
'music7',
'music8',
'music9',
'music10',
'music11',
'music12',
'music13',
'music14',
'music15',
'music16',
'music17',
'music18',
'music19',
'music20',
'music21',
'music22',
'music23',
'music24',
'music25',
'music26'
];
if (sf.music_mode_init === void){
	//�ŏ��Ɉ�x�������s
	//���������ǂ����̃t���O
	sf.music_flag = %[];
	for (var i = 0; i < music.music_storage.count; i++){
		sf.music_flag[i] = false;
	}
	sf.music_mode_init = 1;
}
function music_mode_complete(){ //�S�Ă̋Ȃ𕷂������Ƃɂ���
	for (var i=0; i < music.music_storage.count; i++){
		sf.music_flag[i]=true;
	}
}
music.page = 0;
music.maxpage = music.music_caption.count%(music.column*music.line) == 0 ? music.music_caption.count\(music.column*music.line) - 1 : music.music_caption.count\(music.column*music.line);
@endscript

@return
