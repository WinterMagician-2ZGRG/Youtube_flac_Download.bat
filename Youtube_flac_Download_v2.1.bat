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
REM 20241006 v1.6 yt-dlpによるDL時にリトライ処理を追加、WebM非対応動画のm4aのダウンロードに対応




REM ================================
REM 環境固有値 設定箇所
REM ================================
set work_dir=%USERPROFILE%\Music

REM wemM取得失敗時リトライ回数
set RetryMax=5



echo ================================
echo 動画URLを入力

REM --- PowerShell の InputBox で URL を取得（VBScript 非依存版）---
for /f "usebackq delims=" %%f in (`
  powershell -NoProfile -Command "Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.Interaction]::InputBox('YouTube の動画 URL を入力してください。','動画URL入力','')"
`) do (
  set "yt_url_tmp=%%f"
)

REM 入力された URL を変数に格納
set "yt_url=%yt_url_tmp%"

REM YouTube の動画ID部分だけを抽出
REM 例: https://www.youtube.com/watch?v=ABCDEFG → ABCDEFG
set "yt_ID=%yt_url_tmp:https://www.youtube.com/watch?v=%"

REM 何も入力されていない場合のチェック
if "%yt_url%"=="" (
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




echo 「｜」を置換
set "yt_title=!yt_title:|=｜!"




echo 「＆」を置換
for /f "delims=^& tokens=1,2" %%k in ("%yt_title%") do ( set CC=%%k& set DD=%%l)
set pre_char=%cc%
set post_char=＆%dd%
if "!post_char!"=="＆" (
 set yt_title=!pre_char!
) else (
 set yt_title=!pre_char!!post_char!
)




echo 「＊」を置換
for /f "delims=* tokens=1,2" %%a in ("%yt_title%") do ( set AA=%%a& set BB=%%b)
set pre_char2=%aa%
set post_char2=＊%bb%
if "!post_char2!"=="＊" (
 set yt_title=!pre_char2!
) else (
 set yt_title=!pre_char2!!post_char2!
)




echo その他置換
set "yt_title=!yt_title:;=；!"
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
set retry=0
:Download
if %retry% gtr %RetryMax% (
    echo.
    echo.
    color 0A
    echo ================================
    echo "音声トラック(m4a AAC 140)を取得"
    yt-dlp -f 140 "%yt_url%" --write-thumbnail --convert-thumbnails png
    goto m4acheck
) else (
    echo.
    echo.
    color 0A
    echo ================================
    echo "音声トラック(WebM opus 251)を取得"
    echo "リトライ回数...%retry%／%RetryMax%"
    yt-dlp -f 251 "%yt_url%" --write-thumbnail --convert-thumbnails png
    goto webMcheck
)




:webMcheck
if exist "*.webm" (
    echo.
    echo.
    color 0A
    echo ================================
    echo ファイル取得確認
    echo File Check OK
    echo WebM Mode
    set WebM=1
    goto next
) else (
    echo.
    echo.
    color 0A
    echo ================================
    echo ファイル取得確認
    echo File Check NG
    set /a retry+=1
    goto Download
)

:m4acheck
if exist "*.m4a" (
    echo.
    echo.
    echo ================================
    echo ファイル取得確認
    echo File Check OK
    echo m4a Mode
    set WebM=0
)

:next
if %WebM% == 1 (
    echo.
    echo.
    echo ================================
    echo ファイル名変更
    move "*.webm" "%yt_title%.webm"
) else (
    echo.
    echo.
    echo ================================
    echo ファイル名変更
    move "*.m4a" "%yt_title%.m4a"
)
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



if %WebM%==1 (
    echo.
    echo.
    color 0A
    echo ================================
    echo WebM → opus抽出
    ffmpeg -i "%yt_title%.webm" -vn -acodec copy "%yt_title%.opus"
    REM mkvextract "%yt_title%.webm" tracks 0:"%yt_title%.opus"
)


if %WebM%==1 (
    echo.
    echo.
    color 0A
    echo ================================
    echo opus → flac変換
    ffmpeg -i "%yt_title%.opus" -metadata title="%yt_title%" -metadata artist="Youtube" -metadata album="%yt_title%" -vn "%yt_title%.flac"
) else (
    echo.
    echo.
    echo ================================
    echo m4a → flac変換
    ffmpeg -i "%yt_title%.m4a" -metadata title="%yt_title%" -metadata artist="Youtube" -metadata album="%yt_title%" -vn "%yt_title%.flac"
)


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
move "%yt_title%.m4a" "99_extract_original\%yt_title%.webm"
move "%yt_title%.opus" "99_extract_original\%yt_title%.opus"
rmdir /s /q ".\99_extract_original"



echo.
echo.
color 0A
echo ================================
echo 出力先フォルダをポップアップ
explorer "%dl_dir%"



pause

