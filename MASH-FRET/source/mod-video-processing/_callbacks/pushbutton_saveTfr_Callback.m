function pushbutton_saveTfr_Callback(obj, evd, h_fig)
% pushbutton_saveTfr_Callback([],[],h_fig)
% pushbutton_saveTfr_Callback(outfile,[],h_fig)
%
% h_fig: handle to main figure
% outfile: {1-by-2} destination folder and file

% collect parameters
h = guidata(h_fig);
p = h.param;
tr = p.proj{p.curr_proj}.VP.curr.res_crd{2};

% control transformation
if isempty(tr)
    setActPan(['No transformation detected. Please calculate or import a ',...
        'transformation.'],'error',h_fig);
    return
end

% get file name
if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if ~strcmp(pname(end),filesep)
        pname =[pname,filesep];
    end
else
    if isfield(p, 'trsf_coordRef_file') && ~isempty(p.trsf_coordRef_file)
        [o,fname,o] = fileparts(p.trsf_coordRef_file);
    else
        fname = 'transformation';
    end
    defName = [setCorrectPath('transformed', h_fig) fname '.mat'];
    [fname,pname,o] = uiputfile({'*.mat', 'Matlab files(*.mat)'; ...
        '*.*', 'All files(*.*)'}, 'Export transformation', defName);
end
if ~sum(fname)
    return
end
cd(pname);
[o,fname,o] = fileparts(fname);
fname_tr = getCorrName([fname '_trs.mat'], pname, h_fig);
if ~sum(fname_tr)
    return
end

% save transformation to file
save([pname fname_tr],'-mat','tr');

% set GUI to proper values
ud_VP_coordTransfPan(h_fig);

% display success
setActPan(['Transformation was successfully exported to file: ',pname,...
    fname_tr],'success',h_fig);
