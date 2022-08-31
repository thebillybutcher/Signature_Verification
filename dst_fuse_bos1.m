function [nd_mat,dst_gen,dst_forg] = dst_fuse_bos(GScore1(:,2),GScore2(:,2),ImpScore1(:,2),ImpScore2(:,2),no_gen_test);

%% fd_mat  = fused distance of each user given separately
%% dst_gen  = genuine fused distance of all users pooled together
%% dst_forg  = Imposter fused distance of all users pooled together
%% rforg_cell = contains random imposter distance values

users=size(d1cell,1);
no_test_sign = size(d1cell{1,1},2);
% no_forg = no_test_sign-no_gen_test;
fuse_cell = cell(users,1);mtr_vec=zeros(users,1);
no_gen_train = size(tr_cell{1,1},2);
no_rforg_train = size(rforg_cell{1,1},2);
% nd_cell = cell(users,1);
train_labels = [ones(1,no_gen_train),-ones(1,no_rforg_train)];
% create and train a function that fuses the scores from the two systems.
quiet = true; % don't display output during fusion training
maxiters = 100; % maximum number of training iterations
obj_func = [];  % use the default objective function: cllr objective

for uid=1:users
    %% Training of linear classifier
    gen_mat = tr_cell{uid,1};
    rforg_mat = rforg_cell{uid,1};
    train_scores = [gen_mat(1,:),rforg_mat(1,:);gen_mat(2,:),rforg_mat(2,:)];
    fusion_func = train_linear_fuser(train_scores,train_labels,0.5,true,quiet,maxiters,obj_func);
    %% Testing of linear classifier
    d1 = mean(d1cell{uid,1},1);
    d1_tr = d1(1:no_gen_test);
    d1_non = d1(no_gen_test+1:no_test_sign);
    d2 = mean(d2cell{uid,1},1);
    d2_tr = d2(1:no_gen_test);
    d2_non = d2(no_gen_test+1:no_test_sign);
    test_scores = [d1_tr,d1_non;d2_tr,d2_non];
    fused_score = fusion_func(test_scores)';
%     fused_tr = fusion_func(tr_mat);
%     mtr = min(trf_vec);
%     mtr = mean(fused_tr);
    fuse_cell{uid,1} = fused_score;
%     mtr_vec(uid,1) = mtr;
%     nd_cell{uid,1} = (fused_score-mtr);
end
fd_mat = cell2mat(fuse_cell);
% nd_mat = cell2mat(nd_cell);
% dst_gen = nd_mat(:,1:no_gen_test);
% dst_gen = dst_gen(:)';
% dst_forg = nd_mat(:,no_gen_test+1:no_test_sign);
% dst_forg = dst_forg(:)';
dst_gen = fd_mat(:,1:no_gen_test);
dst_gen = dst_gen(:)';
numtar = length(dst_gen);
dst_forg = fd_mat(:,no_gen_test+1:no_test_sign);
dst_forg = dst_forg(:)';
numnon = length(dst_forg);
scr = [dst_gen,dst_forg];
cal_func = train_linear_calibration(dst_gen,dst_forg,0.5,obj_func,maxiters,quiet);
ct_scr = cal_func(scr);
dst_gen = ct_scr(1:numtar);
dst_forg = ct_scr(numtar+1:numtar+numnon);
end