function [Diff,pl,pr] = PlotMesial(Group1,Group2,Name)
LoadConfig
sl=readdfs('/home/dakaraim/bfp/supp_data/bci32kleft.dfs');
sr=readdfs('/home/dakaraim/bfp/supp_data/bci32kright.dfs');
lab=load('/home/dakaraim/bfp/supp_data/HCP_32k_Label.mat');
Diff = Group1-Group2;
Diff=sqrt(sum(Diff.^2,1));
Diff=Diff.*double(~isnan(lab.brainstructure))';
DL=Diff(1:length(sl.vertices))';
DLsm=smooth_surf_function(sl,DL);

DR=Diff(1+length(sl.vertices):2*length(sl.vertices))';
DRsm=smooth_surf_function(sr,DR);

sl=smooth_cortex_fast(sl,.1,800);
sr=smooth_cortex_fast(sr,.1,800);


pl=figure('Name',Name);
patch('faces',sl.faces,'vertices',sl.vertices,'facevertexcdata',DLsm,'facecolor','interp','edgecolor','none');
view(90,0); material dull; camlight ; axis equal; axis off; axis tight; colormap jet;
view(-90,0); camlight; view(90,0); colorbar; caxis([0.06 0.18])
 
pr=figure('Name',Name);
patch('faces',sr.faces,'vertices',sr.vertices,'facevertexcdata',DRsm,'facecolor','interp','edgecolor','none');
view(-90,0); material dull; camlight; axis equal; axis off; axis tight; colormap jet; 
view(90,0); camlight; view(-90,0); colorbar; caxis([0.06 0.18])

end