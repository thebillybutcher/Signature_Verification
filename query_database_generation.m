clc;
clear all;
close all;
folder_name = 'I:\Abishek\Train\TD1';
folder_contents = dir(folder_name);
fe = size(folder_contents,1);
si = 0;
gen_cell = cell(0,0);spk = 1;
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
        gen_cell{spk,1} = uid;
        gen_cell{spk,1+gsp} = mfcc;
        gsp = gsp+1;
    end
    spk = spk+1;
end
save('train','gen_cell');