function SaveHemis(pl,pr,savename,path)
% SaveHemis, will save figures in the specific path with the given savename
% pl and pr a both patch handles. Run PlotMean to get pl and pr.

currdir = pwd;
cd(path);
print(pl,sprintf('%s_Left',savename),'-dpng');
savefig(pl,sprintf('%s_Left',savename));
print(pr,sprintf('%s_Right',savename),'-dpng');
savefig(pr,sprintf('%s_Right',savename));
cd(currdir);
end

