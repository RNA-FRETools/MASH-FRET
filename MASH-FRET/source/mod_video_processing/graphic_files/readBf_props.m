function [props,excord] = readBf_props(fullFname)
% [props,excord] = readBf_props(fullFname)
% 
% Read key-values pairs stored in metadata of bio format video files and
% laser order in metadata of video frames.
%
% fullFname: video file path
% props: {Nprop-by-2} key-value pairs
% excord: [1-by-nExc] laser idexes for the first nExc video frames (starting from 0)

bfInitLogging(); % Initialize logging
r = bfGetReader(fullFname,0); % Get the channel filler
r.setSeries(0); % Reading first series

% get video's metadata
bfmetdat = r.getSeriesMetadata(); % extract metadata table
metdat = split(char(bfmetdat),',');
M = size(metdat,1);
props = {};
for m = 1:M
    metdat{m,1} = metdat{m,1}(2:end); % remove trailin space and opening brace
    metdat{m,1} = replace(metdat{m,1},' = ',' '); % replace " = " in values by spaces
    if m==M
        metdat{m,1} = metdat{m,1}(1:end-1); % remove closing brace
    end
    md = split(metdat{m,1},'=');
    if size(md,1)>1
        props = cat(1,props,{md{1,1},bfmetdat.get(md{1,1})});
    end
end
[~,id] = sort(props(:,1));
props = props(id',:);

% get frames' metadata
nExc = r.getSizeC();
excord = [];
for l = 1:nExc
    zct = r.getZCTCoords(l-1);
    excord = cat(2,excord,zct(2)+1);
end

r.close();
