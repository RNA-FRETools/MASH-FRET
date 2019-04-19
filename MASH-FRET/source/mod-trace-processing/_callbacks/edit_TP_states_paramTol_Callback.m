function edit_TP_states_paramTol_Callback(obj, evd, h)

% Last update: by MH, 3.4.2019
% >> adjust selected data index in popupmenu, chan_in, to shorter 
%    popupmenu size when discretization is only applied to bottom traces
% >> correct destination for tolerance window size parameter: specific to
%    each bottom trace data

p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    toBot = p.proj{proj}.curr{mol}{4}{1}(2);
    if ~toBot
        val = round(str2num(get(obj, 'String')));
        set(obj, 'String', num2str(val));
        valMax = ...
            p.proj{proj}.nb_excitations*size(p.proj{proj}.intensities,1);
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
                val >= 0 && val <= valMax)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan(['Width of changing zone must be >= 0 and <= ' ...
                num2str(valMax)], h.figure_MASH, 'error');
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            method = p.proj{proj}.curr{mol}{4}{1}(1);
            
            % corrected by MH, 3.4.2019
%             p.proj{proj}.curr{mol}{4}{2}(method,4,:) = val;
            
            % added by MH, 3.4.2019
            chan_in = p.proj{proj}.fix{3}(4);
            nFRET = size(p.proj{proj}.FRET,1);
            nS = size(p.proj{proj}.S,1);
            toFRET = p.proj{proj}.curr{mol}{4}{1}(2);
            if toFRET==1 && (nFRET+nS)>0
                if chan_in>(nFRET+nS)
                    chan_in = nFRET + nS;
                end
            end
            
            % corrected by MH, 3.4.2019
            p.proj{proj}.curr{mol}{4}{2}(method,4,chan_in) = val;
            
            h.param.ttPr = p;
            guidata(h.figure_MASH, h);
            ud_DTA(h.figure_MASH);
        end
    end
end