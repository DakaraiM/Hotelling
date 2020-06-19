clear;clc;
 dirname = '/NCAdisk/SCD_structural_analysis/svreg18a/all';
 dirout = '/home/sychoi/Dropbox/SCD/Analysis/TBM/extendedAnalysis_040220';
 subjects = load_subnames(dirname);
%   temp = load('/Users/sychoi/Dropbox/SCD/Analysis/TBM_December2017/demographics.mat');
%   subjects = temp.subjects; clear temp;
% fname_mask = '/Users/sychoi/Dropbox/SCD/Analysis/TBM_December2017/visualization_tools/BCI-DNI_brain.wm_NOvent2.label.nii.gz';
% fname_mask = '/home/sychoi/Dropbox/SCD/Analysis/TBM/TBM_December2017/WM_filt3_smooth3_FINAL/FDR_Sign_0.1_perm10000.nii.gz';
fname_mask = '/home/sychoi/Dropbox/SCD/Analysis/TBM/TBM_December2017/WM_filt3_smooth3_FINAL/cluster1_aCC.mask.nii.gz';
mask = load_untouch_nii_gz(fname_mask);
%%  subjects = load_subjects('all');
for i = 1:length(subjects)
    subj = subjects{i};%subj = subjects(i).name;
    disp(subj)
        fname_jac = fullfile(dirname,subj,[subj,'.svreg.inv.jacobian.masked.nii.gz']);
        fname_jac22 = fullfile(dirname,subj,[subj,'.svreg.inv.jacobian.masked2.nii.gz']);
        fname_jac2 = fullfile(dirname,subj,[subj,'.svreg.inv.jacobian.logtr.filt3.nii.gz']);
        fname_jac3 = fullfile(dirname,subj,[subj,'.svreg.inv.jacobian.logtr.filt3mm.smooth3mm.nii.gz']);
        if exist(fname_jac22,'file')
            jac = load_untouch_nii_gz(fname_jac22);
%         elseif exist(fname_jac22,'file')
%             jac = load_untouch_nii_gz(fname_jac22);
%         end
%         if exist('jac','var')
            jac_stats{i,1} = subj;
            a = jac.img(mask.img==1 | mask.img==255);
            avg = sum(a)/(length(a));
            jac_stats{i,2} = avg;
            clear jac
%         
%             if exist(fname_jac2,'file')
%                 jac = load_untouch_nii_gz(fname_jac2);
%                 a = jac.img(mask.img==1 | mask.img==255);
%                 avg = sum(a)/(length(a));
%                 jac_stats{i,3} = avg;
%             end
% 
%             if exist(fname_jac3,'file')
%                 jac = load_untouch_nii_gz(fname_jac3);
%                 a = jac.img(mask.img==1 | mask.img==255);
%                 avg = sum(a)/(length(a));
%                 jac_stats{i,4} = avg;
%             end
        else
            disp([subj,':missing data'])
        end
%         save(fullfile(dirout,'WMstats_temp'),'jac_stats');
end
disp('done processing jacobian stats')
disp('compiled to variable jac_stats')

save(fullfile(dirout,'WMstats_FDR_Sign_0.1_perm10000_masked2.ROI1_ACC.mat'),'jac_stats');
%%







