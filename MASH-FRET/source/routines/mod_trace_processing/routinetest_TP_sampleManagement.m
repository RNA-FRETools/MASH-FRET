function routinetest_TP_sampleManagement(h_fig,p,prefix)
% routinetest_TP_sampleManagement(h_fig,p,prefix)
%
% Tests molecule list, molecule status, ASCII file export and trace manager
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TP
% prefix: string to add at the beginning of each action string (usually a specific indent)

h = guidata(h_fig);

setDefault_TP(h_fig,p);

% empty project list
disp(cat(2,prefix,'empty project list...'));
nProj = numel(get(h.listbox_traceSet,'string'));
proj = nProj;
while proj>0
    set(h.listbox_traceSet,'value',proj);
    listbox_traceSet_Callback(h.listbox_traceSet,[],h_fig);
    pushbutton_remTraces_Callback(h.pushbutton_remTraces,[],h_fig);
    proj = proj-1;
end

% import default project
disp(cat(2,prefix,'import default project'));
pushbutton_addTraces_Callback({p.annexpth,p.mash_files{p.nL,p.nChan}},[],...
    h_fig);

% test sample navigation
disp(cat(2,prefix,'test sample navigation...'));
pushbutton_molNext_Callback(h.pushbutton_molNext,[],h_fig);
pushbutton_molPrev_Callback(h.pushbutton_molPrev,[],h_fig);

N = numel(get(h.listbox_molNb,'string'));
n = 1;
while n==1
    n = ceil(rand(1)*N);
end
set(h.edit_currMol,'string',num2str(n));
edit_currMol_Callback(h.edit_currMol,[],h_fig);

% test molecule selection
disp(cat(2,prefix,'>> test molecule status...'));
nspl = randsample(1:N,3);
for n = nspl
    set(h.listbox_molNb,'value',n);
    listbox_molNb_Callback(h.listbox_molNb,[],h_fig);
    checkbox_TP_selectMol_Callback(h.checkbox_TP_selectMol,[],h_fig);
end
pushbutton_TTrem_Callback(h.pushbutton_TTrem,[],h_fig);

% test molecule tag
togglebutton_TP_addTag_Callback(h.togglebutton_TP_addTag,[],h_fig);
nTag = numel(get(h.listbox_TP_defaultTags,'string'));
tag = ceil(rand(1)*nTag);
set(h.listbox_TP_defaultTags,'value',tag);
listbox_TP_defaultTags_Callback(h.listbox_TP_defaultTags,[],h_fig);

set(h.popupmenu_TP_molLabel,'value',1);
pushbutton_TP_deleteTag_Callback(h.pushbutton_TP_deleteTag,[],h_fig);

% test trace update
disp(cat(2,prefix,'test trace update...'));
pushbutton_ttGo_Callback(h.pushbutton_ttGo,[],h_fig);
pushbutton_TP_updateAll_Callback(h.pushbutton_TP_updateAll,[],h_fig);

%% test trace export
disp(cat(2,prefix,'test file export...'));
disp(cat(2,prefix,'>> test all export...'));
pushbutton_expTraces_Callback({false},[],h_fig);
h = guidata(h_fig);
q = h.optExpTr;
nFigFmt = numel(get(q.popupmenu_figFmt,'string'));
opt = p.expOpt;
opt.traces(1) = true;
opt.hist(1) = true;
opt.dt(1) = true;
opt.fig{1}(1) = true;
set_TP_asciiExpOpt(opt,h_fig);
pushbutton_next_Callback({p.dumpdir,p.mash_files{p.nL,p.nChan}},[],h_fig);

% test trace export to single files/one file
disp(cat(2,prefix,'>> test trace export options...'));
opt = p.expOpt;
opt.traces(1) = true;
opt.traces(2) = 1;
opt.traces(6) = ~p.expOpt.traces(6);
pushbutton_expTraces_Callback({false},[],h_fig);
set_TP_asciiExpOpt(opt,h_fig);
pushbutton_next_Callback({p.dumpdir,p.mash_files{p.nL,p.nChan}},[],h_fig);

% test parameters export to separate file
opt.traces(3:7) = false;
opt.traces(8) = 1;
pushbutton_expTraces_Callback({false},[],h_fig);
set_TP_asciiExpOpt(opt,h_fig);
pushbutton_next_Callback({p.dumpdir,p.mash_files{p.nL,p.nChan}},[],h_fig);

% test figure export to different formats
disp(cat(2,prefix,'>> test figure options...'));
opt = p.expOpt;
opt.fig{1}(1) = true;
for fmt = 1:nFigFmt
    if fmt==p.expOpt.fig{1}(2)
        continue
    end
    opt.fig{1}(2) = fmt;
    pushbutton_expTraces_Callback({false},[],h_fig);
    set_TP_asciiExpOpt(opt,h_fig);
    pushbutton_next_Callback({p.dumpdir,p.mash_files{p.nL,p.nChan}},[],...
        h_fig);
end

% test different figure layout and figure preview
exp_fig = cat(2,p.dumpdir,filesep,p.exp_figpreview);
opt.fig{1}(12) = true;
pushbutton_expTraces_Callback({false},[],h_fig);

opt.fig{1}([4,5,8]) = [true,false,false];
opt.fig{2} = cat(2,exp_fig,'_subImg.png');
set_TP_asciiExpOpt(opt,h_fig);

opt.fig{1}([4,5,8]) = [false,true,false];
opt.fig{2} = cat(2,exp_fig,'_top.png');
set_TP_asciiExpOpt(opt,h_fig);

opt.fig{1}([4,5,8]) = [false,false,true];
opt.fig{2} = cat(2,exp_fig,'_bottom.png');
set_TP_asciiExpOpt(opt,h_fig);

opt.fig{1}([4,5,8]) = [true,true,true];
opt.fig{1}(10) = false;
opt.fig{2} = cat(2,exp_fig,'_noHist.png');
set_TP_asciiExpOpt(opt,h_fig);

opt.fig{1}(10) = true;
opt.fig{1}(11) = false;
opt.fig{2} = cat(2,exp_fig,'_noDiscr.png');
set_TP_asciiExpOpt(opt,h_fig);

pushbutton_cancel_Callback(q.pushbutton_cancel,[],h_fig);

%% test trace manager
disp(cat(2,prefix,'test trace manager...'));
pushbutton_TM_Callback(h.pushbutton_TM,[],h_fig);
h = guidata(h_fig);
q = h.tm;

% test panel Overall plot
disp(cat(2,prefix,'>> test overall plot...'));

% test trace plot
nDat1 = numel(get(q.popupmenu_axes1,'string'));
for dat = 1:nDat1
    set(q.popupmenu_axes1,'value',dat);
    popupmenu_axes_Callback(q.popupmenu_axes1,[],h_fig);
end
axlim = get(q.axes_ovrAll_1,'xlim');
l = axlim(1)+rand(1)*(axlim(2)-axlim(1));
axes_ovrAll_1_ButtonDownFcn({l},[],h_fig);

% test histogram plot
nDat2x = numel(get(q.popupmenu_axes2x,'string'));
nDat2y = numel(get(q.popupmenu_axes2y,'string'));
for datx = 1:nDat2x
    set(q.popupmenu_axes2x,'value',datx);
    popupmenu_axes_Callback(q.popupmenu_axes2x,[],h_fig);
    
    set(q.edit_xlim_low,'string',num2str(p.tmOpt{1}(datx,1)));
    edit_lim_low_Callback(q.edit_xlim_low,[],h_fig,1);

    set(q.edit_xnbiv,'string',num2str(p.tmOpt{1}(datx,2)));
    edit_nbiv_Callback(q.edit_xnbiv,[],h_fig,1);

    set(q.edit_xlim_up,'string',num2str(p.tmOpt{1}(datx,3)));
    edit_lim_up_Callback(q.edit_xlim_up,[],h_fig,1);
    
    for daty = 1:nDat2y
        set(q.popupmenu_axes2y,'value',daty);
        popupmenu_axes_Callback(q.popupmenu_axes2y,[],h_fig);
        if daty==1
            continue
        end
        
        set(q.edit_ylim_low,'string',num2str(p.tmOpt{1}(daty-1,1)));
        edit_lim_low_Callback(q.edit_ylim_low,[],h_fig,2);

        set(q.edit_ynbiv,'string',num2str(p.tmOpt{1}(daty-1,2)));
        edit_nbiv_Callback(q.edit_ynbiv,[],h_fig,2);

        set(q.edit_ylim_up,'string',num2str(p.tmOpt{1}(daty-1,3)));
        edit_lim_up_Callback(q.edit_ylim_up,[],h_fig,2);
    end
end
pushbutton_update_Callback(q.pushbutton_update,[],h_fig);


% test panel Overview
disp(cat(2,prefix,'>> test overview...'));
switchPan_TM(q.togglebutton_overview,[],h_fig);

% clear default tags
nTag = numel(get(q.popup_molTag,'string'));
tag = nTag;
while tag>1
    set(q.popup_molTag,'value',tag);
    popup_molTag_Callback(q.popup_molTag,[],h_fig);
    pushbutton_deleteMolTag_Callback(q.pushbutton_deleteMolTag,[],h_fig);
    tag = tag-1;
end

% add default tags
nTag = size(p.tmOpt{2}{1},2);
for tag = 1:nTag
    set(q.edit_molTag,'string',p.tmOpt{2}{1}{tag});
    edit_addMolTag_Callback(q.edit_molTag,[],h_fig);
end
for tag = 1:nTag
    set(q.popup_molTag,'value',tag+1);
    popup_molTag_Callback(q.popup_molTag,[],h_fig);

    pushbutton_tagClr_Callback({p.tmOpt{2}{2}(tag,:)},[],h_fig);
end

% test manual selection/tag
mol_disp = str2num(get(q.edit_nbTotMol,'string'));
max_sld = get(q.slider,'Max');
N = numel(q.molValid);
for tag = 1:nTag
    nspl = randsample(1:N,5);
    for n = nspl
        pos = (N-n+1)-mol_disp+1;
        if pos<=0
            pos = 1;
        end
        row = n-max_sld+pos;
        
        set(q.slider,'value',pos);
        slider_Callback(q.slider,[],h_fig);

        set(q.popup_molNb(row),'value',tag);
        pushbutton_addTag2mol_Callback(q.pushbutton_addTag2mol(row),[],...
            h_fig,row);
        
        % randomly select/unselect molecule
        set(q.checkbox_molNb(row),'value',randsample([true,false],1));
        checkbox_molNb_Callback(q.checkbox_molNb(row),[],h_fig);
    end
end
nspl = randsample(1:N,5);
for n = nspl
    pos = (N-n+1)-mol_disp+1;
    if pos<=0
        pos = 1;
    end
    row = n-max_sld+pos;

    set(q.slider,'value',pos);
    slider_Callback(q.slider,[],h_fig);
    nTagMol = numel(get(q.listbox_molLabel(row),'string'));
    if nTagMol>1
        val = randsample(1:nTagMol,1);
        set(q.listbox_molLabel(row),'value',val);
        pushbutton_remLabel_Callback(q.pushbutton_remLabel(row),[],h_fig,...
            row);
    end
end

% test different selections
nSlct = numel(get(q.popupmenu_selection,'string'));
for slct = [nSlct:-1:2,3]
    set(q.popupmenu_selection,'value',slct);
    popupmenu_selection_Callback(q.popupmenu_selection,[],h_fig);
    if sum(slct==(5:8))
        tag = randsample(1:nTag,1);
        set(q.popupmenu_selectTags,'value',tag);
    end
    pushbutton_select_Callback(q.pushbutton_select,[],h_fig);
end

tag = randsample(1:nTag,1);
set(q.popupmenu_addSelectTag,'value',tag);
popupmenu_addSelectTag_Callback(q.popupmenu_addSelectTag,[],h_fig);
pushbutton_addSelectTag_Callback(q.pushbutton_addSelectTag,[],h_fig);

% remove all molecule tags
pushbutton_untagAll_Callback(q.pushbutton_untagAll,[],h_fig);

% test layout
pushbutton_reduce_Callback(q.pushbutton_reduce,[],h_fig);
pushbutton_reduce_Callback(q.pushbutton_reduce,[],h_fig);

set(q.edit_nbTotMol,'string',num2str(p.tmOpt{2}{3}));
edit_nbTotMol_Callback(q.edit_nbTotMol,[],h_fig);


% test panel Auto-sorting
disp(cat(2,prefix,'>> test automatic sorting...'));
switchPan_TM(q.togglebutton_autoSorting,[],h_fig);

% test trace plot
nDat1 = numel(get(q.popupmenu_AS_plot1,'string'));
for dat = 1:nDat1
    set(q.popupmenu_AS_plot1,'value',dat);
    popupmenu_axes_Callback(q.popupmenu_AS_plot1,[],h_fig);
end

% test range on all data
strDat = removeHtml(get(q.popupmenu_selectXdata,'string'));
strVal = get(q.popupmenu_selectXval,'string');
nDat = numel(strDat);
nCond = numel(get(q.popupmenu_cond,'string'));
nUn = numel(get(q.popupmenu_units,'string'));

datx = 1; % test first data in list only
set(q.popupmenu_selectXdata,'value',datx);
popupmenu_selectData_Callback(q.popupmenu_selectXdata,[],h_fig);

for valx = [1,3,10] % test one data set of each sort
    set(q.popupmenu_selectXval,'value',valx);
    popupmenu_selectData_Callback(q.popupmenu_selectXval,[],h_fig);

    lim_x = get(q.axes_histSort,'xlim');
    xlow = lim_x(1)+(lim_x(2)-lim_x(1))*0.2;
    xup = lim_x(1)+(lim_x(2)-lim_x(1))*0.8;

    set(q.edit_xlow,'string',num2str(lim_x(1)));
    edit_xlow_Callback(q.edit_xlow,[],h_fig);

    set(q.edit_xup,'string',num2str(lim_x(2)));
    edit_xup_Callback(q.edit_xup,[],h_fig);

    set(q.edit_xniv,'string',num2str(p.tmOpt{3}(1)));
    edit_xniv_Callback(q.edit_xniv,[],h_fig);

    for daty = 1:(nDat+1)
        set(q.popupmenu_selectYdata,'value',daty);
        popupmenu_selectData_Callback(q.popupmenu_selectYdata,[],...
            h_fig);

        lim_y = get(q.axes_histSort,'ylim');
        ylow = lim_y(1)+(lim_y(2)-lim_y(1))*0.2;
        yup = lim_y(1)+(lim_y(2)-lim_y(1))*0.8;

        % define 1D range with edit fields
        xup0 = num2str(get(q.edit_xrangeUp,'string'));
        if xlow>=xup0
            set(q.edit_xrangeUp,'string',num2str(Inf));
            edit_xrangeUp_Callback(q.edit_xrangeUp,[],h_fig);
        end
        set(q.edit_xrangeLow,'string',num2str(xlow));
        edit_xrangeLow_Callback(q.edit_xrangeLow,[],h_fig);
        set(q.edit_xrangeUp,'string',num2str(xup));
        edit_xrangeUp_Callback(q.edit_xrangeUp,[],h_fig);

        if daty==1
            % define 1D range by imitating mouse-like behaviour
            disp(cat(2,prefix,'>> >> 1D: ',strDat{datx},'-',...
                strVal{valx},'...'));
            axes_histSort_ButtonDownFcn(q.axes_histSort,[],h_fig);
            pos = posAxesToFig([xlow,ylow],q.figure_traceMngr,...
                q.axes_histSort,'pixels');
            axes_histSort_traverseFcn(q.figure_traceMngr,pos);
            figure_traceMngr_WindowButtonUpFcn({[xup,yup]},[],h_fig);
            continue
        end
        if sum(valx==[1,2]) % frame-wise
            valsy = [1,2];
        elseif sum(valx==(3:9)) % molecule-wise
            valsy = 3:9;
        else % state-wise
            valsy = [10,11];
        end
        for valy = valsy
            disp(cat(2,prefix,'>> >> 2D: ',strDat{datx},'-',...
                strVal{valx},' vs ',strDat{daty-1},'-',strVal{valy},...
                '...'));
            set(q.popupmenu_selectYval,'value',valy);
            popupmenu_selectData_Callback(q.popupmenu_selectYval,[],...
                h_fig);

            lim_y = get(q.axes_histSort,'ylim');
            ylow = lim_y(1)+(lim_y(2)-lim_y(1))*0.2;
            yup = lim_y(1)+(lim_y(2)-lim_y(1))*0.8;

            set(q.edit_ylow,'string',num2str(lim_y(1)));
            edit_ylow_Callback(q.edit_ylow,[],h_fig);

            set(q.edit_yup,'string',num2str(lim_y(2)));
            edit_yup_Callback(q.edit_yup,[],h_fig);

            set(q.edit_yniv,'string',num2str(p.tmOpt{3}(1)));
            edit_yniv_Callback(q.edit_yniv,[],h_fig);

            % define 2D range by imitating mouse-like behaviour
            axes_histSort_ButtonDownFcn(q.axes_histSort,[],h_fig);
            pos = posAxesToFig([xlow,ylow],q.figure_traceMngr,...
                q.axes_histSort,'pixels');
            axes_histSort_traverseFcn(q.figure_traceMngr,pos);
            figure_traceMngr_WindowButtonUpFcn({[xup,yup]},[],h_fig);

            % define 2D range with edit fields
            yup0 = num2str(get(q.edit_yrangeUp,'string'));
            if ylow>=yup0
                set(q.edit_yrangeUp,'string',num2str(Inf));
                edit_yrangeUp_Callback(q.edit_yrangeUp,[],h_fig);
            end
            set(q.edit_yrangeLow,'string',num2str(ylow));
            edit_yrangeLow_Callback(q.edit_yrangeLow,[],h_fig);
            set(q.edit_yrangeUp,'string',num2str(yup));
            edit_yrangeUp_Callback(q.edit_yrangeUp,[],h_fig);

            % test data condition and save range
            if datx~=(daty-1) && valx==1 && valy==1
                opt = p.tmOpt;
                for cond = 1:nCond
                    for un = 1:nUn
                        opt{3}(2) = cond;
                        opt{3}(5) = un;
                        set_TP_tmRangeCond(opt,h_fig);
                        if cond==1 && un==1
                            pushbutton_saveRange_Callback(...
                                q.pushbutton_saveRange,[],h_fig);
                        end
                    end
                end
            end
        end
    end
end

% test panel Video view
disp(cat(2,prefix,'>> test video view...'));
switchPan_TM(q.togglebutton_videoView,[],h_fig);

menu_export_Callback(q.pushbutton_export,[],h_fig);


% export and close project
pushbutton_expProj_Callback({p.dumpdir,p.exp_sortProj},[],h_fig);
pushbutton_remTraces_Callback(h.pushbutton_remTraces,[],h_fig);
