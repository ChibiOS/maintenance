#!/bin/bash

WORKING_COPY=chibios-svn-git

cd $WORKING_COPY

git svn fetch --fetch-all --authors-file=../authors.txt

# list of needed branches
BRANCHES="stable_1.0.x \
	stable_1.2.x \
	stable_1.4.x \
	stable_2.0.x \
	stable_2.2.x \
	stable_2.4.x \
	stable_2.6.x \
	trunk \
	master"

# main loop
for B in $BRANCHES
do
	# echo $B
	# uncomment next string needs for checkout untracked branches
	# git checkout -b $B origin/$B
	git checkout $B
	git svn rebase
done

# push acquired commits
git push origin --all

