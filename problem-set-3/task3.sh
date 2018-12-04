# Cache current branch.
CURRENT_BRANCH=`git branch | grep \* | cut -d ' ' -f2`

# Get unreachable commit's objects' hashes and create branch for each.
for HASH in `git fsck --full --no-reflogs | grep commit | awk '{ print $3 }'`; do
  git checkout -b $HASH $HASH
done

# Get back to original branch.
git checkout $CURRENT_BRANCH
