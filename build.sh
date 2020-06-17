#!/bin/sh

set -e

js="app.js"
min="app.min.js"
out_dir="out"

elm make src/Main.elm --optimize --output=$js "$@"

uglifyjs $js --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output=$min

echo "Compiled size:$(cat $js | wc -c) bytes  ($js)"
echo "Minified size:$(cat $min | wc -c) bytes  ($min)"
echo "Gzipped size: $(cat $min | gzip -c | wc -c) bytes"

rm -r $out_dir
mkdir -p $out_dir
mkdir -p "$out_dir/elm-mdc"
cp -R "styles" "$out_dir/styles"
cp -R "media" "$out_dir/media"
cp -R "elm-mdc/elm-mdc.js" "$out_dir/elm-mdc/elm-mdc.js"
cp -R "elm-mdc/material-components-web.css" "$out_dir/elm-mdc/material-components-web.css"
cp "index.html" "$out_dir/index.html"
mv "app.min.js" "$out_dir/app.js"