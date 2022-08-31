clc;
clear;
close all;
addpath(genpath('bosaris_toolkit'));
load('/home/ramesh/Desktop/Santosh/28-04-2017/TDSV_CDTW/Codes/Abhi_Code/Scores.mat')
load('/home/ramesh/Desktop/Santosh/28-04-2017/TDSV_CDTW/Codes/Abhi_Code/Scores2.mat')
no_gen_test=3;
users = size(GScore1,1);
[fuse_cell,dst_gen,dst_forg] = dst_fuse_bos(GScore1(:,2),GScore2(:,2),ImpScore1,ImpScore2,no_gen_test);

r_loop=1
% cnt = 1;ws_mat = zeros(2,11);
eer_mat = zeros(users,r_loop);
meer_mat = zeros(1,r_loop);
ceer_mat = meer_mat;
% for lp=1:r_loop
%     d1_cell = test_cell(:,lp);%% d1 distance values of all users
%     d2_cell = test_cell1(:,lp);%% d2 distance values of all users
%     tr_cell = ref_cell(:,lp); %% d1(upper row) & d2 (lower row) distance of reference signatures in 2xN format
%     [nd_mat,dst_gen,dst_forg] = dst_fuse_bos1(d1_cell,d2_cell,tr_cell,rforg_cell,no_gen_test);%% fusion and normalization of all users values
    
    for uid=1:users
        dgen = fuse_cell{1,uid};
        dforg = fuse_cell{2,uid};
        ueer = eer(dgen,dforg);
        eer_mat(uid,r_loop) = ueer;
    end
    meer = mean(eer_mat(:,r_loop),1);
    disp('meer')
    meer_ct = eer(dst_gen,dst_forg);
    disp('meer_ct')
%     meer_mat(1,r_loop) = meer;
%     ceer_mat(1,r_loop) = meer_ct;
% end
% MEER = mean(meer_mat)*100;
% disp(MEER);
% CEER = mean(ceer_mat)*100;
% disp(CEER);