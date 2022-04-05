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

% parameters
nChan = p.nChan;

% collect interface parameters
h = guidata(h_fig);

setDefault_VP(h_fig,p,prefix);

% expand panel
h_but = getHandlePanelExpandButton(h.uipanel_VP_moleculeCoordinates,h_fig);
if strcmp(h_but.String,char(9660))
    pushbutton_panelCollapse_Callback(h_but,[],h_fig);
end

% test average image
disp(cat(2,prefix,'test average image...'));
pushbutton_aveImg_go_Callback(h.pushbutton_aveImg_go,[],h_fig);
pushbutton_aveImg_save_Callback({p.dumpdir,p.exp_ave},[],h_fig);
pushbutton_aveImg_load_Callback({p.annexpth,p.ave_file{nChan}},[],h_fig);

setDefault_VP(h_fig,p,prefix);

pushbutton_aveImg_go_Callback(h.pushbutton_aveImg_go,[],h_fig);

% test spot finder
disp(cat(2,prefix,'test spot finder...'));
str_meth = get(h.popupmenu_SF,'string');
nMeth = numel(str_meth);
for meth = 2:nMeth
    
    % test without fitting
    disp(cat(2,prefix,'>> "',str_meth{meth},'" method ...'));
    disp(cat(2,prefix,'>> >> without fitting...'));
    set_VP_spotFinder(meth,false,[],p.sf_prm,p.nChan,h_fig);
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
    
    % test with fitting
    disp(cat(2,prefix,'>> >> with fitting...'));
    set_VP_spotFinder(meth,true,[],p.sf_prm,p.nChan,h_fig);
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

if p.nChan==1
    return
end

% tests mapping tool
disp(cat(2,prefix,'test mapping ...'));
    
disp(cat(2,prefix,'>> import reference image ',p.ave_file{nChan},'...'));
pushbutton_trMap_Callback({p.annexpth,p.ave_file{nChan}},[],h_fig);
h = guidata(h_fig);
proj = h.param.proj{h.param.curr_proj};
viddim = proj.movie_dim;
mov = 1;

disp(cat(2,prefix,'>> map reference coordinates...'));
coord = rand(nPnt,2);
coord(:,1) = ceil(coord(:,1)*viddim{mov}(1)/nChan);
coord(:,2) = ceil(coord(:,2)*viddim{mov}(2));
coord(coord(:,1)>=(fix(viddim{mov}(1)/nChan)-3),1) = ...
    fix(viddim{mov}(1)/nChan)-3;
coord(coord(:,1)<=3,1) = 3;
coord(coord(:,2)>=(viddim{mov}(2)-3),2) = viddim{mov}(2)-3;
coord(coord(:,2)<=3,1) = 3;
coord = coord-0.5;
for pnt = 1:nPnt
    for c = 1:nChan
        axes_map_ButtonDownFcn({coord(pnt,:)},[],h_fig,c);
    end
end

disp(cat(2,prefix,'>> export reference coordinates from mapping tool...'));
menu_map_export({p.dumpdir,p.exp_ref{nChan}},[],h_fig);

figure_map_CloseRequestFcn([],[],h_fig);

disp(cat(2,prefix,'>> export reference coordinates from MASH...'));
pushbutton_trSaveRef_Callback({p.dumpdir,p.exp_ref{nChan}},[],h_fig);

% test transformation calculation
disp(cat(2,prefix,'test transformation calculation ...'));
set_VP_impTrsfOpt(true,p.ref_impOpt(nChan,:),p.spots_impOpt,h_fig);

disp(cat(2,prefix,'>> import reference coordinates ',p.ref_file{nChan},...
    '...'));
pushbutton_trLoadRef_Callback({p.annexpth,p.ref_file{nChan}},[],h_fig);

disp(cat(2,prefix,'>> calculate transformation...'));
pushbutton_calcTfr_Callback(h.pushbutton_calcTfr,[],h_fig)

disp(cat(2,prefix,'>> export transformation...'));
pushbutton_saveTfr_Callback({p.dumpdir,p.exp_trsf{nChan}},[],h_fig)

% test coordinates transformation
disp(cat(2,prefix,'test coordinates transformation ...'));

disp(cat(2,prefix,'>> import spots coordinates ',p.spots_file{nChan},...
    '...'));
pushbutton_impCoord_Callback({p.annexpth,p.spots_file{nChan}},[],...
    h_fig);

for tr = 1:size(p.vers,2)
    disp(cat(2,prefix,'>> >> import transformation ',p.trsf_file{nChan,tr},...
        '...'));
    pushbutton_trLoad_Callback({p.annexpth,p.trsf_file{nChan,tr}},[],...
        h_fig);

    disp(cat(2,prefix,'>> >> transform and export image...'));
    pushbutton_checkTr_Callback({p.annexpth,p.ave_file{nChan};...
        p.dumpdir,p.exp_trsfImg{nChan,tr}},[],h_fig);

    disp(cat(2,prefix,'>> >> transform coordinates...'));
    pushbutton_trGo_Callback(h.pushbutton_trGo,[],h_fig);
    
    disp(cat(2,prefix,'>> >> export transformed coordinates...'));
    pushbutton_trSave_Callback({p.dumpdir,p.exp_coord{nChan,tr}},[],h_fig);
end
