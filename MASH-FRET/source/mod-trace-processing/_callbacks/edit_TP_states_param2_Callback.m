function edit_TP_states_param2_Callback(obj, evd, h_fig)

% Last update by MH, 27.12.2020: add method vbFRET 2D
% update by MH, 3.4.2019: adjust selected data index in popupmenu, chan_in, to shorter popupmenu size when discretization is only applied to bottom traces

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

if method==2 || method==3 % VbFRET
    minVal = p.proj{proj}.TP.curr{mol}{4}{2}(method,1,chan_in);
    maxVal = Inf;
else
    minVal = 0;
    maxVal = 100;
end

if ~(~isempty(val) && numel(val)==1 && ~isnan(val) && val>=minVal ...
        && val<=maxVal)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);

    switch method
        case 2 % VbFRET
            updateActPan(cat(2,'Maximum number of states must be ',...
                '>= ',num2str(minVal)),h_fig,'error');

        case 3 % VbFRET
            updateActPan(cat(2,'Maximum number of states must be ',...
                '>= ',num2str(minVal)),h_fig,'error');

        case 5 % CPA
            updateActPan('Confidence level must be >= 0 and <= 100', ...
                h_fig, 'error');

        case 7 % STaSI+VbFRET-1D
            updateActPan(cat(2,'Maximum number of states must be ',...
                '>= ',num2str(minVal)),h_fig,'error');
    end
    return
end

p.proj{proj}.TP.curr{mol}{4}{2}(method,2,chan_in) = val;

h.param = p;
guidata(h_fig, h);

ud_DTA(h_fig);
