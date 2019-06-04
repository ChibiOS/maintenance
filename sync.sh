#!/bin/bash

LOCAL_REPO=$HOME/chibios-git-svn
SVN_REPO=https://svn.osdn.net/svnroot/chibios/
GIT_REPO=git@github.com:ChibiOS/ChibiOS.git

if [ -z "$1" ]
  then
    echo "No argument supplied, need init, update, or push"
    exit 1
fi

if [[ "$1" == "init" ]]
then

if [ -d $LOCAL_REPO ]
  then
  echo repo already exists at $LOCAL_REPO
  exit 1
fi

echo Cloning from git...
git clone $GIT_REPO $LOCAL_REPO

echo Adding SVN config
cp authors.txt $LOCAL_REPO/
cat << EOF >> $LOCAL_REPO/.git/config
[svn-remote "svn"]
        url = $SVN_REPO
        fetch = trunk:refs/remotes/origin/master
        branches = branches/{stable_17.6.x,stable_18.2.x,stable_19.1.x}:refs/remotes/origin/*
        tags = tags/ver*:refs/tags/*
[svn]
        authorsfile = $LOCAL_REPO/authors.txt
        useLogAuthor = true
EOF

fi

if [[ "$1" == "update" ]]
then

echo Updating SVN refs
cd $LOCAL_REPO
git svn fetch

fi

if [[ "$1" == "push" ]]
then

echo Pushing to git mirror
cd $LOCAL_REPO
git push

fi

