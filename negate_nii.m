function negate_nii(file,out)
% May need to invert statistic of volumetric jacobian  
pmap = load_nii(file);
pmap.img = -1*pmap.img;
save_nii(pmap,out);
disp('Done inverting')
end

