function expTraces(h_fig,varargin)
% expTraces(h_fig)
% expTraces(h_fig,pname,fname)
%
% Save traces to ASCII or MATLAB binary file formats.
% expTraces can be called either after pressing "Export" in Video processing, or from a test routine.
% 
% h_fig: handle to main figure
% pname: destination folder (from routine test)
% fname: destination file name (from routine test)

% collect parameters
h = guidata(h_fig);
p = h.param;
folderRoot = p.proj{p.curr_proj}.folderRoot;
vidfile = p.proj{p.curr_proj}.movie_file;
FRET = p.proj{p.curr_proj}.FRET;
expprm = p.proj{p.curr_proj}.VP.curr.gen_int{4};

% build file name
if ~isempty(varargin)
    pname = varargin{1};
    fname = varargin{2};
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
    fromRoutine = true;
else
    [o,movName,o] = fileparts(vidfile);
    defName = cat(2,setCorrectPath(folderRoot,h_fig),movName);
    [fname,pname,o] = uiputfile({'*.*','All Files (*.*)'},...
        'Export traces',defName);
     fromRoutine = false;
end
if ~sum(fname)
    return
end
cd(pname);
[o,fname,o] = fileparts(fname);
fname_proj = getCorrName(fname,pname,h_fig);
if ~sum(fname_proj)
    return
end

% export files
if ~fromRoutine
    pname = [];
end
saveTraces(p.proj{p.curr_proj},pname,fname_proj,{expprm FRET},h_fig);
