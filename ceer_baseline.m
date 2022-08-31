function [ct_eer] = ceer_baseline(d1cell,tr_cell,no_gen_test)
users=size(d1cell,1);
no_test_sign = size(d1cell{1,1},2);
fuse_cell = cell(users,1);mtr_vec=zeros(users,1);
nd_cell = cell(users,1);
for uid=1:users
    d1_mat = d1cell{uid,1};
    tr_mat = tr_cell{uid,1};
    fuse_mat = d1_mat;
    trf_vec = tr_mat(:,1);
    mf_vec = mean(fuse_mat); 
    mtr = mean(trf_vec);
    fuse_cell{uid,1} = mf_vec;
    mtr_vec(uid,1) = mtr;
    nd_cell{uid,1} = (mf_vec-mtr);
end
nd_mat = cell2mat(nd_cell);
dst_gen = nd_mat(:,1:no_gen_test);
dst_gen = -dst_gen(:)';
dst_forg = nd_mat(:,no_gen_test+1:no_test_sign);
dst_forg = -dst_forg(:)';

  [~,~,~,ct_eer]=fastEval(dst_gen,dst_forg,0.1);                                   
          