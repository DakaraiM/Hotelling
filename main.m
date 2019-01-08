clc; clear;
baseDir = '/home/dakaraim/Data/MH_adolescent_waves/raw_data/wave_2/GrayOrd_filt_mat/';
addpath(genpath('/home/dakaraim/bfp'));
addpath(genpath('/home/dakaraim/Data/MH_adolescent_waves/raw_data/wave_2/Stats'));


cmd = sprintf('ls %s | wc -l',baseDir); %number of subject want to load
[status, SubNum] = unix(cmd); SubNum = str2num(SubNum);
[satus, files]=unix(sprintf('find %s -type f -iname *filt.mat | grep [0-9][0-9][0-9] -o | sort',baseDir))
files = str2num(files); files = num2str(files);
s = load(fullfile(baseDir,sprintf('%s_RS_wave2_bold.32k.GOrd.filt.mat',files(1,:)))); %load one subjects name for matrix initialization


i = 1;
fileName = fullfile(baseDir, sprintf('%s_RS_wave2_bold.32k.GOrd.filt.mat',files(1,:)));
s = load(fileName);

[numV, numT] = size(s.dtseries);

SP = zeros(numT, numV, SubNum);
%% load data (parameters = subNum, baseDir, file prefix, Subs)
for i = 1:SubNum
    fileName = fullfile(baseDir, sprintf('%s_RS_wave2_bold.32k.GOrd.filt.mat',files(i,:)));
    s = load(fileName);
    %t = ([s.dataL; s.dataR])';
    t = ([s.dtseries])'; % Does this actually get the time series information?
    %t = unitNorm(t, 1);
    [norm_sig, mean_vector, norm_vector] = normalizeData(t);
    SP(:, :, i) = norm_sig;
    i
end

%% run group Brain Sync
[X2, Os, Costdif, TotalError] = groupBrainSync_v6(SP(:,:,:));

%% Save data

saveDir = fullfile(baseDir, 'data_processing'); 
unix(sprintf('mkdir -pv %s',saveDir));
fileName = fullfile(saveDir, 'result_raw.mat');
save(fileName, 'X2', 'Os', 'numV','numT', 'Costdif', 'TotalError');

%% Group Stats
% Check which subjects are included in the wave from the participant list
path = '/home/dakaraim/Data/MH_adolescent_waves/raw_data/Participant_info.xlsx';
[num, txt, raw] = ReadExcel(path);
% Find ethnicity groups and indices 1 = East Asian, 2 = Latino
[Subs, ia, ib] = intersect(num(:,1),str2num(files));
ethnicity = num(ia,2); group1 = ethnicity == 1; group2 = ethnicity == 2;
Asian = Subs(group1); Latino = Subs(group2);

% Run GroupBrainSync on sub groups.
%SP = zeros(numT, numVL + numVR, SubNum);
SP = zeros(numT, numV, SubNum);
%% load data
for i = 1:SubNum
    fileName = fullfile(baseDir, sprintf('%s_RS_wave2_bold.32k.GOrd.filt.mat',files(1,:)));
    s = load(fileName);
    %t = ([s.dataL; s.dataR])';
    t = ([s.dtseries])'; % Does this actually get the time series information?
    %t = unitNorm(t, 1);
    [norm_sig, mean_vector, norm_vector] = normalizeData(t);
    SP(:, :, i) = norm_sig;
    i
end

%% run group Brain Sync

