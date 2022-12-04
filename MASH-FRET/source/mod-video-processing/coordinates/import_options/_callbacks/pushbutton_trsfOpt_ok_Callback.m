function pushbutton_trsfOpt_ok_Callback(obj, evd, h_fig)

% retrieve parameters
h = guidata(h_fig);
p = h.param;
nChan = p.proj{p.curr_proj}.nb_channel;
curr = p.proj{p.curr_proj}.VP.curr;

if get(h.trsfOpt.radiobutton_rw, 'Value')
    curr.gen_crd{3}{2}{3} = 'rw';
else
    curr.gen_crd{3}{2}{3} = 'cw';
end

for i = 1:nChan
    curr.gen_crd{3}{2}{4}{1}(i,1:3) = ...
        [str2num(get(h.trsfOpt.edit_start(i), 'String')) ...
        str2num(get(h.trsfOpt.edit_iv(i), 'String')) ...
        str2num(get(h.trsfOpt.edit_stop(i), 'String'))];
    
    curr.gen_crd{3}{2}{5}{1}(i,1:2) = ...
        [str2num(get(h.trsfOpt.edit_cColX(i), 'String')) ...
        str2num(get(h.trsfOpt.edit_cColY(i), 'String'))];
end

curr.gen_crd{3}{2}{4}{2} = [str2num(get(h.trsfOpt.edit_rColX, 'String')) ...
    str2num(get(h.trsfOpt.edit_rColY, 'String'))];

curr.gen_crd{3}{2}{5}{2} = str2num(get(h.trsfOpt.edit_nHead, 'String'));

curr.gen_crd{3}{1}{3} = [str2num(get(h.trsfOpt.edit_molXcol, 'String')) ...
    str2num(get(h.trsfOpt.edit_molYcol, 'String'))];

% save modifications
p.proj{p.curr_proj}.VP.curr = curr;
h.param = p;
guidata(h_fig, h);

% close import options figure
close(h.figure_trsfOpt);
