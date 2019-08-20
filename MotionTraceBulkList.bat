@echo off
rem --- 
rem ---  �f���f�[�^����e��g���[�X�f�[�^�𑵂���vmd�𐶐�����
rem ---  �����f���Ή��o�[�W����
rem --- 
cls

rem -----------------------------------
rem �e��\�[�X�R�[�h�ւ̃f�B���N�g���p�X(���� or ���)
rem -----------------------------------
rem --- Openpose
set OPENPOSE_DIR=..\openpose-1.4.0-win64-gpu-binaries
rem --- OpenposeDemo.exe�̂���f�B���N�g���p�X(PortableDemo��: bin, ���O�r���h��: Release)
set OPENPOSE_BIN_DIR=bin
rem --- 3d-pose-baseline-vmd
set BASELINE_DIR=..\3d-pose-baseline-vmd
rem -- 3dpose_gan_vmd
set GAN_DIR=..\3dpose_gan_vmd
rem -- FCRN-DepthPrediction-vmd
set DEPTH_DIR=..\FCRN-DepthPrediction-vmd
rem -- VMD-3d-pose-baseline-multi
set VMD_DIR=..\VMD-3d-pose-baseline-multi

cd /d %~dp0

rem ---  ���͑Ώۉf���t�@�C���p�X
echo ��͑ΏۂƂȂ�p�����[�^�[�ݒ胊�X�g�t�@�C���̃t���p�X����͂��ĉ������B
echo ���̐ݒ�͔��p�p�����̂ݐݒ�\�ŁA�K�{���ڂł��B
set TARGET_LIST=
set /P TARGET_LIST=����͑Ώۃ��X�g�t�@�C���p�X: 
rem echo INPUT_VIDEO�F%INPUT_VIDEO%

IF /I "%TARGET_LIST%" EQU "" (
    ECHO ��͑Ώۃ��X�g�t�@�C���p�X���ݒ肳��Ă��Ȃ����߁A�����𒆒f���܂��B
    EXIT /B
)

SETLOCAL enabledelayedexpansion
rem -- �t�@�C���������[�v���đS����������
for /f "tokens=1-7 skip=1" %%m in (%TARGET_LIST%) do (
    echo ------------------------------
    echo ���͑Ώۉf���t�@�C���p�X: %%m
    echo ��͂��J�n����t���[��: %%n
    echo �f���ɉf���Ă���ő�l��: %%o
    echo �ڍ׃��O[yes/no/warn]: %%p
    echo ��͂��I������t���[��: %%q
    echo ���]�w�胊�X�g%%r
    echo ���Ԏw�胊�X�g: %%s
    
    rem --- �p�����[�^�[�ێ�
    set INPUT_VIDEO=%%m
    set FRAME_FIRST=%%n
    set NUMBER_PEOPLE_MAX=%%o
    set VERBOSE=2
    set IS_DEBUG=%%p
    set FRAME_END=%%q
    set REVERSE_SPECIFIC_LIST=%%r
    set ORDER_SPECIFIC_LIST=%%s
        
    IF /I "!IS_DEBUG!" EQU "yes" (
        set VERBOSE=3
    )

    IF /I "!IS_DEBUG!" EQU "warn" (
        set VERBOSE=1
    )

    rem -- ���s���t
    set DT=!date!
    rem -- ���s����
    set TM=!time!
    rem -- ���Ԃ̋󔒂�0�ɒu��
    set TM2=!time: =0!
    rem -- ���s�������t�@�C�����p�ɒu��
    set DTTM=!DT:~0,4!!DT:~5,2!!DT:~8,2!_!TM2:~0,2!!TM2:~3,2!!TM2:~6,2!
    
    echo now: !DTTM!

    rem -- Openpose ���s(����Ȃ�)
    cd /d %~dp0
    call BulkOpenposeSilent.bat

    echo BULK OUTPUT_JSON_DIR: !OUTPUT_JSON_DIR!

    cd /d %~dp0

    rem -----------------------------------
    rem --- JSON�o�̓f�B���N�g�� ���� index�ʃT�u�f�B���N�g������
    FOR %%i IN (!OUTPUT_JSON_DIR!) DO (
        set OUTPUT_JSON_DIR_PARENT=%%~dpi
        set OUTPUT_JSON_DIR_NAME=%%~ni
    )
    
    rem -- FCRN-DepthPrediction-vmd���s
    call BulkDepth.bat

    rem -- �L���v�`���l�������[�v����
    for /L %%i in (1,1,!NUMBER_PEOPLE_MAX!) do (
        set IDX=%%i
        
        rem -- 3d-pose-baseline���s
        call Bulk3dPoseBaseline.bat
        
        rem -- 3dpose_gan���s
        rem call Bulk3dPoseGan.bat

        rem -- VMD-3d-pose-baseline-multi ���s
        call BulkVmd.bat
    )

    echo ------------------------------------------
    echo �g���[�X����
    echo json: !OUTPUT_JSON_DIR!
    echo vmd:  !OUTPUT_SUB_DIR!
    echo ------------------------------------------


    rem -- �J�����g�f�B���N�g���ɖ߂�
    cd /d %~dp0

)

ENDLOCAL


rem -- �J�����g�f�B���N�g���ɖ߂�
cd /d %~dp0
