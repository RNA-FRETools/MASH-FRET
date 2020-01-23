function edit_nLasers_Callback(obj, evd, h_fig)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('The number of lasers must be an integer > 0.', ...
        h_fig, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    p = h.param.movPr;
    isLasPrm = [strncmp({p.itg_expMolPrm{:,1}}', 'Power(', 6)];
    [lasPrmRow,o,o] = find(isLasPrm);
    fstLasPrm = lasPrmRow(1);
    lastLasPrm = lasPrmRow(end);
    defPrm = {p.itg_expMolPrm{1:(fstLasPrm-1),:}};
    defPrm = reshape(defPrm, [numel(defPrm)/3 3]);
    addPrm = {p.itg_expMolPrm{(lastLasPrm+1):end,:}};
    addPrm = reshape(addPrm, [numel(addPrm)/3 3]);
    for i = 1:val
        prmVal = [];
        if numel(p.itg_wl) < i
            p.itg_wl(i) = round(p.itg_wl(i-1)*1.2);
        elseif size(p.itg_expMolPrm,2) >= fstLasPrm+i-1
            prmVal = p.itg_expMolPrm{fstLasPrm+i-1,2};
        end
        lasPrm{i,1} = ['Power(' ...
            num2str(round(p.itg_wl(i))) 'nm)'];
        lasPrm{i,2} = prmVal;
        lasPrm{i,3} = 'mW';

    end

    % remove laser wavelengths if reducing the number of lasers
    p.itg_wl = p.itg_wl(1:val);

    for ii = 1:size(p.chanExc,2)
        if isempty(find(p.itg_wl==p.chanExc(ii),1))
            % remove FRET calculations for which donors are not directly
            % excited anymore
            if size(p.itg_expFRET,1)>0
                p.itg_expFRET(p.itg_expFRET(:,1)==ii,:) = [];
            end

            % remove S calculations for dyes that are not directly
            % excited anymore
            if size(p.itg_expS,1)>0
                p.itg_expS(p.itg_expS(:,1)==ii | p.itg_expS(:,2)==ii,:) = ...
                    [];
            end

            % remove channel excitations if reducing the number of lasers
            p.chanExc(ii) = 0;
        end
    end

    if ~isempty(find(size(p.itg_expFRET)==0))
        p.itg_expFRET = [];
    end
    if ~isempty(find(size(p.itg_expS)==0))
        p.itg_expS = [];
    end

    % redifine colors for intensity trajectories
    clr_ref = getDefTrClr(val, p.itg_wl, p.nChan, size(p.itg_expFRET,1),...
        size(p.itg_expS,1));
    p.itg_clr{1} = clr_ref{1}(1:numel(p.itg_wl),:);
    p.itg_clr{2} = clr_ref{2}(1:size(p.itg_expFRET,1),:);
    p.itg_clr{3} = clr_ref{3}(1:size(p.itg_expS,1),:);

    p.itg_expMolPrm = [defPrm;lasPrm;addPrm];
    p.itg_nLasers = val;

    h.param.movPr = p;
    guidata(h_fig, h);
    updateFields(h_fig, 'movPr');
end