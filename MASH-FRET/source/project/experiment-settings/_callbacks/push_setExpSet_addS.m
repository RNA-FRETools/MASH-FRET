function push_setExpSet_addS(obj,evd,h_fig)

% retrieve interface content
h = guidata(h_fig);

% retrieve project parameters
proj = h_fig.UserData;

% check viability of stoichiometry calculation
pair = h.popup_S.Value;
don = proj.FRET(pair,1);
acc = proj.FRET(pair,2);
if don==acc || (~isempty(proj.S) && any(proj.S(proj.S(:,1)==don,2)==acc))
    return
end
if proj.chanExc(don)<=0 || proj.chanExc(acc)<=0
    helpdlg({['Stoichiometry of FRET pair ',proj.labels{don},'-',...
        proj.labels{acc},' is not computable as long as both ',...
        proj.labels{don},' and ',proj.labels{acc},' data upon respective ',...
        'specific laser excitations are unavailable.'],' ',...
        'Try reviewing emitter-specific excitations in tab "Lasers"'});
    return
end

proj.S = cat(1,proj.S,[don,acc]);
h_fig.UserData = proj;

% refresh plot colors
ud_plotColors(h_fig);

% refresh interface
ud_setExpSet_tabCalc(h_fig);
ud_setExpSet_tabDiv(h_fig);

