function [SP,numT,numV] = LoadSubMatrix(baseDir,SubNum,subs,suffix,Subject)
disp('Loading Subject Matrix')
[numV, numT] = size(Subject.dtseries);
SP = zeros(numT, numV, SubNum(1));
    for i = 1:SubNum
        fileName = fullfile(baseDir, sprintf('%s_%s',num2str(subs(i)),suffix));
        s = load(fileName);
        t = ([s.dtseries])'; % time by vertices
        [norm_sig,~,~] = normalizeData(t);
        SP(:, :, i) = norm_sig;
        i
    end
disp('Done Loading Subject Matrix')

end
