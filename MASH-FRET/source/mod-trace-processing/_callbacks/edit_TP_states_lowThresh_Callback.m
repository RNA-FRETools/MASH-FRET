function edit_TP_states_lowThresh_Callback(obj, evd, h_fig)

% Last update: by MH, 3.4.2019
% >> adjust selected data index in popupmenu, chan_in, to shorter 
%    popupmenu size when discretization is only applied to bottom traces

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
nFRET = size(p.proj{proj}.TP.FRET,1);
nS = size(p.proj{proj}.TP.S,1);
chan_in = p.proj{proj}.TP.fix{3}(4);
method = p.proj{proj}.TP.curr{mol}{4}{1}(1);
toFRET = p.proj{proj}.TP.curr{mol}{4}{1}(2);

if method~=1 % Threshold
    return
end

val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Lower threshold value must be a number.',h_fig,'error');
    return
end

if toFRET==1 && (nFRET+nS)>0
    if chan_in>(nFRET+nS)
        chan_in = nFRET + nS;
    end
end

if chan_in > (nFRET + nS)
    perSec = p.proj{proj}.TP.fix{2}(4);
    perPix = p.proj{proj}.TP.fix{2}(5);
    if perSec
        expT = p.proj{proj}.frame_rate;
        val = val*expT;
    end
    if perPix
        nPix = p.proj{proj}.pix_intgr(2);
        val = val*nPix;
    end
end
state = get(h.popupmenu_TP_states_indexThresh,'value');
p.proj{proj}.TP.curr{mol}{4}{4}(2,state,chan_in) = val;

h.param = p;
guidata(h_fig, h);

ud_DTA(h_fig);

