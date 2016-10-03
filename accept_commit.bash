set -e

REPO=github.com/esemsch
PROJECT=gosom
TEST_DIR=tested_source

if [[ -n `git status -s` ]]; then echo "Cannot proceed, working copy is dirty: $(git status -s)."; exit 1; fi

pushd $TEST_DIR/src/$REPO/$PROJECT
COMMIT_TO_ACCEPT=`git rev-parse HEAD`
popd
echo $COMMIT_TO_ACCEPT > accepted_revision.txt
echo "Setting accepted revision to $COMMIT_TO_ACCEPT"
git commit -a -m "Setting accepted revision to $COMMIT_TO_ACCEPT. {1:-}"
git push
