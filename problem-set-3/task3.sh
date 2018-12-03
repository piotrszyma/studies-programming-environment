$CURRENT_BRANCH=`git branch | grep \* | cut -d ' ' -f2`

for HASH in `git fsck --lost-found --unreachable --no-reflogs | grep commit | awk '{ print $3 }'`; do
  git checkout -b $HASH $HASH
done

git checkout $CURRENT_BRANCH
