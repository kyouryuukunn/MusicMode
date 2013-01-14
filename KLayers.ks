[return cond="typeof(global.KLayersLoaded) != 'undefined'"]

; ToDo:
;	�E�ŏ��Ɏ��s����X�N���v�g�E�A�Ō�Ɏ��s����X�N���v�g��ǉ�����
;	�E�g�����W�V�������� mousedown/keydown �ł��Ȃ��悤�ɂ���

;�A�j���[�V�����̃Z�[�u�E���[�h�ŃA�j���������ł��邩�H

; 2012/04/23	0.98c	�E�t�H�[�J�X����Ă��郌�C�����폜���鎞(delOnPage()��
;			�@del()���鎞)��window.focusedLayer=null��ǉ�
;			�EonFocus()�Ń}�E�X�J�[�\���𓮂����̂��A�L�[��
;			�@�����ꂽ���݂̂Ɍ���(MessageLayer�ł�������Ă邵)
; 2012/02/21	0.98b	�t�H�[�J�X����Ă��郌�C����visible/enabled=false��
;			�ݒ肵�ăt�H�[�J�X�������̂�����邽�߂ɁAKLayer
;			�N���X��onSearchNextFocusable()��ǉ�
; 2011/08/13	0.98a	Layer�N���X��order�����o��ύX���Ȃ��悤�ɏC��
; 2011/06/25	0.98	setOptions()��setOptions_sub()���g��ʂ悤�ύX
;			setOptions()��(keys(elm).count <= 0))�𔻒肹�ʂ悤��
;			evalstr()��TJSFunctions��str2num()�ɕύX
; 2011/06/11	0.97	Klayer�N���X��captionface ��ǉ�
; 2011/05/30	0.95	classid ���������̂��������̂Œǉ�
;			KLayersPlugin��onStore/Restore��for�̏��Ԃ�ύX
;			onRestore()���Aelm.backlay == true ��fore->back�߂��v
;			onRestore()�̑�������clear�������̂�Y��ĂďC��
;			setOptions()��loadImages()�̑O��setOptions_sub() �����
;			imageLeft�Ȃǂ��ݒ肳���ꍇ�Ɂu�͈͊O�̉摜�\���v
;			�G���[�ƂȂ�̂��C��
;			KSliderLayer��finalize()��timer.enabled=false��ǉ�
;			discardImage() �� hasImage=0, hasImage=1 ��ǉ�
;			KRadioButtonLayer��setOptions()�ŁA�{�^����==0��e����
; 2011/04/06	0.91	hitThreshold��KLayer��256�ɁAKClickableLayer��16�ɂ���
;			hitThreshold��ۑ�����悤�ɂ���
; 2011/03/26	0.90	KAnimButtonLayer�̃^�O��KAnimLayer�Ɠ���
;			�e��startanim()�̈����ԈႢ���C��
;			setOptions() �� elm.clickstorage!==void����
;			elm.clicktarget===void�̎���clicktarget�������Ⴂ���C��
;			KAnimButtonLayer��onBlur()�ǉ�
;			KAnimLayer�Ȃǂ�[disp]������ x,y �� sx,sy �ɕύX

[call storage="TJSFunctions.ks"]

[iscript]

// �f�t�H���g�̕\���D�揇��
sf.KLAYERS_DEFABSOLUTE = 2000000-2;

/*
KLayers�̃X�P���g���͈ȉ��̒ʂ�B
class KAGLayers_skelton // extends KAGLayer(�܂��͂��̔h�����C��)
{
	var classid;	// �N���X���̕�����
	// var name; name �� Layer �N���X�ɗL��̂Œ�`�s�v�B

	// �R���X�g���N�^�Bname/elm�͏ȗ��\
	function KAGLayers_skelton(w, p, name, elm);

	// �f�X�g���N�^
	function finalize();

	// �I�v�V�����ݒ�Belm===void�̂��Ƃ��l���Ă�������
	function setOptions(elm);

	// �I�u�W�F�N�g�̃R�s�[
	function assign(src);

	// �I�u�W�F�N�g�Z�[�u���ɁA���g�̎����z��dic������ĕԂ�
	function store();

	// �I�u�W�F�N�g���[�h���ɁA�����z��dic�����Ɏ��g��ݒ肷��(dic��Ԃ�)
	function restore(dic);
}
�s�����珑�����Ⴄ�ƃ��x���ƔF������Ă��܂��B���� */

// ���C���[��h������ƒx���Ȃ�̂ŁAKAGLayer�ł͂Ȃ��ALayer�N���X�����̂܂�
// �g���B�Ȃ񂩂̔��q�ɖ߂��Ă��������ǁc�B


// �摜�E�e�L�X�g��\�����邾���̃��C���[
class KLayer extends Layer
{
	var classid = "KLayer";		// �萔
//	var name;			// ���O(Layer�N���X���Œ�`�ς䂦�s�v)
	var caption = "";		// ����
	var captionface = "�l�r �o�S�V�b�N";	// �t�H���g��
	var captioncolor = 0x0;		// �����F(�����x�͂Ȃ�)
	var captionsize = 16;		// �����T�C�Y
	var captionalignx = 'center';	// �����\���ʒu(left/center/right)
	var captionaligny = 'center';	// �����\���ʒu(top/center/bottom)
	var color = 0x80ffffff;		// �w�i�F(�z���g��setter�ɂ���update()
					// �������������񂾂��c�ʓ|�����[
	var graphic = void;		// �摜�t�@�C����(void�ŉ摜�Ȃ�)

// ��Œǉ����邩�l����
//	var oncreate;
//	var createstorage;
//	var createtarget;
//	var ondestroy;
//	var destroystorage;
//	var destroytarget;

	// �R���X�g���N�^
	function KLayer(window, parent, i_name = "", elm)
	{
		super.Layer(window, parent);
		name         = i_name;
		width        = 32;	// �f�t�H���g�T�C�Y
		height       = 32;
		focusable    = false;	// �f�t�H���g�ł� unfocusable
		hitThreshold = 256;	// �f�t�H���g�ł͓����蔻��Ȃ�
		absolute     = sf.KLAYERS_DEFABSOLUTE;
		visible      = true;
		setOptions(elm);
		super.update();		// ����`�悷��
	}

	// �f�X�g���N�^
	function finalize()
	{
		super.finalize();
	}

	// Layer�N���X�̃��[�J���̃����o���R�s�[
	function Layer_setOptions(dst, src)
	{
		// �R�����g�A�E�g����Ă��郁���o��readonly�̂���
		var keyary = [
			"absolute",	//��Έʒu
			"absoluteOrderMode",//��Έʒu���[�h���ǂ���
			"attentionLeft",//�������[�ʒu
			"attentionTop",	//������[�ʒu
			"cached",	//�L���b�V�����s����
			"callOnPaint",	//onPaint�C�x���g���ĂԂ��ǂ���
		//	"children",	//�q���C���z��
			"clipHeight",	//�`��N���b�v��`�c��
			"clipLeft",	//�`��N���b�v��`���[�ʒu
			"clipTop",	//�`��N���b�v��`��[�ʒu
			"clipWidth",	//�`��N���b�v��`����
			"cursor",	//�}�E�X�J�[�\��
		//	"cursorX",	//�}�E�X�J�[�\�� x �ʒu
		//	"cursorY",	//�}�E�X�J�[�\�� y �ʒu
			"enabled",	//����\���ǂ���
			"face",		//�`�����
			"focusable",	//�t�H�[�J�X���󂯎��邩�ǂ���
		//	"focused",	//�t�H�[�J�X����Ă��邩�ǂ���
		//	"font",		//�t�H���g
		//	"hasImage",	//���C�����摜�������Ă��邩�ǂ���
			"height",	//�c��
			"hint",		//�q���g
			"hitThreshold",	//�����蔻��̕~���l
			"hitType",	//�����蔻��̃^�C�v
			"holdAlpha",	//�A���t�@�`�����l����ی삷�邩
			"imageHeight",	//�摜�c��
			"imageLeft",	//���C���摜���[�I�t�Z�b�g
			"imageModified",//�摜���ύX���ꂽ��
			"imageTop",	//���C���摜��[�I�t�Z�b�g
			"imageWidth",	//�摜����
			"imeMode",	//IME���[�h
		//	"isPrimary",	//�v���C�}�����C�����ǂ���
			"joinFocusChain",//�t�H�[�J�X�`�F�[���ɎQ�����邩
			"left",		//���[�ʒu
		//	"mainImageBuffer",//���C���摜�o�b�t�@�|�C���^
		//	"mainImageBufferForWrite",//���C���摜�o�b�t�@�|�C���^(�������ݗp)
		//	"mainImageBufferPitch",//���C���摜�o�b�t�@�s�b�`
			"name",		//���C����
			"neutralColor",	//�����F
		//	"nextFocusable",//����̃t�H�[�J�X���󂯎��郌�C��
		//	"nodeEnabled",	//���C���m�[�h������\���ǂ���
		//	"nodeVisible",	//�m�[�h�������ǂ���
			"opacity",	//�s�����x
//�w�肷���absolute���ς��̂ł����ł͎w�肵�Ȃ� "order",	//���Έʒu
		//	"parent",	//�e���C��
		//	"prevFocusable",//�O���̃t�H�[�J�X���󂯎��郌�C��
		//	"provinceImageBuffer",//�̈�摜�o�b�t�@�|�C���^
		//	"provinceImageBufferForWrite",//�̈�摜�o�b�t�@�|�C���^(�������ݗp)
		//	"provinceImageBufferPitch",//�̈�摜�o�b�t�@�s�b�`
			"showParentHint",	//�e���C���̃q���g�������p����
			"top",		//��[�ʒu
			"type",		//���C���\���^�C�v
			"useAttention",	//���������g�p���邩�ǂ���
			"visible",	//�����ǂ���
			"width"		//����
		//	"window"	//�E�B���h�E�I�u�W�F�N�g
		];
		selectcopy_dic(dst, src, keyary);
//		if (!parent.absoluteOrderMode) ��������ƌZ�탌�C����absolute
//			dst.order = src.order; ��ς��Ă����ɍ���̂ō폜
	}

	// ���̃N���X�̃����o�ݒ�
	function KLayer_setOptions(dst, src)
	{
		// �������炱�̃N���X�̃����o�ݒ�
		var keyary = [
			"classid",
			"caption",
			"captionface",
			"captioncolor",
			"captionsize",
			"captionalignx",
			"captionaligny",
			"color",
			"graphic"	// assign�Ƃ��Ŏg���̂łȂ��ƃ_��
		];
		selectcopy_dic(dst, src, keyary);
	}

	// �I�v�V�����ݒ�
	function setOptions(elm)
	{
		if (elm === void)
			return;

		// ��ɉ摜��ǂށBimageLeft���ݒ肳��摜�͈͊O�̕\����h����
		loadImages(elm.graphic, elm.key);	// void �ł� O.K.
		Layer_setOptions(this, elm);
		KLayer_setOptions(this, elm);
		if (elm.graphic !== void && elm.graphic == "")
			graphic = void;	// loadImages()�Őݒ肵��graphic��
					// setOptions()�ŏ㏑������邽�ߍĐݒ�
		if (elm.caption !== void || elm.captioncolor !== void ||
		    elm.captionsize !== void || elm.captionface !== void ||
		    elm.captionalignx !== void || elm.captionaligny !== void)
			draw();
	}

	// �C���[�W��ǂ�
	function loadImages(graphic, keys)
	{
		if (graphic === void || graphic == "") {
			this.graphic = void;	// "" ���Ƒ��ō���̂ŏ���
			discardImage();
			return;
		}
		this.graphic = graphic;
		super.loadImages(graphic, keys);
		setImagePos(0,0);
		setSizeToImageSize();
		callOnPaint = true;	// ����`�悷��
	}

	// �摜�𖳌�������
	function discardImage()
	{
		graphic = void;
		hasImage = 0;	hasImage = 1;	// ����ŉ摜����x����������
		// �摜�T�C�Y�͕ς��Ȃ��炵���̂ł���ł悢
		setImagePos(0, 0);
////		update();
	}

// ���������on...�́A�P���ɐe�փC�x���g��`���郌�C���[�Ƃ��邽�߂ɒ�`
// �h���N���X�ł͓K�X�C�����邱�ƁB
// 2011/03/08 �폜�B�e�֓`������}�E�X�̈ʒu�Ƃ����Y�����Ⴄ����Ȃ��́B
//	// �}�E�X�������ꂽ�ꍇ
//	function onMouseDown(x, y, button, shift)
//	{
//		// �e�փC�x���g��`���邾��
//		parent.onMouseDown(...);
//	}
//
//	// �}�E�X�������ꂽ�ꍇ
//	function onMouseUp(x, y, button, shift)
//	{
//		// �e�փC�x���g��`���邾��
//		parent.onMouseUp(...);
//	}
//
//	// �}�E�X����������
//	function onMouseEnter()
//	{
//		// �e�փC�x���g��`���邾��
//		parent.onMouseEnter(...);
//	}
//
//	// �}�E�X���o����
//	function onMouseLeave()
//	{
//		// �e�փC�x���g��`���邾��
//		parent.onMouseLeave(...);
//	}
//
// 2011/06/20�폜�B�����Ă��������B
//	// �L�[�������ꂽ��
//	function onKeyDown(key, shift, process)
//	{
//		// focusable�Ȃ̂�super�����s
//		super.onKeyDown(...);	// �C�x���g��`���邾��
//	}
//
//	// �L�[�������ꂽ��
//	function onKeyUp(key, shift, process)
//	{
//		// focusable�Ȃ̂�super�����s
//		super.onKeyUp(...);	// �e�փC�x���g��`���邾��
//	}

	// �ĕ`��
	function onPaint()
	{
		super.onPaint();
		draw();
	}

	// �ĕ`��
	function draw()
	{
		// super.update();	���ꂪ����ƒ���d���Ȃ�
		if (graphic !== void)
			return;
		// �O���t�B�b�N���Ȃ���΃L���v�V����(����)��\��
		fillRect(0,0,width,height, color);
		if (caption === void || caption == "")
			return;
		// setOptions_sub�Ő��l�ɕϊ������ꍇ������̂ŕ�����ɕϊ�
		caption = string(caption);
		var lines = caption.split(/\[r\]/); // ���s�Ŕz��ɕϊ�
		if (lines.count <= 0)
			return;
		font.face = captionface;
		font.height = captionsize;
		// �L���v�V������ align# �ɏ]���ēK���Ȉʒu�ɕ\��
		var lh = captionsize * lines.count;
		var ly = (height-lh)/2;
		if (captionaligny == 'top')
			ly = 0;
		else if (captionaligny == 'bottom')
			ly = height-lh;
		for (var i = 0; i < lines.count; i++, ly += font.height) {
			var lw = font.getTextWidth(lines[i]);
			var lx = (width-lw)/2;
			if (captionalignx == 'left')
				lx = 0;
			else if (captionalignx == 'right')
				lx = width-lw;
			drawText(lx, ly, lines[i], captioncolor, 255);
		}
	}

	// �X�N���v�g��������A���g���R���e�L�X�g�Ƃ��Ď��s����
	function eval(str)
	{
		if (str === void || str.length <= 0)
			return;
		if (str[0] == '&')
			str = str.substr(1);
		// ������ ! ��������A���g���R���e�L�X�g�Ƃ��Ď��s
		if (str[str.length-1] == '!') {
			str = str.substr(0, str.length-1);
			return str!;
		}
		return Scripts.eval(str);
	}

	// �R�s�[
	function assign(src, updateflg=true)
	{
		super.assignImages(src, true);	// KAGLayer�ɂ�assign()�͂Ȃ�
		// ���ꁫ���Ƃ�����Əd����������񂪁c
		Layer_setOptions(this, src);
		KLayer_setOptions(this, src);
		update() if (updateflg);
	}

	// �Z�[�u���ɏォ��Ă΂��
	function store()
	{
//		var dic = super.store(); �X�[�p�[�N���X�� Layer������s�v
		var dic = %[];
		Layer_setOptions(dic, this);
		KLayer_setOptions(dic, this);
		return dic;
	}

	// ���[�h���ɏォ��Ă΂��
	function restore(dic)
	{
		if (dic === void)
			return;
//		super.restore(dic);	�X�[�p�[�N���X�� Layer������s�v
		setOptions(dic);
		return dic;
	}

	// ���̃t�H�[�J�X�\�ȃ��C����T���Ƃ�
	function onSearchNextFocusable(layer)
	{
		// focused button��disable�������Ƀ}�E�X�J�[�\�����ړ������Ȃ�
		if (!nodeEnabled || !nodeVisible)
			super.onSearchNextFocusable(null);
		else
			super.onSearchNextFocusable(layer);
		// onBlur()�Ƃ�onNodeDisabled()�͎����t�H�[�J�X�u��v��
		// �Ă΂��̂Ŏg���Ȃ�����
	}
}


// �A�j���[�V���������C��
class KAnimLayer extends KLayer
{
	var classid = "KAnimLayer";	// �萔
//	var name;			// ���O(Layer�N���X���Œ�`�ς䂦�s�v)
	var conductor;			// �A�j���[�V�����̃R���_�N�^
//	var graphic;	// �A�j���[�V�����p�^�[���摜�c�͐e�N���X�Ɋ��ɂ���̂�
	var animinfo;			// �A�j���[�V�������t�@�C��(.adf)

	// �R���X�g���N�^
	function KAnimLayer(win, par, i_name="", elm)
	{
		conductor = new AnimationConductor(this);
		super.KLayer(win, par, i_name, elm);
		setOptions(elm);
	}

	// �f�X�g���N�^
	function finalize()
	{
		invalidate conductor;
	}

	// conductor/animinfo��loadImages()���Őݒ肳���̂�setOptions()�͕s�v

	// �A�j���[�V�������~����
	function stopAnim()
	{
		conductor.stop();
	}

	// �C���[�W��ǂݍ��ށBheight�͌�Ŏw�肷�邱��
	function loadImages(graphic, key)
	{
		stopAnim();
		super.loadImages(grahpic, key);
		// �A�j���[�V������񂪂���Γǂ�
		loadAnimInfo(grahpic);
	}

	// �A�j���[�V�������t�@�C����ǂݍ���
	function loadAnimInfo(graphic)
	{
		startAnim(Storages.chopStorageExt(graphic)+".adf", "");
	}

	// �A�j���[�V�������J�n����
	function startAnim(storage=animinfo, label)
	{
		stopAnim();
		if (storage !== void && storage != "" &&
		    Storages.isExistentStorage(storage)) {
			animinfo = storage;
			// �A�j���[�V������`�t�@�C�������݂���
			conductor.startLabel = label;
			conductor.stopping = false;
			conductor.running = true;
			conductor.clearCallStack();
//			conductor.interrupted = Anim_interrupted;
			conductor.loadScenario(storage);
			conductor.goToLabel(label);
			conductor.startProcess(true);
		} else {
			// adffile�����������ꍇ�͕��ʂ̉摜���C���Ƃ��ĐU����
			animinfo = "";
		}
	}

	// �R�s�[
	function assign(src)
	{
		super.assign(src);
		animinfo = src.animinfo;
		conductor.assign(src.conductor);
	}

	// �Z�[�u
	function store()
	{
		var dic = super.store();
		dic.animinfo = animinfo;
		dic.conductor = conductor.store();
		return dic;
	}

	// ���[�h
	function restore(dic)
	{
		stopAnim();
		if (dic === void)
			return;
		super.restore(dic);	// ���̒��� setOptions(dic) �����s����
		animinfo = dic.animinfo;
		// �ȉ��͋g���g���̃o�O���Ǝv�����ǁA����Ƃ��Ȃ���
		// �u�n�[�h�E�F�A�G���[���������܂����v�ɂȂ��Ă��܂��c�B
		if (dic.conductor.storageName != "")
			conductor.restore(dic.conductor);
		else {
			invalidate conductor;
			conductor = new AnimationConductor(this);
		}
		return dic;
	}

// ��������^�O�n���h�� ------------------------------------------------

	// ������ [s]
	function s(elm)
	{
		// ��~
		elm.context.running = false;
		return -1; // ��~
	}

	// �^�O�n���h�� loadcell() �͉������Ȃ�
	function loadcell()
	{
		// .adf �t�@�C���ɑ��݂������ɃG���[�ɂ��Ȃ����߂̃_�~�[
		return 0;
	}

	// �ǉ��^�O�n���h�� pos(x, y)
	function pos(elm)
	{
		left    =  str2num(elm.x,      left);
		top     =  str2num(elm.y,       top);
		left    += str2num(elm.dx,        0);
		top     += str2num(elm.dy,        0);
		opacity =  str2num(elm.opa, opacity);
		opacity += str2num(elm.iopa,      0);
		return 0;
	}

	// �ǉ��^�O�n���h�� size(w, h)
	function size(elm)
	{
		setSize(str2num(elm.w, width), str2num(elm.h, height));
		return 0;
	}

	// index �l�͈̔͂� 0�`max �ɐ��K������
	function evalidx(cur, max)
	{
		var ret = cur%max;
		return (ret >= 0) ? ret : ret+max;
	}

	// disp�^�O�㏑���n���h��
	function disp(elm)
	{
		var sx = str2num(elm.sx);
		var sy = str2num(elm.sy); // def=0(-imageLeft����Ȃ�) �ɒ���
		if (elm.six !== void) {
			var cursix = -imageLeft\width;
			var idx = str2num(elm.six.replace(/six/, cursix));
			sx = evalidx(idx, imageWidth\width) * width;
		}
		if (elm.siy !== void) {
			var cursiy = -imageTop\height;
			var idx = str2num(elm.siy.replace(/siy/, cursiy));
			sy = evalidx(idx, imgeHeight\height) * height;
		}
		if (elm.index !== void) {
			var curidx = -imageTop\height;
			var idx = str2num(elm.index.replace(/index/, curidx));
			sy = evalidx(idx, imageHeight\height) * height;
		}
		setImagePos(-(sx), -(sy));
		return 0;
	}

	// �^�O�n���h���ǉ��Aloop
	function loop(elm)
	{
		// ���[�v���邱�Ƃ�錾����
		// �Z�O�����g�ɂ���Ă̓��[�v�����肵�Ȃ������肷�邽�߁B
		elm.context.looping = true;
		return 0;
	}

	// �^�O�n���h���ǉ��Anoloop�Floop�̔��΁B
	function noloop(elm)
	{
		// ���[�v���g��Ȃ����Ƃ�錾����
		// �Z�O�����g�ɂ���Ă̓��[�v�����肵�Ȃ������肷�邽�߁B
		elm.context.looping = false;
		return 0;
	}

	// �^�O�n���h���ǉ� wait
	function wait(elm)
	{
		return elm.time; // �w�莞�Ԃ�����~
	}

// ����AKLayer��eval()�Ƃ��Ԃ�̂ō폜�B����Ȃ�������B
	// �^�O�n���h��
//	function eval(elm)
//	{
//		eval(elm.exp); // elm.exp �����Ƃ��Ď��s
//		return 0;
//	}
}


// �{�^���ɂ��g���邪�摜�ω����Ȃ����C��
class KClickableLayer extends KLayer
{
	var classid 		= "KClickableLayer";// �萔

	var countpage 		= true;		// [button]�^�O��countpage�Q��

	var repeatable          = false;	// ���s�[�g�\���ǂ���
	var repeattimer;			// ���s�[�g����̃^�C�}�[
	var repeatinterval1     = 500;		// ���s�[�g�Ԋu1(����)
	var repeatinterval2     = 100;		// ���s�[�g�Ԋu2

	// �I�v�V�����Q
	var onclick;		// �����ꂽ���Ɏ��s���铮��
	var clickse;		// �����ꂽ���ɖ炷��
	var clicksebuf = 0;	// �����ꂽ���ɖ炷���̃o�b�t�@
	var clickstorage;	// �����ꂽ���ɃW�����v����V�i���I�t�@�C��
	var clicktarget;	// �����ꂽ���ɃW�����v����V�i���I���x��
	var onrelease;		// �����ꂽ���Ɏ��s���铮��
	var releasese;		// �����ꂽ���ɖ炷��
	var releasesebuf = 0;	// �����ꂽ���ɖ炷���̃o�b�t�@
	var releasestorage;	// �����ꂽ���ɃW�����v����V�i���I�t�@�C��
	var releasetarget;	// �����ꂽ���ɃW�����v����V�i���I���x��
	var onenter;		// �|�C���^�����������Ɏ��s���铮��
	var enterse;		// �|�C���^�����������ɖ炷��
	var entersebuf = 0;	// �|�C���^�����������ɖ炷���̃o�b�t�@
	var enterstorage; // �|�C���^�����������ɃW�����v����V�i���I�t�@�C��
	var entertarget;  // �|�C���^�����������ɃW�����v����V�i���I���x��
	var onleave;		// �|�C���^���o�����Ɏ��s���铮��
	var leavese;		// �|�C���^���o�����ɖ炷��
	var leavesebuf = 0;	// �|�C���^���o�����ɖ炷���̃o�b�t�@;
	var leavestorage; // �|�C���^���o�����ɃW�����v����V�i���I�t�@�C��
	var leavetarget;  // �|�C���^���o�����ɃW�����v����V�i���I���x��

	// �R���X�g���N�^
	function KClickableLayer(win, parent, i_name, elm)
	{
		super.KLayer(win, parent, i_name);
		if(typeof win.cursorPointed !== "undefined")
			cursor = win.cursorPointed;
		hitThreshold = 0;
		focusable = true;	// �t�H�[�J�X�𓾂���

		repeattimer = new Timer(this, "onMouseDownRepeat");
		repeattimer.interval = repeatinterval1;

		setOptions(elm);
	}

	// �f�X�g���N�^
	function finalize()
	{
		repeattimer.enabled = false;
		invalidate repeattimer;
		super.finalize(...);
	}

	// ���̃��C�����[�J���̃����o���R�s�[
	function KClickableLayer_setOptions(dst, src)
	{
		var keyary = [
			"countpage",
			"repeatable",
		//	"repeattimer.interval",
		//	"repeattimer.enabled",
			"repeatinterval1",
			"repeatinterval2",
			"onclick",
			"clickse",
			"clicksebuf",
			"clickstorage",
			"clicktarget",
			"onrelease",
			"releasese",
			"releasesebuf",
			"releasestorage",
			"releasetarget",
			"onenter",
			"enterse",
			"entersebuf",
			"enterstorage",
			"entertarget",
			"onleave",
			"leavese",
			"leavesebuf",
			"leavestorage",
			"leavetarget"
		];
		selectcopy_dic(dst, src, keyary);
		if (typeof(src.repeattimer) != 'undefined') {
			if (typeof(dst.repeattimer) == 'undefined')
				dst.repeattimer = %[];
			dst.repeattimer.interval = src.repeattimer.interval;
			dst.repeattimer.enabled = src.repeattimer.enabled;
		}
	}

	// �I�v�V������ݒ�
	function setOptions(elm)
	{
		if (elm === void)
			return;
		if (elm.exp !== void)	// onrelease��exp�ƑS������
			elm.onrelease = elm.exp;
		if (elm.storage !== void)
			elm.releasestorage = elm.storage;
		if (elm.target !== void)
			elm.releasetarget = elm.target;
		// ��ɉ摜��ǂށBimageLeft���ݒ肳��摜�͈͊O�̕\����h����
		loadImages(elm.graphic, elm.key) if (elm.graphic !== void);
		// �e���C���ɃI�v�V�����w��
		super.setOptions(elm);
		KClickableLayer_setOptions(this, elm);
		// *storage �������w�肳�ꂽ�ꍇ�ɔ����A*target�� void�ɂ���
		if (elm.clickstorage !== void && elm.clicktarget === void)
			clicktarget = void;
		if (elm.releasestorage !== void && elm.releasetarget === void)
			releasetarget = void;
		if (elm.enterstorage !== void && elm.entertarget === void)
			entertarget = void;
		if (elm.leavestorage !== void && elm.leavetarget === void)
			leavetarget = void;
	}

	// exp�ɁA�T�E���h��炷���߂̎���','�Œǉ����ĕԂ�
	function addSndExp(exp, sndfile, buf)
	{
		if (sndfile !== void) {
			buf = 0 if (buf === void);
			exp = "(kag.se[" + buf + "].play(%[storage:\""
				+ sndfile.escape() + "\"]))"
				+ ((exp === void) ? "" : ", (" + exp + ")");
		}
		return exp;
	}

	// �}�E�X�������ꂽ�ꍇ
	function onMouseDown(x, y, button=mbLeft, shift=0)
	{
		if (button != mbLeft) {
			// ���N���b�N�ȊO�͖���
			super.onMouseDown(...);
			return;
		}
		focus();
		var exp = addSndExp(onclick, clickse, clicksebuf);
		if (button == mbLeft && exp !== void)
			eval(exp);
		if (clickstorage !== void || clicktarget !== void)
			window.process(clickstorage, clicktarget, countpage);

		if (repeatable)
			repeattimer.enabled  = true;
	}

	// �}�E�X��������ςȂ��̎��̃��s�[�g�֐�
	function onMouseDownRepeat()
	{
		onMouseDown(cursorX, cursorY, mbLeft, 0);
		repeattimer.interval = repeatinterval2;
	}

	// �}�E�X�������ꂽ�ꍇ
	function onMouseUp(x, y, button=mbLeft, shift=0)
	{
		repeattimer.enabled  = false;
		repeattimer.interval = repeatinterval1;

//		super.onMouseUp(...); // parent.onMouseUp()�����s���Ȃ��悤��

		var exp = addSndExp(onrelease, releasese, releasesebuf);
		if (button == mbLeft && exp !== void) {
			eval(exp);
//			return;
//			// �u�^�C�g���ɖ߂�v�̎��͂���return���Ȃ��ƃG���[��
			// �Ȃ����Ⴄ���ǁc�ǂ�����B
		}
		if (releasestorage !== void || releasetarget !== void)
			window.process(releasestorage,releasetarget,countpage);
	}

//	// �Ȃ�ł������łȂ�onMouseDown()�g���Ă�񂾂����c�B���͉������Ȃ�
//	// onClick()��mouseUp���ɓ�������A���������Ȃ��B
//	function onClick()
//	{
//		super.onClick(...);
//	}

	// �}�E�X����������
	function onMouseEnter()
	{
//		super.onMouseEnter(...);// parent.onMouseUp()�����s���Ȃ��悤��
		focus();

		var exp2 = addSndExp(onenter, enterse, entersebuf);
		if (/*!parent.selProcessLock && */exp2 !== void)
			eval(exp2);
		if (enterstorage !== void || entertarget !== void)
			window.process(enterstorage, entertarget, countpage);
	}

	// �}�E�X���o����
	function onMouseLeave()
	{
//		super.onMouseLeave(...);// parent.onMouseUp()�����s���Ȃ��悤��

		var exp2 = addSndExp(onleave, leavese, leavesebuf);
		if (/*!parent.selProcessLock && */exp2 !== void)
			eval(exp2);
		if (leavestorage !== void || leavetarget !== void)
			window.process(leavestorage, leavetarget, countpage);
	}

	// �t�H�[�J�X���ꂽ��
	function onFocus(focused, direction)
	{
//		super.onFocus(...); // parent.onMouseUp()�����s���Ȃ��悤��
		// �}�E�X�����ꂽ�������߂ăt�H�[�J�X�����̂ŁA����͏Ȃ�
		if (0 <= cursorX && cursorX < width &&
		    0 <= cursorY && cursorY < height)
			return;
		// �L�[�������ꂽ���̂݃t�H�[�J�X����̂ŁA�����łȂ���ΏȂ�
		var gks = window.getKeyState;
		if (!gks(VK_LEFT) && !gks(VK_UP) && !gks(VK_RIGHT) &&
		    !gks(VK_DOWN) && !gks(VK_TAB))
			return;

		// �}�E�X�����g�̒��S�Ɉړ�����B�����onMouseEnter�̉摜�ɂȂ�
		setCursorPos(width\2, height\2);
	}

	// �L�[�������ꂽ��(animbutton�ł܂����܂������ĂȂ�)
	function onKeyDown(key, shift, process)
	{
		if (process && (key == VK_RETURN || key == VK_SPACE)) {
			// �X�y�[�X�L�[�܂��̓G���^�[�L�[�������ꂽ��
			// ������mouse�������ꂽ���Ƃɂ���
			onMouseDown(width\2, height\2, mbLeft, shift);
			super.onKeyDown(key, shift, false);
		} else {
			super.onKeyDown(...);
		}
	}

	// �L�[�������ꂽ��(animbutton�ł܂����܂������ĂȂ�)
	function onKeyUp(key, shift, process)
	{
		if (process && (key == VK_RETURN || key == VK_SPACE)) {
			// �X�y�[�X�L�[�܂��̓G���^�[�L�[�������ꂽ��
			// ������mouse�������ꂽ���Ƃɂ���
			onMouseUp(width\2, height\2, mbLeft, shift);
			super.onKeyUp(key, shift, false);
		} else {
			super.onKeyUp(...);
		}
	}

	// ���C���[�̃R�s�[
	function assign(src, updateflg=true)
	{
		super.assign(src, false);
		KClickableLayer_setOptions(this, src);
		update() if (updateflg);
	}

	// �Z�[�u���ɏォ��Ă΂��
	function store()
	{
		var dic = super.store();
		KClickableLayer_setOptions(dic, this);
		return dic;
	}

	// ���[�h���ɏォ��Ă΂��
	function restore(dic)
	{
		if (dic === void)
			return;
		super.restore(dic);	// ���̒��� setOptions(dic) �����s����
		return dic;
	}
}


// �{�^���Q�̋��ʃ��C��
class KButtonLayer extends KClickableLayer
{
	var classid 		= "KButtonLayer";// �萔

	var Butt_imageLoaded    = false;	// �摜���ǂݍ��܂ꂽ��
	var Butt_mouseOn        = false;	// ���C�����Ƀ}�E�X�����邩
	var Butt_mouseDown      = false;	// �}�E�X�{�^����������Ă��邩
	var Butt_color          = clNone;
	var Butt_caption        = '';		// �{�^���̃L���v�V����
	var Butt_captionColor   = 0x000000;	// �L���v�V�����̐F
	var Butt_keyPressed     = false;

	// �R���X�g���N�^
	function KButtonLayer(win, parent, i_name, elm)
	{
		super.KClickableLayer(win, parent, i_name);
		setOptions(elm);
	}

	// �f�X�g���N�^
	function finalize()
	{
		super.finalize(...);
	}

	// ���̃��C�����[�J���̃����o���R�s�[
	function KButtonLayer_setOptions(dst, src)
	{
		var keyary = [
			"Butt_imageLoaded",
			"Butt_mouseOn",
			"Butt_mouseDown",
			"Butt_color",
			"Butt_caption",
			"Butt_captionColor",
			"Butt_keyPressed"
		];
		selectcopy_dic(dst, src, keyary);
	}

	// �I�v�V������ݒ�
	function setOptions(elm)
	{
		if (elm === void)
			return;
		super.setOptions(elm);
		// �w��I�v�V���������g�̃v���p�e�B�ɐݒ�
		KButtonLayer_setOptions(this, elm);
	}

	// �摜��ǂݍ���
	function loadImages(graphic, key)
	{
		super.loadImages(graphic, key);
		super.width      = imageWidth \ 3;
		super.height     = imageHeight;
		Butt_imageLoaded = true;
	}

	// �摜��j�����A�����{�^�����C���Ƃ��ē��삷��悤�ɂ���
	function discardImage()
	{
		Butt_imageLoaded = false;
		super.discardImage();
	}

	// ���݂̉摜��\������(s: 0=���ʁA1=clicked�A2=entered)
	function drawState(s)
	{
		if(!enabled)
			s = 0; // �������

		if(Butt_imageLoaded) {
			// �{�^���C���[�W���ǂݍ��܂�Ă���
			// TODO: keyboard focus
			imageLeft = -s * width;
		} else {
			var w = width, h = height;
			if(Butt_keyPressed)
				s = 1; // ������Ă���
			// �ȉ��A�g�ƃL���v�V������`��
			face = dfAlpha;
			fillRect(0,0, w,h, Butt_color);
			// �����̃T�C�Y�𓾂�
			var tw = font.getTextWidth (Butt_caption);
			var th = font.getTextHeight(Butt_caption);
			if(s == 0 || s == 2) {
				// �ʏ킠�邢�̓}�E�X����ɂ���
				colorRect(  0,   0,   w,   1, 0xffffff, 128);
				colorRect(  0,   1,   1, h-2, 0xffffff, 128);
				colorRect(w-1,   1,   1, h-1, 0x000000, 128);
				colorRect(  1, h-1, w-2,   1, 0x000000, 128);
				drawText((w-tw)>>1, (h-th)>>1, 
					Butt_caption, Butt_captionColor,
					nodeEnabled ? 255 : 128);
			} else {
				// ������Ă���
				colorRect(  0,   0,   w,   1, 0x000000, 128);
				colorRect(  0,   1,   1, h-2, 0x000000, 128);
				colorRect(w-1,   1,   1, h-1, 0xffffff, 128);
				colorRect(  1, h-1, w-2,   1, 0xffffff, 128);
				drawText(((w-tw)>>1) +1,((h-th)>>1)+1,
				 	Butt_caption, Butt_captionColor,
					nodeEnabled ? 255 : 128);
			}

			if(s != 0)	// �n�C���C�g����
				colorRect(2,2,w-4,h-4,clHighlight,64);
			if(focused) {	// �t�H�[�J�X������̂Ńn�C���C�g����
				colorRect(  2,  2,w-4,  1, clHighlight, 128);
				colorRect(  2,  3,  1,h-5, clHighlight, 128);
				colorRect(  3,h-3,w-5,  1, clHighlight, 128);
				colorRect(w-3,  3,  1,h-6, clHighlight, 128);
			}
		}
	}

	// �}�E�X�������ꂽ�ꍇ
	function onMouseDown(x, y, button=mbLeft, shift=0)
	{
		if (button != mbLeft) {
			// ���N���b�N�ȊO�͖���
			super.onMouseDown(...);
			return;
		}

		Butt_mouseDown = true;
		update();
		super.onMouseDown(...);
	}

	// �}�E�X�������ꂽ�ꍇ
	function onMouseUp(x, y, button=mbLeft, shift=0)
	{
		Butt_mouseDown = false;
		update();
		super.onMouseUp(...);
	}

	// �Ȃ�ł������łȂ�onMouseDown()�g���Ă�񂾂����c�B���͉������Ȃ�
	// onClick()��mouseUp���ɓ�������A���������Ȃ��B
	function onClick()
	{
		super.onClick(...);
	}

	// ���݂̏�Ԃɂ��킹�ĕ`����s��
	function draw()
	{
		if(Butt_mouseDown)
			drawState(1);
		else if(Butt_mouseOn)
			drawState(2);
		else
			drawState(0);
	}

	// �`��̒��O�ɌĂ΂��
	function onPaint()
	{
		super.onPaint(...);
		draw();
	}

	// �}�E�X����������
	function onMouseEnter()
	{
		Butt_mouseOn = true;
		update();
		super.onMouseEnter(...);
	}

	// �}�E�X���o����
	function onMouseLeave()
	{
		Butt_mouseOn = false;
		Butt_mouseDown = false;
		update();
		super.onMouseLeave(...);
	}

	// ���C���̃m�[�h���s�ɂȂ���
	function onNodeDisabled()
	{
		super.onNodeDisabled(...);
		Butt_mouseDown = false;
		update();
	}

	// ���C���̃m�[�h���L���ɂȂ���
	function onNodeEnabled()
	{
		super.onNodeEnabled(...);
		update();
	}

	// �t�H�[�J�X���ꂽ��
	function onFocus(focused, direction)
	{
//		super.onFocus(...); // parent.onMouseUp()�����s���Ȃ��悤��
		// �}�E�X�����ꂽ�������߂ăt�H�[�J�X�����̂ŁA����͏Ȃ�
		if (0 <= cursorX && cursorX < width &&
		    0 <= cursorY && cursorY < height)
			return;
		// �L�[�������ꂽ���̂݃t�H�[�J�X����̂ŁA�����łȂ���ΏȂ�
		var gks = window.getKeyState;
		if (!gks(VK_LEFT) && !gks(VK_UP) && !gks(VK_RIGHT) &&
		    !gks(VK_DOWN) && !gks(VK_TAB))
			return;

		// �}�E�X�����g�̒��S�Ɉړ�����B�����onMouseEnter�̉摜�ɂȂ�
 		setCursorPos(width\2, height\2);
		Butt_mouseOn = true;
		update();
	}

	// �t�H�[�J�X����������
	function onBlur()
	{
		super.onBlur(...);
		Butt_mouseDown = false;
		update();
	}

	// �L�[�������ꂽ��(animbutton�ł܂����܂������ĂȂ�)
	function onKeyDown(key, shift, process)
	{
		if (process && (key == VK_RETURN || key == VK_SPACE))
			Butt_keyPressed = true;
		super.onKeyDown(...);
	}

	// �L�[�������ꂽ��(animbutton�ł܂����܂������ĂȂ�)
	function onKeyUp(key, shift, process)
	{
		if (process && (key == VK_RETURN || key == VK_SPACE))
			Butt_keyPressed = false;
		super.onKeyUp(...);
	}

	// �{�^���̃R�s�[
	function assign(src, updateflg=true)
	{
		super.assign(src, false);
		KButtonLayer_setOptions(this, src);
		update() if (updateflg);
	}

	// �Z�[�u���ɏォ��Ă΂��
	function store()
	{
		var dic = super.store();
		KButtonLayer_setOptions(dic, this);
		return dic;
	}

	// ���[�h���ɏォ��Ă΂��
	function restore(dic)
	{
		if (dic === void)
			return;
		super.restore(dic);	// ���̒��� setOptions(dic) �����s����
		return dic;
	}

	property caption
	{
		setter(x) {
			Butt_caption = x;
			update();
		}
		getter {
			return Butt_caption;
		}
	}

	property color
	{
		setter(x) {
			Butt_color = int x;
			update();
		}
		getter {
			return Butt_color;
		}
	}

	property captionColor
	{
		setter(x) {
			Butt_captionColor = int x;
			update();
		}
		getter {
			return Butt_captionColor;
		}
	}
}


// �A�j���[�V�����������N�{�^�����C��(AnimationButtonLayer�̏Ă�����)
class KAnimButtonLayer extends KButtonLayer
{
	var classid    = "KAnimButtonLayer";	// �萔
	// �A�j���[�V�����{�^���̒ǉ�����
	var conductor;		// �A�j���[�V�����̃R���_�N�^
	var animinfo;		// �A�j���[�V������`�t�@�C����
	var maxpatternnum = 1;	// ���݂̃A�j���[�V�����Z���ő吔

	// �R���X�g���N�^
	function KAnimButtonLayer(win, parent, i_name, elm)
	{
		conductor = new AnimationConductor(this);
		super.KButtonLayer(...);
//		setOptions(elm);	// super�Őݒ肳��邩��s�v
	}

	// �f�X�g���N�^
	function finalize()
	{
		stopAnim();
		super.finalize(...);
		// �Ō�� invalidate ���������AstopAnim()�ŃG���[�o�Ȃ�
		invalidate conductor;
	}

	// ���̃��C�����[�J���̃����o���R�s�[
	function KAnimButtonLayer_setOptions(dst, src)
	{
		// animinfo��conductor�� loadImages()�œǂ܂��̂ŕs�v
		dst.maxpatternnum = src.maxpatternnum if (src.maxpatternnum !== void);
	}

	// �I�v�V������ݒ�
	function setOptions(elm)
	{
		if (elm === void)
			return;
		super.setOptions(elm);
		KAnimButtonLayer_setOptions(this, elm);
		// loadImages() �̌�� height �����ݒ肷��
		height = elm.height if (elm.height !== void);
	}

	// �A�j���[�V�������~����
	function stopAnim(resetidx=true)
	{
//�����̂ł́Hif (conductor !== void)	// �h���N���X����loadImages()�̎�void
			conductor.stop();
		imageTop = 0 if (resetidx);
	}

	// �A�j���[�V�������t�@�C����ǂݍ���
	function loadAnimInfo(graphic)
	{
		startAnim(Storages.chopStorageExt(graphic)+".bsd", "");
	}

	// �A�j���[�V�������J�n����B����܂ł�animinfo���ݒ肳��Ă��邱�ƁB
	function startAnim(storage=animinfo, label)
	{
		stopAnim(false);	// idx�̓��Z�b�g���Ȃ�
		if (storage !== void && storage != "" && Butt_imageLoaded &&
		    Storages.isExistentStorage(storage)) {
			animinfo = storage;
			// �A�j���[�V������`�t�@�C�������݂���
			conductor.startLabel = label;
			conductor.stopping = false;
			conductor.running = true;
			conductor.clearCallStack();
//			conductor.interrupted = Anim_interrupted;
			conductor.loadScenario(storage);
			conductor.goToLabel(label);
			conductor.startProcess(true);
		} else {
			// bsdfile�����������ꍇ�͕��ʂ�Button�Ƃ��ĐU����
			animinfo = "";
		}
	}

	// �C���[�W��ǂݍ��ށB���̌�ɓK���� height �ɒ������邱��
	function loadImages(graphic, key, newheight)
	{
		stopAnim();
// ToDo: ���ꂪ����� slidertab������������Ă��܂��c�����s���A��Œǋ����邱��
//		discardImage();
		if (graphic === void)
			return;
		super.loadImages(graphic, key);
		if (newheight !== void)
			height = newheight;
		maxpatternnum = imageHeight \ height;
		// �A�j���[�V������񂪂���Γǂ�
		loadAnimInfo(graphic);
	}

	// �C���[�W��j������
	function discardImage()
	{
		stopAnim();
		super.discardImage();
		animinfo      = '';
		maxpatternnum = 1;
	}

	// �N���b�N���̓���
	function onMouseDown(x, y, button=mbLeft, shift=0)
	{
		if (button != mbLeft) {
			// ���N���b�N�ȊO�͖���
			super.onMouseDown(...);
			return;
		}

		super.onMouseDown(...);
		startAnim(, '*onclick');	// "*onclick"����A�j���J�n
	}

	// �}�E�X�������ꂽ�ꍇ
	function onMouseUp(x, y, button=mbLeft, shift=0)
	{
		super.onMouseUp(...);
		startAnim(, '*onenter');
	}

	// �}�E�X����������
	function onMouseEnter()
	{
		super.onMouseEnter(...);
		startAnim(, '*onenter');	// "*onenter"����A�j���J�n
	}

	// �}�E�X���o����
	function onMouseLeave()
	{
		super.onMouseLeave(...);
		startAnim(, '*normal');	// "*normal"����A�j���J�n
	}

	// �t�H�[�J�X(unclicked focus)���ꂽ��
	function onFocus(focused, direction)
	{
		super.onFocus(...);
		startAnim(, '*onenter');
	}

	// �t�H�[�J�X(unclicked focus)����������
	function onBlur()
	{
		super.onBlur(...);
		startAnim(, '*normal');
	}

	// �{�^���̃R�s�[
	function assign(src, updateflg=true)
	{
		super.assign(src, false);
		KAnimButtonLayer_setOptions(this, src);
		conductor.assign(src.conductor);
		update() if (updateflg);
	}


// ------ ��������A�j���[�V������`�t�@�C��(.bsd)�̃^�O�n���h�� --------------
// �w��KAnimLayer��.adf �Ɠ����Ȃ񂾂��ǁc���܂������ł��Ȃ������̂ŁB

	// ������ [s]
	function s(elm)
	{
		// ��~
		elm.context.running = false;
		return -1; // ��~
	}

	// �^�O�n���h�� loadcell() �͉������Ȃ�
	function loadcell()
	{
		// .bsd �t�@�C���ɑ��݂������ɃG���[�ɂ��Ȃ����߂̃_�~�[
		return 0;
	}

	// �ǉ��^�O�n���h�� pos(x, y)
	function pos(elm)
	{
		left    =  str2num(elm.x,      left);
		top     =  str2num(elm.y,       top);
		left    += str2num(elm.dx,        0);
		top     += str2num(elm.dy,        0);
		opacity =  str2num(elm.opa, opacity);
		opacity += str2num(elm.iopa,      0);
		return 0;
	}

	// �ǉ��^�O�n���h�� size(w, h)
	function size(elm)
	{
		setSize(str2num(elm.w, width), str2num(elm.h, height));
		return 0;
	}

	// index �l�͈̔͂� 0�`max �ɐ��K������
	function evalidx(cur, max)
	{
		var ret = cur%max;
		return (ret >= 0) ? ret : ret+max;
	}

	// disp�^�O�㏑���n���h��
	function disp(elm)
	{
//		var sx = str2num(elm.sx); // �������ʒu�␳�̓X�L�b�v
		var sy = str2num(elm.sy); // def=0(-imageLeft����Ȃ�) �ɒ���
//		if (elm.six !== void) {
//			var cursix = -imageLeft\width;
//			var idx = str2num(elm.six.replace(/six/, cursix));
//			sx = evalidx(idx, imageWidth\width) * width;
//		}
		if (elm.siy !== void) {
			var cursiy = -imageTop\height;
			var idx = str2num(elm.siy.replace(/siy/, cursiy));
			sy = evalidx(idx, imgeHeight\height) * height;
		}
		if (elm.index !== void) {
			var curidx = -imageTop\height;
			var idx = str2num(elm.index.replace(/index/, curidx));
			sy = evalidx(idx, imageHeight\height) * height;
		}
		setImagePos(imageLeft, -(sy));	// �������������͕ύX���Ȃ�
		return 0;
	}

	// �^�O�n���h���ǉ��Aloop
	function loop(elm)
	{
		// ���[�v���邱�Ƃ�錾����
		// �Z�O�����g�ɂ���Ă̓��[�v�����肵�Ȃ������肷�邽�߁B
		elm.context.looping = true;
		return 0;
	}

	// �^�O�n���h���ǉ��Anoloop�Floop�̔��΁B
	function noloop(elm)
	{
		// ���[�v���g��Ȃ����Ƃ�錾����
		// �Z�O�����g�ɂ���Ă̓��[�v�����肵�Ȃ������肷�邽�߁B
		elm.context.looping = false;
		return 0;
	}

	// �^�O�n���h���ǉ� wait
	function wait(elm)
	{
		return elm.time; // �w�莞�Ԃ�����~
	}

// ------ �������烍�[�h�E�Z�[�u ----------------------------------------

	// �Z�[�u���ɏォ��Ă΂��
	function store()
	{
		var dic = super.store();
		dic.conductor = conductor.store();
		KAnimButtonLayer_setOptions(dic, this);
		return dic;
	}

	// ���[�h���ɏォ��Ă΂��
	function restore(dic)
	{
		stopAnim();
		if (dic === void)
			return;
		super.restore(dic);	// ���̒��� setOptions(dic) �����s����
		// �ȉ��͋g���g���̃o�O���Ǝv�����ǁA����Ƃ��Ȃ���
		// �u�n�[�h�E�F�A�G���[���������܂����v�ɂȂ��Ă��܂��c�B
		if (dic.conductor.storageName != "")
			conductor.restore(dic.conductor);
		else {
			invalidate conductor;
			conductor = new AnimationConductor(this);
		}
		return dic;
	}
}


// �g�O���{�^�����C���[
// released/checked/checkedonmouse�̎O��Ԃ�\��
class KToggleButtonLayer extends KAnimButtonLayer
{
	var classid = "KToggleButtonLayer";

	var checked = false;	// �N���b�N����Ă��邩�ǂ���
	var oncheck;		// check ���ꂽ���ɌĂ΂�� TJS �֐�
	var checkse;		// check ���ꂽ���ɖ炷��
	var checksebuf = 0;	// �����ꂽ���ɖ炷���̃o�b�t�@
	var checkstorage;	// check ���ꂽ���ɌĂ΂�� KAG �X�g���[�W
	var checktarget;	// check ���ꂽ���ɌĂ΂�� KAG target
	var onuncheck;		// uncheck ���ꂽ���ɌĂ΂�� TJS �֐�
	var uncheckse;		// check ���ꂽ���ɖ炷��
	var unchecksebuf = 0;	// �����ꂽ���ɖ炷���̃o�b�t�@
	var uncheckstorage;	// uncheck �̎��ɌĂ΂�� KAG �X�g���[�W
	var unchecktarget;	// uncheck �̎��ɌĂ΂�� KAG target

	// �R���X�g���N�^
	function KToggleButtonLayer(window, parent, name, elm)
	{
		super.KAnimButtonLayer(window, parent, name);
		setOptions(elm);
	}

	// �f�X�g���N�^
	function finalize()
	{
		super.finalize();
	}

	// ���̃��C�����[�J���̃����o���R�s�[
	function KToggleButtonLayer_setOptions(dst, src)
	{
		var keyary = [
			"checked",
			"oncheck",
			"checkse",
			"checksebuf",
			"checkstorage",
			"checktarget",
			"onuncheck",
			"uncheckse",
			"unchecksebuf",
			"uncheckstorage",
			"unchecktarget"
		];
		selectcopy_dic(dst, src, keyary);
	}

	// �I�v�V�����ݒ�
	function setOptions(elm)
	{
		if (elm === void)
			return;
		// exp,storage,target��oncheck�ɑ΂�����̂Ȃ̂Őݒ�
		if (elm.exp !== void)
			elm.oncheck = elm.exp, delete elm.exp;
		if (elm.storage !== void)
			elm.checkstorage = elm.storage, delete elm.storage;
		if (elm.target !== void)
			elm.checktarget = elm.target, delete elm.target;
		if (elm.checked !== void && elm.checked != checked)
			onMouseDown(width\2, height\2, mbLeft, 0); //toggle����
		super.setOptions(elm);
		KToggleButtonLayer_setOptions(this, elm);
	}

	// �摜�ǂݍ���
	function loadImages(graphic, key)
	{
		if (graphic === void)
			return;
		super.loadImages(graphic, key);
	}

	// �`�F�b�N���ꂽ���ɌĂ΂���(makeCheck()�����˂�)
	function onCheck(x, y, button=mbLeft, shift=0)
	{
		if (checked)	// ������Ă����͉������Ȃ�
			return;
		checked = true;	// �����`�F�b�N���ɂ��ĂԂ̂Ńt���Oon�K�v
		draw();
		var e = addSndExp(oncheck, checkse, checksebuf);
		if (button == mbLeft && e !== void)
			eval(e);
		if (checkstorage !== void || checktarget !== void)
			window.process(checkstorage,checktarget,countpage);
		startAnim(, "*oncheck");
	}

	// �`�F�b�N���������ꂽ���ɌĂ΂��(makeCheck()�����˂�)
	function onUncheck(x, y, button=mbLeft, shift=0)
	{
		if (!checked)	// ������ĂȂ��������͉������Ȃ�
			return;
		checked = false;// �����`�F�b�N���ɂ��ĂԂ̂Ńt���Ooff�K�v
		draw();
		var e = addSndExp(onuncheck, uncheckse, unchecksebuf);
		if (button == mbLeft && e !== void)
			eval(e);
		if (uncheckstorage !== void || unchecktarget !== void)
			window.process(uncheckstorage,unchecktarget,countpage);
		startAnim(, (Butt_mouseOn) ? "*onuncheck" : "*onenter");
	}

	// �}�E�X�������ꂽ��
	function onMouseDown(x, y, button=mbLeft, shift=0)
	{
		if (button != mbLeft) {
			// ���N���b�N�ȊO�͖���
			super.onMouseDown(...);
			return;
		}

		if (checked)
			onUncheck(...); // �`�F�b�N���������ꂽ
		else
			onCheck(...);	// �`�F�b�N���ꂽ
	}

	// �}�E�X�������ꂽ��
	function onMouseUp(x, y, button=mbLeft, shift=0)
	{
		// �������Ȃ��悤 override
		// super.onMouseUp(...); �͕s�v�B�g�O�����Ȃ�����
	}

	// �}�E�X����������
	function onMouseEnter()
	{
		global.ButtonLayer.onMouseEnter(...);
		if (checked)
			startAnim(, "*onenter"); // �`�F�b�N���̂�*onenter�J�n
	}

	// �}�E�X���o����
	function onMouseLeave()
	{
		global.ButtonLayer.onMouseLeave(...);
		if (checked)
			startAnim(, "*oncheck");// �`�F�b�N���̂�*oncheck�J�n
	}

	// �`�悷��Ƃ�(onPaint()����Ă΂��)
	function draw()
	{
		// check ����Ă�� 1, check�łȂ���� 0
		if (checked)
			drawState(1);
		else if (Butt_mouseOn)
			drawState(2);
		else
			drawState(0);
	}

	// �{�^���̃R�s�[
	function assign(src, updateflg=true)
	{
		super.assign(src, false);
		KToggleButtonLayer_setOptions(this, src);
		update() if (updateflg);
	}

	// �Z�[�u���ɏォ��Ă΂��
	function store()
	{
		var dic = super.store();
		KToggleButtonLayer_setOptions(dic, this);
		return dic;
	}

	// ���[�h���ɏォ��Ă΂��
	function restore(dic)
	{
		if (dic === void)
			return;
		super.restore(dic);	// ���̒��� setOptions(dic) �����s����
		return dic;
	}
}


// �`�F�b�N�{�b�N�X�̓��ɓ\��togglebutton�A�e�ɃC�x���g�𑗂�悤������Ɖ���
class KCheckBoxTopLayer extends KToggleButtonLayer
{
	var classid = "KCheckBoxTopLayer";

	// �R���X�g���N�^
	function KCheckBoxTopLayer(window, parent, name, elm)
	{
		super.KToggleButtonLayer(window, parent, name);
		focusable = false;	// ����̓t�H�[�J�X����Ȃ�(�e�������)
		setOptions(elm);
	}

	// �f�X�g���N�^
	function finalize()
	{
		super.finalize();
	}

	// �C���[�W�ǂݍ���
	function loadImages(graphic, key)
	{
		super.loadImages(...);
		// �e�̃T�C�Y�������ɍ��킹��
		parent.setSize(width, height);
	}

	// �`�F�b�N���ꂽ���ɌĂ΂��(makeCheck()�����˂�)
	function onCheck(x, y, button=mbLeft, shift=0)
	{
		super.onCheck(...);
		parent.onCheck(...);	// �e���Ă�
	}

	// �`�F�b�N���������ꂽ���ɌĂ΂���(makeCheck()�����˂�)
	function onUncheck(x, y, button=mbLeft, shift=0)
	{
		super.onUncheck(...);
		parent.onUncheck(...);	// �e���Ă�
	}

	// �}�E�X�������ꂽ��
	function onMouseDown(x, y, button=mbLeft, shift=0)
	{
		if (button != mbLeft) {
			// ���N���b�N�ȊO�͖���
			super.onMouseDown(...);
			return;
		}

		if (typeof(parent.canMouseDown) != 'undefined')
			if (!parent.canMouseDown())
				return;
		super.onMouseDown(...);
		parent.onMouseDown(...);	// �e���Ă�
	}

	// �}�E�X�������ꂽ��
	function onMouseUp(x, y, button=mbLeft, shift=0)
	{
		super.onMouseUp(...);
		parent.onMouseUp(...);		// �e���Ă�
	}

	// �}�E�X����������
	function onMouseEnter()
	{
		super.onMouseEnter(...);
		parent.onMouseEnter(...);	// �e���Ă�
	}

	// �}�E�X���o����
	function onMouseLeave()
	{
		super.onMouseLeave(...);
		parent.onMouseLeave(...);	// �e���Ă�
	}
}		


// �`�F�b�N�{�b�N�X���C���[(���Ԃ�ToggleButton + �w�i)
class KCheckBoxLayer extends KAnimButtonLayer
{
	var classid    = "KCheckBoxLayer";	// �萔
	var toggle;		// �g�O���{�^�����C��

	// �R���X�g���N�^
	function KCheckBoxLayer(window, parent, name, elm)
	{
		super.KAnimButtonLayer(window, parent, name);
		toggle = new KCheckBoxTopLayer(window, this);
		setOptions(elm); // �g�O���Ǝ��g��ݒ肷�邽�߂ɕʂŌĂ�
	}

	// �f�X�g���N�^
	function finalize()
	{
		invalidate toggle;
		super.finalize();
	}

	// �I�v�V�����ݒ�@�����ł͂܂� toggle ����`����Ă��Ȃ����Ƃ�����
	function setOptions(elm)
	{
		if (elm === void)
			return;

		if (elm.toggle !== void) {
			// toggle ���ݒ肳��Ă���Βl��ݒ肷��(restore��)
			super.setOptions(elm);
			toggle.setOptions(elm.toggle);
		} else {
			// �ʏ�� setOptions() ��
			var e = %[
				left:elm.left, top:elm.top,
				width:elm.basewidth, height:elm.baseheight,
				graphic:elm.basegraphic, color:elm.basecolor
			];
			if (elm.basewidth === void && elm.width !== void)
				e.width = elm.width;
			if (elm.baseheight === void && elm.height !== void)
				e.height = elm.height;
			super.setOptions(e);
			(Dictionary.assign incontextof e)(elm);
			delete e.left;	// X/Y���W��0,0�Œ�Ȃ̂ō폜
			delete e.top;
			toggle.setOptions(e);
		}
	}

	// check ���ꂽ�Ƃ�
	function onCheck(x, y, button, shift)
	{
		// KRadioButtonLayer �̂��߂ɁA�Ȃɂ����Ȃ�����`�������Ƃ�
	}

	// uncheck ���ꂽ�Ƃ�
	function onUncheck(x, y, button, shift)
	{
		// onCheck()�Ɠ������R
	}

	// ����{�^���������I�ɉ���
	function makeCheck(x, y, button=mbLeft, shift=0)
	{
		if (!toggle.checked)
			toggle.onCheck(...);
	}

	// ����{�^���������I�ɗ���
	function makeUncheck(x, y, button=mbLeft, shift=0)
	{
		if (toggle.checked)
			toggle.onUncheck(...);
	}

	// �}�E�X�������ꂽ��
	function onMouseDown(x, y, button, shift)
	{
		super.onMouseDown(...);
		if (button != mbLeft) {
			// ���N���b�N�ȊO�͖���
			return;
		}

		// onCheck()�ŃN���b�N�����̂ŁA�}�E�X���o�Ă���off��
		if ((cursorX < 0 || width <= cursorX) ||
		    (cursorY < 0 || height <= cursorY))
			onMouseLeave();
	}

	// update ����Ƃ��ɁAbase/toggle�� update����B
	function update()
	{
		toggle.update();
		super.update();
	}

	// �{�^���̃R�s�[
	function assign(src, updateflg=true)
	{
		super.assign(src, false);
		toggle.assign(src.toggle, false);

		update() if (updateflg);
	}

	// �Z�[�u���ɏォ��Ă΂��
	function store()
	{
		var dic = super.store();
		dic.toggle = toggle.store();
		return dic;
	}

	// ���[�h���ɏォ��Ă΂��
	function restore(dic)
	{
		if (dic === void)
			return;
		super.restore(dic); // ���̒��� setOptions(dic) �����s����
		return dic;
	}

	property checked {
		getter() {
			return toggle.checked;
		}
		setter(x) {
			if (x)
				toggle.onCheck();
			else
				toggle.onUncheck();
		}
	}
}


// �X���C�_�[���C���Ŏg���^�u�{�^�����C���[
// �X���C�_�[�̈ꕔ�Ȃ̂ŁA�e����pos/size���ύX����邱�Ƃɒ���
class KSliderTabLayer extends KAnimButtonLayer
{
	var classid = "KSliderTabLayer";

	var dragging = false;	// �h���b�O���t���O
	var clickx=0, clicky=0;	// �N���b�N���ꂽ���̍��W�ۑ��p

	// �R���X�g���N�^
	function KSliderTabLayer(window, parent, elm)
	{
		super.KAnimButtonLayer(window, parent);
		if (elm!==void && elm.graphic === void && elm.color === void) {
			elm = %[] if (elm === void);
			elm.color = 0x80ffffff;
		}
		setOptions(elm);
	}

	// �f�X�g���N�^
	function finalize()
	{
		super.finalize();
	}

	// �}�E�X�������ꂽ��
	function onMouseDown(x, y, button, shift)
	{
		if (button != mbLeft) {
			// ���N���b�N�ȊO�͖���
			super.onMouseDown(...);
			return;
		}

		super.onMouseDown(...);
		if (!enabled || button != mbLeft)
			dragging = false;
		else {
			dragging = true;
			clickx = x;
			clicky = y;
		}
	}

	// �}�E�X�������ꂽ��
	function onMouseUp(x, y, button, shift)
	{
		super.onMouseUp(...);
		dragging = false;
	}

	// �}�E�X���������ꂽ��
	function onMouseMove(x, y, shift)
	{
		super.onMouseMove(...);
		if (!dragging)
			return;	// drag���łȂ���ΏI��
		// �X���C�_���h���b�O���ꂽ���͐e��onSliderDragged()���Ă�
		parent.onSliderDragged(x, y, clickx, clicky);
	}

	// �L�[�������ꂽ��
	function onKeyDown(key, shift, process)
	{
		parent.onKeyDown(...);	// �e���Ă�
	}

	// �{�^���̃R�s�[
	function assign(src, updateflg=true)
	{
		super.assign(src, false);
		dragging = src.dragging;
		clickx = src.clickx;
		clicky = src.clicky;

		update() if (updateflg);
	}

	// �Z�[�u���ɏォ��Ă΂��(�X�[�p�[�N���X�Ɠ����Ȃ̂ŕs�v)
//	function store()

	// ���[�h���ɏォ��Ă΂��
	function restore(dic)
	{
		if (dic === void)
			return;
		super.restore(dic);	// ���̒��� setOptions(dic) �����s����
		dragging = false;
		clickx = clicky = 0;
		return dic;
	}
}


// �X���C�_�[(�c�������Ƃ��h���b�O�\)�AKClickableLayer�̔h���ɂ�����
class KSliderLayer extends KLayer
{
	var classid = "KSliderLayer";	// �萔
	var vval = 0.0;		// �c�̌��ݒl(0�`1.0)
	var hval = 0.0;		// ���̌��ݒl(0�`1.0)
	var vstep = 0;		// �c�̍��ݕ�(0�Ŗ��i�K)
	var hstep = 0;		// ���̍��ݕ�(0�Ŗ��i�K)
	var tab;		// �X���C�_�[�̃^�u�������C��
	var timer;		// �X���C�_�[�^�u�O�����������̃��s�[�g�^�C�}
	var hdst, vdst;		// �^�u�O�N���b�N���̎����ړ����̖ڕW�ꏊ

	var onchange;		// �ύX���ꂽ���Ɏ��s����TJS�X�N���v�g
	var onchangefunc;	// �ύX���ꂽ���Ɏ��s����TJS�X�N���v�g(�֐�)
	var onchangestorage;	// �ύX���ꂽ���Ɏ��s����KAG�X�g���[�W
	var onchangetarget;	// �ύX���ꂽ���Ɏ��s����KAG���x��

	// �R���X�g���N�^
	function KSliderLayer(window, parent, i_name, elm)
	{
		super.KLayer(window, parent, i_name); // �܂�elm�͐ݒ肵�Ȃ�
		tab = new KSliderTabLayer(window, this);

		hitThreshold = 0;	// ��������

		timer = new Timer(this, "onMouseDownRepeat");
		timer.interval = 100;
		timer.enabled = false;		// �ŏ��� false��

		if (elm!==void && elm.width !== void && elm.height !== void) {
			// ��������������TAB�����킹�A�c�E���X���C�_�[�Ƃ���
			if (elm.tabwidth === void && elm.width < elm.height) {
				elm = %[] if (elm === void);
				elm.tabwidth = elm.width;
			}
			if (elm.tabheight === void && elm.width > elm.height) {
				elm = %[] if (elm === void);
				elm.tabheight = elm.height;
			}
		}
		setOptions(elm);// updateState() �͂��̒��Ŏ��s�����̂ŕs�v
	}

	// �f�X�g���N�^
	function finalize()
	{
		timer.enabled = false;
		invalidate tab;
		invalidate timer;
		super.finalize(...);
	}

	// ���̃��C�����[�J���̃����o���R�s�[
	function KSliderLayer_setOptions(dst, src)
	{
		var keyary = [
			"vval",
			"hval",
			"vstep",
			"hstep",
		//	"tab",
		//	"timer",
			"hdst", "vdst",
			"onchange",
			"onchangefunc",
			"onchangestorage",
			"onchangetarget"
		];
		selectcopy_dic(dst, src, keyary);
		if (typeof(src.timer) != 'undefined') {
			// Timer�ɂ�assign������
			if (typeof(dst.timer) == 'undefined')
				dst.timer = %[];
			dst.timer.interval = src.timer.interval;
			dst.timer.enabled = src.timer.enabled;
		}
	}

	// �I�v�V�����ݒ�
	function setOptions(elm)
	{
		if (elm === void)
			return;
		if (elm.basegraphic !== void)
			elm.graphic = elm.basegraphic;
		if (elm.basecolor !== void)
			elm.color = elm.basecolor;

		// �ȑO�Ɠ����l��ݒ肷��ꍇ�͖���������BupdateState()��
		// onchange/onchangefunc�̖������[�v��h������
		if (elm.hval !== void && elm.hval == hval)
			delete elm.hval;
		if (elm.vval !== void && elm.vval == vval)
			delete elm.vval;
// �u�ȑO�Ɠ����l�̎��̓X�L�b�v����d�g�݁v�́A�������̂��߂ɂ��K�v�B
// ��ɑS�N���X�ɃC���v�����邱�ƁBsetOptions_sub()�̂悤�Ȋ֐��ɂ��Ă��悢�B

		super.setOptions(elm);
		KSliderLayer_setOptions(this, elm);
//		if (elm.graphic !== void) �摜�� super.setOptions ���œǂ�
//			loadImages(elm.graphic);
		if (tab !== void) {
			// ���̓^�u�ւ͈ȉ��̍��ڂ̂ݎw��\�Bstore()�ɒ���
			var tabelm = %[ graphic:elm.tabgraphic,
					caption:elm.tabcaption,
					color:elm.tabcolor,
					width:elm.tabwidth,
					height:elm.tabheight ];
			tab.setOptions(tabelm);
			if (elm.width !== void || elm.height !== void || 
			    elm.hstep !== void || elm.vstep !== void || 
			    elm.hval !== void || elm.vval !== void)
				updateState();	// �X���C�_�[�ʒu�X�V
////			update();	// �X���C�_�[��back�`��
		}
	}

	// ��ԍX�V�A���݂̒l�ŃX���C�_�[�ʒu���X�V����B
	function updateState()
	{
		// step ���w�肳��Ă�����l�𐳋K������
		if (hstep != 0.0)
			hval = int((hval+hstep/2)/hstep)*hstep;
		if (vstep != 0.0)
			vval = int((vval+vstep/2)/vstep)*vstep;
		hval = (hval < 0.0) ? 0.0 : (1.0 < hval) ? 1.0 : hval;
		vval = (vval < 0.0) ? 0.0 : (1.0 < vval) ? 1.0 : vval;
		// ���݂̒l�ɂ��킹��tab�̈ʒu���ړ�����
		tab.setPos((width-tab.width)*hval,
			   (height-tab.height)*(1-vval));
		if (onchangefunc !== void)
			eval(
				onchangefunc+"(("+hval+"), ("+vval+"), ("+tab.dragging+"))"
				// onchangefunc(hval, vval, dragging) �����s
			);
		if (onchangestorage !== void || onchangetarget !== void) {
			// tf.xxxx��ݒ肵�āAonchnagestorage��onchangetarget���Ă�
			tf.hval = hval, tf.vval = vval, tf.dragging = tab.dragging;
			window.process(onchangestorage, onchangetarget, countpage);
		}
	}

	// �X���C�_�[�^�u���h���b�O���ꂽ��(�X���C�_�[�^�u�N���X����Ă΂��)
	function onSliderDragged(x, y, clickx, clicky)
	{
		// ���݂̕\�����ׂ��ʒu�Ɉړ�
		// �X�e�b�v��updateState()�ōl����̂ł����ł͍l���Ȃ�
		hval = (tab.left+(x-clickx))/(width -tab.width);
		vval = 1-(tab.top +(y-clicky))/(height-tab.height);
		updateState();
	}

	// �w��J�E���g�������ړ�
	function moveStep(hcount=0, vcount=0)
	{
		// �ړ���(Xstep)�� 0 �̎��́A0.05 ���݂ňړ�����
		hval += ((hstep == 0.0) ? 0.05 : hstep) * hcount;
		vval += ((vstep == 0.0) ? 0.05 : vstep) * vcount;
		updateState();
	}

	// �X���C�_�������ꂽ���̃��s�[�g�֐�
	function onMouseDownRepeat()
	{
		// ��������tab�̈�ɓ����Ă��Ȃ����tab���ړ�
		if (hdst < tab.left)
			moveStep(-1, 0);
		else if (hdst > tab.left + tab.width)
			moveStep(1, 0);
		// �c������tab�̈�ɓ����Ă��Ȃ����tab���ړ�
		if (vdst < tab.top)
			moveStep(0, 1);
		else if (vdst > tab.top + tab.height)
			moveStep(0, -1);
		// �̈�ɓ������� timer ���~
		if (tab.left <= hdst && hdst <= tab.left + tab.width &&
		    tab.top  <= vdst && vdst <= tab.top  + tab.height)
			timer.enabled = false;
	}

	// �X�N���[���o�[�̃X���C�_�O�����������̃��s�[�g����J�n
	function scrollTo(x, y)
	{
		hdst = x, vdst = y;
		timer.enabled = true;
	}

	// �}�E�X�������ꂽ��(���̎��͕K���X���C�_�[�^�u�O��������Ă���)
	function onMouseDown(x, y, button, shift)
	{
		if (button != mbLeft) {
			// ���N���b�N�ȊO�͖���
			super.onMouseDown(...);
			return;
		}

		scrollTo(x, y);
	}

	// �}�E�X���������ꂽ��
	function onMouseMove(x, y, shift)
	{
		super.onMouseMove(...);
		if (timer.enabled)
			hdst = x, vdst = y;
	}

	// �}�E�X�������ꂽ��
	function onMouseUp(x, y, button, shift)
	{
		super.onMouseUp(...);
		timer.enabled = false;
	}

	// �L�[�������ꂽ��(�L�[�ŃX���C�_�[����͖�����)
	function onKeyDown(key, shift, process)
	{
		if (process) {
			if (key == VK_LEFT) {
				moveStep(-1, 0);
				return;
			} else if (key == VK_RIGHT) {
				moveStep(1, 0);
				return;
			} else if (key == VK_UP) {
				moveStep(0, 1);
				return;
			} else if (key == VK_DOWN) {
				moveStep(0, -1);
				return;
			}
		}
		parent.onKeyDown(...);
	}

	// �\�������Ƃ�
	function onPaint()
	{
		if (graphic === void) {
			fillRect(0,0,width,height, color);
			if (tab !== void && width == tab.width) {
				// �c�X���C�_�[������
				var w = width/2;
				var k = tab.height;
				fillRect(w,   k/2, 1, height-k, 0x80000000);
				fillRect(w+1, k/2, 1, height-k, 0x80ffffff);

			} else if (tab !== void && height == tab.height) {
				// ���X���C�_�[������
				var h = height/2;
				var k = tab.width/2;
				fillRect(k/2, h,   width-k, 1, 0x80000000);
				fillRect(k/2, h+1, width-k, 1, 0x80ffffff);
			}
		}
		super.onPaint(...);
	}

	// �{�^���̃R�s�[
	function assign(src, updateflg=true)
	{
		super.assign(src, false);
		KSliderLayer_setOptions(this, src);
		tab.assign(src.tab);
		update() if (updateflg);
	}

	// �Z�[�u���ɏォ��Ă΂��
	function store()
	{
		var dic = super.store();
		KSliderLayer_setOptions(dic, this);
		dic.tab = tab.store();	// dic.tab.*�ɃZ�[�u�Adic.tab*�͎g���
		return dic;
	}

	// ���[�h���ɏォ��Ă΂��
	function restore(dic)
	{
		timer.enabled = false;		// �^�C�}���~�߂�
		if (dic === void)
			return;
		super.restore(dic);	// ���̒��� setOptions(dic) �����s����
		tab.restore(dic.tab);
		timer.enabled = false;		// �^�C�}���~�߂�
		return dic;
	}
}


// RadioButton�̈�A�C�e���B��x�������Ă��g�O�����Ȃ��Ƃ��낪�قȂ�B
class KRadioButtonItem extends KCheckBoxLayer
{
	var classid  = 'KRadioButtonItem';

	// �R���X�g���N�^
	function KRadioButtonItem(window, parent, name, elm)
	{
		super.KCheckBoxLayer(...);
	}

	// �f�X�g���N�^
	function finalize()
	{
		super.finalize();
	}

	// �}�E�X���������Ƃ��\���ǂ���
	function canMouseDown(x, y, button=mbLeft, shift=0)
	{
		return !toggle.checked;	// ��x������h���׍H
	}

	// �}�E�X�������ꂽ��
	function onMouseDown(x, y, button=mbLeft, shift=0)
	{
		if (button != mbLeft) {
			// ���N���b�N�ȊO�͖���
			super.onMouseDown(...);
			return;
		}

		super.onMouseDown(...);
		parent.onMouseDown(...);	// �e���Ă�
	}

	// check ���ꂽ�Ƃ�
	function onCheck(x, y, button, shift)
	{
		super.onCheck(...);
		// �e(KRadioButtonLayer) �� onCheck()���ĂԂ悤�ɂ���
		parent.onCheck(x, y, button, shift, this);
	}

	// uncheck ���ꂽ�Ƃ�
	function onUncheck(x, y, button, shift)
	{
		super.onUncheck(...);
		// KRadioButton �� onUncheck()���ĂԂ悤�ɂ���
		parent.onUncheck(x, y, button, shift, this);
	}
}


// KRadioButtonItem �𕡐��z�u���郉�W�I�{�^��
// onCheck()/onUncheck()�́A���̃N���X�̂ł͂Ȃ��Ă��̎q�̂��ĂԂ��ƁB
class KRadioButtonLayer extends KLayer
{
	var classid     = 'KRadioButtonLayer';

	var disttype    = 'holizontal'; // holizontal(����) or vertical(����)
	var space       = 10;		// �{�^���̊Ԃ̋���
	var buttonleft  = 0;		// ���{�^���̍���X���W
	var buttontop   = 0;		// ���{�^���̍���Y���W
	var pushed      = -1;		// ������Ă���{�^��(������Ԃł�-1)
	var buttons     = [];		// RadioButtonItem(�{�^��)�z��
	var buttonopts  = %[];		// �{�^���̃I�v�V����
	var ibuttonopts = [];		// �{�^���ʂ̃I�v�V����
	var oncheck;			// �����ꂽ���̓���
	var oncheckfunc;		// �����ꂽ���̓���(�֐�)
	var onuncheck;			// �����ꂽ���̓���
	var onuncheckfunc;		// �����ꂽ���̓���(�֐�)

	// �R���X�g���N�^
	function KRadioButtonLayer(window, parent, i_name, elm=%[])
	{
		super.KLayer(window, parent);
		focusable = false;	// ���̃��C���̓t�H�[�J�X�����Ȃ�
		if (elm.pushed === void)
			elm.pushed = 0;	// �ŏ��̈��͕K��pushed=0���w��
		setOptions(elm);
	}

	// �f�X�g���N�^
	function finalize()
	{
		super.finalize();
	}

	// �{�^���ɃI�v�V�����ݒ�
	function setOptions_button(elm=%[], ielm=[])
	{
		// �{�^���I�v�V�������w�肳��Ă�����ݒ�
		for (var i = buttons.count-1; i >= 0; i--) {
			buttons[i].setOptions(elm);
			if (i < ielm.count) {
				buttons[i].setOptions(ielm[i]);
				marge_dic(ibuttonopts[i], ielm[i]);
			}
		}
		// �����̂��̂��㏑��(�{���͉��ŏ����Ă邩��s�v�����O�̂���)
		marge_dic(buttonopts, elm);
	}

	// ���̃��C�����[�J���̃����o���R�s�[
	function KRadioButtonLayer_setOptions(dst, src)
	{
		var keyary = [
			"disttype",
			"space",
			"buttonleft",
			"buttontop",
			"pushed",
			// "buttons"     = [];	// RadioButtonItem(�{�^��)�z��
			// "buttonopts"  = %[];	// �{�^���̃I�v�V����
			// "ibuttonopts" = [];	// �{�^���ʂ̃I�v�V����
			"oncheck",
			"oncheckfunc",
			"onuncheck",
			"onuncheckfunc"
		];
		selectcopy_dic(dst, src, keyary);
	}

	// �I�v�V�����ݒ�
	function setOptions(elm)
	{
		if (elm === void)
			return;
		// �ŏ��� elm.pushed ��ۑ�
		var new_pushed = elm.pushed;
		delete elm.pushed;
		super.setOptions(elm);
		KRadioButtonLayer_setOptions(this, elm);
		changeButtonNum(elm.buttonnum);
		if (buttons.count == 0)
			return;
		setOptions_button(elm.buttonopts, elm.ibuttonopts);
		if (elm.disttype !== void || elm.space !== void)
			alignButtons(); // �z�u�ύX
		// elm.pushed ���w�肳��Ă�����A�{�^��������
		if (new_pushed !== void)
			makeCheck(new_pushed);
	}

	// �{�^���z�u���X�V����
	function alignButtons()
	{
		if (buttons.count <= 0)
			return;
		var pos = 0, max = 0;
		if (disttype == 'vertical') {
			// �c�z�u����
			for (var i = 0 ; i < buttons.count; i++) {
				buttons[i].setPos(buttonleft, buttontop+pos);
				pos += buttons[i].height + space;
				if (max < buttons[i].width)
					max = buttons[i].width;
			}
			setSize(max, pos-space); // �摜�T�C�Y�͕ύX���Ȃ�
		} else {
			// ���z�u����
			for (var i = 0; i < buttons.count; i++) {
				buttons[i].setPos(buttonleft+pos, buttontop);
				pos += buttons[i].width + space;
				if (max < buttons[i].height)
					max = buttons[i].height;
			}
			setSize(pos-space, max); // �摜�T�C�Y�͕ύX���Ȃ�
		}
	}

	// �{�^������ύX����
	function changeButtonNum(num)
	{
		if (num == buttons.count)
			return;
		if (num < buttons.count) {
			// ������w�肪���Ȃ������炢�����폜
			// �z�񖖔�����폜����
			for (var i = buttons.count-1; i >= num; i--) {
				invalidate buttons.pop();
				invalidate ibuttonopts.pop();
			}
		} else {
			// ������w�肪����������ǉ��쐬
			// �z�񖖔��ɒǉ�����
			var b = buttons;
			for (var i = b.count; i < num; i++) {
				b.push(new KRadioButtonItem(window, this));
				b[i].setOptions(buttonopts);
				ibuttonopts.push(%[]);
			}
		}
		alignButtons();
	}

	// �{�^���̂����ꂩ�������ꂽ���̓���(�q���C������Ă΂��)
	function onCheck(x, y, button=mbLeft, shift=0, btnobj)
	{
		var index = buttons.find(btnobj);
		if (pushed == index)
			return;			// ��x�����Ȃ牽�����Ȃ�
		if (pushed >= 0)
			makeUncheck(pushed);	// �ȑO�̃{�^��������
		pushed = index;

		// oncheck �����s
		if (oncheck !== void)
			eval(oncheck);
		// oncheckfunc �Ŏw�肳�ꂽ�֐��� index�������u�����ČĂ�
		// �֐�����index�Ƃ��������񂪖������Ƃ��O��B�댯�B
		if (oncheckfunc !== void) {
			var funcstr = oncheckfunc;
			eval(funcstr.replace(/index/, index));
		}
	}

	// �{�^���̂����ꂩ�������ꂽ���̓���(�q���C������Ă΂��)
	function onUncheck(x, y, button=mbLeft, shift=0, btnobj)
	{
		var index = buttons.find(btnobj);
		// onuncheck �����s
		if (onuncheck !== void)
			eval(onuncheck);
		// onuncheckfunc�Ŏw�肳�ꂽ�֐��� btnidx�������u�����ČĂ�
		// �֐�����index�Ƃ��������񂪖������Ƃ��O��B�댯�B
		if (onuncheckfunc !== void) {
			var funcstr = onuncheckfunc;
			eval(funcstr.replace(/index/, index));
		}
	}

	// ����{�^��������(�����ł͑��̃{�^���̃g�O������͂��Ȃ����Ƃɒ���)
	// ������Ɖ���� onCheck() �Ńg�O�������̂ŁB
	function makeCheck(index)
	{
		buttons[index].makeCheck(buttons[index].cursorX,
				         buttons[index].cursorY, mbLeft, 0);
	}

	// ����{�^���𗣂�(���̃{�^���̃g�O������͂��Ȃ����Ƃɒ���)
	function makeUncheck(index)
	{
		buttons[index].makeUncheck();
	}

	// �{�^���̃R�s�[
	function assign(src, updateflg=true)
	{
		super.assign(src, false);
		KRadioButtonLayer_setOptions(this, src);
		(Dictionary.assignStruct incontextof buttonopts)(src.buttonopts);
		ibuttonopts.assignStruct(src.ibuttonopts);
		changeButtonNum(src.buttons.count);
		for (var i = 0; i < src.buttons.count; i++)
			buttons[i].assign(src.buttons[i], false);

		update() if (updateflg);
	}

	// �Z�[�u���ɏォ��Ă΂��
	function store()
	{
		var dic = super.store();
		KRadioButtonLayer_setOptions(dic, this);
		dic.buttonopts = %[];
		(Dictionary.assign incontextof dic.buttonopts)(buttonopts);
		dic.buttons = [];
		dic.ibuttonopts = [];
		dic.ibuttonotps.assignStruct(ibuttonopts);
// ����� restore ���� setOptions �Őݒ肳���̂��l����ƂȂ������悢
//		for (var i = 0; i < buttons.count; i++)
//			dic.buttons[i] = buttons[i].store();
		dic.buttonnum     = buttons.count;	// restore()�Ŏg��
		return dic;
	}

	// ���[�h���ɏォ��Ă΂��
	function restore(dic)
	{
		if (dic === void)
			return;
// ���ꂾ�Ɖ�����Ă��{�^�����L�����Z������Ȃ���������Ȃ������
		pushed = -1;		// ��� pushed ��ʃ{�^���ɂ��Ă���
		super.restore(dic);	// ���̒��� setOptions(dic) �����s����
		return dic;
	}
}


// ���̃��C���ȉ��̎w��̖��O�������C���[��T��
function findLayer_sub(name, baselayer=kag.fore.base, findonlyone=false)
{
	var ret = [];
	if (name === void || baselayer.name == name) {
		// �L���X�g���Ȃ��Ă��A�����ƓK���ȃN���X�̃C���X�^���X��
		// ���Ĕz��ɑ������邱�Ƃ��m�F�ς�
		ret.add(baselayer);
	}
	for (var i = baselayer.children.count-1; i >= 0; i--) {
		var ary = findLayer_sub(name, baselayer.children[i]);
		for (var j = ary.count-1; i>= 0; i--) {
			// findonlyone�ł����Ă��A������ary�ŕԂ�
			var ary = findLayer_sub(name, baselayer.children[i]);
			add_ary(ret, ary);
		}
	}
	if (findonlyone)
		return (ret.count <= 0) ? void : ret[0];
	else
		return ret;
}


// ���̃��C���ȉ��̎w��̖��O�������C���[��T��(�ŏ��̈����)
function findLayer(name, baselayer=kag.fore.base)
{
	return findLayer_sub(name, baselayer, true);
}


// ���̃��C���ȉ��̎w��̖��O�������C���[��T��(�z��ŕԂ�)
function findLayers(name, baselayer=kag.fore.base)
{
	return findLayer_sub(name, baselayer);
}


// �����z��ɏ]���Ĉ���C���[���쐬����
function createLayer(dic, parent=kag.fore.base)
{
	var elm = %[];
	(Dictionary.assign incontextof elm)(dic);
	var classid = elm.classid;
	delete elm.classid;
	if (elm.parent !== void)
		parent = findLayer(elm.parent, parent);
	if (parent === void)
		em('Error: createLayer(): elm.parent = ' + elm.parent);
	delete elm.parent;
	return new (global[classid])(kag, parent, elm.name, elm);
}


// �����z��̔z��ɏ]���āA�����̃��C������C�ɍ쐬����
function createLayers(ary, parent=kag.fore.base)
{
	var ret = [];
	// �~���ɂ��������Afocus�������ɐݒ肳���B�Ȃ�ł�̂�B
	for (var i = ary.count-1; i >= 0; i--)
		ret[i] = createLayer(ary[i], parent);
	// �z��ŕԂ��Ȃ��ƁA�Q�Ƃ��ĂȂ��Ƃ���TJS���J�������Ⴄ�̂�ret�K�{
	return ret;
}



// ������ނ�KLayers����ʏ�ɔz�u���邱�Ƃ��ł��郉�b�p�[�v���O�C��
// SystemButton��rclick��ʂȂǂŎg�p����B
class KLayersPlugin extends KAGPlugin
{
	var window;		// �e�E�C���h�E
	var name;		// ���O�B�Z�[�u�̎��Ɏg���̂ŕK�{
	var foreparent;		// �\��ʂ̐e
	var backparent;		// ����ʂ̐e
	var foreary = [];	// �\��ʂ̎q�N���X�z��
	var backary = [];	// ����ʂ̎q�N���X�z��

	// �R���X�g���N�^
	function KLayersPlugin(w, i_name, fp=w.fore.base, bp=w.back.base)
	{
		super.KAGPlugin(...);
		window     = w;
		name       = i_name;
		foreparent = fp;
		backparent = bp;
	}

	// �f�X�g���N�^
	function finalize()
	{
		delOnPage('both');
		super.finalize(...);
	}

	// ����y�[�W�̎qLayer��S�č폜
	function delOnPage(page='fore')
	{
		//�t�H�[�J�X�������Ȃ��悤�ɕύX
		window.focusedLayer = null;
		if(page == 'both' || page == 'fore')
			for(var i = foreary.count-1; i >= 0; i--)
				invalidate(foreary.pop());
		if(page == 'both' || page == 'back')
			for(var i = backary.count-1; i >= 0; i--)
				invalidate(backary.pop());
	}

	// �w��name�̎qLayer���폜
	function del(name, page='fore')
	{
		//�t�H�[�J�X�������Ȃ��悤�ɕύX
		window.focusedLayer = null;
		if(name === void) {
			delOnPage(page);
			return;
		}
		if(page == 'both' || page == 'fore')
			for(var i = foreary.count-1; i >= 0; i--)
				if(foreary[i].name == name) {
					invalidate(foreary[i]);
					foreary.erase(i);
				}
		if(page == 'both' || page == 'back')
			for(var i = backary.count-1; i >= 0; i--)
				if(backary[i].name == name) {
					invalidate(backary[i]);
					backary.erase(i);
				}
	}

	// �qLayer����ǉ�
	function add(name='noname', classobj, page='fore', elm)
	{
		var obj;
		if (page == 'fore' || page == 'both') {
			obj = new classobj(window, foreparent, name, elm);
			foreary.add(obj);
		}
		if (page == 'back' || page == 'both') {
			obj = new classobj(window, backparent, name, elm);
			backary.add(obj);
		}
	}

	// name��page�ɑΉ�����q���C����T��
	function search(name, page='fore')
	{
		var retary = [];
		if(page == 'both' || page == 'fore') {
			for(var i = foreary.count-1; i >= 0; i--)
				if(name === void || foreary[i].name == name)
					retary.add(foreary[i]);
		}
		if(page == 'both' || page == 'back') {
			for(var i = backary.count-1; i >= 0; i--)
				if(name === void || backary[i].name == name)
					retary.add(backary[i]);
		}
		return retary;
	}

	// name��page�ɑΉ�����q���C����T��(�������)
	function search_one(name, page='fore')
	{
		var retary = search(name, page);
		if (retary.count == 0)
			return void;
		if (retary.count == 1)
			return retary[0];
		em("search_one()�őΏۃ��C����������������܂����B"+
			"�Ƃ肠���� void ��Ԃ��܂��B"+
			"search_one("+name+", "+page+")");
		return void;
	}

	// �I�v�V�����w��
	function setOptions(name, page='fore', elm)
	{
		var focused = -1;
		// �}�E�X���ړ������Ȃ����߂ɁA�t�H�[�J�X���C�����Ō��
		// �ύX���邽�߂̍׍H
		// ary���Ƀt�H�[�J�X���ꂽ���C�������݂��Ȃ��ꍇ������̂ŁA
		// window.focusedLayer�͎g�p�ł��Ȃ�
		//
		// �c����A0.98b��KLayer��onSearchNextFocusable()�ǉ���������A
		// �K�v�Ȃ��Ȃ����񂶂�Ȃ����낤���c�B
		var ary = search(name, page);
		for (var i = ary.count-1; i >= 0; i--) {
			if (ary[i].focused)
				focused = i;
			else
				ary[i].setOptions(elm);
		}
		if (focused >= 0)
			ary[focused].setOptions(elm);
	}

	// ���C���̕\�������̏��̃R�s�[
	// backlay �^�O��g�����W�V�����̏I�����ɌĂ΂��
	function onCopyLayer(toback)
	{
		if (toback) {
			// �\����
			delOnPage('back');
			for(var i = foreary.count-1; i >= 0 ; i--) {
				var classobj = global[foreary[i].classid];
				backary[i] = new classobj(window,
					backparent, foreary[i].name);
				backary[i].assign(foreary[i]);
			}
		} else {
			// �����\
			delOnPage('fore');
			for(var i = backary.count-1; i >= 0 ; i--) {
				var classobj = global[backary[i].classid];
				foreary[i] = new classobj(window,
					foreparent, backary[i].name);
				foreary[i].assign(backary[i]);
			}
		}
	}

	// ���ƕ\�̊Ǘ���������
	function onExchangeForeBack()
	{
		// children = true �̃g�����W�V�����ł́A�g�����W�V�����I������
		// �\��ʂƗ���ʂ̃��C���\���������������ւ��̂ŁA
		// ����܂� �\��ʂ��Ǝv���Ă������̂�����ʂɁA����ʂ��Ǝv����
		// �������̂��\��ʂɂȂ��Ă��܂��B�����̃^�C�~���O�ł��̏���
		// ����ւ���΁A�����͐����Ȃ��B
		var ary = [];
		ary.assign(foreary);
		foreary.assign(backary);
		backary.assign(ary);

		var tmp = foreparent;
		foreparent = backparent;
		backparent = tmp;
	}

	// �Z�[�u
	function onStore(f, elm)
	{
		// �x��ۑ�����Ƃ�
		var dic = f["klayersplugin_" + name] = %[];
		dic.foreary = [];
		dic.backary = [];
		for(var i = 0; i < foreary.count; i++)
			dic.foreary.add(foreary[i].store());
		for(var i = 0; i < backary.count; i++)
			dic.backary.add(backary[i].store());
		return dic;	// �q�N���X�̂��߂ɕԂ�
	}

	// ���[�h
	function onRestore(f, clear, elm)
	{
		// �x��ǂݏo���Ƃ�
		delOnPage('both');
		var dic = f["klayersplugin_" + name];
		if(dic === void)
			return;
		// �ǂݍ��񂾂��̂�߂�
		if (elm !== void && elm.backlay) {
			// [tempload backlay=true]�Ȃ�
			for(var i = 0; i < dic.foreary.count; i++) {
				var classobj = global[dic.foreary[i].classid];
				backary[i] = new classobj(window, backparent);
				backary[i].restore(dic.foreary[i]);
			}
		} else {
			// �ʏ펞�̓ǂݍ���
			for(var i = 0; i < dic.foreary.count; i++) {
				var classobj = global[dic.foreary[i].classid];
				foreary[i] = new classobj(window, foreparent);
				foreary[i].restore(dic.foreary[i]);
			}
			for(var i = 0; i < dic.backary.count; i++) {
				var classobj = global[dic.backary[i].classid];
				backary[i] = new classobj(window, backparent);
				backary[i].restore(dic.backary[i]);
			}
		}
		return dic;	// �q�N���X�̂��߂ɕԂ�
	}
}


// KLayersPlugin�N���X��������Ƃ����g�������A���b�Z�[�W���C���Ƀ{�^����
// �z�u���邽�߂̃N���X�B
// ���b�Z�[�W�E�B���h�E�ɂ�������visible/unvisible���ݒ肳���
// �悤�ɂ��邽�߁B
class KLayersPluginOnMessage extends KLayersPlugin
{
	var withmessage     = true;	// ���b�Z�[�W��ʂƈꏏ�ɉB�����ǂ���
	var foreary_visible = [];	// �B�������� fore �� layer �̕\�����
	var backary_visible = [];	// �B�������� back �� layer �̕\�����
	var anytimeenabled  = false;	// ���enable���B�ʏ��stable��Ԃł̂�enable

	// �R���X�g���N�^
	function KLayersPluginOnMessage(name, fp, bp, withmessage=true, anytimeenabled=false)
	{
		super.KLayersPlugin(kag, name, fp, bp);
		this.withmessage = withmessage;
		this.anytimeenabled = anytimeenabled;
	}

	// Add �̎��� absolute �� message ���C���̏�ɂ���悤�׍H
	function add(name='noname', classobj, page='fore', elm = %[])
	{
		if (elm.absolute === void)
			elm.absolute = 1100000;	//���b�Z�[�W���C��100���ڂƓ���
		super.add(...);
	}

	// �u����v( s l p �̊e�^�O�Œ�~�� ) ���A
	// �u���s���v ( ����ȊO ) ���̏�Ԃ��ς�����Ƃ��ɌĂ΂��
	function onStableStateChanged(stable)
	{
		if (anytimeenabled)
			return;
		super.onStableStateChanged(...);
		// ���s���̓��C���𖳌��ɂ���
		setOptions(, 'both', %[ enabled: stable ]);
	}

	// ���b�Z�[�W���C�������[�U�̑���ɂ���ĕ\���E��\������鎞
	// �Ă΂��B���b�Z�[�W���C���ƕ\��/��\���𓯊������邽�ߐݒ�
	function onMessageHiddenStateChanged(hidden)
	{
		if (!withmessage)
			return;
		super.onMessageHiddenStateChanged(...);
		if (hidden) {
			// �B���Ƃ��F���݂̏�Ԃ��L������
			foreary_visible = [];
			backary_visible = [];
			for (var i = foreary.count-1; i >= 0; i--)
				foreary_visible[i] = foreary[i].visible;
			for (var i = backary.count-1; i >= 0; i--) 
				backary_visible[i] = backary[i].visible;
			setOptions(, 'both', %[ visible: false ]);
		} else {
			// �\������Ƃ��F���̏�Ԃɖ߂�
			for (var i = foreary.count-1; i >= 0; i--)
				foreary[i].visible = foreary_visible[i];
			for (var i = backary.count-1; i >= 0; i--)
				backary[i].visible = backary_visible[i];
			foreary_visible = [];
			backary_visible = [];
		}
	}

	// ���̂܂܂ł́Ahidden ���ɗv�f�� add/del ���ꂽ�ꍇ���l�����Ă��Ȃ��B
	// �{���́Afore/backary_visible[] �ɒǉ��E����폜���鏈�����K�v�B

	// ���C���̕\�������̏��R�s�[
	function onCopyLayer(toback)
	{
		super.onCopyLayer(toback);
		if (toback)
			backary_visible.assign(foreary_visible); // �\����
		else
			foreary_visible.assign(backary_visible); // �����\
	}

	// ���ƕ\�̊Ǘ���������
	function onExchangeForeBack()
	{
		super.onExchangeForeBack();
		var tmp = [];
		tmp.assign(foreary_visible);
		foreary_visible.assign(backary_visible);
		backary_visible.assign(tmp);
	}

	// �Z�[�u(���b�Z�[�W�������ɃZ�[�u�ł��Ȃ���Εs�v)
	function onStore(f, elm)
	{
		var dic = super.onStore(f, elm);
		dic.withmessage = withmessage;
		dic.foreary_visible = [];
		dic.foreary_visible.assign(foreary_visible);
		dic.backary_visible = [];
		dic.backary_visible.assign(backary_visible);
		dic.anytimeenabled = anytimeenabled;
		return dic;	// �q�N���X�̂��߂ɕԂ�
	}

	// ���[�h(���b�Z�[�W�������ɃZ�[�u�ł��Ȃ���Εs�v)
	function onRestore(f, clear, elm)
	{
		var dic = super.onRestore(f, clear, elm);
		if (dic === void)
			return dic;
		withmessage = dic.withmessage;
		if (elm !== void && elm.backlay) {
			// [tempload backlay=true]�̎�
			backary_visible = [];
			if (dic.foreary_visible !== void)
				backary_visible.assign(dic.foreary_visible);
		} else {
			// �ʏ펞
			foreary_visible = [];
			if (dic.foreary_visible !== void)
				foreary_visible.assign(dic.foreary_visible);
			backary_visible = [];
			if (dic.backary_visible !== void)
				backary_visible.assign(dic.backary_visible);
		}
//		onMessageHiddenStateChanged(0);
//		������͕s�v�Bsuper.onRestore() ���Őݒ肵�Ă��܂����߁B
		anytimeenabled = dic.anytimeenabled;
		return dic;	// �q�N���X�̂��߂ɕԂ�
	}
}


// ���̃t�@�C����ǂݍ��񂾃t���O
global.KLayersLoaded = true;

[endscript]

[return]
