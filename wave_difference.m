clc;clear all;close all;

% This script performs pointwise group differences in cortical thicknesses
% for the right hemisphere
% modify as appropriate for left hemisphere

%group1 and group2 directory names
dirname1='\\hippocampus.usc.edu\socialdevelopmentproject\fMRI\BrainSuite\Stats\subject_session';
dirname2='\\hippocampus.usc.edu\socialdevelopmentproject\fMRI\BrainSuite\Stats\subject_session';

% subject names end in 01 or in 02 for session 1 or 2. 
aa10=dir(dirname1);

% get common subjects that have both session data
T = readtable('\\hippocampus.usc.edu\socialdevelopmentproject\fMRI\BrainSuite\Stats\Common_subjects_paired.csv');
com = intersect(str2mat(aa10.name), T.subjID);
aa1 = com(contains(com,'_01'));
aa2 = com(contains(com,'_02'));


jjj=1;
npts=1000;
% load target atlas brain
tar=readdfs('C:\Program Files\BrainSuite19b\svreg\BCI-DNI_brain_atlas\BCI-DNI_brain.left.mid.cortex.dfs');

% load RIGHT mid cortex and smooth value, which is cortical thickness
    for jj=1:length(aa1)
        subbasename=sprintf('%s\\%s\\%s.right.mid.cortex.svreg.dfs',dirname1,aa1{jj},aa1{jj});
        if ~exist(subbasename,'file')
            continue;
        end
        s=readdfs(subbasename);        
        s.attributes=smooth_surf_function(s,s.attributes);
        writedfs(sprintf('%s\\%s\\%s.right.mid.cortex.svreg.dfs',dirname1,aa1{jj},aa1{jj}),s);
        fprintf('%d/%d smoothings done\n',jj,length(aa1));
    end
    for jj=1:length(aa2)
        subbasename=sprintf('%s\\%s\\%s.right.mid.cortex.svreg.dfs',dirname2,aa2{jj},aa2{jj});
        if ~exist(subbasename,'file')
            continue;
        end
        s=readdfs(subbasename);
        s.attributes=smooth_surf_function(s,s.attributes);
        writedfs(sprintf('%s\\%s\\%s.right.mid.cortex.svreg.dfs',dirname2,aa2{jj},aa2{jj}),s);
        fprintf('%d/%d smoothings done\n',jj,length(aa1));
    end

    % calculate difference per voxel for smoothed image. 
for ptset=1:npts:length(tar.vertices)
    ptst1=ptset:min(ptset+npts-1,length(tar.vertices));clear Thickness1 Thickness2
    jj1=1;
    for jj1=1:length(aa1)
        if ~exist(subbasename)
            continue; 
        end
        subbasename=sprintf('%s\\%s\\%s.right.mid.cortex.svreg.dfs',dirname1,aa1{jj1},aa1{jj1});
        s=readdfs(subbasename);
        Thickness1(:,jj1)=s.attributes(ptst1);        jj1=jj1+1;
    end
    jj1=1;
    for jj1=1:length(aa2)
        subbasename=sprintf('%s\\%s\\%s.right.mid.cortex.svreg.dfs',dirname2,aa2{jj1},aa2{jj1});
        if ~exist(subbasename)
            continue;
        end
        s=readdfs(subbasename);
        Thickness2(:,jj1)=s.attributes(ptst1);        jj1=jj1+1;
    end
    
    % testing
    % what is this about? 
    %Thickness1(:,13)=[];
    %[h(ptst1),p(ptst1),~]=ttest2(Thickness1',Thickness2');
    diff = Thickness2 - Thickness1;
    
    disp(sprintf('%d/%d',ptset, length(tar.vertices)));
         
end

%pfdr=FDR(p,0.05);

h=figure;
patch('vertices',tar.vertices,'faces',tar.faces,'facevertexcdata',diff,'edgecolor','none','facecolor','interp');
axis equal;axis off;camlight;material dull;lighting phong;

% How to set the colors. 
tar.vcolor=0*tar.vcolor;tar.vcolor(:,3)=1;
tar.vcolor(p<0.05,3)=0;tar.vcolor(p<0.05,1)=1;
writedfs('difference_right.dfs',tar);
saveas(h,'difference_right.fig');


