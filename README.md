Harmonising Chorales by Probabilistic Inference
===============================================

Copyright (C) 2005 Moray Allan

These programs are free software; you can redistribute them and/or modify
them under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

These programs are distributed in the hope that they will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with these programs; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA


Requirements
============

- GSL, BLAS, Atlas libraries.
- MIDI::Simple library, available from CPAN as part of MIDI-Perl.


music directory
===============

This contains Bach's chorales as downloaded from
ftp://i11ftp.ira.uka.de/pub/neuro/dominik/midifiles/bach.zip


harmonise.sh
============

./harmonise.sh

Generates the most probable harmonisations under the model.

Creates a chord model 'model-chords' and finds the most probable harmonisation
for each test chorale under this model, then creates an ornamentation model
'model-ornamentation' and finds the most probable ornamentation for each of
the generated chords, giving final ornamented harmonisations in the directory
'model-ornamentation/viterbi-results'.

Also evaluates the performance of the models, and prints comparative 
statistics, given as log-probabilities per symbol (sample cross-entropies).


notatechorale.sh
================

./notatechorale.sh FILENAME

Typesets a chorale data file in music notation, using the lilypond music
notation program.


playchorale.sh
==============

./playchorale.sh FILENAME

Plays back a chorale data file, using the timidity MIDI synthesiser.


prob
====

./chorale-c/prob MODELNAME evaluate

Trains an HMM using the input data for the named model (e.g. 'chords'), and
evaluates how well it fits the data, also comparing performance against
some simpler models.

./chorale-c/prob MODELNAME viterbi

Trains an HMM using the input data for the named model, and finds the most
probable state sequence for each entry in the test set of original
harmonisations.

./chorale-c/prob MODELNAME viterbi-test

Trains an HMM using the input data for the named model, and finds the most
probable state sequences for each entry in the test set, using the sequences
in 'input-test' rather than 'input'.  This is used to find ornamentations
for chord sequences generated by a previous HMM, where the test data is not
taken directly from Bach's harmonisations.

./chorale-c/prob MODELNAME sample [seed=N]

Trains an HMM using the input data for the trained model, and samples a state
sequence for each entry in the test set.  An initial seed for the random
number generator may be given.