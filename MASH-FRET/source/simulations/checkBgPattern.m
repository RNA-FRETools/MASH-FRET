function [ok, p] = checkBgPattern(p, h_fig)

ok = 1;

if ~isfield(p, 'bgImg') || isempty(p.bgImg)
    data = getFile2sub('Pick a BG pattern image', h_fig);
    if isempty(data)
        ok = 0;
        return;
    end
    if strcmp(intUnits, 'electron')
        data.frameCur = arb2phtn(data.frameCur);
    end
    p.bgImg = data;
else
    loadBG = questdlg('Load another BG pattern?', ...
        'Background image', 'Yes', 'No', 'No');
    if isempty(loadBG)
        ok = 0;
        return;
    elseif strcmp(loadBG, 'Yes')
        data = getFile2sub('Pick a BG pattern image', h_fig);
        if isempty(data)
            ok = 0;
            return;
        end
        if strcmp(intUnits, 'electron')
            data.frameCur = arb2phtn(data.frameCur);
        end
        p.bgImg = data;
    end
end
