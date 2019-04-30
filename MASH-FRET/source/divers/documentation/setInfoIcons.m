function hBut = setInfoIcons(obj,h_fig,image_file)

cdata = imread(image_file);

h = guidata(h_fig);

O = numel(obj);
hBut = [];

un = get(h_fig,'units');
set(h_fig,'units','pixels');

if isfield(h,'itgExpOpt')
    h_pushbutton_itgExpOpt_cancel = ...
        h.itgExpOpt.pushbutton_itgExpOpt_cancel;
else
    h_pushbutton_itgExpOpt_cancel = [];
end
if isfield(h,'trsfOpt')
    h_pushbutton_trsfOpt_cancel = h.trsfOpt.pushbutton_trsfOpt_cancel;
else
    h_pushbutton_trsfOpt_cancel = [];
end
if isfield(h,'itgFileOpt')
    h_pushbutton_itgFileOpt_cancel = ...
        h.itgFileOpt.pushbutton_itgFileOpt_cancel;
else
    h_pushbutton_itgFileOpt_cancel = [];
end
if isfield(h,'trImpOpt')
    h_pushbutton_trImpOpt_cancel = h.trImpOpt.pushbutton_trImpOpt_cancel;
else
    h_pushbutton_trImpOpt_cancel = [];
end
if isfield(h,'optExpTr')
    h_pushbutton_optExpTr_cancel = h.optExpTr.pushbutton_cancel;
else
    h_pushbutton_optExpTr_cancel = [];
end
if isfield(h,'tm')
    h_togglebutton_tm_videoView = h.tm.togglebutton_videoView;
else
    h_togglebutton_tm_videoView = [];
end
if isfield(h,'bga')
    h_pushbutton_bga_save = h.bga.pushbutton_save;
else
    h_pushbutton_bga_save = [];
end
if isfield(h,'optExpTdp')
    h_pushbutton_optExpTdp_cancel = h.optExpTdp.pushbutton_cancel;
else
    h_pushbutton_optExpTdp_cancel = [];
end

for o = 1:O
    switch obj(o)
        case h.uipanel_S_videoParameters
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('video parameters'),obj(o)));
        case h.uipanel_S_molecules
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('molecules'),obj(o)));
        case h.uipanel_S_experimentalSetup
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('experimental setup'),obj(o)));
        case h.uipanel_S_exportOptions
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('sim export options'),obj(o)));
        case h.axes_example_hist
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('sim visualization'),obj(o),[-2,-2]));
            
        case h.pushbutton_loadMov
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('vp visualization'),obj(o),[-1,1]));
        case h.uipanel_VP_plot
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('vp plot'),obj(o)));
        case h.uipanel_VP_experimentSettings
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('experiment settings'),obj(o)));
        case h_pushbutton_itgExpOpt_cancel
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('project options'),obj(o),[-1,1]));
        case h.uipanel_VP_editAndExportVideo
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('edit video'),obj(o)));
        case h.uipanel_VP_moleculeCoordinates
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('molecule coordinates'),obj(o)));
        case h_pushbutton_trsfOpt_cancel
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('vp import options'),obj(o),[2,1]));
        case h.uipanel_VP_intensityIntegration
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('intensity integration'),obj(o)));
        case h_pushbutton_itgFileOpt_cancel
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('vp export options'),obj(o),[-1,1]));
            
        case h_pushbutton_trImpOpt_cancel
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('tp import options'),obj(o),[-1,1]));
        case h.pushbutton_traceImpOpt
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('tp project management'),obj(o),[-1,1]));
        case h.uipanel_TP_sampleManagement
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('sample management'),obj(o)));
        case h_pushbutton_optExpTr_cancel
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('tp export options'),obj(o),[-1,1]));
        case h_togglebutton_tm_videoView
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('trace manager'),obj(o),[2,1]));
        case h.uipanel_TP_plot
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('tp plot'),obj(o)));
        case h.uipanel_TP_subImages
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('sub-images'),obj(o)));
        case h.uipanel_TP_backgroundCorrection
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('background correction'),obj(o)));
        case h_pushbutton_bga_save
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('background analyzer'),obj(o),[2,1]));
        case h.uipanel_TP_factorCorrections
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('factor corrections'),obj(o)));
        case h.uipanel_TP_denoising
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('denoising'),obj(o)));
        case h.uipanel_TP_photobleaching
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('photobleaching'),obj(o)));
        case h.uipanel_TP_findStates
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('find states'),obj(o)));
        case h.axes_topRight
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('tp visualization'),obj(o),[-2,-2]));
            
        case h.pushbutton_thm_impASCII
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('ha project management'),obj(o),[-1,1]));
        case h.uipanel_HA_histogramAndPlot
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('ha plot'),obj(o)));
        case h.uipanel_HA_stateConfiguration
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('ha state configuration'),obj(o)));
        case h.uipanel_HA_statePopulations
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('state populations'),obj(o)));
        case h.axes_hist1
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('ha visualization'),obj(o),[-2,-2]));

        case h.pushbutton_TDPimpOpt
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('ta project management'),obj(o),[-1,1]));
        case h_pushbutton_optExpTdp_cancel
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('ta project management'),obj(o),[-1,1]));
        case h.uipanel_TA_transitionDensityPlot
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('ta plot'),obj(o)));
        case h.uipanel_TA_stateConfiguration
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('ta state configuration'),obj(o)));
        case h.uipanel_TA_stateTransitionRates
            hBut = cat(2,hBut,mkbutton(cdata,...
                getDocLink('transition rates'),obj(o)));
    end
end

set(h_fig,'units',un);


function pos = getPixPos(obj)
un = get(obj,'units');
set(obj,'units','pixels');
pos = get(obj,'position');
set(obj,'units',un);


function hBut = mkbutton(cdat,link,obj,varargin)

% defaults
w_but = 22;
h_but = 20;
h_txt = 15;
mg = 5;
mgShift = -3;
incr = 2;
pixperchar = 3;

posObj = getPixPos(obj);

if strcmp(get(obj,'type'),'uipanel')
    fntUn = get(obj,'fontunits');
    fntSz = get(obj,'fontsize');
    fntWght = get(obj,'fontweight');
    txt = get(obj,'title');
    if isempty(strfind(txt,''))
        txt = cat(2,txt,' .');
    end
    
    min_w = pixperchar*length(txt);
    postxt = [0 0 min_w h_txt];
    outstr = [' ';' '];
    
    while numel(outstr)>1
        dummy = uicontrol('style','text','visible','off','fontunits',fntUn,...
            'fontsize',fntSz,'fontweight',fntWght,'string',txt,'position',...
            postxt);
        outstr = textwrap(dummy,{txt});
        delete(dummy);
        postxt(3) = postxt(3) + incr;
    end

    extra_x = postxt(3) + mgShift;
    extra_y = - 2*mg - h_but/2;
    
    data{3} = [0,1];
    
    x = posObj(1) + extra_x;
    y = posObj(2) + posObj(4);
    
else
    posShift = varargin{1};

    if posShift(1)<0
        extra_x = - mg - w_but; % left-side of origin
    else
        extra_x = mg; % right-side of origin
    end
    if posShift(2)<0
        extra_y = - mg - h_but; % bottom-side of origin
    else
        extra_y = mg; % top-side of origin
    end
    
    % particular cases where no margin must be added
    if posShift(1)==1 && (posShift(2)==-1 || posShift(2)==2)
        extra_x = 0;
    elseif posShift(1)==-2 && (posShift(2)==-1 || posShift(2)==2)
        extra_x = - w_but; 
    elseif posShift(2)==1 && (posShift(1)==-1 || posShift(1)==2)
        extra_y = 0;
    elseif posShift(2)==-2 && (posShift(1)==-1 || posShift(1)==2)
        extra_y = - h_but;
    end
    
    if abs(posShift(1))==1
        data{3}(1) = 0; % origin = left border
        x = posObj(1) + extra_x;
    else
        data{3}(1) = 1; % origin = right border
        x = posObj(1) + posObj(3) + extra_x;
    end
    if abs(posShift(2))==1
        data{3}(2) = 0; % origin = bottom border
        y = posObj(2) + extra_y;
    else
        data{3}(2) = 1; % origin = top border
        y = posObj(2) + posObj(4) + extra_y;
    end
end

pos = [x,y,w_but,h_but];

data{1} = obj;
data{2} = [extra_x,extra_y,w_but,h_but];

h_parent = get(obj,'parent');

hBut = uicontrol('style','pushbutton','parent',h_parent,'units','pixels',...
    'position',pos,'cdata',cdat,'tooltipstring','Help','callback',...
    {@pushbutton_help_Callback,link},'userdata',data);

un = get(h_parent,'units');
set(hBut,'units',un);


