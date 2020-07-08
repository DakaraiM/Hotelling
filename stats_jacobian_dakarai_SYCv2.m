clear;clc;
dirname = '\\hippocampus.usc.edu\SocialDevelopmentProject\fMRI\BrainSuite\Stats\subject_session';
dirout = [dirname, '\Paired_ttest'];
%%  Load roi label file and get roi IDs
% get custom lobes labels
lobes = 'BCI-DNI_brain.lobes.customGW.label.nii.gz' ; % load label files
lobes_vol = load_untouch_nii(lobes);

% get custom PVC label GM/WM/CSF whole brain map
pvc = 'BCI-DNI_brain.GWS.label.nii.gz';
pvc_vol = load_untouch_nii(pvc);

% get bci-dni labels
bci = 'C:\Program Files\BrainSuite19b\svreg\BCI-DNI_brain_atlas\BCI-DNI_brain.label.nii.gz';
bci_vol = load_untouch_nii(bci);

label_vol = bci_vol;
label = 'bci'

roiIDs = unique(label_vol.img); % defines the ROI IDs
roiIDs(ismember(roiIDs,[0,740,760])) = []; % excludes certain rois
%roiIDs = roiIDs(ismember(roi,[1000:3000])); % or only have certain rois within a range of values
%% identify statistically significant regions
fname_stats = '\\hippocampus.usc.edu\SocialDevelopmentProject\fMRI\BrainSuite\Stats\subject_session\Paired_ttest\pairedttest_session_BCI-DNI_brain.bfc.nii_log_pvalues_adjusted.negated.nii.gz';
stats = load_untouch_nii(fname_stats);

%   Binarize statistical result: all significant voxels
% cposmin = 1.30102999566398 from *log_pvalues_adjusted.ini 
shell_neg = stats; % Copy header 
shell_neg.img = zeros(size(stats.img));
shell_neg.img(stats.img <= -1.30102999566398 ) = 1; % neg pvals
save_untouch_nii(shell_neg,fullfile(dirout,sprintf('pairedttest_sigNegative.%s.mask.nii.gz', label))); % save and check your mask in BrainSuite
shell_post = stats;
shell_post.img = zeros(size(stats.img));
shell_post.img(stats.img >= 1.30102999566398 ) = 1; % post pvals
save_untouch_nii(shell_post,fullfile(dirout,sprintf('pairedttest_sigPositive.%s.mask.nii.gz',label))); % save and check your mask in BrainSuite
%% filters roi label file by post and neg significant regions
roi_neg = label_vol;
roi_neg.img = int16(label_vol.img).*int16(shell_neg.img);
save_untouch_nii(roi_neg,fullfile(dirout,sprintf('pairedttest_sigNegative.%s.label.nii.gz',label))); % save and check your label in BrainSuite
roi_post = label_vol;
roi_post.img = int16(label_vol.img).*int16(shell_post.img);
save_untouch_nii(roi_post,fullfile(dirout,sprintf('pairedttest_sigPositive.%s.label.nii.gz',label))); % save and check your labels in BrainSuite

% compute the total number of voxels that are in a given roi and % of labels that are significant
roi_voxcount(:,1) = double(roiIDs);
for i = 1:length(roiIDs)
    roi_voxcount(i,2) = sum(find(label_vol.img==roiIDs(i))); % total number of voxels
    roi_voxcount(i,3) = sum(find(roi_neg.img==roiIDs(i)))/roi_voxcount(i,2); %percent of significant voxels that have negative significant pvalues for a regions
    roi_voxcount(i,4) = sum(find(roi_post.img==roiIDs(i)))/roi_voxcount(i,2); % percent of signficant voxels that have positve significant pvalues
end
%%  subjects = load_subjects('all');
tt = readtable('\\hippocampus.usc.edu\SocialDevelopmentProject\fMRI\BrainSuite\Stats\subject_session\BSSR_paired_ttest\ROI_volume');
T = readtable('\\hippocampus.usc.edu\socialdevelopmentproject\fMRI\BrainSuite\Stats\Common_subjects_paired.csv');
aa10=dir(dirname);
com = intersect(str2mat(aa10.name), T.subjID);
wave1 = com(contains(com,'_01'));
wave2 = com(contains(com,'_02'));
%%  compute mean Jacobian determinants for roi list
for sub =1:length(wave1)
    fname_dJac = sprintf('%s\\%s\\%s.svreg.inv.jacobian.smooth3.0mm.nii.gz',dirname,wave1{sub},wave1{sub});
    if exist(fname_dJac,'file')
        jac_stats.subj{sub,1} = wave1{sub}; % save subject
        djac = load_untouch_nii(fname_dJac);
        % get specific ROI        
        rmzeros = 0;
        jac_stats.neg(sub,:) = roi_mean(djac, roi_neg, roiIDs, rmzeros);
        jac_stats.post(sub,:) = roi_mean(djac, roi_post, roiIDs, rmzeros);
        clear djac % clear memory
    else
        disp([sub,':missing data'])
    end
    disp(sub);
    save(fullfile(dirout,'WMstats_temp'),'jac_stats');
end
disp('done processing jacobian stats')
disp('compiled to variable jac_stats')

% recover average GM/WM for specific ROI
% jac_stats{1,2}(find(roi == 720))
%%  save outputs
save(fullfile(dirout,sprintf('stats_FDR.%s.ROI.mat',label)),'jac_stats','roiIDs','wave1');
csvwrite(fullfile(dirout,sprintf('meanJacD_negSig.%s.csv',label)), jac_stats.neg);
csvwrite(fullfile(dirout,sprintf('meanJacD_postSig.%s.csv',label)), jac_stats.post);
writecell(jac_stats.subj,fullfile(dirout,sprintf('meanJacD_subjects.%s.csv',label)));
csvwrite(fullfile(dirout,sprintf('meanJacD_roiIDs.%s.csv',label)), roiIDs);
csvwrite(fullfile(dirout,sprintf('ROI_percent_significant.%s.csv',label)), roi_voxcount);
%% plot results for a specific ROI
% 2 = WM