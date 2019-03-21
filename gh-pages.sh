#!/bin/bash
set -e

rm -rf gh-pages || exit 0;

# Compile the specimen
cd specimen/
mkdir -p ../gh-pages/
elm make Main.elm --optimize --output ../gh-pages/index.html

# Deploy to GH Pages
cd ../gh-pages
git init
git add .
git commit -m "Deploying to GH Pages"
git push --force "git@github.com:kuzminadya/mogeefont.git" master:gh-pages
