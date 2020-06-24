function plot_ROI(stats,roi_num,T,roi,type)
% T contains participant information
% ROI is the vector of avaialbe ROI's
% roi_num is the specific ROI of choice
% type is the binary statistical map

if type == "WM"
    type = 2;
elseif type == "GM"
    type = 3;
elseif type == "subcortical"
    type = 4;
else
    msg = "Choose type to be WM, GM, or subcortical";
    error(msg);
end

ROI = find(roi == roi_num);
gender = categorical(T.sex(1:2:end));
B = cell2mat(stats(gender == '1',type));
G = cell2mat(stats(gender == '2',type));
figure;
scatter(gender(gender == '1'), B(:,ROI));
hold on; scatter(gender(gender=='2'), G(:,ROI))

end