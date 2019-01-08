
clc; clear
[baseDir, suffix,SubList,figDir] = LoadConfig;

%% Initialization
% Get subject files and subject number
[SubNum,files] = GetFiles(baseDir);

% load subject for initialization
[s_init] = LoadSubject(baseDir,suffix,files);

% Get subgroups  
[Subs,EAsian,Latino] = GetSubGroups(SubList,files);

[SP,~,~] = LoadSubMatrix(baseDir,SubNum,Subs,suffix,s_init);

load('Group_BS_atlas.mat')
[EA_avg_20,L_avg_20] = Subject2AtlasSyncAVG_20(Os,SP,EAsian,Latino);
save([baseDir 'data_processing/data/' 'Group_subgroup_avg_20'],'EA_avg_20','L_avg_20')
[Diff, pl,pr] = PlotMesial(EA_avg_20,L_avg_20,'East Asian vs. Latino 10-20');
SaveHemis(pl,pr,'EA_v_L_10_20_m',figDir)
[Diff,pl,pr] = PlotSaggital(EA_avg_20,L_avg_20,'East Asian vs. Latino 10-20');
SaveHemis(pl,pr,'EA_v_L_10_20',figDir)

