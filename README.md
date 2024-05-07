# Youtube_flac_Download.bat
<br>
<br>
下記のセットアップ作業を済ませてください<br>
<br>
● yt-dlpの導入<br>
winget install yt-dlp<br>
<br>
<br>
● ffmpegの導入(yt-dlp導入時に一緒にInstallした場合は実行不要)<br>
winget install ffmpeg
<br>
<br>
● mkvtoolnixの導入<br>
mkdir "%appdata%\convert_work"<br>
cd /d "%appdata%\convert_work"<br>
curl -OL "https://mkvtoolnix.download/windows/releases/84.0/mkvtoolnix-64-bit-84.0-setup.exe"<br>
"%appdata%\convert_work\mkvtoolnix-64-bit-84.0-setup.exe" /S<br>
<br>
<br>
● mkvtoolnixをPath(環境変数)へ追記<br>
setx /M path "%path%;C:\Program Files\MKVToolNix"<br>
<br><br>
<br><br>

# つかいかた
① batをダウンロード<br>
https://github.com/WinterMagician-2ZGRG/Youtube_flac_Download.bat/archive/refs/heads/main.zip<br>
<br>
② Youtubeの動画URLを用意する<br>
下記の形式であることを確認<br>
https://www.youtube.com/watch?v=dQw4w9WgXcQ<br>
※Playlist等のURLは使えません。動画単体のURLを用意してください。<br>
<br>
③ 最新版のbatをクリックして実行<br>
<br>
④ ポップアップ表示される入力ウィンドウにURLを貼り付けて処理させる<br>
