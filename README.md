# Youtube_flac_Download.bat

下記のセットアップ作業を済ませてください

●yt-dlpの導入
winget install yt-dlp


●mkvtoolnixの導入
mkdir "%appdata%\convert_work"
cd /d "%appdata%\convert_work"
curl -OL "https://mkvtoolnix.download/windows/releases/84.0/mkvtoolnix-64-bit-84.0-setup.exe"
"%appdata%\convert_work\mkvtoolnix-64-bit-84.0-setup.exe" /S


●mkvtoolnixをPath(環境変数)へ追記
setx /M path "%path%;C:\Program Files\MKVToolNix"

