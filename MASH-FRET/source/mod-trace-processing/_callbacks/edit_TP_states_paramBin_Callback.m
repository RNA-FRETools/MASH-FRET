function edit_TP_states_paramBin_Callback(obj, evd, h_fig)

% Last update: by MH, 3.4.2019
% >> adjust selected data index in popupmenu, chan_in, to shorter 
%    popupmenu size when discretization is only applied to bottom traces

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);
chan_in = p.proj{proj}.TP.fix{3}(4);
method = p.proj{proj}.TP.curr{mol}{4}{1}(1);
toFRET = p.proj{proj}.TP.curr{mol}{4}{1}(2);

val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('State binning must be >= 0', ...
        h_fig, 'error');
    return
end
        
% added by MH, 3.4.2019
if toFRET==1 && (nFRET+nS)>0
    if chan_in>(nFRET+nS)
        chan_in = nFRET + nS;
    end
end

if chan_in > (nFRET + nS)
    perSec = p.proj{proj}.cnt_p_sec;
    if perSec
        expT = p.proj{proj}.frame_rate;
        val = val*expT;
    end
end

p.proj{proj}.TP.curr{mol}{4}{2}(method,6,chan_in) = val;

h.param = p;
guidata(h_fig, h);

ud_DTA(h_fig);
