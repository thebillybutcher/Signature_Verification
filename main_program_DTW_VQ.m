clc;
close all;
clear all;

load('train.mat');
load('Test.mat');

Test_spk=size(gen_cell_test,1);
mat=cell2mat(gen_cell(:,1));
codebook_size=32;width=2;
Ref_VQ=cell(0,0);Gen_VQ=cell(0,0);Cohort_VQ=cell(0,0);Imp_VQ=cell(0,0);
GScore1=cell(0,0);GScore2=cell(0,0);ImpScore1=cell(0,0);ImpScore2=cell(0,0);
for i=1:Test_spk
    no_sp_file=sp_mat(i,1);
    spk_id=gen_cell_test{i,1};
    row_no=find(mat==spk_id);
    Train_mat=cell2mat(gen_cell(row_no,2:4)');
    [code]=vqsplit(Train_mat',codebook_size);
    cnt=1;
    for l=1:4
        Cohort_id=spk_mat1(row_no,l+1);
        for m=1:3
           Cohort_feat=gen_cell{Cohort_id,1+m};
           Cohort_Indx=VQIndex(Cohort_feat',code);
           Cohort_VQ{1,cnt}=Cohort_Indx;
           Cohort_VQ{2,cnt}=Cohort_feat;
           cnt=cnt+1;
        end
    end
    Imp_Score1=[];Imp_Score2=[];
    for k=1:no_sp_file
        Gen_feat=gen_cell_test{i,1+k};
        Gen_Indx=VQIndex(Gen_feat',code);
        Gen_VQ{i,k}=Gen_Indx;
        for j=1:3
            Ref_feat=gen_cell{row_no,1+j};
            Ref_Indx=VQIndex(Ref_feat',code);
            Ref_VQ{i,j}=Ref_Indx;
            [bool]=VQCompare(Gen_Indx,Ref_Indx);
            [Gen_Score1(k,j),Gen_Score2(k,j)]=dtw_vq(Gen_feat,Ref_feat,bool,width);
        end
        for ch=1:12
           Cohort_Indx=Cohort_VQ{1,ch};
           Cohort_feat=Cohort_VQ{2,ch};
           [bool]=VQCompare(Gen_Indx,Cohort_Indx);
           [Cohort_Score1(k,ch),Cohort_Score2(k,ch)]=dtw_vq(Gen_feat,Cohort_feat,bool,width);
        end
        Score_Genuine1(k,:)=[Gen_Score1(k,:) Cohort_Score1(k,:)];
        Score_Genuine2(k,:)=[Gen_Score2(k,:) Cohort_Score2(k,:)];
        for ii=1:10
            imp_mat=imp_cell{row_no,1};
            Imp_id=imp_mat(ii,1);
            imp_row=find(mat==Imp_id);
            for jj=1:3
               Imp_feat=gen_cell{imp_row,1+jj};
               Imp_Indx=VQIndex(Imp_feat',code);
               Imp_VQ{ii,jj}=Imp_Indx;
               [bool]=VQCompare(Gen_Indx,Imp_Indx);
               [Imposter_Score1(ii,jj),Imposter_Score2(ii,jj)]=dtw_vq(Gen_feat,Imp_feat,bool,width);
            end
        end
        ch1 = Cohort_Score1(k,:);ch2 = Cohort_Score2(k,:);
        ch1=repmat(ch1,10,1);ch2=repmat(ch2,10,1);
        Score_Imposter1=[Imposter_Score1 ch1];
        Score_Imposter2=[Imposter_Score2 ch2];
        Imp_Score1=[Imp_Score1;Score_Imposter1];
        Imp_Score2=[Imp_Score2;Score_Imposter2];
    end
    nm = name_cell(i,2:2+sp_mat(i,1)-1);
    
    GScore1{i,1}=nm';GScore2{i,1}=nm';
    GScore1{i,2}=Score_Genuine1;GScore2{i,2}=Score_Genuine2;
%     ImpScore1{i,1}=nm';ImpScore2{i,1}=nm';
    ImpScore1{i,1}=Imp_Score1;ImpScore2{i,1}=Imp_Score2;
end
