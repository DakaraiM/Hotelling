% This script calculates the subject wise deformation difference. 
% make sure to add paths to brainsuite utilities 

clear; clc;

% set to BSSR BIDS format directory
dirname = '\\hippocampus.usc.edu\SocialDevelopmentProject\fMRI\BrainSuite\Stats\subject_session';
dirout = [dirname, '\Paired_ttest'];
aa10=dir(dirname);
T = readtable('\\hippocampus.usc.edu\socialdevelopmentproject\fMRI\BrainSuite\Stats\Common_subjects_paired.csv');com = intersect(str2mat(aa10.name), T.subjID);
com = intersect(str2mat(aa10.name), T.subjID);
wave1 = com(contains(com,'_01'));
wave2 = com(contains(com,'_02'));

sub = 1;
% calculate TBM difference within subject.
for sub =1:length(wave1) % Wave1 and wave2 have the same lenght because we are looking at common subjects
    
    subbasename=sprintf('%s\\%s\\%s.svreg.inv.jacobian.smooth3.0mm.nii.gz',dirname,wave2{sub},wave2{sub});
    vol=load_untouch_nii(subbasename);
    dx1=vol.img;
    
    subbasename=sprintf('%s\\%s\\%s.svreg.inv.jacobian.smooth3.0mm.nii.gz',dirname,wave2{sub},wave2{sub});
    vol=load_untouch_nii(subbasename);
    dx2=vol.img;
    
    % get header for subject
    diff = vol;
    diff.img = dx2 - dx1;
    
    % Note: naming of *smooth3.1mm* forces BSSR to load difference jacobian file
    % save same file in both directories for loading purposes. 
    if exist(sprintf('%s\\%s\\%s.svreg.inv.jacobian.smooth3.1mm.nii.gz',dirname,wave2{sub},wave2{sub}), 'file')
        continue;
    end
    save_untouch_nii(diff, sprintf('%s\\%s\\%s.svreg.inv.jacobian.smooth3.1mm.nii.gz',dirname,wave2{sub},wave2{sub}));
    
    if exist(sprintf('%s\\%s\\%s.svreg.inv.jacobian.smooth3.1mm.nii.gz',dirname,wave1{sub},wave1{sub}), 'file')
        continue;
    end
    save_untouch_nii(diff, sprintf('%s\\%s\\%s.svreg.inv.jacobian.smooth3.1mm.nii.gz',dirname,wave1{sub},wave1{sub}));
    
   disp(sub)
end

