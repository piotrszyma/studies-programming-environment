#
# Script counts number of commits, lines added and removed for user in SVN repo.
#
#   Example of usage: bash task1.sh https://156.17.7.16/p_25/ 229735
#

REPO=$1
USERNAME=$2

# For listing number of commits.
NUM_OF_COMMITS=`svn log -v --xml $REPO | grep '<author>'$USERNAME'</author>' | wc -l`

# For getting number of lines added / removed.
SUM_ADDED=0
SUM_DELETED=0

# Loop through author's revisions.
for i in `svn log -v --xml $REPO | grep -B 1 '<author>'$USERNAME'</author>' | awk 'NR % 3 == 1' | grep -Po '\d+'`; do
  REV=$i

  # Get lines added in revision using diffstat.
  for ADDED_PER_COMMIT in `svn diff $REPO -c $REV | diffstat -t | awk -F "," '{print $1}' | awk 'NR>1' | awk '{s+=$1} END {print s}'`; do
    SUM_ADDED=`expr $SUM_ADDED + $ADDED_PER_COMMIT`
  done

  # Get lines deleted in revision using diffstat.  
  for DELETED_PER_COMMIT in `svn diff $REPO -c $REV | diffstat -t | awk -F "," '{print $2}' | awk 'NR>1' | awk '{s+=$1} END {print s}'`; do
    SUM_DELETED=`expr $SUM_DELETED + $DELETED_PER_COMMIT`
  done
done

echo 'User '$USERNAME' has made '$NUM_OF_COMMITS' commits; added '$SUM_ADDED' lines and deleted '$SUM_DELETED'.'
