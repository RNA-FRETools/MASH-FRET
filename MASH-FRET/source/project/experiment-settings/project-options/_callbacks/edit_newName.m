function edit_newName(obj, evd, h_fig)
str = get(obj, 'String');
maxN = 10;
if ~(~isempty(str) && length(str) <= maxN)
    updateActPan(['Parameter name must not be empty and must contain ' ...
        num2str(maxN) ' characters at max.'], h_fig, 'error');
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
else
    set(obj, 'BackgroundColor', [1 1 1]);
end