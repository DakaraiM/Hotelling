
clc; clear
[baseDir, suffix,SubList,figDir] = LoadConfig;

%% Initialization
% Get subject files and subject number
[SubNum,files] = GetFiles(baseDir);

% load subject for initialization
[s_init] = LoadSubject(baseDir,suffix,files);

% Get subgroups  
[Subs,EAsian,~] = GetSubGroups(SubList,files);

[SP,~,~] = LoadSubMatrix(baseDir,SubNum,Subs,suffix,s_init);

% Get Orthogonal Transforms
load('Group_BS_atlas.mat')
[EA_avg_1_10,EA_avg_11_20] = Subject2AtlasSyncAVG_EA_same(Os,SP,EAsian);
save([baseDir 'data_processing/data/' 'Group_subgroup_avg_EA_same'],'EA_avg_1_10','EA_avg_11_20');
[Diff,pl,pr] = PlotMesial(EA_avg_1_10,EA_avg_11_20,'East Asian 1-10 Vs. 11-20');
SaveHemis(pl,pr,'EA_v_EA_1_10_20_m',figDir)
[Diff,pl,pr] = PlotSaggital(EA_avg_1_10,EA_avg_11_20,'East Asian 1-10 vs. 11-20');
SaveHemis(pl,pr,'EA_v_EA_1_10_20',figDir)
