@echo off
color 0A
TITLE Youtube_flac_Download
setlocal EnableDelayedExpansion
REM ================================
REM  YoutubeからOpusを抽出してflac化
REM ================================
REM 20240507 v1.0 新規作成
REM 20240507 v1.1 ファイルパスに使えない文字列を含んだ動画タイトルを修正する処理を追加
REM 20240507 v1.2 誤記修正
REM 20240507 v1.3 禁止記号の置換処理を追加
REM 20240507 v1.4 置換処理する記号に＆と＊を追加
REM 20240508 v1.5 置換処理する記号に；を追加、前半置換処理のコードを一部修正




REM ================================
REM 環境固有値 設定箇所
REM ================================
set work_dir=%USERPROFILE%\Music




echo ================================
echo 動画URLを入力
for /f "usebackq" %%f in (`mshta vbscript:execute("Dim input:input=InputBox(""動画URLを入力してください""):CreateObject(""Scripting.FileSystemObject"").GetStandardStream(1).WriteLine(input):Close"^)`) do (
set yt_url_tmp=%%f
set yt_url="!yt_url_tmp!"
)

set yt_ID=!yt_url_tmp:https://www.youtube.com/watch?v=!
set yt_ID=%yt_ID:~1%

if %yt_url%=="" (
  echo 動画URLが入力されませんでした。バッチ処理を終了します
  pause
  exit /b
)

echo 動画URL：%yt_url%
echo 動画ID：%yt_ID%



echo.
echo.
color 0A
echo ================================
echo 動画タイトル取得
for /f "usebackq delims=" %%A in (`yt-dlp --print title !yt_url!`) do set yt_title=%%A
color 0A



echo.
echo ----------
echo 動画タイトル：!yt_title!
echo ----------
echo 取得された動画タイトル名が正しければ続行してください...
pause >nul
echo.


echo.
echo.
color 0A
echo ================================
echo 動画タイトル名 禁止文字等 置換処理
echo 「"！　|　?　/　:　<　>　*　＆"」置換処理

REM 「&」を置換
for /f "delims=^& tokens=1,2" %%k in ("%yt_title%") do ( set CC=%%k& set DD=%%l)
set pre_char=%cc%
set post_char=＆%dd%
if "!post_char!"=="＆" (
 set yt_title=!pre_char!
) else (
 set yt_title=!pre_char!!post_char!
)


REM 「*」を置換
for /f "delims=* tokens=1,2" %%a in ("%yt_title%") do ( set AA=%%a& set BB=%%b)
set pre_char2=%aa%
set post_char2=＊%bb%
if "!post_char2!"=="＊" (
 set yt_title=!pre_char2!
) else (
 set yt_title=!pre_char2!!post_char2!
)


REM その他置換
set "yt_title=!yt_title:;=；!"
set "yt_title=!yt_title:|=｜!"
set "yt_title=!yt_title:?=？!"
set "yt_title=!yt_title:/=／!"
set "yt_title=!yt_title::=：!"
REM set "yt_title=!yt_title:<=＜!"
REM set "yt_title=!yt_title:>=＞!"
REM set "yt_title=!yt_title:"!"=!"
REM 置換処理後の文字列を出力
echo ファイル名：%yt_title%


echo.
echo.
color 0A
echo ================================
echo 出力先ディレクトリ作成
set dl_dir=%work_dir%\%yt_title%
echo %dl_dir%
mkdir "%dl_dir%"
cd /d "%dl_dir%"



echo.
echo.
color 0A
echo ================================
echo 音声トラック(WebM opus 251)を取得
yt-dlp -f 251 "%yt_url%" --write-thumbnail --convert-thumbnails png
move "*.webm" "%yt_title%.webm"
move "*.png" "%yt_title%.png"



echo.
echo.
color 0A
echo ================================
echo アートワーク整備
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
echo WebM → opus抽出
mkvextract "%yt_title%.webm" tracks 0:"%yt_title%.opus"



echo.
echo.
color 0A
echo ================================
echo opus → flac変換
ffmpeg -i "%yt_title%.opus" -metadata title="%yt_title%" -metadata artist="Youtube" -metadata album="%yt_title%" -vn "%yt_title%.flac"



echo.
echo.
color 0A
echo ================================
echo flac タグ情報埋め込み変換
ffmpeg -i "%yt_title%.flac" -i thumb.png -map 0:a -map 1:v -c copy -disposition:1 attached_pic "%yt_title%_meta.flac"



echo.
echo.
color 0A
echo ================================
echo 不要データ削除
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
echo 出力先フォルダをポップアップ
explorer "%dl_dir%"



pause

