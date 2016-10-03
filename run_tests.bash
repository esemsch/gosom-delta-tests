set -e

REPO=github.com/esemsch
PROJECT=gosom
TEST_DIR=tested_source
OUTPUT_DIR=output
BRANCH=master
ACCEPTED_COMMIT=`cat accepted_commit.txt`

while getopts :b: OPTION; do
	case $OPTION in
		b)
			BRANCH=$OPTARG
			;;
		?)
			echo -e \\n"Option -${BOLD}$OPTARG${NORM} not allowed."
			exit;
			;;
	esac
done

#trap exit
function exitHandler() {
	if [[ $? == 0 ]]; then
		echo SUCCESS
	else
		echo FAILURE
		exit 1
	fi
}
trap exitHandler EXIT

echo "Cleaning up"
rm -rf $TEST_DIR $OUTPUT_DIR
mkdir -p $TEST_DIR/src/$REPO
mkdir -p $OUTPUT_DIR
export GOPATH=`readlink -f tested_source`

echo "Running Accepted"
pushd $TEST_DIR/src/$REPO
git clone https://$REPO/$PROJECT
pushd gosom
git checkout $ACCEPTED_COMMIT
go build
popd
popd
go run run.go > $OUTPUT_DIR/accepted.txt

echo "Running New"
pushd $TEST_DIR/src/$REPO/$PROJECT
git checkout origin/$BRANCH
go build
popd
go run run.go > $OUTPUT_DIR/new.txt

diff $OUTPUT_DIR/accepted.txt $OUTPUT_DIR/new.txt
