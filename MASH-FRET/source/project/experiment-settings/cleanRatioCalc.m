function cleanRatioCalc(h_fig)

% retrieve interface content
h = guidata(h_fig);

% retrieve project parameters
proj = h_fig.UserData;

% sort out ill-defined FRET calculations
nFRET = size(proj.FRET,1);
incl = false(1,nFRET);
for fret = 1:nFRET
    don = proj.FRET(fret,1);
    acc = proj.FRET(fret,2);
    if don<=proj.nb_channel && acc<=proj.nb_channel && don~=acc && ...
            proj.chanExc(don)>0
        incl(fret) = true;
    end
end
proj.FRET = proj.FRET(incl,:);
if all(~incl)
    proj.FRET = [];
end

% sort out ill-defined stoichiometry calculations
nS = size(proj.S,1);
incl = false(1,nS);
for s = 1:nS
    don = proj.S(s,1);
    acc = proj.S(s,2);
    if ~isempty(proj.FRET) && any(proj.FRET(proj.FRET(:,1)==don,2)==acc) && ...
            proj.chanExc(acc)>0
        incl(s) = true;
    end
end
proj.S = proj.S(incl,:);
if all(~incl)
    proj.S = [];
end

h_fig.UserData = proj;
