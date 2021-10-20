function popup_setExpSet_excEm(obj,evd,h_fig,l)

% defaults
redclr = [1,0.9,0.9];

h = guidata(h_fig);
proj = h_fig.UserData;

c = get(obj,'value')-1;
if proj.chanExc(c)==proj.excitations(l)
    return
end
if c>=1
    if proj.excitations(l)==0
        helpdlg('The laser wavelength must be a strictly positive value.');
        set(h.edit_excWl(l),'backgroundcolor',redclr);
        ud_setExpSet_tabLaser(h_fig);
        return
    elseif proj.chanExc(c)>0
        helpdlg({['Specific laser excitation is already defined for ',...
            'emitter ',proj.labels{c},'.'],'',...
            'Try to review specific excitations of other lasers.'});
        ud_setExpSet_tabLaser(h_fig);
        return
    else
        proj.chanExc(c) = proj.excitations(l);
    end
else
    proj.chanExc(proj.chanExc==proj.excitations(l)) = 0;
end

h_fig.UserData = proj;

% refresh data ratio calculations
cleanRatioCalc(h_fig);

% refresh laser plots and panel
ud_setExpSet_tabLaser(h_fig);
ud_setExpSet_tabCalc(h_fig);
