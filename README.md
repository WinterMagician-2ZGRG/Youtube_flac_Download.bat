# Youtube_flac_Download.bat
<br>
<br>
下記のセットアップ作業を済ませてください<br>
<br>
●yt-dlpの導入<br>
winget install yt-dlp<br>
<br>
<br>
●mkvtoolnixの導入<br>
mkdir "%appdata%\convert_work"<br>
cd /d "%appdata%\convert_work"<br>
curl -OL "https://mkvtoolnix.download/windows/releases/84.0/mkvtoolnix-64-bit-84.0-setup.exe"<br>
"%appdata%\convert_work\mkvtoolnix-64-bit-84.0-setup.exe" /S<br>
<br>
<br>
●mkvtoolnixをPath(環境変数)へ追記<br>
setx /M path "%path%;C:\Program Files\MKVToolNix"<br>

