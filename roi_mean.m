function m = roi_mean(vol, labelvol, roi, rmzeros)
% author: choisoyo@usc.edu
% modified by : dakaraim@usc.edu
% Loads the ROI only for that subject

if ~exist('rmzeros')
    rmzeros = 0;
end


for i = 1:size(roi,1)
    temp = logical(zeros(size(labelvol.img)));
    temp(labelvol.img==roi(i))=1;
    vals = vol.img(temp);
    if rmzeros
        vals = nonzeros(vals);
    end
    vals = vals(~isnan(vals));
    m(i) = mean(vals);
end

end
