@echo off
color 0A
TITLE Youtube_flac_Download
setlocal EnableDelayedExpansion
REM ================================
REM  Youtube����Opus�𒊏o����flac��
REM ================================
REM 20240507 v1.0 �V�K�쐬
REM 20240507 v1.1 �t�@�C���p�X�Ɏg���Ȃ���������܂񂾓���^�C�g�����C�����鏈����ǉ�
REM 20240507 v1.2 ��L�C��
REM 20240507 v1.3 �֎~�L���̒u��������ǉ�
REM 20240507 v1.4 �u����������L���Ɂ��Ɓ���ǉ�
REM 20240508 v1.5 �u����������L���ɁG��ǉ��A�O���u�������̃R�[�h���ꕔ�C��




REM ================================
REM ���ŗL�l �ݒ�ӏ�
REM ================================
set work_dir=%USERPROFILE%\Music




echo ================================
echo ����URL�����
for /f "usebackq" %%f in (`mshta vbscript:execute("Dim input:input=InputBox(""����URL����͂��Ă�������""):CreateObject(""Scripting.FileSystemObject"").GetStandardStream(1).WriteLine(input):Close"^)`) do (
set yt_url_tmp=%%f
set yt_url="!yt_url_tmp!"
)

set yt_ID=!yt_url_tmp:https://www.youtube.com/watch?v=!
set yt_ID=%yt_ID:~1%

if %yt_url%=="" (
  echo ����URL�����͂���܂���ł����B�o�b�`�������I�����܂�
  pause
  exit /b
)

echo ����URL�F%yt_url%
echo ����ID�F%yt_ID%



echo.
echo.
color 0A
echo ================================
echo ����^�C�g���擾
for /f "usebackq delims=" %%A in (`yt-dlp --print title !yt_url!`) do set yt_title=%%A
color 0A



echo.
echo ----------
echo ����^�C�g���F!yt_title!
echo ----------
echo �擾���ꂽ����^�C�g��������������Α��s���Ă�������...
pause >nul
echo.


echo.
echo.
color 0A
echo ================================
echo ����^�C�g���� �֎~������ �u������
echo �u"�I�@|�@?�@/�@:�@<�@>�@*�@��"�v�u������

REM �u&�v��u��
for /f "delims=^& tokens=1,2" %%k in ("%yt_title%") do ( set CC=%%k& set DD=%%l)
set pre_char=%cc%
set post_char=��%dd%
if "!post_char!"=="��" (
 set yt_title=!pre_char!
) else (
 set yt_title=!pre_char!!post_char!
)


REM �u*�v��u��
for /f "delims=* tokens=1,2" %%a in ("%yt_title%") do ( set AA=%%a& set BB=%%b)
set pre_char2=%aa%
set post_char2=��%bb%
if "!post_char2!"=="��" (
 set yt_title=!pre_char2!
) else (
 set yt_title=!pre_char2!!post_char2!
)


REM ���̑��u��
set "yt_title=!yt_title:;=�G!"
set "yt_title=!yt_title:|=�b!"
set "yt_title=!yt_title:?=�H!"
set "yt_title=!yt_title:/=�^!"
set "yt_title=!yt_title::=�F!"
REM set "yt_title=!yt_title:<=��!"
REM set "yt_title=!yt_title:>=��!"
REM set "yt_title=!yt_title:"!"=!"
REM �u��������̕�������o��
echo �t�@�C�����F%yt_title%


echo.
echo.
color 0A
echo ================================
echo �o�͐�f�B���N�g���쐬
set dl_dir=%work_dir%\%yt_title%
echo %dl_dir%
mkdir "%dl_dir%"
cd /d "%dl_dir%"



echo.
echo.
color 0A
echo ================================
echo �����g���b�N(WebM opus 251)���擾
yt-dlp -f 251 "%yt_url%" --write-thumbnail --convert-thumbnails png
move "*.webm" "%yt_title%.webm"
move "*.png" "%yt_title%.png"



echo.
echo.
color 0A
echo ================================
echo �A�[�g���[�N����
copy "%yt_title%.png" "front.png"
copy "%yt_title%.png" "folder.png"
copy "%yt_title%.png" "cover.png"
copy "%yt_title%.png" "coverart.png"
copy "%yt_title%.png" "artwork.png"
copy "%yt_title%.png" "AlbumArtSmall.png"
copy "%yt_title%.png" "thumb.png"



echo.
echo.
color 0A
echo ================================
echo WebM �� opus���o
mkvextract "%yt_title%.webm" tracks 0:"%yt_title%.opus"



echo.
echo.
color 0A
echo ================================
echo opus �� flac�ϊ�
ffmpeg -i "%yt_title%.opus" -metadata title="%yt_title%" -metadata artist="Youtube" -metadata album="%yt_title%" -vn "%yt_title%.flac"



echo.
echo.
color 0A
echo ================================
echo flac �^�O��񖄂ߍ��ݕϊ�
ffmpeg -i "%yt_title%.flac" -i thumb.png -map 0:a -map 1:v -c copy -disposition:1 attached_pic "%yt_title%_meta.flac"



echo.
echo.
color 0A
echo ================================
echo �s�v�f�[�^�폜
del "%yt_title%.flac"
move "%yt_title%_meta.flac" "%yt_title%.flac"
mkdir 99_extract_original
move "%yt_title%.webm" "99_extract_original\%yt_title%.webm"
move "%yt_title%.opus" "99_extract_original\%yt_title%.opus"
rmdir /s /q ".\99_extract_original"



echo.
echo.
color 0A
echo ================================
echo �o�͐�t�H���_���|�b�v�A�b�v
explorer "%dl_dir%"



pause

