

�悭����~���[�W�b�N���[�h����������

�������g�������l�������Ȃ�D���Ɏg���Ă���
���ρA�Ĕz�z�͎��R
�g�p�𖾋L����K�v���񍐂���K�v���Ȃ�
���Ǖ񍐂������Ƃ��ꂵ��
���R�Ȃɂ������Ă��ӔC�͎��Ȃ�����

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
�܂�Afterinit.tjs(�Ȃ���΂���)�ɂ��̂��킦��
kag.onCloseQuery = function ()
{
	saveSystemVariables();
	if(!askOnClose) { global.Window.onCloseQuery(true); return; }
	tf.timer.enabled=false if tf.timer !== void;
	global.Window.onCloseQuery(askYesNo("�I�����܂����H"));
} incontextof kag;

295�s�ڂ̉E�N���b�N�̐ݒ�����ɂ��킹�Ă�����
music_mode_init.ks��18�s�ڂ���̊e�ϐ�������������

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
