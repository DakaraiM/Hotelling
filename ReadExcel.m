function [num, txt, raw] = ReadExcel(path)

[num, txt, raw] = xlsread(path);
cell2mat(raw(2:end,1))
end
