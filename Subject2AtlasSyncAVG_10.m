function [Group1_avg,Group2_avg] = Subject2AtlasSyncAVG_10(Os,SP,Group1,Group2)
% load group average 
X = zeros(size(SP,1),size(SP,2),1);
for i = 1:10
    X = X + Os(:,:,i)*SP(:,:,i);
end
Group1_avg = X./size(SP,3);

X = zeros(size(SP,1),size(SP,2),1);
for i = 1:10
    X = X + Os(:,:,size(Group1,1)+i)*SP(:,:,size(Group1,1)+i);
end
Group2_avg = X./size(SP,3);
end