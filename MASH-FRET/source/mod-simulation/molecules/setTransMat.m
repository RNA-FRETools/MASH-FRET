function setTransMat(transMat, h_fig)
% setTransMat(transMat, h_fig)
%
% fill up edit fields with transition rate constants
%
% transMat: transition rate constant matrix (in frame-1)
% h_fig: handle to main figure

% default
lightgray = [0.939,0.939,0.939];

h = guidata(h_fig);
p = h.param;
inSec = p.proj{p.curr_proj}.time_in_sec;
rate = p.proj{p.curr_proj}.sim.curr.gen_dt{1}(4);

if inSec
    transMat = transMat*rate;
    str_un = 'second-1';
else
    str_un = 'frame-1';
end

h_ed = [h.edit11,h.edit12,h.edit13,h.edit14,h.edit15;...
    h.edit21,h.edit22,h.edit23,h.edit24,h.edit25;...
    h.edit31,h.edit32,h.edit33,h.edit34,h.edit35;...
    h.edit41,h.edit42,h.edit43,h.edit44,h.edit45;...
    h.edit51,h.edit52,h.edit53,h.edit54,h.edit55];

J = size(h_ed,1);

for j1 = 1:J
    for j2 = 1:J
        ttstr = wrapHtmlTooltipString(sprintf(['transition rate constant ',...
            '<b>%i->%i</b> (in ',str_un,')'],j1,j2));
        set(h_ed(j1,j2),'string',num2str(transMat(j1,j2)),'tooltipstring',...
            ttstr);
        if transMat(j1,j2)==0
            set(h_ed(j1,j2),'backgroundcolor',lightgray);
        end
    end
end
