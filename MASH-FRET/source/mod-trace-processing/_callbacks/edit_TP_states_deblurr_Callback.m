function edit_TP_states_deblurr_Callback(obj,evd,h_fig)

% collect project parameters
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);
chan_in = p.proj{proj}.TP.fix{3}(4);
method = p.proj{proj}.TP.curr{mol}{4}{1}(1);
toFRET = p.proj{proj}.TP.curr{mol}{4}{1}(2);


val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));

if ~(numel(val)==1 && (val==0 || val==1))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Deblurr option must be 1 (activated) or 0 (deactivated)',...
        h_fig,'error');
    return
end

% correct selected channel if necessary
if toFRET==1 && (nFRET+nS)>0
    if chan_in>(nFRET+nS)
        chan_in = nFRET + nS;
    end
end

% save new parameters
p.proj{proj}.TP.curr{mol}{4}{2}(method,7,chan_in) = val;
h.param = p;
guidata(h_fig, h);

% update panel
ud_DTA(h_fig);
