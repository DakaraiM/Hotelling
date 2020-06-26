clear;clc;
dirname = '\\hippocampus.usc.edu\SocialDevelopmentProject\fMRI\BrainSuite\Stats\subject_session';
dirout = [dirname, '\BSSR_paired_ttest'];

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

% Binarize statistical result
shell = zeros(size(stats.img));
shell(stats.img > 1 | stats.img < -1) = 1;

% get binary statistical white matter map and grey matter map
WM_vol = shell.*(frac_vol.img == 3);
GM_vol = shell.*(frac_vol.img == 2);
subcortical_vol = shell.*(frac_vol.img == 5);


%%  subjects = load_subjects('all');
tt = readtable('\\hippocampus.usc.edu\SocialDevelopmentProject\fMRI\BrainSuite\Stats\subject_session\BSSR_paired_ttest\ROI_volume');
T = readtable('\\hippocampus.usc.edu\socialdevelopmentproject\fMRI\BrainSuite\Stats\Common_subjects_paired.csv');
aa10=dir(dirname);
com = intersect(str2mat(aa10.name), T.subjID);
wave1 = com(contains(com,'_01'));
wave2 = com(contains(com,'_02'));

for sub =1:length(wave1)
    fname_dJac = sprintf('%s\\%s\\%s.svreg.inv.jacobian.smooth1.0mm.nii.gz',dirname,wave1{sub},wave1{sub});
    
    if exist(fname_dJac, 'file')
        djac = load_untouch_nii(fname_dJac);
        jac_stats{sub,1} = wave1{sub};
        thal_vox = djac.img(87,191,237);
        jac_stats{sub,2} = thal_vox;
        
    end
end
    
%     if exist(fname_dJac,'file')
%         djac = load_untouch_nii(fname_dJac);
%         jac_stats{sub,1} = wave1{sub}; % save subject
%         % get specific ROI
%         WM.img = djac.img.*WM_vol;
%         GM.img = djac.img.*GM_vol;
%         subcortical.img = djac.img.*subcortical_vol;
%         roi = tt.Var1;
%         rmzeros = 1;
%         jac_stats{sub,2} = roi_mean(WM, label_vol, roi, rmzeros);
%         jac_stats{sub,3} = roi_mean(GM, label_vol, roi, rmzeros);
%         jac_stats{sub,4} = roi_mean(subcortical, label_vol, roi, rmzeros);
%         clear GM
%         clear WM
%         clear subcortical
%     else
%         disp([sub,':missing data'])
    end
    disp(sub);
    %save(fullfile(dirout,'WMstats_temp'),'jac_stats');
end
disp('done processing jacobian stats')
disp('compiled to variable jac_stats')

% recover average GM/WM for specific ROI
% jac_stats{1,2}(find(roi == 720))

save(fullfile(dirout,'stats_FDR.ROI.mat'),'jac_stats','roi','wave1','T');
%% plot results for a specific ROI
% 2 = WM











