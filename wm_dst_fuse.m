
function [dst_gen,dst_forg] = wm_dst_fuse(d1cell,d2cell,tr_cell,alp,no_gen_test)
users=size(d1cell,1);
no_test_sign = size(d1cell{1,1},2);
fuse_cell = cell(users,1);mtr_vec=zeros(users,1);
nd_cell = cell(users,1);
for uid=1:users
    d1_mat = d1cell{uid,1};
    d2_mat = d2cell{uid,1};
    tr_mat = tr_cell{uid,1};
    fuse_mat = min(alp.*d1_mat,d2_mat);
    trf_vec = min(alp.*tr_mat(:,1),tr_mat(:,2));
    mf_vec = mean(fuse_mat); 
    mtr = mean(trf_vec);
    fuse_cell{uid,1} = mf_vec;
    mtr_vec(uid,1) = mtr;
    mr = (max(tr_mat(:,1))/max(tr_mat(:,2)));
    nd_cell{uid,1} = (mf_vec-mtr).*mr;
end
nd_mat = cell2mat(nd_cell);
dst_gen = nd_mat(:,1:no_gen_test);
dst_gen = -dst_gen(:)';
dst_forg = nd_mat(:,no_gen_test+1:no_test_sign);
dst_forg = -dst_forg(:)';
end