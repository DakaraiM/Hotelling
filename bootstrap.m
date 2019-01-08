
clc; clear
[baseDir, suffix, SubList,figDir] = LoadConfig;

%% Initialization
% Get subject files and subject number
[SubNum,files] = GetFiles(baseDir);

% load subject for initialization
[s_init] = LoadSubject(baseDir,suffix,files);

% Get subgroups  
[Subs,EAsian,Latino] = GetSubGroups(SubList,files);

[SP,~,~] = LoadSubMatrix(baseDir,SubNum,Subs,suffix,s_init);

load('Group_BS_atlas.mat')
[EA_avg,L_avg] = Subject2AtlasSyncAVG(Os,SP,EAsian,Latino);
save([baseDir 'data_processing/data/' 'Group_subgroup_avg'],'EA_avg','L_avg')
[Diff,pl,pr] = PlotMesial(EA_avg,L_avg,'East Asian Vs. Latino');
SaveHemis(pl,pr,'EA_v_L_m',figDir)
[Diff,pl,pr] = PlotSaggital(EA_avg,L_avg,'East Asian vs. Latino');
SaveHemis(pl,pr,'EA_v_L',figDir)
