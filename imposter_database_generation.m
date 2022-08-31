clc;
close all;
clear all;

load('train.mat');
no_spk=size(gen_cell,1);

load('Test.mat');
imp_cell=cell(no_spk,1);
n=cell2mat(gen_cell(:,1))';
for i=1:no_spk
    cohort_id=spk_mat(i,2:5);
    Imp_spk_id = setxor(n,cohort_id);
    indx=randperm(no_spk-4,10);
    Imp_spk_id1=Imp_spk_id(indx);
    cohort_id1=repmat(cohort_id,10,1);
    Imp_mat=[Imp_spk_id1' cohort_id1];
    imp_cell{i,1}=Imp_mat;
end
save('Test','gen_cell_test','name_cell','sp_mat','spk_mat','spk_mat1','imp_cell');