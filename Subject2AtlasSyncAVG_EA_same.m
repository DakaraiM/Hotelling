function [Group1_avg,Group2_avg] = Subject2AtlasSyncAVG_EA_same(Os,SP,Group1,Group2)
% Os - orthogonal matrices for all N subjects [T x T x N]
% SP - Matrices for N subjects [T x V x N]
% Group1 and Group2 are both scalars to indiate the size of Groups

% load group average 
X = zeros(size(SP,1),size(SP,2),1);
for i = 1:10
    X = X + Os(:,:,i)*SP(:,:,i);
end
Group1_avg = X./size(SP,3);

X = zeros(size(SP,1),size(SP,2),1);
for i = 11:20
    X = X + Os(:,:,i)*SP(:,:,i);
end
Group2_avg = X./size(SP,3);
end