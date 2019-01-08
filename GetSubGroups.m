function [Subs,EAsian, Latino] = GetSubGroups(SubList,files)
[num, ~, ~] = ReadExcel(SubList);
% Find ethnicity groups and indices 1 = East Asian, 2 = Latino
[Subs, ia, ~] = intersect(num(:,1),files);
ethnicity = num(ia,2); group1 = ethnicity == 1; group2 = ethnicity == 2;
EAsian = Subs(group1); Latino = Subs(group2);
Subs = [EAsian; Latino];
end
