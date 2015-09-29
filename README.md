#Smoothed Bootstrap Aggregation (SBA)

SBA is a method that uses bootstrapping of site patterns and borrows kernel
smoothing techniques from machine learning to account for errors in maximum
likelihood parameter estimates in codeml [1].  It is currently working with
codon models M2a and M8.

To use the method, codeml must be run three times.

First, a number of bootstrap samples must be generated from a sequence alignment.
To do this, run codeml with ```bootstrap = N``` in the control file, where
```N``` is the number of bootstrap samples to generate.

Second, parameters must be estimated for each of the bootstrap samples.  To do
this, run codeml with ```sba = 1``` and ```ndata = N``` in the control file.
The ````seqfile```` entry in the control file must be set to file containing the
boostrap sequence alignments, which, by default is boot.txt.  Don't forget to
comment out the ```bootstrap = N``` line that was set in the previous step.

Third, the p-parameters of the omega distribution must be smoothed and posterior
probabilities for each set of parameters must be calculated using the original
sequence alignment, so ````seqfile```` must again point to same file from the
first step.  The amount of smoothing is controlled by a kernel bandwidth
parameter.  Specify this value with ```h = x``` in the control file, where
```x``` is a values between 0 and 1.  For this final stage, ```sba = 2``` must
also be present in the control file.

Below are the relevant parameters for SBA in the control file.

       seqfile   = input.seq * steps 1 and 3
       seqfile   = boot.txt  * contains boostrap alignemnts (step 2 only)
       ndata     = 2         * step 2 only
       bootstrap = 2         * step 1, generate N boostrap sequence alignments
       sba       = 1         * step 2, estimate parameters for bootstrap alignments
       sba       = 2         * step 3, smoothing and calculated posterior probabilities
       h         = 0.4       * step 3, smoothing bandwidth parameter (0 <= h <= 1)

The output file ```sba_ps.csv``` will be created.  Each row of this file
contains the site posterior probabilities for positive selection associated with
one set of model parameters [2].  Column ```i``` of the file contains the
posterior probabilities for site ```i``` over all sets of model parameters.
Inferences should be based on the average posterior probabilities for a site,
i.e., inference for site ```i```, should be based on the average of column ```i```.

[1] Yang, Ziheng. "PAML 4: phylogenetic analysis by maximum likelihood." Molecular biology and evolution 24.8 (2007): 1586-1591.

[2] The value of omega for the positive selection category is added on to the end of each row.