#
# Script counts number of commits, lines added and removed for user in SVN repo.
#
#   Example of usage: bash task1.sh https://156.17.7.16/p_25/ 229735
#

# REPO=$1
USERNAME=$1
BRANCH=$2

# git clone $1 /tmp/repo
# cd /tmp/repo

# For listing number of commits
NUM_OF_COMMITS=`git log $BRANCH | grep "$USERNAME" | wc -l`

# For getting number of lines added / removed
SUM_ADDED=0
SUM_DELETED=0

for i in `git log master | grep -B 1 "$USERNAME" | awk 'NR % 3 == 1' | awk '{print $2}'`; do
  REV=$i
  
  ADDED_PER_COMMIT=`git show $REV --shortstat | tail -n 1 | grep -Po '[0-9]*(?=\ insertions)'`
  DELETED_PER_COMMIT=`git show $REV --shortstat | tail -n 1 | grep -Po '[0-9]*(?=\ deletions)'`
  
  if [[ $ADDED_PER_COMMIT  ]]; then
    SUM_ADDED=`expr $SUM_ADDED + $ADDED_PER_COMMIT`
  fi

  if [[ $DELETED_PER_COMMIT ]]; then
    SUM_DELETED=`expr $SUM_DELETED + $DELETED_PER_COMMIT`
  fi
done

echo 'User '$USERNAME' has made '$NUM_OF_COMMITS' commits; added '$SUM_ADDED' lines and deleted '$SUM_DELETED'.'
