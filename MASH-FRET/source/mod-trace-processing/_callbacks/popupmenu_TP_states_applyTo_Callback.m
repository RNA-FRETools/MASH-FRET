function popupmenu_TP_states_applyTo_Callback(obj, evd, h_fig)

% Last update: by MH, 3.4.2019
% >> adjust selected data index in popupmenu, fix{3}(4), to shorter 
%    popupmenu size when discretization is only applied to bottom traces

h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    val = get(obj, 'Value');
    meth = p.proj{proj}.curr{mol}{4}{1}(1);
    if meth==3 && val~=1
        val = 1;
        disp(['2D analysis is available for intensity ratio (bottom)',...
            ' traces only.']);
    end

    switch val
        
        case 1 % bottom
            p.proj{proj}.curr{mol}{4}{1}(2) = 1;
            
            % added by MH, 3.4.2019
            nFRET = size(p.proj{proj}.FRET,1);
            nS = size(p.proj{proj}.S,1);
            chan = p.proj{proj}.fix{3}(4);
            if chan>nFRET+nS
                chan = nFRET+nS;
            end
            p.proj{proj}.fix{3}(4) = chan;
            
            % modified by MH, 26.03.2019:
            % the warning is activated when choosing the
            % photobleaching-based calculation
%             % added by FS, 5.6.2018
%             % disable photobleaching based gamma factor determination
%             % popupmenu and pushbutton are enable again if isDiscrTop is 1 in 'discrTraces.m'
%             set(h.pushbutton_optGamma, 'enable', 'off')
%             p.proj{proj}.curr{mol}{5}{4}(1) = 0; % deactivate the pb based gamma correction checkbox
%             set(h.popupmenu_TP_factors_method, 'enable', 'off', 'Value', 1)
    
        case 2 % top
            p.proj{proj}.curr{mol}{4}{1}(2) = 0;
            
            % modified by MH, 26.03.2019:
            % the warning is activated when choosing the
            % photobleaching-based calculation
%             % added by FS, 5.6.2018
%             % disable photobleaching based gamma factor determination
%             % popupmenu and pushbutton are enable again if isDiscrTop is 1 in 'discrTraces.m'
%             set(h.pushbutton_optGamma, 'enable', 'on')
%             p.proj{proj}.curr{mol}{5}{4}(1) = 1; % activate the pb based gamma correction checkbox
%             set(h.popupmenu_TP_factors_method, 'enable', 'on', 'Value', 2)
    
        case 3 % all
            p.proj{proj}.curr{mol}{4}{1}(2) = 2;
    end

    h.param.ttPr = p;
    guidata(h_fig, h);
    ud_DTA(h_fig);
end