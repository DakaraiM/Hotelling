% Stats configuration file
function [baseDir,suffix,SubList,figDir] = LoadConfig

addpath(genpath('/home/dakaraim/bfp'));
addpath(genpath('/home/ajoshi/git_sandbox/svreg/src/'));
addpath(genpath('/home/dakaraim/Data/MH_adolescent_waves/raw_data/wave_2/'));
baseDir = '/home/dakaraim/Data/MH_adolescent_waves/raw_data/wave_2/GrayOrd_filt_mat/';
SubList = '/home/dakaraim/Data/MH_adolescent_waves/raw_data/Participant_info.xlsx';
suffix = 'RS_wave2_bold.32k.GOrd.filt.mat';
figDir = '/home/dakaraim/Data/MH_adolescent_waves/raw_data/wave_2/GrayOrd_filt_mat/data_processing/Figures/';

end