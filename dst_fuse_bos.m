function [fuse_cell,dst_gen,dst_forg] = dst_fuse_bos(GScore1,GScore2,ImpScore1,ImpScore2,no_ref);

%% fd_mat  = fused distance of each user given separately
%% dst_gen  = genuine fused distance of all users pooled together
%% dst_forg  = Imposter fused distance of all users pooled together
%% rforg_cell = contains random imposter distance values

users=size(GScore1,1);
no_test_sign = size(GScore1{1,1},2);
% no_forg = no_test_sign-no_gen_test;
fuse_cell = cell(2,users);
no_rforg_train = no_test_sign-no_ref;
% nd_cell = cell(users,1);
% train_labels = [ones(1,no_ref),-ones(1,no_rforg_train)];
% create and train a function that fuses the scores from the two systems.
quiet = true; % don't display output during fusion training
maxiters = 100; % maximum number of training iterations
obj_func = [];  % use the default objective function: cllr objective

for uid=1:users
    No_files = size(GScore1{uid,1},1);
    train_labels = [ones(1,no_ref*No_files),-ones(1,no_rforg_train*No_files)];
    %% Training of linear classifier
    gen_mat1 = GScore1{uid,1}(:,1:no_ref);
    gen_mat1 = gen_mat1(:)';
    rf_mat1 = GScore1{uid,1}(:,no_ref+1:no_test_sign);
    rf_mat1 = rf_mat1(:)';
    gen_mat2 = GScore2{uid,1}(:,1:no_ref);
    gen_mat2 = gen_mat2(:)';
    rf_mat2 = GScore2{uid,1}(:,no_ref+1:no_test_sign);
    rf_mat2 = rf_mat2(:)';
    train_scores = [gen_mat1,rf_mat1;gen_mat2,rf_mat2];
    fusion_func = train_linear_fuser(train_scores,train_labels,0.5,true,quiet,maxiters,obj_func);
    %% Testing of linear classifier
    gen_mat1 = GScore1{uid,1}(:,1:no_ref);
    gen_mat1 = gen_mat1(:)';
    no_gen_test=length(gen_mat1);
    imp_mat1 = ImpScore1{uid,1}(:,no_ref+1:no_test_sign);
    imp_mat1 = imp_mat1(:)';
    gen_mat2 = GScore2{uid,1}(:,1:no_ref);
    gen_mat2 = gen_mat2(:)';
    imp_mat2 = ImpScore2{uid,1}(:,no_ref+1:no_test_sign);
    imp_mat2 = imp_mat2(:)';
    
    test_scores = [gen_mat1,imp_mat1;gen_mat2,imp_mat2];
    fused_score = fusion_func(test_scores)';
    
    
    fuse_cell{1,uid}=fused_score(1,1:no_gen_test);
    fuse_cell{2,uid}=fused_score(1,no_gen_test+1:end);
    
%     fused_tr = fusion_func(tr_mat);
%     mtr = min(trf_vec);
%     mtr = mean(fused_tr);
%     fuse_cell{uid,1} = fused_score;
%     mtr_vec(uid,1) = mtr;
%     nd_cell{uid,1} = (fused_score-mtr);
end
% fd_mat = cell2mat(fuse_cell);
% nd_mat = cell2mat(nd_cell);
% dst_gen = nd_mat(:,1:no_gen_test);
% dst_gen = dst_gen(:)';
% dst_forg = nd_mat(:,no_gen_test+1:no_test_sign);
% dst_forg = dst_forg(:)';
dst_gen = cell2mat(fuse_cell(1,:));
% dst_gen = dst_gen(:)';
numtar = length(dst_gen);
dst_forg = cell2mat(fuse_cell(2,:));
% dst_forg = dst_forg(:)';
numnon = length(dst_forg);
scr = [dst_gen,dst_forg];
cal_func = train_linear_calibration(dst_gen,dst_forg,0.5,obj_func,maxiters,quiet);
ct_scr = cal_func(scr);
dst_gen = ct_scr(1:numtar);
dst_forg = ct_scr(numtar+1:numtar+numnon);
end