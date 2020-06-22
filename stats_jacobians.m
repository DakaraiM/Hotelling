clear;clc;
dirname = '\\hippocampus.usc.edu\SocialDevelopmentProject\fMRI\BrainSuite\Stats\subject_session';
dirout = dirname; 

% get atlas fractionation label mask
frac_atlas ='C:\Program Files\BrainSuite19b\svreg\BCI-DNI_brain_atlas\BCI-DNI_brain.pvc.label.nii.gz';
frac_vol = load_untouch_nii(frac_atlas);
% 3 = WM, 2 = GM, 5= GM/WM boundary

% get atlas label volume
label = 'C:\Program Files\BrainSuite19b\svreg\BCI-DNI_brain_atlas\BCI-DNI_brain.label.nii.gz';
label_vol = load_untouch_nii(label);

% get statistical volume and WM/GM volumes
fname_stats = '\\hippocampus.usc.edu\SocialDevelopmentProject\fMRI\BrainSuite\Stats\subject_session\BSSR_paired_ttest\pairedttest_session_BCI-DNI_brain.bfc.nii_log_pvalues_adjusted_inverted.nii.gz';
stats = load_untouch_nii(fname_stats);
WM_vol.img = stats.img(frac_vol.img == 3);
GM_vol.img = stats.img(frac_vol.img == 2);
subcortical = stats.img(frac_vol.img == 5);

%%  subjects = load_subjects('all');
tt = readtable('\\hippocampus.usc.edu\SocialDevelopmentProject\fMRI\BrainSuite\Stats\subject_session\BSSR_paired_ttest\ROI_volume');
T = readtable('\\hippocampus.usc.edu\socialdevelopmentproject\fMRI\BrainSuite\Stats\Common_subjects_paired.csv');
aa10=dir(dirname);
com = intersect(str2mat(aa10.name), T.subjID);
wave1 = com(contains(com,'_01'));
wave2 = com(contains(com,'_02'));
    
for sub =1:length(wave1)
    fname_dJac = sprintf('%s\\%s\\%s.svreg.inv.jacobian.smooth1.0mm.nii.gz',dirname,wave1{sub},wave1{sub});
    if exist(fname_dJac,'file')
            djac = load_untouch_nii(fname_dJac);
            jac_stats{sub,1} = wave1{sub}; % save subject
            % get specific ROI
            vol.img = djac.img(WM_vol.img >= 1 | WM_vol.img <= -1 ); % threshold at 1 > abs(p_value)
            roi = tt.Var1; 
            rmzeros = 1;
            jac_stats{sub,2} = roi_mean(vol, label_vol, roi, rmzeros);
            clear vol
        else
            disp([sub,':missing data'])
        end
        %save(fullfile(dirout,'WMstats_temp'),'jac_stats');
end
disp('done processing jacobian stats')
disp('compiled to variable jac_stats')

%save(fullfile(dirout,'WMstats_FDR_Sign_0.1_perm10000_masked2.ROI1_ACC.mat'),'jac_stats');
%%







