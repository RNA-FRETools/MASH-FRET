% MH modified checkbox to popupmenu 26.3.2019
% FS added 8.1.2018, last modified 11.1.2018
function popupmenu_TP_factors_method_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    method = get(obj, 'Value');
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    toFRET = p.proj{proj}.curr{mol}{4}{1}(2);
    
    if (method==2 && toFRET == 1) % if DTA applied to bottom traces, deactivate pb gamma calculation
        val = 0;
        helpdlg({cat(2,'Photobleaching-based gamma calculation needs donor ',...
            'intensity-time traces to be discretized') '' cat(2,'To ',...
            'discretize intensity-time traces, go to panel "Find states" ',...
            'set "apply to" to "top" or "all"')},...
            'Photobleaching-based gamma');
        
    elseif method==1 % manual
        val = 0;
        
    else % photobleaching-based calculation
        val = 1;
    end
    
    p.proj{proj}.curr{mol}{5}{4}(1) = val; % pb based gamma corr checkbox
    p.proj{proj}.curr{mol}{5}{5}(1) = val; % show cutoff checkbox
    
    h.param.ttPr = p;
    guidata(h_fig, h);
    ud_cross(h_fig);
%     updateFields(h_fig, 'ttPr');
    
%     if val == 1 % added by FS, 24.7.2018
%         updateFields(h_fig, 'ttPr');
%     end
    
    % get updated handle (updated in updateFields)
    % h = guidata(h_fig) is called at the beginning of the next function (updateFields is the last function),
    % but here the handle is still needed for the next line
%     h = guidata(h_fig);
%     set(obj, 'Value', h.param.ttPr.proj{proj}.curr{mol}{5}{4}(1)) % updates the pb Gamma checkbox
end