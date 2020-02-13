function pushbutton_impMovFile_Callback(obj, evd, h_fig)
[fname, pname, o] = uigetfile({ ...
    '*.sif;*.sira;*.tif;*.gif;*.png;*.spe;*.pma', ...
    ['Supported Graphic File Format' ...
    '(*.sif,*.sira,*.tif,*.gif,*.png,*.spe,*.pma)']; ...
    '*.*', 'All File Format(*.*)'}, 'Select a graphic file:');
if ~isempty(fname) && sum(fname)
    h = guidata(h_fig);
    m = guidata(h.figure_trImpOpt);
    m{2}{2} = [pname fname];
    set(h.trImpOpt.text_fnameMov, 'String', fname);
    guidata(h.figure_trImpOpt, m);
end


