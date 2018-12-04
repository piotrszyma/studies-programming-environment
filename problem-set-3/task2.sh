#
# Script counts number of commits, lines added and removed for user in GIT repo.
#
#   bash task2.sh <user email> <branch> <?repo url>
#
#   Example of usage: bash task2.sh thompson2908@gmail.com master
#                     bash task2.sh thompson2908@gmail.com master \
#                     git@github.com:piotrszyma/bemar-odziez.git
#

EMAIL=$1
BRANCH=$2
REPO=$3

if [[ $# -eq 3 ]] ; then
  rm -rf /tmp/repo
  git clone $REPO /tmp/repo
  cd /tmp/repo
fi

# Get number of commits by counting lines.
NUM_OF_COMMITS=`git log $BRANCH --author="$EMAIL" --oneline | wc -l`

# For getting number of lines added / removed
SUM_ADDED=0
SUM_DELETED=0

# Get user's revisions.
for i in `git log $BRANCH --author="$EMAIL" --oneline --format="%H"`; do
  REV=$i

  # Extract added lines in commit.
  ADDED_PER_COMMIT=`git show $REV --shortstat | tail -n 1 | grep -Po '[0-9]*(?=\ insertions)'`
  # Extract deleted lines in commit.  
  DELETED_PER_COMMIT=`git show $REV --shortstat | tail -n 1 | grep -Po '[0-9]*(?=\ deletions)'`

  # If any added lines in commit, add to sum.
  if [[ $ADDED_PER_COMMIT ]]; then
    SUM_ADDED=`expr $SUM_ADDED + $ADDED_PER_COMMIT`
  fi

  # If any deleted lines in commit, add to sum.
  if [[ $DELETED_PER_COMMIT ]]; then
    SUM_DELETED=`expr $SUM_DELETED + $DELETED_PER_COMMIT`
  fi
done

echo 'User '$EMAIL' has made '$NUM_OF_COMMITS' commits; added '$SUM_ADDED' lines and deleted '$SUM_DELETED'.'
