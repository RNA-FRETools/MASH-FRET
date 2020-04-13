function edit_TP_states_deblurr_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param.ttPr;

if isempty(p.proj)
    return
end

val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));

if ~(numel(val)==1 && (val==0 || val==1))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Deblurr option must be 1 (activated) or 0 (deactivated)',...
        h_fig,'error');
    return
end

% collect project parameters
proj = p.curr_proj;
mol = p.curr_mol(proj);
method = p.proj{proj}.curr{mol}{4}{1}(1);
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);
toFRET = p.proj{proj}.curr{mol}{4}{1}(2);
chan_in = p.proj{proj}.fix{3}(4);

% correct selected channel if necessary
if toFRET==1 && (nFRET+nS)>0
    if chan_in>(nFRET+nS)
        chan_in = nFRET + nS;
    end
end

% save new parameters
p.proj{proj}.curr{mol}{4}{2}(method,7,chan_in) = val;
h.param.ttPr = p;
guidata(h_fig, h);

% update panel
ud_DTA(h_fig);
