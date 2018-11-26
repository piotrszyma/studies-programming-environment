REPO=$1

USERS=`svn log --quiet $REPO | grep "^r" | awk '{print $3}' | sort | uniq`

echo $REPO

for USER in $USERS; do
  echo 'Checking for '$USER
  bash task1.sh $REPO $USER;
done



