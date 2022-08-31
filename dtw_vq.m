function [dst,dfr]=dtw_vq(s1,s2,bool,width)
lr=length(s1);
lc=length(s2);

cost_mat1=pdist2(s1,s2,'cityblock');

cost_mat=zeros(lr-width+1,lc-width+1);
for i=1:lr-width+1
     cost_mat(i,1)=cost_mat(i,1)+  sum(sum(bsxfun(@(i,j) abs(i-j), s1(i:i+width-1,:),s2(1:width,:))));
end
for j=2:lc-width+1
      cost_mat(1,j)=cost_mat(1,j)+ sum(sum(bsxfun(@(i,j) abs(i-j),s1(1:width,:) ,s2(j:j+width-1,:)))); 
end
for i=2:lr-width+1
    for j=2:lc-width+1
         cost_mat(i,j)=cost_mat(i-1,j-1)-cost_mat1(i-1,j-1)+cost_mat1(i+width-1,j-1+width);
    end
end
cost_mat=cost_mat/width;
acc_cost_mat=cost_mat;
%% Calculation of accumulated cost matrix
for i=1:lr-width+1
    acc_cost_mat(i,1)=sum(cost_mat(1:i,1));
end
for j=1:lc-width+1
    acc_cost_mat(1,j)=sum(cost_mat(1,1:j));
end
for i=2:lr-width+1
    for j=2:lc-width+1
        t=[acc_cost_mat(i-1,j-1) acc_cost_mat(i,j-1) acc_cost_mat(i-1,j)];
        acc_cost_mat(i,j)=cost_mat(i,j)+min(t);
    end
end

%% Finding DTW path
dst=acc_cost_mat(lr-width+1,lc-width+1);
[dpath]=dtw_path(acc_cost_mat);
lng=length(dpath);

%%% Voting of DTW path indices by Code book
dfr=0;
for i = 1:lng
    count=0;
    for k=0:width-1
          if(bool(dpath(1,i)+k,dpath(2,i)+k)==1)
              count=count+1;
          end
    end
%     dst=dst+count/width;
    dfr=dfr+count./width;
 end
dst=dst./lng;
dfr=dfr./lng;