@echo off
rem --- 
rem ---  OpenPose �� json�f�[�^���� 3D�f�[�^�ɕϊ�(baseline)
rem --- 

rem -- index
set DISPLAY_IDX=0%IDX%

rem echo OUTPUT_JSON_DIR_PARENT: %OUTPUT_JSON_DIR_PARENT%
rem echo OUTPUT_JSON_DIR_NAME: %OUTPUT_JSON_DIR_NAME%
rem echo DISPLAY_IDX: %DISPLAY_IDX%

rem ------------------------------------------------
rem -- JSON�o�̓f�B���N�g�� ���� index�ʃT�u�f�B���N�g������
set OUTPUT_SUB_DIR=%OUTPUT_JSON_DIR_PARENT%\%OUTPUT_JSON_DIR_NAME%_%DTTM%_idx%DISPLAY_IDX%

rem echo OUTPUT_SUB_DIR: %OUTPUT_SUB_DIR%

echo ------------------------------------------
echo 3d-pose-baseline-vmd [%IDX%]
echo ------------------------------------------

rem -- 3d-pose-baseline �f�B���N�g���Ɉړ�
cd /d %~dp0
cd /d %BASELINE_DIR%

rem ---  python ���s
python src/openpose_3dpose_sandbox_vmd.py --camera_frame --residual --batch_norm --dropout 0.5 --max_norm --evaluateActionWise --use_sh --epochs 200 --load 4874200 --gif_fps 30 --verbose %VERBOSE% --openpose %OUTPUT_SUB_DIR% --person_idx 1

cd /d %~dp0

exit /b
