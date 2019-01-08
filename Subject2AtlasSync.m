function SP = Subject2AtlasSync(Os,SP)
for i = 1:size(SP,3)
    SP(:,:,i) = Os(:,:,i)*SP(:,:,i);
end
end