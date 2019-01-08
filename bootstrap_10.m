
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
[EA_avg_10,L_avg_10] = Subject2AtlasSyncAVG_10(Os,SP,EAsian,Latino);
save([baseDir 'data_processing/data/' 'Group_subgroup_avg_10'],'EA_avg_10','L_avg_10')
[Diff,pl,pr] = PlotMesial(EA_avg_10,L_avg_10,'East Asian vs. Latino 1-10');
SaveHemis(pl,pr,'EA_v_L_1_10_m',figDir)
[Diff,pl,pr] = PlotSaggital(EA_avg_10,L_avg_10,'East Asian vs. Latino 1-10');
SaveHemis(pl,pr,'EA_v_L_1_10',figDir)

