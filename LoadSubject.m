function [s_init] = LoadSubject(baseDir,suffix,files)
fileName = fullfile(baseDir, sprintf('%s_%s',num2str(files(1,:)),suffix));
s_init = load(fileName);
end