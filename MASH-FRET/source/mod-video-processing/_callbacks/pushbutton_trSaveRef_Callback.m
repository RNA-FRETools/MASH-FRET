function pushbutton_trSaveRef_Callback(obj,evd,h_fig)
% pushbutton_trSaveRef_Callback([],[],h_fig)
% pushbutton_trSaveRef_Callback(file,[],h_fig)
%
% h_fig: handle to main figure
% file: {1-by-2} cell array with:
%  file{1}: file locations
%  file{2}: file name

% retrieve parameters
h = guidata(h_fig);
p = h.param;
coordref = p.proj{p.curr_proj}.VP.curr.res_crd{3};

% control reference coordinates
if isempty(coordref)
    setContPan(['No reference coordinates detected. Please map ',...
        'coordinates first.'],'error',h_fig);
    return
end

% get destination coordinates file
if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if pname(end)~=filesep
        pname = [pname,filesep];
    end
else
    [o,defName,o] = fileparts(q.refimgfile);
    defName = [setCorrectPath('mapping', h_fig) defName '.map'];
    [fname,pname,o] = uiputfile({'*.map','Mapped coordinates files(*.map)'; ...
        '*.*','All files(*.*)'},'Export coordinates', defName);
end
if ~sum(fname)
    return
end
cd(pname);
[o,fname,o] = fileparts(fname);
fname = getCorrName([fname '.map'], pname, h_fig);
if ~sum(fname)
    return
end

% save coordinates to file
f = fopen([pname fname], 'Wt');
fprintf(f, 'x\ty\n');
fprintf(f, '%d\t%d\n', coordref');
fclose(f);

% display succes
setContPan(['Reference coordinates were successfully saved to file: ',...
    pname,fname], 'success', h_fig);
