function ud_S_vidParamPan(h_fig)
% ud_S_vidParamPan(h_fig)
%
% Set panel Video parameters to proper values
%
% h_fig: handle to main figure

% defaults
str = {...
    [char(956),'_ic,dark:'],'',               [char(951),':'],'',                'K:',''; ...
    [char(956),'_ic,dark:'],[char(963),'_d:'],[char(951),':'],[char(963),'_q:'], 'K:','sat:';...
    [char(956),'_ic,dark:'],'A_CIC:',         [char(951),':'],[char(963),'_ic:'],'K:',[char(964),'_CIC:'];...
    [char(956),'_ic,dark:'], '',              [char(951),':'],'',                'K:','';...
    [char(956),'_ic,dark:'],[char(963),'_d:'],[char(951),':'],'CIC:',            'g:','s:'};
ttstr0{1} = {wrapHtmlTooltipString('Dark counts or <b>camera offset</b> (ic)'),'',...
    wrapHtmlTooltipString('Total <b>detection efficiency</b> (ec/pc)'),'',...
    wrapHtmlTooltipString('Overall <b>system gain</b> (ic/ec)'),''};
ttstr0{2} = {wrapHtmlTooltipString('Dark counts or <b>camera offset</b> (ic)'),...
        wrapHtmlTooltipString('<b>Standard deviation</b> of the read-out noise (pc)'),...
        wrapHtmlTooltipString('Total <b>quantum efficiency</b> (ec/pc)'),...
        wrapHtmlTooltipString('<b>Standard deviaton</b> of the analog-to-digital conversion noise (ec)'),...
        wrapHtmlTooltipString('Overall <b>system gain</b> (ic/ec)'),...
        wrapHtmlTooltipString('<b>Pixel saturation</b>')};
ttstr0{3} = {wrapHtmlTooltipString('Dark counts or <b>camera offset</b> (ic)'),...
        wrapHtmlTooltipString('Exponential <b>tail contribution</b>'),...
        wrapHtmlTooltipString('Total <b>quantum efficiency</b> (ec/pc)'),...
        wrapHtmlTooltipString('<b>Standard deviation</b> of the Gaussian camera noise (ic)'),...
        wrapHtmlTooltipString('Overall <b>system gain</b> (ic/ec)'),...
        wrapHtmlTooltipString('Exponential tail <b>decay constant</b> (ic)')};
ttstr0{4} = {wrapHtmlTooltipString('Dark counts or <b>camera offset</b> (ic)'),'','','','',''};
ttstr0{5} = {wrapHtmlTooltipString('Dark counts or <b>camera offset</b> (ic)'),...
        wrapHtmlTooltipString('<b>Standard deviation</b> of the read-out noise (ec)'),...
        wrapHtmlTooltipString('Total <b>detection efficiency</b> (ec/pc)'),...
        wrapHtmlTooltipString('<b>Contribution</b> of clock-induced charges (ec)'),...
        wrapHtmlTooltipString('<b>Amplification gain</b>'),...
        wrapHtmlTooltipString('<b>Amplifier sensitivity</b> or analog-to-digital factor (ec/ic)')};

% collect interface parameters
h = guidata(h_fig);
p = h.param;

if ~prepPanel(h.uipanel_S_videoParameters,h)
    return
end

% collect experiment settings and video parameters
proj = p.curr_proj;
prm = p.proj{proj}.sim;

h_txt = [h.text_camNoise_01 h.text_camNoise_02 h.text_camNoise_03 ...
    h.text_camNoise_04 h.text_camNoise_05 h.text_camNoise_06];
h_ed = [h.edit_camNoise_01 h.edit_camNoise_02 h.edit_camNoise_03 ...
    h.edit_camNoise_04 h.edit_camNoise_05 h.edit_camNoise_06];

% set GUI to proper values
set(h.edit_length, 'String', num2str(prm.nbFrames));
set(h.edit_simRate, 'String', num2str(prm.rate));
set(h.edit_pixDim, 'String', num2str(prm.pixDim));
set(h.edit_simBitPix,'String', num2str(prm.bitnr));
set(h.edit_simMov_w, 'String', num2str(prm.movDim(1)));
set(h.edit_simMov_h, 'String', num2str(prm.movDim(2)));

% get camera noise index
switch prm.noiseType
    case 'poiss' % Poisson or prm-model from Börner et al. 2017
        ind = 1;
    case 'norm' % Gaussian, Normal or N-model from Börner et al. 2017
        ind = 2;
    case 'user' % User defined or NExpN-model from Börner et al. 2017
        ind = 3;
    case 'none' 
        ind = 4;
    case 'hirsch'
        ind = 5;
end
set(h.popupmenu_noiseType, 'Value', ind);

% set all camera noise parameters
for i = 1:size(h_txt,2)
    set(h_txt(i),'string',str{ind,i});
    set(h_ed(i),'string',num2str(prm.camNoise(ind,i)),'tooltipstring',...
        ttstr0{ind}{i});
end

% adjust parameters
switch prm.noiseType
    case 'poiss' % Poisson or prm-model from Börner et al. 2017
        % turn off unused parameters
        set([h_txt([2,5,4,6]) h_ed([2,5,4,6])],'enable','off');
        set(h_ed([2,4,6]),'string','');
        
    case 'norm' % Gaussian, Normal or N-model from Börner et al. 2017
        % generate and set saturation value
        [o,mu_rho_stat] = Saturation(prm.bitnr);
        set(h.edit_camNoise_06, 'Enable', 'inactive','string',...
            num2str(mu_rho_stat));
        
    case 'none' 
        % turn off unused parameters
        set([h_txt(2:6),h_ed(2:6)], 'Enable', 'off');
        set(h_ed([2,4,6]), 'String','');
end
