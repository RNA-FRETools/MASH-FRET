function setTransMat(transMat, h_fig)

% default
lightgray = [0.939,0.939,0.939];

h = guidata(h_fig);

h_ed = [h.edit11 h.edit21 h.edit31 h.edit41 h.edit51 
    h.edit12 h.edit22 h.edit32 h.edit42 h.edit52
    h.edit13 h.edit23 h.edit33 h.edit43 h.edit53
    h.edit14 h.edit24 h.edit34 h.edit44 h.edit54
    h.edit15 h.edit25 h.edit35 h.edit45 h.edit55];

J = size(h_ed,1);

for j1 = 1:J
    for j2 = 1:J
        set(h_ed(j1,j2),'string',num2str(transMat(j2,j1)));
        if transMat(j2,j1)==0
            set(h_ed(j1,j2),'backgroundcolor',lightgray);
        end
    end
end
