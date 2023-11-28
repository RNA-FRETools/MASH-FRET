function edit_TP_states_param3_Callback(obj, evd, h_fig)

% Last update by MH, 27.12.2020: add 2D-vbFRET
% created by MH, 3.4.2019: function was missing (???)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);
chan_in = p.proj{proj}.TP.fix{3}(4);
method = p.proj{proj}.TP.curr{mol}{4}{1}(1);
toFRET = p.proj{proj}.TP.curr{mol}{4}{1}(2);
    
% added by MH, 3.4.2019
if toFRET==1 && (nFRET+nS)>0
    if chan_in>(nFRET+nS)
        chan_in = nFRET + nS;
    end
end

if ~sum(double(method == [2,3,5,7]))
    return
end

val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if isempty(val) || numel(val)~=1 || isnan(val) || ...
        ((method==2 || method==3) && val<=0) || ...
        (method==5 && ~(val==1 || val==2))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);

    switch method
        case 2 % VbFRET-1D
            updateActPan('Number of iterations must be > 0',...
                h_fig,'error');

        case 3 % VbFRET-2D
            updateActPan('Number of iterations must be > 0',...
                h_fig,'error');

        case 5 % CPA
            updateActPan(cat(2,'Method for change localisation ',...
                'must be 1 or 2 ("max." or "MSE")'),h_fig,...
                'error');

        case 7 % STaSI+VbFRET-1D
            updateActPan('Number of iterations must be > 0',...
                h_fig,'error');
    end
    return
end

p.proj{proj}.TP.curr{mol}{4}{2}(method,3,chan_in) = val;

h.param = p;
guidata(h_fig, h);

ud_DTA(h_fig);
