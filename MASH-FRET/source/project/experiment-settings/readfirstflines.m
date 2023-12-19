function fdat = readfirstflines(pname,fname,delimchar,nlines)
% fdat = readfirstflines(pname,fname,delimchar,maxflines)
%
% Reads first lines of file and returns it into a cell array.
%
% pname: source directory
% fname: source file name
% delimchar: {1-by-nDelim} column-delimiation characters
% nlines: nuber of file lines to read

fdat = {};
fline = 0;
if pname(end)~=filesep
    pname = [pname,filesep];
end
f = fopen([pname,fname],'r');
while fline<nlines && ~feof(f)
    rowdat = split(fgetl(f),delimchar)';
    excl = false(1,numel(rowdat));
    for col = 1:numel(rowdat)
        chars = unique(rowdat{col});
        if numel(chars)==0 || (numel(chars)==1 && chars==' ')
            excl(col) = true;
        end
    end
    rowdat(excl) = [];
    if ~isempty(fdat) && size(rowdat,2)~=size(fdat,2)
        if size(rowdat,2)<size(fdat,2)
            rowdat = cat(2,rowdat,...
                cell(1,size(fdat,2)-size(rowdat,2)));
        else
            fdat = cat(2,fdat,...
                cell(size(fdat,1),size(rowdat,2)-size(fdat,2)));
        end
    end
    fdat = cat(1,fdat,rowdat);
    fline = fline+1;
end
fclose(f);
