function ud_TDPdata(h_fig)
% ud_TDPdata(h_fig)
%
% Recalculates and store TDP 
%
% h_fig: handle to main figure

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

proj = p.curr_proj; % current project
tpe = p.TDP.curr_type(proj); % current channel type
tag = p.TDP.curr_tag(proj); % current channel type

[p,ok,str] = buildTDP(p,tag,tpe);
if ~ok && strcmp(p.curr_mod{proj},'TA')
    setContPan(str, 'warning', h_fig);
end

h.param = p;
guidata(h_fig, h);
