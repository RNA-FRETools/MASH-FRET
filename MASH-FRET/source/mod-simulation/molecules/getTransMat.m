function transMat = getTransMat(h_fig)
% getTransMat returns the numerical transition matrice from the edit fields

h = guidata(h_fig);

% gather handles to edit fields in a matrix
h_ed = [h.edit11,h.edit12,h.edit13,h.edit14,h.edit15;...
    h.edit21,h.edit22,h.edit23,h.edit24,h.edit25;...
    h.edit31,h.edit32,h.edit33,h.edit34,h.edit35;...
    h.edit41,h.edit42,h.edit43,h.edit44,h.edit45;...
    h.edit51,h.edit52,h.edit53,h.edit54,h.edit55];

% get transition rate constants
transMat = zeros(size(h_ed));
for r = 1:size(transMat,1)
    for c = 1:size(transMat,2)
        k_rc = str2double(h_ed(r,c).String);
        if ~isempty(k_rc) && numel(k_rc)==1 && ~isnan(k_rc)
            transMat(r,c) = k_rc;
        end
    end
end