function [SubNum,files] = GetFiles(baseDir)

cmd = sprintf('find %s -type f -iname *filt.mat | wc -l',baseDir);
[status, SubNum] = unix(cmd); SubNum = str2num(SubNum);
[status, files]=unix(sprintf('find %s -type f -iname *filt.mat | grep [0-9][0-9][0-9] -o | sort',baseDir));
files = str2num(files); 

end
