
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
music.page_basex = 500; //�y�[�W�{�^���̏���x���W
music.page_basey = 0;   //�y�[�W�{�^���̏���y���W
music.page_width = 20;  //�y�[�W�{�^���Ԃ̕�
music.page_height = 0;  //�y�[�W�{�^���Ԃ̍���
music.width  = (kag.scWidth - music.base_x*2)\music.column; //��
music.height = 50; //����
music.music_storage = []; //���y�t�@�C����������
music.music_caption = []; //�~���[�W�b�N���[�h�ɕ\�������^�C�g��������
music.music_storage = [   //2�̔z��͓������ԂłȂ��Ă͂Ȃ�Ȃ�
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
	//�ŏ��Ɉ�x�������s
	//���������ǂ����̃t���O
	sf.music_flag = %[];
	for (var i = 0; i < music.music_storage.count; i++){
		sf.music_flag[i] = false;
	}
	sf.music_mode_init = 1;
}
if (0){ //�S�Ă̋Ȃ𕷂������Ƃɂ���
	for (var i=0; i < music.music_storage.count; i++){
		sf.music_flag[i]=true;
	}
}
music.page = 0;
music.maxpage = music.music_caption.count%(music.column*music.line) == 0 ? music.music_caption.count\(music.column*music.line) - 1 : music.music_caption.count\(music.column*music.line);
@endscript

@return
