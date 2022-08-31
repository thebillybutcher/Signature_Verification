clc;
clear all;
close all;
folder_name = 'I:\Abishek\Test\TD1';
folder_contents = dir(folder_name);
fe = size(folder_contents,1);
si = 0;
gen_cell_test = cell(0,0);spk = 1;sp_mat=zeros(fe-2,1);
name_cell=cell(0,0);
for i = 1:fe
    if (strcmp(folder_contents(i,1).name,'.') || ...
        strcmp(folder_contents(i,1).name,'..') || ...
        (folder_contents(i,1).isdir == 0))
        continue;
    end
    user = folder_contents(i,1).name;
    uid = str2double(user);
    user_folder = strcat(folder_name,'\',user);
    ufc = dir(user_folder);n = size(ufc,1);
    gsp = 1;
    for sgn=1:n
        if (strcmp(ufc(sgn,1).name,'.') || ...
            strcmp(ufc(sgn,1).name,'..') || ...
            (ufc(sgn,1).isdir == 1))
            continue;
        end
        filename = ufc(sgn,1).name;
        file_path = strcat(user_folder,'\',filename);
        load(file_path);
%         fileid = fopen(file_path,'r+');
%         sign_cell = textscan(fileid,'%d %d %d');
%         fclose(fileid);
%         sign_mat = cell2mat(sign_cell);
%         ep = find(filename=='.');
%         if(ep==7)
%             gen_cell{uid-10,gsid} = double(sign_mat);
%             gf_mat(uid-10,1)= gsid;
%             gsid = gsid+1;
%         else
%             forg_cell{uid-10,fsid} = double(sign_mat);
%             gf_mat(uid-10,2)= fsid;
%             fsid = fsid+1;
%         end
        gen_cell_test{spk,1} = uid;
        name_cell{spk,1}=uid;       
        name_cell{spk,1+gsp}= filename;
        gen_cell_test{spk,1+gsp} = mfcc;
        gsp = gsp+1;
    end
    sp_mat(spk,1)=gsp-1;
    spk = spk+1;
end
file_path='I:\BKSP\SPEPD\Codes1\cohort_TD_Set';
fileid = fopen(file_path,'r+');
sign_cell = textscan(fileid,'%d %d %d %d %d');
fclose(fileid);
spk_mat = cell2mat(sign_cell);
load('train.mat');
spk_infr=cell2mat(gen_cell(:,1));
no_spk = size(gen_cell,1);
spk_mat1=spk_mat;
for i=1:no_spk
cohort=spk_mat(i,2:5);

for j=1:4
    cohort_usr=cohort(1,j);
    row_no=find(spk_infr==cohort_usr);
    spk_mat1(i,j+1)=row_no;
end
    
end
save('Test','gen_cell_test','name_cell','sp_mat','spk_mat','spk_mat1');


