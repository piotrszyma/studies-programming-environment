REPO=$1

USERS=`svn log --quiet $REPO | grep "^r" | awk '{print $3}' | sort | uniq`

echo 'Stats for repository: '$REPO

for USER in $USERS; do
  bash task1.sh $REPO $USER &
done

wait



