function pushbutton_trsfOpt_ok_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.movPr;
nChan = h.param.movPr.nChan;

if get(h.trsfOpt.radiobutton_rw, 'Value')
    p.trsf_refImp_mode = 'rw';
else
    p.trsf_refImp_mode = 'cw';
end

for i = 1:nChan
    p.trsf_refImp_rw{1}(i,1:3) = ...
        [str2num(get(h.trsfOpt.edit_start(i), 'String')) ...
        str2num(get(h.trsfOpt.edit_iv(i), 'String')) ...
        str2num(get(h.trsfOpt.edit_stop(i), 'String'))];
    
    p.trsf_refImp_cw{1}(i,1:2) = ...
        [str2num(get(h.trsfOpt.edit_cColX(i), 'String')) ...
        str2num(get(h.trsfOpt.edit_cColY(i), 'String'))];
end

p.trsf_refImp_rw{2} = [str2num(get(h.trsfOpt.edit_rColX, 'String')) ...
    str2num(get(h.trsfOpt.edit_rColY, 'String'))];

p.trsf_refImp_cw{2} = str2num(get(h.trsfOpt.edit_nHead, 'String'));

p.trsf_coordImp = [str2num(get(h.trsfOpt.edit_molXcol, 'String')) ...
    str2num(get(h.trsfOpt.edit_molYcol, 'String'))];

p.trsf_coordLim = [str2num(get(h.trsfOpt.edit_movW, 'String')) ...
    str2num(get(h.trsfOpt.edit_movH, 'String'))];

h.param.movPr = p;
guidata(h_fig, h);

close(h.figure_trsfOpt);
