REPO=$1
USERNAME=$2

# For listing number of commits
SVN_LOG=`svn log -v --xml $1`
NUM_OF_COMMITS=`echo $SVN_LOG | grep '<author>'$2'</author>' | wc -l`


# For getting number of lines added / removed

SUM_ADDED=0
SUM_DELETED=0

for i in `echo $SVN_LOG | grep -B 1 '<author>'$2'</author>' | awk 'NR % 3 == 1' | grep -Po '\d+'`; do

  if [ "$i" -eq 0 ]
  then
    continue
  fi

  DIFFSTAT=`svn diff https://156.17.7.16/p_25/ -r $PREREV:$REV | diffstat -t`
  REV=$i
  PREREV=`expr $REV - 1`

  for ADDED_PER_COMMIT in `echo $DIFFSTAT | awk -F "," '{print $1}' | awk 'NR>1'`; do
    SUM_ADDED=`expr $SUM_ADDED + $ADDED_PER_COMMIT`
  done
  
  for DELETED_PER_COMMIT in `echo $DIFFSTAT | awk -F "," '{print $2}' | awk 'NR>1'`; do
    SUM_DELETED=`expr $SUM_DELETED + $DELETED_PER_COMMIT`
  done
done

echo 'User '$USERNAME' has made '$NUM_OF_COMMITS' commits; he added '$SUM_ADDED' lines and deleted '$SUM_DELETED' lines.'
