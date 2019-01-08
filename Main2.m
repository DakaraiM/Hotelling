clc; clear ;
%% Set Paths and image suffix
% Set Basedir and Suffix to begin analysis
[baseDir, suffix,SubList] = LoadConfig;

%% Initialization
% Get subject files and subject number
[SubNum,files] = GetFiles(baseDir);

% load subject for initialization
[s_init] = LoadSubject(baseDir,suffix,files);

% Get subgroups  
[Subs,EAsian, Latino] = GetSubGroups(SubList,files);

%% load data, run group BrainSync, Save output
saveName = 'Group_BS_atlas.mat';
dirName = 'data_processing';

[SP,numT,numV] = LoadSubMatrix(baseDir,SubNum,Subs,suffix,s_init);
tic
[X2, Os, Costdif, TotalError] = groupBrainSync_v6(SP(:,:,:));
elapsedTime = toc;
disp('Group BrainSync Atlas Complete')
vars = struct('X2',X2,'Os',Os,'numV',numV,'numT',numT,'Costdif',Costdif,...
    'TotalError',TotalError,'elapsedTime',elapsedTime);
SaveData(baseDir,dirName,saveName,vars);

%% Run GroupBrainSync on sub groups.
saveName = 'EAsian_BS_atlas.mat';
dirName = 'data_processing';
[X2, Os, Costdif, TotalError] = groupBrainSync_v6(SP(:,:,1:size(EAsian,1)));
elapsedTime=toc;
disp('East Asian BrainSync Atlas Complete')

vars = struct('X2',X2,'Os',Os,'numV',numV,'numT',numT,'Costdif',Costdif,...
    'TotalError',TotalError,'elapsedTime',elapsedTime);
SaveData(baseDir,dirName,saveName,vars);

saveName = 'Latino_BS_atlas.mat';
dirName = 'data_processing';
tic
[X2, Os, Costdif, TotalError] = groupBrainSync_v6(SP(:,:,size(EAsian,1)+1:end));
elapsedTime=toc;
disp('Latino BrainSync Atlas Complete')

vars = struct('X2',X2,'Os',Os,'numV',numV,'numT',numT,'Costdif',Costdif,...
    'TotalError',TotalError,'elapsedTime',elapsedTime);
SaveData(baseDir,dirName,saveName,vars);
clear
%% Sync Subjects to atlas and calculate mean difference map
[EA_avg,L_avg]=SubjectSync;
[Diff,pl,pr] = PlotMean(EA_avg,L_avg,'East Asian Vs. Latino');

%SaveHemis(pl,pr,'EA_v_L',figDir)