./unicodesub.sh

echo "building..."
pulp build --to rnapp/purs_app.js --skip-entry-point

sed -i '' 's/var PS = {}/export var PS = {}/' rnapp/purs_app.js