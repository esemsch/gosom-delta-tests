set -e

REPO=github.com/esemsch
PROJECT=gosom
TEST_DIR=tested_source
OUTPUT_DIR=output

echo "Cleaning up"
rm -rf $TEST_DIR $OUTPUT_DIR
mkdir -p $TEST_DIR/src/$REPO
mkdir -p $OUTPUT_DIR
export GOPATH=`readlink -f tested_source`

echo "Running Accepted"
pushd $TEST_DIR/src/$REPO
git clone https://$REPO/$PROJECT
pushd gosom
git checkout 86f31f623889b2676c25243937282225569305bf
go build
popd
popd
go run run.go > $OUTPUT_DIR/accepted.txt

echo "Running New"
pushd $TEST_DIR/src/$REPO/$PROJECT
git checkout origin/master
go build
popd
go run run.go > $OUTPUT_DIR/new.txt

diff $OUTPUT_DIR/accepted.txt $OUTPUT_DIR/new.txt
if [[ $? == 0 ]]; then
	echo SUCCESS
else
	echo FAILURE
	exit 1
fi
