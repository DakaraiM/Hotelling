% This script calculates the subject wise deformation difference. 
% make sure to add paths to brainsuite utilities 

dirname1='\\hippocampus.usc.edu\socialdevelopmentproject\fMRI\BrainSuite\Stats\subject_session';
aa10=dir(dirname1);

T = readtable('\\hippocampus.usc.edu\socialdevelopmentproject\fMRI\BrainSuite\Stats\Common_subjects_paired.csv');
com = intersect(str2mat(aa10.name), T.subjID);
wave1 = com(contains(com,'_01'));
wave2 = com(contains(com,'_02'));

sub = 1;

% calculate TBM difference within subject Smooth first before looking at
% the difference. 
for sub =1:length(wave1)
    subbasename=sprintf('%s\\%s\\%s.svreg.inv.jacobian.nii.gz',dirname1,wave1{sub},wave1{sub});
    if exist(subbasename,'file')
        continue;
    end
        disp(sub)

    vol=load_nii(subbasename);
    dx1=vol.img;
    
    subbasename=sprintf('%s\\%s\\%s.svreg.inv.jacobian.nii.gz',dirname1,wave2{sub},wave2{sub});
    if exist(subbasename,'file')
        continue;
    end
    vol=load_nii(subbasename);
    dx2=vol.img;
    
    diff = dx2 - dx1;
    TBMdiff = make_nii(diff);
    TMBdiff_smooth = unix(['smooth_surf_function.sh'])
    
    if exist(sprintf('%s\\%s\\%s.svreg.inv.jacobian.smooth1.0mm.nii.gz',dirname1,wave2{sub},wave2{sub}), 'file')
        continue;
    end
 
    save_nii(TBMdiff, sprintf('%s\\%s\\%s.svreg.inv.jacobian.smooth1.0mm.nii.gz',dirname1,wave2{sub},wave2{sub}));
    
    if exist(sprintf('%s\\%s\\%s.svreg.inv.jacobian.smooth1.0mm.nii.gz',dirname1,wave1{sub},wave1{sub}), 'file')
        continue;
    end
    save_nii(TBMdiff, sprintf('%s\\%s\\%s.svreg.inv.jacobian.smooth1.0mm.nii.gz',dirname1,wave1{sub},wave1{sub}));
    sub=sub+1;
end

