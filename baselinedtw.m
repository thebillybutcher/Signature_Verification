function [dst]=baselinedtw(s1,s2)
lr=length(s1);
lc=length(s2);


%% Calculation of accumulated cost matrix
acc_cost_mat=zeros(lr,lc);
for i=2:lr
    for j=2:lc
        t=[acc_cost_mat(i-1,j-1) acc_cost_mat(i,j-1) acc_cost_mat(i-1,j)];
        acc_cost_mat(i,j)=cost_mat(i,j)+min(t);
    end
end

%disp(acc_cost_mat);

%% Finding DTW path
dst=acc_cost_mat(lr,lc);
[dpath]=dtw_path(acc_cost_mat);
lng=length(dpath);

dst=dst/lng;
