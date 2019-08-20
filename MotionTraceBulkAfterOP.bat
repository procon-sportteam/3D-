@echo off
rem --- 
rem ---  �f���f�[�^����e��g���[�X�f�[�^�𑵂���vmd�𐶐�����
rem --- Openpose ���擾�ł��Ă���ꍇ(FCRN�ȍ~���{)
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


rem -- Openpose �㏈�����s
cd /d %~dp0
call BulkOpenposeAfter.bat

echo BULK OUTPUT_JSON_DIR: %OUTPUT_JSON_DIR%

cd /d %~dp0

rem -----------------------------------
rem --- JSON�o�̓f�B���N�g�� ���� index�ʃT�u�f�B���N�g������
FOR %%1 IN (%OUTPUT_JSON_DIR%) DO (
    set OUTPUT_JSON_DIR_PARENT=%%~dp1
    set OUTPUT_JSON_DIR_NAME=%%~n1
)

rem -- ���s���t
set DT=%date%
rem -- ���s����
set TM=%time%
rem -- ���Ԃ̋󔒂�0�ɒu��
set TM2=%TM: =0%
rem -- ���s�������t�@�C�����p�ɒu��
set DTTM=%dt:~0,4%%dt:~5,2%%dt:~8,2%_%TM2:~0,2%%TM2:~3,2%%TM2:~6,2%

rem -- FCRN-DepthPrediction-vmd���s
call BulkDepth.bat

rem -- �L���v�`���l�������[�v����
for /L %%i in (1,1,%NUMBER_PEOPLE_MAX%) do (
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
echo json: %OUTPUT_JSON_DIR%
echo vmd:  %OUTPUT_SUB_DIR%
echo ------------------------------------------


rem -- �J�����g�f�B���N�g���ɖ߂�
cd /d %~dp0
