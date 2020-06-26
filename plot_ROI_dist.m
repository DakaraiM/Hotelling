function ax = plot_ROI_dist(x,y,z,roi)
% x,y,and z are scalars
dirname = '\\hippocampus.usc.edu\SocialDevelopmentProject\fMRI\BrainSuite\Stats\subject_session';

% get atlas label volume
label = 'C:\Program Files\BrainSuite19b\svreg\BCI-DNI_brain_atlas\BCI-DNI_brain.label.nii.gz';
label_vol = load_untouch_nii(label);

% get statistical roi volume
fname_stats = '\\hippocampus.usc.edu\SocialDevelopmentProject\fMRI\BrainSuite\Stats\subject_session\sex\bss_anova_sex_BCI-DNI_brain.bfc.nii_log_pvalues_adjusted.nii.gz';
stats = load_untouch_nii(fname_stats);

% get ROI indices
temp1 = logical(zeros(size(label_vol.img)));
temp1(label_vol.img==roi) = 1;

% Get positive stat values
temp2 = logical(zeros(size(label_vol.img)));
temp2(stats.img > 1.3) = 1;

pos = (temp1 & temp2);

% Get negative stat values
temp3 = logical(zeros(size(label_vol.img)));
temp3(stats.img < -1.3) = 1;

neg = (temp1 & temp3);

dirname = '\\hippocampus.usc.edu\SocialDevelopmentProject\fMRI\BrainSuite\Stats\subject_session';
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
        %thal_vox = djac.img(x,y,z);
         mean_vox = mean(djac.img(neg));
        jac_stats{sub,2} = mean_vox;
        %jac_stats{sub,2} = thal_vox;
        clear djac
        
    end
end

gender = categorical(T.sex(1:2:end));
c = zeros(size(gender,1),3);
c(find(gender == '1'), 3) = 1; % blue = male
c(find(gender == '2')) = 1; % red = female
figure;
ax = scatter(gender, cell2mat(jac_stats(:,2)), [], c);
ax.Parent.XTickLabel = {'male','female'};
ax.Parent.YLabel.String = {'\Delta_{2-1} Jacobian determinant'};
%ax.Parent.Title.String = sprintf("Subject Distribution at (%s, %s, %s)", x,y,z);
ax.Parent.Title.String = sprintf("Subject Distribution of ROI = %s avg", num2str(roi));
ax.Parent.FontSize = 16;


end
