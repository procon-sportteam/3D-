@echo off
rem --- 
rem ---  3D �� �֐߃f�[�^���� vmd�f�[�^�ɕϊ�
rem --- 

echo ------------------------------------------
echo VMD-3d-pose-baseline-multi [%IDX%]
echo ------------------------------------------

rem -- VMD-3d-pose-baseline-multi �f�B���N�g���Ɉړ�
cd /d %~dp0
cd /d %VMD_DIR%

rem ---  python ���s
python applications\pos2vmd_multi.py -v %VERBOSE% -t "%OUTPUT_SUB_DIR%" -b "born\���ɂ܂����~�N�{�[��.csv" -c 30 -z 0 -s 1 -p 0.5 -r 3 -k 1 -e 0

cd /d %~dp0

exit /b
