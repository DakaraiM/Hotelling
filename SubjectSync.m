function [EA_avg,L_avg] = SubjectSync
%% Set Paths and image suffix
% Set Basedir and Suffix to begin analysis
[baseDir, suffix,SubList] = LoadConfig;

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
save('Group_subgroup_avg','EA_avg','L_avg')
clear S
%{
load('EAsian_BS_atlas.mat')
S = Subject2AtlasSync(Os,SP(:,:,1:size(EAsian,1)));
save('EAsian_Subject_Sync','S','-v7.3')
clear S

load('Latino_BS_atlas.mat')
S = Subject2AtlasSync(Os,SP(:,:,size(EAsian,1)+1:end));
save('Latino_Subject_Sync','S','-v7.3')
clear S
%}
end

