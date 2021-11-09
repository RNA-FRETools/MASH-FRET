function push_setExpSet_addFRET(obj,evd,h_fig)

% retrieve interface content
h = guidata(h_fig);

% retrieve project parameters
proj = h_fig.UserData;

% check viability of FRET calculation
don = h.popup_don.Value;
acc = h.popup_acc.Value;
if don==acc ||  ...
        (~isempty(proj.FRET) && any(proj.FRET(proj.FRET(:,1)==don,2)==acc))
    return
end
if proj.chanExc(don)<=0
    helpdlg({['FRET for pair ',proj.labels{don},'-',proj.labels{acc},...
        ' is not calculable as long as ',proj.labels{don},...
        ' data upon specific laser excitation is unavailable.'],' ',...
        'Try reviewing emitter-specific excitations in tab "Lasers"'});
    return
end

proj.FRET = cat(1,proj.FRET,[don,acc]);
h_fig.UserData = proj;

% refresh plot colors
ud_plotColors(h_fig);

% refresh trajectory file import options
ud_trajImportOpt(h_fig);

% refresh interface
ud_setExpSet_tabCalc(h_fig);
ud_setExpSet_tabFstrct(h_fig);
ud_setExpSet_tabDiv(h_fig);


