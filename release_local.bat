
workon web;
rm -r dist\;
pyinstaller --noupx --onedir --onefile app/httpserver.py;
cp -r app/* dist/;