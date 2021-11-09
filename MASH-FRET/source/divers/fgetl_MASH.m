function fline = fgetl_MASH(f)

% defaults
charnewline = uint8([10,13]);

% read each character until new line character
ch = uint8(0);
fline = [];
while ~isempty(ch) && ~any(ch==charnewline)
    ch = fread(f,1,'uint8');
    fline = cat(2,fline,ch);
end

% remove new line character
if ~isempty(ch) && any(ch==charnewline)
    fline(end) = [];
end

% convert to characters
fline = char(fline);