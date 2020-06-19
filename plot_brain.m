function pval = plot_brain(statistic)
LoadConfig
sl=readdfs('/home/dakaraim/bfp/supp_data/bci32kleft.dfs');
sr=readdfs('/home/dakaraim/bfp/supp_data/bci32kright.dfs');
lab=load('/home/dakaraim/bfp/supp_data/HCP_32k_Label.mat');

pval = statistic;

pval=pval.*double(~isnan(lab.brainstructure))';
L=pval(1:length(sl.vertices))';
Lsm=smooth_surf_function(sl,L);% laplace Beltrami Filtering on statistic

R=pval(1+length(sl.vertices):2*length(sl.vertices))';
Rsm=smooth_surf_function(sr,R);

sl=smooth_cortex_fast(sl,.1,800);
sr=smooth_cortex_fast(sr,.1,800);

pl=figure('Name', 'Left');
patch('faces',sl.faces,'vertices',sl.vertices,'facevertexcdata',Lsm,'facecolor','interp','edgecolor','none');
view(90,0); material dull; camlight ; axis equal; axis off; axis tight; colormap jet;
view(-90,0); camlight;  colorbar; caxis([0.06 0.18])
 
pr=figure('Name','Right');
patch('faces',sr.faces,'vertices',sr.vertices,'facevertexcdata',Rsm,'facecolor','interp','edgecolor','none');
view(-90,0); material dull; camlight; axis equal; axis off; axis tight; colormap jet; 
view(90,0); camlight;  colorbar; caxis([0.06 0.18])

end