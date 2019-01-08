function [Tsq,Err,df,x,y, XY] = SyncHotelling(k)

load('SyncData.mat')
t = tic;
[Tsq,df,x,y,XY] = Hotelling(x,y,k);
Err = RankError(XY,k);
toc(t);
save('wave2_structural_Stats','Tsq','Err','df','x','y')
save('wave2_structural_JointMatrix','XY','-v7.3')
end
