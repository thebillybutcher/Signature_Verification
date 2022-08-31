clc;
clear all;
close all;
addpath(genpath('bosaris_toolkit'));
no_users=100;                                                  %%%% Number of  users
no_gen_sign=25;                                                %%%% Number of genuine signatures per user
no_forg_sign=25;                                               %%%% Number of forgery signatures per user
load gen_ftr;                                                  %%%% Point based feature vectors correspondinng to the set of genuine signatures of all users
load forg_ftr;                                                 %%%% Point based feature vectors correspondinng to the  set of forgery signatures of all users
r_loop=1;                                                     %%% number of repetitions=1

fprintf('Baseline DTW performance evaluation');
%%% Random selection of signatures (for enrolment and evaluation) from each
%%% user of MCYT database

f_indx = 1:no_forg_sign;
g_indx_mat = zeros(r_loop,no_gen_sign+no_forg_sign);
for i=1:r_loop
    g_indx = randsample(no_gen_sign,no_gen_sign)';
    indx = [g_indx,f_indx];
    g_indx_mat(i,:) = indx;
end

save g_indx_mat g_indx_mat;

dmat_cell=cell(no_users,r_loop);
dmat_cell1=dmat_cell;
tngcell = dmat_cell1;

     no_train=5;                                                   %%% no of enrolled genuine signatures in each repetition=5 per user
    no_gen_test = no_gen_sign-no_train;                        %% no of genuine signatures in each repetition for testing = 20 per user
    no_test_sign=no_gen_test+no_forg_sign;                     %% Total no of  signatures in each repetition for testing =45 per user
    mat_a=g_indx_mat(1:r_loop,1:no_train);
    tcell=cell(no_train,1);
   
  
        ceer_mat = zeros(r_loop,1);
  
        for itr=1:r_loop
    fprintf('\n \n Single Repetition of experiment');
                                                    
        a=mat_a(itr,:);                                    %% indices of enrolled signatures for training
            b=1:no_gen_sign;                             
            b=setxor(b,a);                                     %% indices of  signatures for testing
            for user =1:no_users
             user
                tr_sign=a(1:no_train);
        
                
                                %% Training of system   : DTW  calculation betwen pairs of enrolled signatures
                k=1;
                  tr_mat=zeros(no_train*(no_train-1)/2,2);
                for i=1:no_train-1
                    for j=i+1:no_train
                        [tr_mat(k,1)]=baselinedtw(gen{user,a(i)},gen{user,a(j)});
                        k=k+1;
                    end
                end
                tngcell{user,itr} = tr_mat;

                           %% Testing of system : DTW  calculation on  test signatures being matched to enrolled signatures
               
                           mat1=zeros(no_train,no_gen_test);
                 
                          mat2=zeros(no_train,no_forg_sign);
                   
                           
                     for i=1:no_train
                    for j=1:no_gen_test
                        [mat1(i,j)]=baselinedtw(gen{user,a(i)},gen{user,b(j)});
                    end
                     end
%
                for i=1:no_train
                    for j=1:no_forg_sign
                   
                        [mat2(i,j)]=baselinedtw(gen{user,a(i)},forg{user,j});
                    end
                end
                
            dmat=[mat1,mat2];
                dmat_cell{user,itr}=dmat;
              
                
            end
            d1cell=dmat_cell(:,itr);             
             dmat=[mat1,mat2];                 
            trn_cell = tngcell(:,itr);
            [ct_eer] = ceer_baseline(d1cell,trn_cell,no_gen_test);           %%% EER computation of Baseline DTW system
             fprintf('\n EER using Baseline DTW is  %4f', ct_eer*100);
                
    end

 CEER=ct_eer*100;
 
 save BASELINEDTW_PERF CEER;