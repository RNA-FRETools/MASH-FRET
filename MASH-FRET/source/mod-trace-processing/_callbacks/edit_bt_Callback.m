function edit_bt_Callback(obj, evd, h_fig)

% Last update by MH 29.3.2019
% >> adapt bleethrough coefficients to new parameter structure (see 
%    project/setDefPrm_traces.m)

h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    val = str2num(get(obj, 'String'));
    if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0 ...
            && val <= 1)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        updateActPan('Bleedthrough coefficient must be >= 0 and <= 1', ...
            h_fig, 'error');
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        proj = p.curr_proj;
        mol = p.curr_mol(proj);
        
        % cancelled by MH,29.3.2019
%         exc = p.proj{proj}.fix{3}(1);

        chan_in = p.proj{proj}.fix{3}(2);
        chan_out = p.proj{proj}.fix{3}(3);
        
        % modified by MH,29.3.2019
%         p.proj{proj}.curr{mol}{5}{1}{exc,chan_in}(chan_out) = val;
        p.proj{proj}.curr{mol}{5}{1}(chan_in,chan_out) = val;
        
        h.param.ttPr = p;
        guidata(h_fig, h);
        ud_cross(h_fig);
    end
end