#!/bin/bash

WORKING_COPY=chibios-svn-git

cd $WORKING_COPY

git svn fetch --authors-file=../authors.txt --use-log-author

# list of needed branches
BRANCHES="stable_1.0.x \
	stable_1.2.x \
	stable_1.4.x \
	stable_2.0.x \
	stable_2.2.x \
	stable_2.4.x \
	stable_2.6.x \
	stable_3.0.x \
	stable_16.1.x \
	stable_17.6.x \
	trunk \
	master"

# main loop
for B in $BRANCHES
do
	# echo $B
	# commented string needs only for untracked branches checkout
	#git checkout -b $B origin/$B
	git checkout $B
	git svn rebase
done

# push acquired commits
git push origin --all

