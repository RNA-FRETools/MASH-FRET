function edit_TP_states_paramRefine_Callback(obj, evd, h)

% Last update: by MH, 3.4.2019
% >> adjust selected data index in popupmenu, chan_in, to shorter 
%    popupmenu size when discretization is only applied to bottom traces

p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    val = round(str2num(get(obj, 'String')));
    set(obj, 'String', num2str(val));
    if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        updateActPan('Number of refinment cycles must be >= 0', ...
            h.figure_MASH, 'error');
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        method = p.proj{proj}.curr{mol}{4}{1}(1);
        chan_in = p.proj{proj}.fix{3}(4);
        
        % added by MH, 3.4.2019
        nFRET = size(p.proj{proj}.FRET,1);
        nS = size(p.proj{proj}.S,1);
        toFRET = p.proj{proj}.curr{mol}{4}{1}(2);
        if toFRET==1 && (nFRET+nS)>0
            if chan_in>(nFRET+nS)
                chan_in = nFRET + nS;
            end
        end
        
        p.proj{proj}.curr{mol}{4}{2}(method,5,chan_in) = val;
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
        ud_DTA(h.figure_MASH);
    end
end