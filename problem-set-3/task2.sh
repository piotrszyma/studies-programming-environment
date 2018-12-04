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

# Get number of lines added / removed.
SUM_ADDED=`git --no-pager log $BRANCH --author="$EMAIL" --shortstat --oneline \
 | awk 'NR % 2 == 0' \
 | grep -Po '[0-9]*(?=\ insertion)' \
 | awk '{s+=$1} END {print s}'`

SUM_DELETED=`git --no-pager log $BRANCH --author="$EMAIL" --shortstat --oneline \
 | awk 'NR % 2 == 0' \
 | grep -Po '[0-9]*(?=\ deletion)' \
 | awk '{s+=$1} END {print s}'`

# Set 0 if empty.
[[ -z "$SUM_ADDED" ]] && SUM_ADDED=0
[[ -z "$SUM_DELETED" ]] && SUM_DELETED=0

echo 'User '$EMAIL' has made '$NUM_OF_COMMITS' commits; added '$SUM_ADDED' lines and deleted '$SUM_DELETED'.'
