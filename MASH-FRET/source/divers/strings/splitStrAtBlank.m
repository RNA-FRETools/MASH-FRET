function str_split = splitStrAtBlank(str)
% str_split = splitStrAtBlank(str)
%
% Split string at blank characters and return a cell vector
%
% str: string with blank characters
% str_split: cell vector containing split strings

blankchar = {' ',sprintf('\t')};

str_split = {};

c0 = 1;
startblank = false;
for c = 1:length(str)
    if any(contains(blankchar,str(c)))
        if ~startblank
            startblank = true;
            str_split = cat(2,str_split,str(c0:c-1));
        end

    elseif startblank
        c0 = c;
        startblank = false;
    end
end
str_split = cat(2,str_split,str(c0:end));
