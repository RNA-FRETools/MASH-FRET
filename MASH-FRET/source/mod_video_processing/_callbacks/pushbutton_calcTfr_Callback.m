function pushbutton_calcTfr_Callback(obj, evd, h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

if p.nChan<=1 || p.nChan>3
    updateActPan(['This functionality is available for 2 or 3 ' ...
        'channels only.'], h_fig, 'error');
    return
end

if ~(isfield(p, 'trsf_coordRef') && ~isempty(p.trsf_coordRef))
    updateActPan('No reference coordinates loaded.', h_fig, 'error');
    return
end

tform_type = p.trsf_type;
if tform_type<=1
    updateActPan('Select a transformation type.', h_fig, 'error');
    return
end

% calculate transformation
tr = createTrafo(tform_type, p.trsf_coordRef, h_fig);
if isempty(tr)
    return
end

p.trsf_tr = tr;

str_type = get(h.popupmenu_trType, 'String');
str_type = str_type{tform_type};

% get file name
saved = 1;
if isfield(p, 'trsf_coordRef_file') && ~isempty(p.trsf_coordRef_file)
    [o,fname,o] = fileparts(p.trsf_coordRef_file);
else
    fname = 'transformation';
end
defName = [setCorrectPath('transformed', h_fig) fname '.mat'];
[fname,pname,o] = uiputfile({'*.mat', 'Matlab files(*.mat)'; ...
    '*.*', 'All files(*.*)'}, 'Export transformation', defName);
if ~sum(fname)
    saved = 0;
else
    % save transformation to file
    cd(pname);
    [o,fname,o] = fileparts(fname);
    fname_tr = getCorrName([fname '_trs.mat'], pname, h_fig);
    if ~sum(fname_tr)
        saved = 0;
    end
end
if ~saved
    p.trsf_tr_file = [];
else
    save([pname fname_tr], '-mat', 'tr' );
    p.trsf_tr_file = fname_tr;
end

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_coordTransfPan(h_fig);

% show action
updateActPan(['Transformation from type "' str_type '" was successfully ',...
    'calculated and exported to file: ' pname fname_tr], h_fig, 'success');
