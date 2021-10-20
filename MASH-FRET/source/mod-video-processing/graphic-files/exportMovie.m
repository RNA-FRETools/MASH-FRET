function ok = exportMovie(h_fig,varargin)
% exportMovie(h_fig,varargin)
% exportMovie(h_fig,pname,fname)
%
% Export video/image to file
%
% h_fig: handle to main figure
% pname: destination folder
% fname: destination file name

% default
fmtext = {'.sira','.gif','.tif','.mat','.avi','.png'};
fmtname = {'MASH-FRET video format','Graphics Interchange Format',...
    'Tagged Image File Format','MATLAB binary file format',...
    'Audio Video Interleave','Portable Network Graphics'};
ok = 0;

% collect parameters
h = guidata(h_fig);
p = h.param;
vidfile = p.proj{p.curr_proj}.movie_file;
curr = p.proj{p.curr_proj}.VP.curr;
start = curr.edit{2}(1);
stop = curr.edit{2}(2);
filtlst = curr.edit{1}{4};

% get destination file
if ~isempty(varargin)
    pname = varargin{1};
    fname = varargin{2};
    [~,~,fext] = fileparts(fname);
    findex = find(contains(fmtext,fext));
    if isempty(findex)
        disp('unknown file extension');
            return
    end
else
    str_fmt = {};
    for fmt = 1:numel(fmtext)-1
        str_fmt = cat(1,str_fmt,...
            {['*',fmtext{fmt}],[fmtname{fmt},'(*',fmtext{fmt},')']});
    end
    if stop==start
        str_fmt = cat(1,str_fmt,...
            {['*',fmtext{end}],[fmtname{end},'(*',fmtext{end},')']});
    end
    
    [~,expname,~] = fileparts(vidfile);
    
    [fname,pname,findex] = uiputfile(str_fmt,'Export video to file',...
        expname);
end
if ~sum(fname)
    return
end
cd(pname);
fname = getCorrName(fname, pname, h_fig);
if ~sum(fname)
    return
end

% export video/image to file
switch findex
    case 1
        ok = export2Sira(h_fig, fname, pname);
    case 2
        ok = export2Tiff(h_fig, fname, pname);
    case 3
        ok = export2Gif(h_fig, fname, pname);
    case 4
        ok = export2Mat(h_fig, fname, pname);
    case 5
        ok = export2Avi(h_fig, fname, pname);
    case 6
        ok = export2Png(h_fig, fname, pname);
end
if ~ok
    return
end

% build action
if numel(start:stop) > 1
    grType = 'Video ';
else
    grType = 'Image ';
end
str_bg = [];
if ~isempty(filtlst)
    str_bg = 'with corrections: ';
    bgCorr = get(h.listbox_bgCorr, 'String');
    for i = 1:numel(bgCorr)
        str_bg = cat(2,str_bg,'"',bgCorr{i},'", ');
    end
end

% show action
updateActPan([grType str_bg 'has been successfully exported to file: ' ...
    pname fname], h_fig, 'success');

ok = 1;

