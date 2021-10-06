function TTgenGo(h_fig,varargin)
% TTgenGo(h_fig)
% TTgenGo(h_fig,pname,fname)
%
% Save traces to MASH project and other files.
% TTgenGo can be called either after pressing "create & export" button in Video processing, or from a test routine.
% 
% h_fig: handle to main figure
% pname: destination folder (from routine test)
% fname: destination .mash file (from routine test)

% Last update by MH, 28.3.2019: change MASH folder from /video-processing back to root folder
% update by MH, 18.2.2019: change default folder to video_processing comment code

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'VP')
    return
end

proj = p.curr_proj;
folderRoot = p.proj{proj}.folderRoot;
prm = p.proj{proj}.VP;

% update data
updateFields(h_fig,'movPr');

if ~(isfield(prm,'itg_movFullPth') && ~isempty(prm.itg_movFullPth))
    set(h.edit_movItg,'BackgroundColor',[1 0.75 0.75]);
    updateActPan('No movie loaded.',h_fig,'error');
    return
end
if ~(isfield(prm,'coordItg') && ~isempty(prm.coordItg))
    set(h.edit_itg_coordFile,'BackgroundColor',[1,0.75,0.75]);
    updateActPan('No coordinates loaded.',h_fig,'error');
    return
end

% build file name
if ~isempty(varargin)
    pname = varargin{1};
    fname = varargin{2};
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
    fromRoutine = true;
else
    [o,movName,o] = fileparts(prm.itg_movFullPth);
    defName = cat(2,setCorrectPath(folderRoot,h_fig),movName,...
        '.mash');
    [fname,pname,o] = uiputfile({'*.mash;', 'MASH project(*.mash)'; ...
         '*.*','All Files (*.*)'},'Export MASH project',defName);
     fromRoutine = false;
end
if ~sum(fname)
    return
end
cd(pname);
[o,fname,o] = fileparts(fname);
fname_proj = getCorrName(cat(2,fname,'.mash'),pname,h_fig);
if ~sum(fname_proj)
    return
end

% export data
dat = exportProject(p,cat(2,pname,fname_proj),h_fig);
if isempty(dat)
    return
end

% save project
save(cat(2,pname,fname_proj),'-struct','dat');

% export other files
if ~fromRoutine
    pname = [];
end
saveTraces(dat,pname,fname_proj,...
    {prm.itg_expMolFile prm.itg_expFRET},h_fig);

