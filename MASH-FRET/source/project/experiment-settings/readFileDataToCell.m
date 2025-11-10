function datvect = readFileDataToCell(f,row1,delimchar)
% datvect = readFileDataToCell(f,row1,delimchar)
%
% Read file columns of different lengths and return the to a cell vector.
%
% f: file identifier
% row1: line nb. below file header lines
% delimchar: file column delimiter
% datvect: {1-by-nCol} content of file columns

% skip header lines
for line = 1:(row1-1)
    fgetl(f); 
end

% read content
datarr = {};
while ~feof(f)
    % read and split line
    str = split(fgetl(f),delimchar)';
    
    % extend cell array
    datarr = cat(1,datarr,str);
end

% format cell array as a cell vector
datarrnum = cellfun(@str2num,datarr,'UniformOutput',false);
nCols = size(datarrnum,2);
datvect = cell(1,nCols);
for col = 1:nCols
    datvect{col} = cell2mat(datarrnum(:,col));
end

% delete empty columns
datvect(cellfun(@isempty,datvect)) = [];