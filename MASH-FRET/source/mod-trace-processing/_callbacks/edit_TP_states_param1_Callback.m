function edit_TP_states_param1_Callback(obj, evd, h)

% Last update: by MH, 3.4.2019
% >> adjust selected data index in popupmenu, chan_in, to shorter 
%    popupmenu size when discretization is only applied to bottom traces

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
    
    if sum(double(method == [1,2,4,5]))
        val = round(str2num(get(obj, 'String')));
        set(obj, 'String', num2str(val));
        
        if method == 2 % VbFRET
            maxVal = p.proj{proj}.curr{mol}{4}{2}(method,2,chan_in);
        else
            maxVal = Inf;
        end

        if ~(~isempty(val) && numel(val)==1 && ~isnan(val) && val>0 && ...
                val<maxVal)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            
            switch method
                case 1 % Threshold
                    updateActPan('Number of states must be > 0', ...
                        h.figure_MASH, 'error');
                    
                case 2 % VbFRET
                    updateActPan(cat(2,'Minimum number of states must be ',...
                        '> 0 and < ',num2str(maxVal)),h.figure_MASH,...
                        'error');

                case 4 % CPA
                    updateActPan('Number of bootstrap samples must be > 0', ...
                        h.figure_MASH, 'error');
                    
                case 5 % STaSI
                    updateActPan('Maximum number of states must be > 0', ...
                        h.figure_MASH, 'error');
            end

        else
            set(obj, 'BackgroundColor', [1 1 1]);
            
            if method==1 % Threshold
                thresh = p.proj{proj}.curr{mol}{4}{4};
                if size(thresh,2)<val
                    thresh = cat(2,thresh,repmat(thresh(:,end,:),...
                        [1,val-size(thresh,2),1]));
                end
                p.proj{proj}.curr{mol}{4}{4} = thresh;
            end
            
            p.proj{proj}.curr{mol}{4}{2}(method,1,chan_in) = val;
            h.param.ttPr = p;
            guidata(h.figure_MASH, h);
            ud_DTA(h.figure_MASH);
        end
    end
end