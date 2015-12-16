#/bin/bash
echo "Compiling all LESS files to CSS"
cd css/
for file in *.less
do
    FROM=$file
    TO=${file/.*/.css}
    echo "$FROM --> $TO"
    lessc $FROM $TO
done

rm -rf test-common.css
rm -rf font.css
rm -rf color.css

cd -
exit 0

cd min

node r.js -o favorite-build.js
node r.js -o test-build.js
node r.js -o report-build.js

cd -

exit
