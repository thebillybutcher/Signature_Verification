clc;
clear all;
close all;
no_users=100;                                                 
no_gen_sign=25;                                                
no_forg_sign=25;                                               
load gen_ftr;                                                  %%%% feature vectors of genuine signatures
load forg_ftr;                                                 %%%% feature vectors of forgery signatures
load BASELINEDTW_PERF;
fprintf('Enhanced DTW performance evaluation');

load g_indx_mat;
  r_loop=1;                                                  

dmat_cell=cell(no_users,r_loop);
dmat_cell1=dmat_cell;
tngcell = dmat_cell1;


 no_train=5;                                            
 no_gen_test  = no_gen_sign - no_train;                       
 no_test_sign = no_gen_test+no_forg_sign;                   
 mat_a = g_indx_mat(1:r_loop,1:no_train);
 tcell=cell(no_train,1);
   

    codebook_size=32;                                         
      
      
    ceer_mat_wtprod=zeros(r_loop,1);
                 
    for itr=1:r_loop                                          
      fprintf('\n\n Single Repetition of experiment');                                                       
            a=mat_a(itr,:);       %  Genuine Training file + indices of enrolled signatures for training
            b=1:no_gen_sign;      %  Genuine Testing file 
            b=setxor(b,a);        % indices of  signatures for testing + setxor sets the value that are not in intersection of a and b
            
            
            for user =1:no_users
            
                tr_sign=a(1:no_train);
          
                                  % CODE BOOK  GENERATION  %
     
                tr_cell=gen(user,tr_sign);
                tcell(1:no_train,1)=tr_cell(1:no_train);
                t=cell2mat(tcell)';
                [code]=vqsplit(t,codebook_size);
               
              
                
                                   %%% CODE BOOK INDICE ASSIGNMENT TO
                                   %%% FEATURE VECTORS   %% %%%
                  
                   
                gen_ind_dst = cell(no_gen_sign,2);
                forg_ind_dst = cell(no_forg_sign,2);


                for i = 1:no_train
                    [gen_ind_dst{a(i),1},gen_ind_dst{a(i),2}] = VQIndex(gen{user,a(i)}',code);
                end


                for i = 1:no_gen_test
                    [gen_ind_dst{b(i),1},gen_ind_dst{b(i),2}] = VQIndex(gen{user,b(i)}',code);
                end


                for i = 1:no_forg_sign
                    [forg_ind_dst{i,1},forg_ind_dst{i,2}] = VQIndex(forg{user,i}',code);
                end
                
                                %% Training of system   : DTW and VQ based feature calculation betwen pairs of enrolled signatures
                k=1;
                tr_mat=zeros(no_train*(no_train-1)/2,2);


                for i=1:no_train-1
                    for j=i+1:no_train
                        [bool]=VQCompare(gen_ind_dst{a(i),1},gen_ind_dst{a(j),1});
                        [tr_mat(k,1),tr_mat(k,2)]=dtw_vq(gen{user,a(i)},gen{user,a(j)},bool,width);
                        k=k+1;
                    end
                end
                tngcell{user,itr} = tr_mat;

                           %% Testing of system : DTW and VQ based feature calculation on  test signatures being matched to enrolled signatures

                            % mat1 and mat2 are used for computing the
                            % baseline DTW scores

                            % mat3 and mat4 are used for computing the
                            % enhanced DTW scores with VQ integration

                          mat1=zeros(no_train,no_gen_test);
                          mat3=mat1;
                          mat2=zeros(no_train,no_forg_sign);
                          mat4=mat2;
                           
                for i=1:no_train
                    for j=1:no_gen_test
                        [bool]=VQCompare(gen_ind_dst{a(i),1},gen_ind_dst{b(j),1});
                        [mat1(i,j),mat3(i,j)]=dtw_vq(gen{user,a(i)},gen{user,b(j)},bool,width);
                    end
                end

                for i=1:no_train
                    for j=1:no_forg_sign
                        [bool]=VQCompare(gen_ind_dst{a(i),1},forg_ind_dst{j,1});
                        [mat2(i,j),mat4(i,j)]=dtw_vq(gen{user,a(i)},forg{user,j},bool,width);
                    end
                end
                
                dmat=[mat1,mat2];dmat1=[mat3,mat4];
                dmat_cell{user,itr}=dmat;
                dmat_cell1{user,itr}=dmat1;
            end
                                                 %%% Computation of EER of enhanced system
                                                 %%% Combination Schemes --- weighted product rule  %%%%%
              
            d1cell = dmat_cell(:,itr);d2cell = dmat_cell1(:,itr);
            trn_cell = tngcell(:,itr);
           
                
          
            [dst_gen,dst_forg] = wp_dst_fuse(d1cell,d2cell,trn_cell,2,no_gen_test);   %%% weighted prod rule alpha value = 2     
            [~,~,~,ct_eer_wtprod]=fastEval(dst_gen,dst_forg,0.1);                                   
             fprintf('\n EER is  %4f', ct_eer_wtprod*100);
            
    end
    
  fprintf('\n \n Baseline DTW scheme EER is  %4f', CEER);
























  addpath(genpath('bosaris_toolkit'));
