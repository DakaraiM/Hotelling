%% Hotellings test 
% Between groups one and two that have been synchronized 

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

%% load BrainSync'd data and subjects

[SP,numT,numV] = LoadSubMatrix(baseDir,SubNum,Subs,suffix,s_init);
% Get subgroup average maps and orthogonal matrices
load('EAsian_BS_atlas.mat')
EA_atlas = Os;
load('Latino_BS_atlas.mat')
Lat_atlas = Os;
% get subject matrices and sync to atlas
y = SP(:,:,ismember(Subs,Latino));
for i = 1:length(Latino)
    y(:,:,i) = Lat_atlas(:,:,i)*y(:,:,i); % [T x V x subs]
end
% make y to mave dimensions [V x T x subs]
y = struct('data',permute(y,[2 1 3])); 

x = SP(:,:,ismember(Subs,EAsian));
for i = 1:length(EAsian)
    x(:,:,i) = EA_atlas(:,:,i)*x(:,:,i);
end
x = struct('data',permute(x,[2 1 3]));

save('SyncData','x','y','-v7.3')
% compute hotellings T2 test

[stat,Err,df,x,y,XY] = Hotelling(x,y,k);


