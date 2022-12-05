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

nMov = numel(p.es{nChan,p.nL}.imp.vfile);
multichanvid = nMov==1;

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
if multichanvid
    avefiles = p.ave_file{nChan};
    pushbutton_aveImg_load_Callback({p.annexpth,avefiles},[],h_fig);
else
    avefiles = cell(1,nMov);
    [~,name,ext] = fileparts(p.ave_file{nChan});
    for mov = 1:nMov
        avefiles{mov} = [name,'_',p.es{nChan,p.nL}.chan.emlbl{mov},ext];
    end
    pushbutton_aveImg_load_Callback({p.annexpth,avefiles},[],h_fig);
end

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
if multichanvid
    disp(cat(2,prefix,'>> import reference image ...'));
else
    disp(cat(2,prefix,'>> import reference images ...'));
end
pushbutton_trMap_Callback({p.annexpth,avefiles},[],h_fig);
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

if multichanvid
    ref_file = p.ref_file{nChan};
else
    [~,name,ext] = fileparts(p.ref_file{nChan});
    ref_file = [name,'_sglchan',ext];
end
disp(cat(2,prefix,'>> import reference coordinates ',ref_file,'...'));
pushbutton_trLoadRef_Callback({p.annexpth,ref_file},[],h_fig);

disp(cat(2,prefix,'>> calculate transformation...'));
pushbutton_calcTfr_Callback(h.pushbutton_calcTfr,[],h_fig)

disp(cat(2,prefix,'>> export transformation...'));
if multichanvid
    tr_file = p.exp_trsf{nChan};
else
    [~,name,ext] = fileparts(p.exp_trsf{nChan});
    tr_file = [name,'_sglchan',ext];
end
pushbutton_saveTfr_Callback({p.dumpdir,tr_file},[],h_fig)

% test coordinates transformation
disp(cat(2,prefix,'test coordinates transformation ...'));

if multichanvid
    spot_file = p.spots_file{nChan};
else
    [~,name,ext] = fileparts(p.spots_file{nChan});
    spot_file = [name,'_sglchan',ext];
end
disp(cat(2,prefix,'>> import spots coordinates ',spot_file,'...'));
pushbutton_impCoord_Callback({p.annexpth,spot_file},[],...
    h_fig);

for tr = 1:size(p.vers,2)-1

    if multichanvid
        tr_file = p.trsf_file{nChan,tr};
    elseif tr==2
        [~,name,ext] = fileparts(p.trsf_file{nChan,tr});
        tr_file = [name(1:end-4),'_sglchan_trs',ext];
    else
        continue
    end
    disp(cat(2,prefix,'>> >> import transformation ',tr_file,'...'));
    pushbutton_trLoad_Callback({p.annexpth,tr_file},[],h_fig);

    disp(cat(2,prefix,'>> >> transform and export image...'));
    if multichanvid
        avefiles = p.ave_file{nChan};
        trim_file = p.exp_trsfImg{nChan,tr};
    else
        avefiles = cell(1,nMov);
        [~,name,ext] = fileparts(p.ave_file{nChan});
        for mov = 1:nMov
            avefiles{mov} = ...
                [name,'_',p.es{nChan,p.nL}.chan.emlbl{mov},ext];
        end
        [~,name,ext] = fileparts(p.exp_trsfImg{nChan,tr});
        trim_file = [name,'_sglchan_trs',ext];
    end
    pushbutton_checkTr_Callback(...
        {p.annexpth,avefiles;p.dumpdir,trim_file},[],h_fig);

    disp(cat(2,prefix,'>> >> transform coordinates...'));
    pushbutton_trGo_Callback(h.pushbutton_trGo,[],h_fig);
    
    disp(cat(2,prefix,'>> >> export transformed coordinates...'));
    if multichanvid
        coord_file = p.exp_coord{nChan,tr};
    else
        [~,name,ext] = fileparts(p.exp_coord{nChan,tr});
        coord_file = [name,'_sglchan',ext];
    end
    pushbutton_trSave_Callback({p.dumpdir,coord_file},[],h_fig);
end
