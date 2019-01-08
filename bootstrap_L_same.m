
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

load('Group_BS_atlas.mat')
[L_avg_1_10,L_avg_10_20] = Subject2AtlasSyncAVG_L_same(Os,SP,EAsian);
% Data will be saved in the directory you originally the function from. 
save([baseDir 'data_processing/data/' 'Group_subgroup_avg_L_same'],'L_avg_1_10','L_avg_10_20')
[Diff,pl,pr] = PlotMesial(L_avg_1_10,L_avg_10_20,'Latin 1-10 Vs. 11-20');
SaveHemis(pl,pr,'L_v_L_1_10_20_m',figDir);
[Diff,pl,pr] = PlotSaggital(L_avg_1_10,L_avg_10_20,'Latin 1-10 vs. 11-20');
SaveHemis(pl,pr,'L_v_L_1_10_20',figDir)
