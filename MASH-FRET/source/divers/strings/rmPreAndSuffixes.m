function str = rmPreAndSuffixes(str0)
% str = rmPreAndSuffixes(str0)
%
% Remove identical preffixes and suffixes in "str0" and return clean strings "str"
%
% str0: {1-by-nStr} cell array conatining strings to clean
% str: {1-by-nStr} cell array containing clean strings

S = numel(str0);
str = cell(1,S);

if S<2
    disp('rmPreAndSuffixes: the number of input strings must be greater than 1');
    return
end

% remove common preffixe
endPref = false;
endStr = false;
pos = 0;
while ~endPref && ~endStr
    pos = pos+1;
    if pos>length(str0{1})
        endStr = true;
    else
        refchar = str0{1}(pos);
        for s = 2:S
            if pos>length(str0{s})
                endStr = true;
            else
                if str0{s}(pos)~= refchar
                    endPref = true;
                    break
                end
            end
        end
    end
end
for s = 1:S
    if pos>length(str0{s})
        str{s} = '';
    else
        str{s} = str0{s}(pos:end);
    end
end

% remove common suffixe
endSuf = false;
endStr = false;
pos = 0;
while ~endSuf && ~endStr
    pos = pos+1;
    if (length(str{1})-pos+1)<1
        endStr = true;
    else
        refchar = str{1}(length(str{1})-pos+1);
        for s = 2:S
            if (length(str{s})-pos+1)<1
                endStr = true;
            else
                if str{s}(length(str{s})-pos+1)~= refchar
                    endSuf = true;
                    break
                end
            end
        end
    end
end
for s = 1:S
    if (length(str{s})-pos+1)<1
        str{s} = '';
    else
        str{s} = str{s}(1:(length(str{s})-pos+1));
    end
end



