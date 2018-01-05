function num = getValueFromStr(preWord, str)
% Return the numeric value found in the string, located just
% after the first sub-string.
% "preWord" >> sub-string
% "str" >> full string
% "num" >> numeric value found

% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

cLen = length(preWord);
if cLen == 0
    cPos = 1;
else
    cPos = strfind(str, preWord);
end
if ~isempty(cPos)
    ii = cLen; % "word" --> cLen = 4
    preNum = str(cPos(1,1) + ii);
    num = str2num(preNum);
    if ((~isempty(str2num(preNum)) || strcmp(preNum, '-')) && (cPos(1,1) + ii) < numel(str))
        ii = ii + 1;
        preNumPrev = preNum;
        preNum = strcat(preNum, str(cPos(1,1) + ii));
        if ~isempty(str2num(preNum))
            num = str2num(preNum);
        end
        while (~isempty(str2num(preNum)) && numel(str2num(preNum)) == 1 && (cPos(1,1) + ii) < numel(str) && ~strcmp(preNum, preNumPrev))
            ii = ii + 1;
            preNumPrev = preNum;
            preNum = strcat(preNum, str(cPos(1,1) + ii));
            if (~isempty(str2num(preNum)) && numel(str2num(preNum)) == 1 && ~strcmp(preNum, preNumPrev))
                num = str2num(preNum);
            end
        end
    end
else
    num = [];
end