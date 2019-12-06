function edit_TP_states_param2_Callback(obj, evd, h_fig)

% Last update: by MH, 3.4.2019
% >> adjust selected data index in popupmenu, chan_in, to shorter 
%    popupmenu size when discretization is only applied to bottom traces

h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
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
    
    if sum(double(method == [2,4]))
        val = round(str2num(get(obj, 'String')));
        set(obj, 'String', num2str(val));
    
        if method == 2 % VbFRET
            minVal = p.proj{proj}.curr{mol}{4}{2}(method,2,chan_in);
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

                case 4 % CPA
                    updateActPan('Confidence level must be >= 0 and <= 100', ...
                        h_fig, 'error');
            end
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            p.proj{proj}.curr{mol}{4}{2}(method,2,chan_in) = val;
            h.param.ttPr = p;
            guidata(h_fig, h);
            ud_DTA(h_fig);
        end
    end
end