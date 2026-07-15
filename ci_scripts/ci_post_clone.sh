#!/bin/sh
set -e

echo ">>> Installing Node.js 24"
brew install node@24
export PATH="/opt/homebrew/opt/node@24/bin:$PATH"
echo 'export PATH="/opt/homebrew/opt/node@24/bin:$PATH"' >> ~/.zprofile

node --version
npm --version

echo ">>> Installing Ionic CLI and Cordova"
npm install -g @ionic/cli cordova

echo ">>> Installing project dependencies"
cd "$CI_WORKSPACE"
npm ci

echo ">>> Writing moodle.config.json"
cat > moodle.config.json << EOF
{
  "default_lang": "vi",
  "defaultsites": [
    {
      "url": "${MOODLE_SITE_URL}",
      "name": "VBS LMS"
    }
  ],
  "forcedefault": false
}
EOF

echo ">>> Setting Bundle ID to vn.vbs.moodleapp"
sed -i '' 's/id="com\.moodle\.moodlemobile"/id="vn.vbs.moodleapp"/' config.xml

echo ">>> Building web (production)"
npm run build:prod

echo ">>> Adding iOS platform"
ionic cordova platform add ios

echo ">>> Done — Xcode project ready at platforms/ios/"
ls platforms/ios/
