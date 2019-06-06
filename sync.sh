#!/bin/bash

BASE=$HOME/mirrors
LOCAL_SVN=$BASE/chibios-svn
LOCAL_GIT=$BASE/chibios-git
REMOTE_SVN=https://svn.osdn.net/svnroot/chibios/
REMOTE_GIT=git@github.com:ChibiOS/ChibiOS.git
SVN_UUID=27425a3e-05d8-49a3-a47f-9c15f0e5edd8

if [ -z "$1" ]
  then
    echo "No argument supplied, need init, update, or push"
    exit 1
fi

if [[ "$1" == "init" ]]
then

if [ -d $BASE ]
  then
  echo repo already exists at $BASE
  exit 1
fi

mkdir -p $BASE
echo Creating SVN Mirror...
svnadmin create $LOCAL_SVN $REMOTE_SVN
mkdir $LOCAL_SVN/hooks
echo '#!/bin/sh' > $LOCAL_SVN/hooks/pre-revprop-change
chmod 755 $LOCAL_SVN/hooks/pre-revprop-change

echo Syncing SVN mirror for the first time, this will take a while...
svnsync sync file://$LOCAL_SVN

echo Cloning from git...
git clone $REMOTE_GIT $LOCAL_GIT

echo Adding SVN config
cp authors.txt $BASE/
cat << EOF >> $LOCAL_GIT/.git/config
[svn-remote "svn"]
        url = file://$LOCAL_SVN
        fetch = trunk:refs/remotes/origin/master
        fetch = branches/stable_18.2.x:refs/remotes/origin/stable_18.2.x
        fetch = branches/stable_19.1.x:refs/remotes/origin/stable_19.1.x
        tags = tags/ver*:refs/tags/*
        rewriteRoot = svn://svn.code.sf.net/p/chibios/svn
        rewriteUUID = $SVN_UUID
[svn]
        authorsfile = $BASE/authors.txt
        useLogAuthor = true
EOF

fi

if [[ "$1" == "update" ]]
then

echo Syncing SVN mirror
svnsync sync file://$LOCAL_SVN

echo Updating SVN refs
cd $LOCAL_GIT
git svn fetch

fi

if [[ "$1" == "push" ]]
then

echo Pushing to git mirror
cd $LOCAL_GIT
git push

fi
