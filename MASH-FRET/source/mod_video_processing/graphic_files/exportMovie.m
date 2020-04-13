function ok = exportMovie(h_fig,varargin)
% exportMovie(h_fig,varargin)
% exportMovie(h_fig,pname,fname)
%
% Export video/image to file
%
% h_fig: handle to main figure
% pname: destination folder
% fname: destination file name

% initialize output
ok = 0;

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

% collect processing parameters
startFrame = p.mov_start;
lastFrame = p.mov_end;

% get destination file
if ~isempty(varargin)
    pName = varargin{1};
    fName = varargin{2};
    [o,o,fext] = fileparts(fName);
    fIndex = strfind({'.sira','.tif','.gif','.mat','.avi','.png'},fext);
    fIndex = find(~cellfun('isempty',fIndex));
    if isempty(fIndex)
        disp('unknown file extension');
            return
    end
else
    [o,movName,o] = fileparts(h.movie.file);
    str_format = {'*.sira', 'SIRA Graphic File Format(*.sira)'; ...
                  '*.tif', 'Tagged Image File Format(*.tif)'; ...
                  '*.gif', 'Graphics Interchange Format(*.gif)'; ...
                  '*.mat', 'Matlab File(*.mat)'; ...
                  '*.avi', 'AVI File(*.avi)'};
    if lastFrame==startFrame
        str_format{end+1,1} = '*.png';
        str_format{end,2} = 'Portable Network Graphics(*.png)';
    end
    [fName,pName,fIndex] = uiputfile(str_format,'Select a movie format: ',...
        movName);
end
if ~sum(fName)
    return
end
cd(pName);
fName = getCorrName(fName, pName, h_fig);

% export video/image to file
switch fIndex
    case 1
        ok = export2Sira(h_fig, fName, pName);
    case 2
        ok = export2Tiff(h_fig, fName, pName);
    case 3
        ok = export2Gif(h_fig, fName, pName);
    case 4
        ok = export2Mat(h_fig, fName, pName);
    case 5
        ok = export2Avi(h_fig, fName, pName);
    case 6
        ok = export2Png(h_fig, fName, pName);
end
if ~ok
    return
end

% build action
if numel(startFrame:lastFrame) > 1
    grType = 'Movie ';
else
    grType = 'Image ';
end
str_bg = [];
if isfield(p, 'bgCorr')  && ~isempty(p.bgCorr)
    str_bg = 'with corrections: ';
    bgCorr = get(h.listbox_bgCorr, 'String');
    for i = 1:numel(bgCorr)
        str_bg = cat(2,str_bg,'"',bgCorr{i},'", ');
    end
end

% show action
updateActPan([grType str_bg 'has been successfully exported to file: ' ...
    pName fName], h_fig, 'success');

ok = 1;

