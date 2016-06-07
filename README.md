#Smoothed Bootstrap Aggregation (SBA)

SBA is a method that uses bootstrapping of site patterns and kernel smoothing to
account for errors in maximum likelihood parameter estimates in codeml [1].  It
is currently working with codon models M2a, branch-site A, and M8.

#Installation

On systems with BSD make, simply run ```make```.  On systems with GNU make, such
as GNU/Linux and OS X run ```make -f Makefile.gnu```.  Install the resulting
executable, ```codeml_sba```, wherever you like, although you probably want it
somewhere in your executable path.

#Usage

To use the method, ```codeml_sba``` must be run three times.

#### Step 0
First, a number of bootstrap samples must be generated from a sequence
alignment.  To do this, run ```codeml_sba``` with ```bootstrap = N``` in the
control file, where ```N``` is the number of bootstrap samples to generate.

#### Step 1
Next, parameters must be estimated for each of the bootstrap samples.  To do
this, run ```codeml_sba``` with ```sba = 1``` and ```ndata = N``` in the control
file.  The ````seqfile```` entry in the control file must be set to a file
containing the boostrap sequence alignments, which, by default is
```boot.txt```.  Don't forget to comment out the ```bootstrap = N``` line that
was set in the previous step.

#### Step 2
Finally, the p-parameters of the omega distribution must be smoothed and
posterior probabilities for each set of parameters must be calculated using the
original sequence alignment, so ````seqfile```` must again point to same file
from step 0.  The amount of smoothing is controlled by a kernel bandwidth
parameter.  Specify this value with ```h = x``` in the control file, where
```x``` is a values between 0 and 1.  For this final stage, ```sba = 2``` must
also be present in the control file.

Below are the relevant parameters for SBA in the control file.  Only activate
the SBA parameters in the current step and comment those in the other steps.

      * step 0
      seqfile   = input.seq * contains sequence alignment
      bootstrap = N         * generate N boostrap sequence alignments

      * step 1
      seqfile   = boot.txt  * contains boostrap sequence alignemnts
      ndata     = N         * N bootstrap alignments
      sba       = 1         * estimate parameters for each bootstrap alignment

      * step 2
      seqfile   = input.seq * contains sequence alignment
      h         = 0.4       * smoothing bandwidth parameter (0 <= h <= 1)
      sba       = 2         * smooth and calculate posterior probabilities


The output file ```sba_ps.csv``` will be created (or
```sba_foreground_branches_ps.csv``` if you are running a branch-site model) .
Each row of this file contains the site posterior probabilities for positive
selection associated with one set of model parameters [2].  Column ```i``` of
the file contains the posterior probabilities for site ```i``` over all sets of
model parameters.  Inferences should be based on the average posterior
probabilities for a site, i.e., inference for site ```i```, should be based on
the average of column ```i```.  In column ```i+1``` the associated ω estimate is
printed.

[1] Yang, Ziheng. "PAML 4: phylogenetic analysis by maximum
likelihood." Molecular biology and evolution 24.8 (2007): 1586-1591.

[2] The value of omega for the positive selection category is added on
to the end of each row.
