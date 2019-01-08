function [Group1_avg,Group2_avg] = Subject2AtlasSyncAVG(Os,SP,Group1,Group2)
% load group average given group index vectors Group1 and Group2
X = zeros(size(SP,1),size(SP,2),1);
for i = 1:size(Group1,1)
    X = X + Os(:,:,i)*SP(:,:,i);
end
Group1_avg = X./size(SP,3);

X = zeros(size(SP,1),size(SP,2),1);
for i = 1:size(Group2,1)
    X = X + Os(:,:,size(Group1,1)+i)*SP(:,:,size(Group1,1)+i);
end
Group2_avg = X./size(SP,3);
end