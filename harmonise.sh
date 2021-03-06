#!/bin/bash

set -e

# HARMONYDIR is the directory containing the scripts and original data
# edit to set HARMONYDIR to the correct directory when the script is run
# [ -d $HARMONYDIR/music/ ] || export HARMONYDIR=$HOME/work/harmony-new/
[ -d $HARMONYDIR/music/ ] || export HARMONYDIR=./
[ -d $HARMONYDIR/music/ ] || ( echo Unable to find files, please set HARMONYDIR to the install directory. ; exit 1 )

# HARMONYOUTPUTDIR is the directory where the models should be saved
# edit to set HARMONYOUTPUTDIR to the correct directory when the script is run
[ -n "$HARMONYOUTPUTDIR" ] || export HARMONYOUTPUTDIR=$HARMONYDIR
mkdir -p $HARMONYOUTPUTDIR
[ -w $HARMONYOUTPUTDIR ] || ( echo Unable to write to ${HARMONYDIR}, will use /tmp/ instead. ; HARMONYOUTPUTDIR=/tmp/ )

echo Using data/programs in \'$HARMONYDIR\'.
echo Writing output to \'$HARMONYOUTPUTDIR\'.
echo

# ensure we have Perl in $PATH
which perl >/dev/null || ( echo Unable to find Perl interpreter. ; exit 1 )

# ensure programs are compiled, ready to use below
make -C $HARMONYDIR/chorale-c/ HARMONYDIR="$HARMONYDIR" MODELDIR="$HARMONYOUTPUTDIR"

for DATASET in dur moll; do
  TRAIN=train_$DATASET
  TEST=test_$DATASET
  STAGE1=chords-$DATASET
  STAGE2=ornamentation-$DATASET
  perl -I$HARMONYDIR/chorale-perl $HARMONYDIR/chorale-perl/hmm-data.pl $STAGE1 chordtransposed/HARMONIK SOPRAN $TRAIN $TEST
  $HARMONYDIR/chorale-c/prob $STAGE1 evaluate viterbi
  perl -I$HARMONYDIR/chorale-perl $HARMONYDIR/chorale-perl/hmm-output-expand.pl $STAGE1 viterbi
  perl -I$HARMONYDIR/chorale-perl $HARMONYDIR/chorale-perl/hmm-ornamentation-data.pl $STAGE2 $STAGE1 viterbi $TRAIN $TEST
  $HARMONYDIR/chorale-c/prob $STAGE2 evaluate viterbi-test
  perl -I$HARMONYDIR/chorale-perl $HARMONYDIR/chorale-perl/hmm-ornamentation-expand.pl $STAGE2 $STAGE1 viterbi viterbi

  echo
  echo Output files are in $HARMONYOUTPUTDIR/model-$STAGE2/viterbi-results/
  echo
  echo If you have timidity installed then you can use playchorale.sh to play them back.
done
