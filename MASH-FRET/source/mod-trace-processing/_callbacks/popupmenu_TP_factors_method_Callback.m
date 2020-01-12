% MH modified checkbox to popupmenu 26.3.2019
% FS added 8.1.2018, last modified 11.1.2018
function popupmenu_TP_factors_method_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    method = get(obj, 'Value');
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
%     toFRET = p.proj{proj}.curr{mol}{4}{1}(2);
%     
%     if (method==2 && toFRET == 1) % if DTA applied to bottom traces, deactivate pb gamma calculation
%         val = 0;
%         helpdlg({cat(2,'Photobleaching-based gamma calculation needs donor ',...
%             'intensity-time traces to be discretized') '' cat(2,'To ',...
%             'discretize intensity-time traces, go to panel "Find states" ',...
%             'set "apply to" to "top" or "all"')},...
%             'Photobleaching-based gamma');
%         
%     else
%         val = method-1;
%     end
%     
%     p.proj{proj}.curr{mol}{6}{2}(1) = val; % method
    
    p.proj{proj}.curr{mol}{6}{2}(1) = method-1; % method
    h.param.ttPr = p;
    guidata(h_fig, h);
    ud_factors(h_fig)
end
