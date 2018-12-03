#
# Script for bulk count of number of commits, lines added and removed for all users in SVN repo.
#
#   Example of usage: bash task1-stats.sh https://156.17.7.16/p_25/
#

REPO=$1

USERS=`svn log --quiet $REPO | grep "^r" | awk '{print $3}' | sort | uniq`

echo 'Stats for repository: '$REPO

for USER in $USERS; do
  bash task1.sh $REPO $USER &
done

wait
