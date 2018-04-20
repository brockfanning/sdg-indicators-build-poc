#!/usr/bin/env bash
if [ $CIRCLE_BRANCH == 'develop' ]; then
    git config --global user.email $GH_EMAIL
    git config --global user.name $GH_NAME

    git clone $CIRCLE_REPOSITORY_URL out

    cd out
    git checkout develop || git checkout --orphan develop
    git rm -rf .
    cd ..

    # TODO: Ruby/gem is probably not installed...
    gem install gh-pages
    jekyll build

    cp -a build/. out/.

    mkdir -p out/.circleci && cp -a .circleci/. out/.circleci/.
    cd out

    git add -A
    git commit -m "Automated deployment to GitHub Pages: ${CIRCLE_SHA1}" --allow-empty

    git push origin $TARGET_BRANCH
fi