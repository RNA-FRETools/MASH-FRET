function edit_dirExc_Callback(obj, evd, h_fig)

% Last update by MH 29.3.2019
% >> adapt direct excitation coefficients to new parameter structure (see 
%    project/setDefPrm_traces.m)

h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    val = str2num(get(obj, 'String'));
    if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0 ...
            && val <= 1)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        updateActPan(['Direct excitation coefficient must be >= 0 and ' ...
            '<= 1'], h_fig, 'error');
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        proj = p.curr_proj;
        exc_in = p.proj{proj}.fix{3}(1);
        chan_in = p.proj{proj}.fix{3}(2);
        
        % modified by MH, 13.1.2020
%         % modified by MH, 29.3.2019
% %         exc_base = p.proj{proj}.fix{3}(7);
% %         p.proj{proj}.curr{mol}{5}{2}{exc_in,chan_in}(exc_base) = val;
%         p.proj{proj}.curr{mol}{5}{2}(exc_in,chan_in) = val;
        p.proj{proj}.fix{4}{2}(exc_in,chan_in) = val;
        
        h.param.ttPr = p;
        guidata(h_fig, h);
        updateFields(h_fig,'cross');
    end
end