

�悭����~���[�W�b�N���[�h����������

�������g�������l�������Ȃ�D���Ɏg���Ă���
���ρA�Ĕz�z�͎��R
�g�p�𖾋L����K�v���񍐂���K�v���Ȃ�
���Ǖ񍐂������Ƃ��ꂵ��
���R�Ȃɂ������Ă��ӔC�͎��Ȃ�����
�g�p�ɂ�Biscrat��SKN_Slider.ks���K�v

�S������T���v����skydrive�Ō��J���Ă���
https://skydrive.live.com/#cid=8F8EF4D2142F33D4&id=8F8EF4D2142F33D4!257

�@�\
��x�������Ȃ����\������
�^�C�g�����ɍ��킹�āA�����ł؁[�W�𒲐�����
�Đ��ʒu�\���A�����X���C�_�[
�ꎞ�I�ȉ��ʕύX
������x���C�A�E�g���ύX�o����
�g����
�ݒ��Afirst.ks��music_mode_init.ks��ǂݍ���
��
@call music_mode_init.ks
���music_mode.ks���T�u���[�`���Ƃ��ČĂׂ΂悢
��
[link exp="kag.callExtraConductor('music_mode.ks', '*music_mode')"]�~���[�W�b�N���[�h[endlink]

�ݒ���@
�܂�Afterinit.tjs(�Ȃ���΂���)�ɂ��̕������킦��
kag.onCloseQuery = function ()
{
	saveSystemVariables();
	if(!askOnClose) { global.Window.onCloseQuery(true); return; }
	tf.timer.enabled=false if tf.timer !== void;
	global.Window.onCloseQuery(askYesNo("�I�����܂����H"));
} incontextof kag;

music_mode.ks��295�s�ڂ̉E�N���b�N�̐ݒ�����ɂ��킹�Ă�����
music_mode_init.ks��18�s�ڂ���̊e�ϐ�������������

music.base = 'black'; //�w�i�摜
music.playmark = 'checked'; //�Đ����̃}�[�N��\������摜
music.line   = 7;  //�Đ��^�C�g����\�������
music.column = 3;  //�Đ��^�C�g����\������s��
music.base_x = 50; //�Đ��^�C�g���̏���x���W
music.base_y = 35; //�Đ��^�C�g���̏���y���W
music.width  = (kag.scWidth - music.base_x*2)\music.column; //��̕�
music.height = 50; //�s�̕�
music.page_basex = 500; //�y�[�W�{�^���̏���x���W
music.page_basey = 0;   //�y�[�W�{�^���̏���y���W
music.page_width = 20;  //�y�[�W�{�^���Ԃ̕�
music.page_height = 0;  //�y�[�W�{�^���Ԃ̍���
music.page_font = %['italic' => true];  //�y�[�W�{�^���̃t�H���g
music.music_storage = []; //���y�t�@�C����������
music.music_caption = []; //�~���[�W�b�N���[�h�ɕ\�������^�C�g��������
2�̔z��͓������ԂłȂ��Ă͂Ȃ�Ȃ�
�܂��Amusic_mode_complete()�����s���邱�ƂőS�Ă̋Ȃ𕷂������Ƃɂł���

����flagmusic���Ȃ����t����}�N���ɑg�ݍ���
��
@macro name=pl
@playbgm *
@flagmusic *
@endmacro
����ł����Ǖ������Ȃ͋L�^�����
�������Astorage�Ŏw�肳�ꂽ�������music.music_storage����T����
�L�^���Ă���̂Ŋg���q�̗L���͓��ꂵ�Ȃ���΂Ȃ�Ȃ�
