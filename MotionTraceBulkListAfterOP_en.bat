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

rem ---  ���͑Ώۃp�����[�^�[�t�@�C���p�X
echo Please enter the full path of the parameter setting list file to be analyzed.
echo This setting is available only for half size alphanumeric characters, it is a required item.
set TARGET_LIST=
set /P TARGET_LIST=** Analysis target list file path: 
rem echo INPUT_VIDEO�F%INPUT_VIDEO%

IF /I "%TARGET_LIST%" EQU "" (
    ECHO Analysis target list file path is not set, therefore, processing is aborted.
    EXIT /B
)

SETLOCAL enabledelayedexpansion
rem -- �t�@�C���������[�v���đS����������
for /f "tokens=1-8 skip=1" %%m in (%TARGET_LIST%) do (
    echo ------------------------------
    echo Input target video file path: %%m
    echo Frame number to start analysis: %%n
    echo Maximum number of people in the image: %%o
    echo Detailed log[yes/no/warn]: %%p
    echo Analysis end frame number: %%q
    echo Openpose analysis result JSON directory path: %%r
    echo Reverse specification list: %%s
    echo Sequential list: %%t

    
    rem --- �p�����[�^�[�ێ�
    set INPUT_VIDEO=%%m
    set FRAME_FIRST=%%n
    set NUMBER_PEOPLE_MAX=%%o
    set VERBOSE=2
    set IS_DEBUG=%%p
    set FRAME_END=%%q
    set OUTPUT_JSON_DIR=%%r
    set REVERSE_SPECIFIC_LIST=%%s
    set ORDER_SPECIFIC_LIST=%%t
    
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
    echo verbose: !VERBOSE!

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
