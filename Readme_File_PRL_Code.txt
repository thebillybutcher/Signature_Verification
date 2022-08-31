Readme File of MATLAB Code for Paper titled:  

`An enhanced contextual DTW based system for online signature verication using Vector Quantization'.
-------------------------------------------------------------------------------------------------------------------------------

It is suggested to  first run the baseline DTW system and then the  proposed algorithm.

The instructions to run the baseline DTW  are as follows: (MATLABR-2012b is used)

Please follow the steps:

(1) Execute the " main_program_baseline_dtw.m " file to start the signature verification  process  of the Baseline DTW system.  

(2) The execution may take time (about 2 hours), to get the EER, as there are  100 users in MCYT Database, with 5 enrolled signature per user.

(3) We consider only one repetition of an experiment protocol for demonstration. Note that the results cited in manuscript are for 5 repetitions.
 The random sampling of  signatures  (for enrollment and evaluation) in the iteration are saved to run the proposed algorithm  " main_program_enhanced_dtw.m " .


(4) Execute the " main_program_enhanced_dtw.m " file to start the signature verification  process with the Enhanced DTW system, discussed in the proposal in Subsections 3.4 and 3.5.


(5) The code-book size used is 32 and window length values= 13 for the current implementation.  
The number of signatures enrolled per user =5. 
Number of users =100.
The weighted product rule scheme is used for illustrating the reproducibilty, with  alpha value=2.
 

(6)  Note that the execution may take  time (in 2 Hours) to get the EER, as there are 100 users in MCYT Database.

-------------------------------------------------------------------------------------------------------------------------------


The reviewer can note that the proposed  methodology  " main_program_enhanced_dtw.m "  does comparatively better than  baseline DTW algorithm " main_program_baseline_dtw.m ".  

--------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

The  user defined functions used  are as follows:

(1) dtw_vq.m : Calculates the contextual DTW  and VQ based scoring distance between online signatures.

(2) dtw_path.m : it provides the pair of point indices of two aligned signatures.

(3) vqsplit.m: it provides the code-vectors using the LBG Algorithm.

(4) VQIndex: It assigns the cluster index to each  point based feature vector of a signature.

(5) VQCompare: It compares the clusers index of all possible point pairs of two signature.

(6) baselinedtw.m  :   Computation of baseline DTW score

(7) ceer_baseline.m  : performs the EER computation of baseline DTW 

(8) wp_dst_fuse.m : Combination of the scores using weighted product rule.


--------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

The details of mat files provided are as follows:

(1) gen_ftr.mat: It contains the five dimensional feature vector of genuine signatures (discussed in subsection 3.1 of paper) 
 of all users of MCYT database.
 
f = [delx,dely,delp,sin(theta),cos(theta)];

(2) forg_ftr.mat: It contains the five dimensional feature vector of forgery signatures (discussed in subsection 3.1 of paper) of all users of MCYT database.    
 
f = [delx,dely,delp,sin(theta),cos(theta)];

------------------------------------------------------------------------------------------------------------------------