function [pval,t2]=hotelling_t2_test(X,Y)

% X and Y are 3D arrays
% dim 1: number of features
% dim 2: number of subjects
% dim 3: number of mesh nodes

% https://en.wikipedia.org/wiki/Hotelling%27s_T-squared_distribution#Hotelling.27s_two-sample_T-squared_statistic
nx=size(X,2);
ny=size(Y,2);
p=size(X,1);

% find means
Xbar= mean(X,2); Ybar=mean(Y,2);

% subtract means from data
X_Xbar=bsxfun(@minus,X,Xbar);
Y_Ybar=bsxfun(@minus,Y,Ybar);
% matrix size: (number of features X number of subjects X number of mesh nodes)

% find covariances (without averaging)
Wx = multiprod_sparse (X_Xbar, permute (X_Xbar, [2 1 3]));
Wy = multiprod_sparse (Y_Ybar, permute (Y_Ybar, [2 1 3]));

% compute Hotelling's Tsquared test statistic
W=(Wx+Wy)/(nx+ny-2);
W = bsxfun (@plus, W, 1e-5 * eye (size (W, 1)));
%
Xbar=squeeze(Xbar); Ybar=squeeze(Ybar);
%
Xbar_minus_Ybar = reshape (Xbar - Ybar, size(Xbar,1), 1, size(Xbar,2));
t2 = squeeze (mean (sum ((Xbar_minus_Ybar) .* (multi_backslash (W, Xbar_minus_Ybar)), 1), 2));
%I think 'mean' is not necessary
% for jj=1:size(W,3)
%     t2(jj)=(Xbar(:,jj)-Ybar(:,jj))'*(W(:,:,jj)\(Xbar(:,jj)-Ybar(:,jj)));
% end

% test statistic
t2=t2*(nx*ny/(nx+ny));

% p value
stat=((nx+ny-1-p)/((nx+ny-2)*p))*t2;
pval=1-fcdf(stat,p,nx+ny-1-p);

return                                                                                                                                            