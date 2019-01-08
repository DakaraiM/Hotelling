function SaveData(baseDir,dirName, saveName, vars)
saveDir = fullfile(baseDir, dirName);
unix(sprintf('mkdir -pv %s',saveDir));
fileName = fullfile(saveDir, saveName);
save(fileName,'-struct','vars');
fprintf('%s saved in %s \n',fileName ,saveDir)
end