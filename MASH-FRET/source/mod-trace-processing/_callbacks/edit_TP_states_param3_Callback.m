function edit_TP_states_param3_Callback(obj, evd, h_fig)

% created by MH, 3.4.2019
% >> function was missing (???)

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

        if isempty(val) || numel(val)~=1 || isnan(val) || ...
                (method==2 && val<=0) || (method==4 && ~(val==1 || val==2))
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            
            switch method
                case 2 % VbFRET
                    updateActPan('Number of iterations must be > 0',...
                        h_fig,'error');

                case 4 % CPA
                    updateActPan(cat(2,'Method for change localisation ',...
                        'must be 1 or 2 ("max." or "MSE")'),h_fig,...
                        'error');
            end
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            p.proj{proj}.curr{mol}{4}{2}(method,3,chan_in) = val;
            h.param.ttPr = p;
            guidata(h_fig, h);
            ud_DTA(h_fig);
        end
    end
end