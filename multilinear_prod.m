function X = multilinear_prod(x,RHS)
%% input x: can be multidimensionl of size m x n x [q x...x p]
%         dim1 = number of features
%         dim2 = number of subjects
%         dim3 = number of mesh points

sn = size(x);
p = prod(sn(3:end));
% build string for indexing higher dimensions of x
% what happens when x is more than three dimensions??? 
str = sprintf([repmat('x(:,:,%d), ',[1 p-1]) 'x(:,:,%d)'], 1:p);
% Build sparse block matrix
test = eval(['sparse(blkdiag(' str '))']);
% reshape to preserve columnwise order per page. 
RHS = reshape(permute(RHS, [1 3 2]), size(RHS,1)*size(RHS,3), size(RHS,2));
X = test*RHS;
X = permute(reshape(X',size(RHS,2),sn(1),sn(3)),[2 1 3]);
end


