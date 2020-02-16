function set_VP_projOpt(p,wl,h_but,h_fig)
% set_VP_projOpt(p,nL,nChan,h_but,h_fig)
%
% Set project options to proper values and update interface parameters
%
% p: structure containing project options and that must contain fields:
%  p.proj_title: project title
%  p.mol_name: molecule name
%  p.conc_mg: Mg concentration
%  p.conc_k: K concentration
%  p.laser_pow: laser powers
%  p.labels: channel labels
%  p.chanExc: channel-specific excitation
%  p.FRET: donor-accpetor FRET pairs
%  p.S: FRET pairs to calculate stoichiometry for
% wl: laser wavelength in chronological order
% h_but: handle to button that was pressed to open option window
% h_fig: handle to main figure

% collect project options
nL = size(p.laser_pow,2);
nChan = size(p.labels,2);

% collect modified interface parameters
h = guidata(h_fig);

% open project option window
if h_but==h.pushbutton_chanOpt
    openItgExpOpt(h_but,[],h_fig);
elseif h_but==h.pushbutton_editParam
    pushbutton_editParam_Callback(h_but,[],h_fig);
else
     disp('set_VP_projOpt: unknown button');
     return
end

% collect modified interface parameters
h = guidata(h_fig);
q = h.itgExpOpt;

% set default experimental conditions
set(q.edit_movName,'string',p.proj_title);
edit_param_Callback(q.edit_movName,[],1,h_fig);

set(q.edit_molName,'string',p.mol_name);
edit_param_Callback(q.edit_molName,[],2,h_fig);

set(q.edit_prmVal(3),'string',num2str(p.conc_mg));
edit_param_Callback(q.edit_prmVal(3),[],3,h_fig);

set(q.edit_prmVal(4),'string',num2str(p.conc_k));
edit_param_Callback(q.edit_prmVal(4),[],4,h_fig);

for l = 1:nL
    set(q.edit_prmVal(4+l),'string',num2str(p.laser_pow(l)));
    edit_param_Callback(q.edit_prmVal(4+l),[],4+l,h_fig);
end

% remove extra conditions
nPrm = numel(get(q.listbox_prm,'string'));
prm = nPrm;
while prm>0
    set(q.listbox_prm,'value',prm);
    pushbutton_itgExpOpt_rem_Callback(q.pushbutton_itgExpOpt_rem,[],h_but,...
        h_fig);
    prm = prm-1;
    
    % collect modified interface parameters
    h = guidata(h_fig);
    q = h.itgExpOpt;
end

% add extra user-defined conditions
nPrm = size(p.prm_extra,1);
for prm = 1:nPrm
    set(q.edit_newName,'string',p.prm_extra{prm,1});
    edit_newName(q.edit_newName,[],h_fig);

    set(q.edit_newUnits,'string',p.prm_extra{prm,3});
    edit_newUnits(q.edit_newUnits,[],h_fig);

    pushbutton_itgExpOpt_add_Callback(q.pushbutton_itgExpOpt_add,[],h_but,...
        h_fig);
    
    % collect modified interface parameters
    h = guidata(h_fig);
    q = h.itgExpOpt;
    
    set(q.edit_prmVal(4+nL+prm),'string',num2str(p.prm_extra{prm,2}));
    edit_param_Callback(q.edit_prmVal(4+nL+prm),[],4+nL+prm,h_fig);
end

% set default labels
nLbl = size(p.labels,2);
str_defLbl = get(q.listbox_dyeLabel,'string');
for lbl = 1:nLbl
    if sum(~cellfun('isempty',strfind(str_defLbl,p.labels{lbl})))
        continue
    end
    set(q.edit_dyeLabel,'string',p.labels{lbl});
    pushbutton_addLabel_Callback(q.pushbutton_addLabel,[],h_fig);
end

% set channel-specific parameters
str_lbl = get(q.popupmenu_dyeLabel,'string');
for c = 1:nChan
    set(q.popupmenu_dyeChan,'value',c);
    popupmenu_dyeChan_Callback(q.popupmenu_dyeChan,[],h_fig);
    
    % set channel-specific excitation
    l0 = find(wl==p.chanExc(c));
    if isempty(l0)
        set(q.popupmenu_dyeExc,'value',(nL+1));
    else
        set(q.popupmenu_dyeExc,'value',l0);
    end
    popupmenu_dyeExc_Callback(q.popupmenu_dyeExc,[],h_fig);
    
    % set channel-specific label
    lbl0 = find(~cellfun('isempty',strfind(str_lbl,p.labels{c})));
    set(q.popupmenu_dyeLabel,'value',lbl0);
    popupmenu_dyeLabel_Callback(q.popupmenu_dyeLabel,[],h_fig);
end

% set FRET pairs
if isfield(q,'listbox_FRETcalc');
    nFRET = numel(get(q.listbox_FRETcalc,'string'));
else
    nFRET = 0;
end
n = nFRET;
while n>0
    set(q.listbox_FRETcalc,'value',n);
    pushbutton_remFRET_Callback(q.pushbutton_remFRET,[],h_fig);
    n = n-1;
end
for n = 1:size(p.FRET,1)
    set(q.popupmenu_FRETfrom,'value',p.FRET(n,1));
    set(q.popupmenu_FRETto,'value',p.FRET(n,2));
    pushbutton_addFRET_Callback(q.pushbutton_addFRET,[],h_fig);
end

% set Stoichiometry pairs
if isfield(q,'listbox_Scalc')
    nS = numel(get(q.listbox_Scalc,'string'));
else
    nS = 0;
end
n = nS;
while n>0
    set(q.listbox_Scalc,'value',n);
    pushbutton_remS_Callback(q.pushbutton_remS,[],h_fig);
    n = n-1;
end
for n = 1:size(p.S,1)
    [pair,o,o] = find(p.FRET(:,1)==p.S(n,1) & p.FRET(:,2)==p.S(n,2));
    set(q.popupmenu_Spairs,'value',pair);
    pushbutton_addS_Callback(q.pushbutton_addS,[],h_fig);
end

% save options and close window
pushbutton_itgExpOpt_ok_Callback(q.pushbutton_itgExpOpt_ok,[],h_but,h_fig);

