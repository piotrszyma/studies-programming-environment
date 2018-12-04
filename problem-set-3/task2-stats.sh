#
# Script for bulk count of number of commits, lines added and removed for all users in GIT repo.
#
#   bash task2-stast.sh <branch> <?repo url>
#
#   Example of usage: bash task2-stats.sh master
#   Example of usage: bash task2-stats.sh master git@github.com:piotrszyma/bemar-odziez.git
#

BRANCH=$1
REPO=$2

# If repo not provided, assumes in repo dir.
if [[ $# -eq 2 ]] ; then
  rm -rf /tmp/repo
  git clone $REPO /tmp/repo
  cd /tmp/repo
fi

# Get all users' emails.
USERS=`git log --pretty="%ae" | sort -n | uniq`

for USER in $USERS; do
  # Run task2.sh for each user on specific branch.
  bash task2.sh $USER $BRANCH &
done

wait