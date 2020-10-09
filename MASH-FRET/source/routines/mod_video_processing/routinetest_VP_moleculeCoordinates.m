function routinetest_VP_moleculeCoordinates(h_fig,p,prefix)
% routinetest_VP_moleculeCoordinates(h_fig,p,prefix)
%
% Tests average image, spotfinder, mapping tool, transformation calculation, image transformation and coordinates transformation
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_VP
% prefix: string to add at the beginning of each action string (usually a apecific indent)

% defaults
nPnt = 20;
m = 1;

% collect interface parameters
h = guidata(h_fig);

% set defaults
setDefault_VP(h_fig,p);

% test average image
disp(cat(2,prefix,'test average image...'));
pushbutton_aveImg_go_Callback({p.dumpdir,p.exp_ave},[],h_fig);
pushbutton_aveImg_load_Callback({p.annexpth,p.ave_file{p.nChan}},[],h_fig);

% set defaults
setDefault_VP(h_fig,p);

% test spot finder
disp(cat(2,prefix,'test spot finder...'));
str_meth = get(h.popupmenu_SF,'string');
nMeth = numel(str_meth);
for meth = 2:nMeth
    
    % test on all frames without fitting
    disp(cat(2,prefix,'>> "',str_meth{meth},'" method on all frames...'));
    disp(cat(2,prefix,'>> >> without fitting...'));
    set_VP_spotFinder(meth,false,true,p.sf_prm,p.nChan,h_fig);
    pushbutton_SFgo_Callback(h.pushbutton_SFgo,[],h_fig);

    % move sliding bar
    n = get(h.slider_img,'value');
    set(h.slider_img,'value',n+m);
    m = -m;
    slider_img_Callback(h.slider_img,[],h_fig);
    
    % export to file
    pushbutton_SFsave_Callback({p.dumpdir,sprintf(p.exp_tracks{1},meth)},[],...
        h_fig);
    
    % test on all frames with fitting
    disp(cat(2,prefix,'>> >> with fitting...'));
    set_VP_spotFinder(meth,true,true,p.sf_prm,p.nChan,h_fig);
    pushbutton_SFgo_Callback(h.pushbutton_SFgo,[],h_fig);
    
    % move sliding bar
    n = get(h.slider_img,'value');
    set(h.slider_img,'value',n+m);
    m = -m;
    slider_img_Callback(h.slider_img,[],h_fig);
    
    % export to file
    pushbutton_SFsave_Callback({p.dumpdir,sprintf(p.exp_tracks{2},meth)},[],...
        h_fig);
    
    % test on current frame without fitting
    disp(cat(2,prefix,'>> "',str_meth{meth},'" method on current frame...'));
    disp(cat(2,prefix,'>> >> without fitting...'));
    set_VP_spotFinder(meth,false,false,p.sf_prm,p.nChan,h_fig);
    pushbutton_SFgo_Callback(h.pushbutton_SFgo,[],h_fig);
    
    % move sliding bar
    n = get(h.slider_img,'value');
    set(h.slider_img,'value',n+m);
    slider_img_Callback(h.slider_img,[],h_fig);
    set(h.slider_img,'value',n);
    slider_img_Callback(h.slider_img,[],h_fig);
    
    % export to file
    pushbutton_SFsave_Callback({p.dumpdir,sprintf(p.exp_spots{1},meth)},[],...
        h_fig);
    
    % test on current frame with fitting
    disp(cat(2,prefix,'>> >> with fitting...'));
    set_VP_spotFinder(meth,true,false,p.sf_prm,p.nChan,h_fig);
    pushbutton_SFgo_Callback(h.pushbutton_SFgo,[],h_fig);
    
    % move sliding bar
    set(h.slider_img,'value',n+m);
    slider_img_Callback(h.slider_img,[],h_fig);
    set(h.slider_img,'value',n);
    slider_img_Callback(h.slider_img,[],h_fig);
    
    % export to file
    pushbutton_SFsave_Callback({p.dumpdir,sprintf(p.exp_spots{2},meth)},[],...
        h_fig);
end

% tests mapping tool
disp(cat(2,prefix,'test mapping for different number of channels...'));
for nChan = 2:p.nChan_max
    % set number of channels
    set(h.edit_nChannel,'string',num2str(nChan));
    edit_nChannel_Callback(h.edit_nChannel,[],h_fig);
    
    % import reference image
    disp(cat(2,prefix,'>> import reference image ',p.ave_file{nChan},...
        '...'));
    pushbutton_loadMov_Callback({p.annexpth,p.ave_file{nChan}},[],h_fig);
    
    % generate random reference coordinates
    coord = rand(nPnt,2);
    coord(:,1) = 1+coord(:,1)*(fix(h.movie.pixelX/nChan)-2);
    coord(:,2) = 1+coord(:,1)*(h.movie.pixelY-2);
    
    % tests mapping tool
    disp(cat(2,prefix,'>> map reference coordinates...'));
    pushbutton_trMap_Callback({p.annexpth,p.ave_file{nChan}},[],h_fig);
    h = guidata(h_fig);
    for pnt = 1:nPnt
        for c = 1:nChan
            axes_map_ButtonDownFcn({coord(pnt,:)},[],h_fig,c);
        end
    end
    
    % close mapping tool and export coordinates
    disp(cat(2,prefix,'>> export reference coordinates...'));
    figure_map_CloseRequestFcn({p.dumpdir,p.exp_ref{nChan}},[],h_fig);
end

% test transformation calculation for different channels
disp(cat(2,prefix,'test transformation calculation for different number ',...
    'of channels...'));
for nChan = 2:p.nChan_max
    % set number of channels
    set(h.edit_nChannel,'string',num2str(nChan));
    edit_nChannel_Callback(h.edit_nChannel,[],h_fig);
    
    % set import options
    set_VP_impTrsfOpt(true,p.ref_impOpt(nChan,:),p.spots_impOpt,h_fig);

    % test import of reference coordinates and transformation calculation
    disp(cat(2,prefix,'>> import reference coordinates ',p.ref_file{nChan},...
        '...'));
    pushbutton_trLoadRef_Callback({p.annexpth,p.ref_file{nChan}},[],h_fig);
    
    % calculate transformation
    disp(cat(2,prefix,'>> calculate and export transformation...'));
    pushbutton_calcTfr_Callback({p.dumpdir,p.exp_trsf{nChan}},[],h_fig)
end

% test transformation for different channels
disp(cat(2,prefix,'test transformation for different number of channels',...
    '...'));
for nChan = 2:p.nChan_max
    % set number of channels
    set(h.edit_nChannel,'string',num2str(nChan));
    edit_nChannel_Callback(h.edit_nChannel,[],h_fig);
    
    % import coordinates to transform
    disp(cat(2,prefix,'>> import spots coordinates ',p.spots_file{nChan},...
        '...'));
    pushbutton_impCoord_Callback({p.annexpth,p.spots_file{nChan}},[],...
        h_fig);
    
    % import transformation and transorm coordinates
    for tr = 1:size(p.vers,2)
        % import transformation
        disp(cat(2,prefix,'>> >> import transformation ',...
            p.trsf_file{nChan,tr},'...'));
        pushbutton_trLoad_Callback({p.annexpth,p.trsf_file{nChan,tr}},[],...
            h_fig);
        
        % transform reference image
        disp(cat(2,prefix,'>> >> transform and export image...'));
        pushbutton_checkTr_Callback({p.annexpth,p.ave_file{nChan};...
            p.dumpdir,p.exp_trsfImg{nChan,tr}},[],h_fig);
        
        % transform coordinates
        disp(cat(2,prefix,'>> >> transform and export coordinates...'));
        pushbutton_trGo_Callback({p.dumpdir,p.exp_coord{nChan,tr}},[],...
            h_fig);
    end
end
