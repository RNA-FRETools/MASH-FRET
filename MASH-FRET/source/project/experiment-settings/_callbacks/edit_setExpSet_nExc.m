function edit_setExpSet_nExc(obj,evd,h_fig,h_fig0)

% retrieve project data
proj = h_fig.UserData;


% adjust number of lasers
nExc = str2double(get(obj,'string'));
if isempty(nExc)
    nExc = 0;
end
if nExc<0
    nExc = 0;
end
if nExc>10
    nExc = 10;
end
proj.nb_excitations = nExc;

% adjust laser wavelengths
for l = 1:nExc
    if l>numel(proj.excitations)
        proj.excitations = [proj.excitations,max(proj.excitations)+100];
    end
end
proj.excitations = proj.excitations(1:nExc);

% adjust emitter-specific excitations
excl = false(1,proj.nb_channel);
for c = 1:proj.nb_channel
    if ~any(proj.excitations==proj.chanExc(c))
        excl(c) = true;
    end
end
proj.chanExc(excl) = 0;

% recalculate average images
if proj.is_movie
    proj.aveImg = calcAveImg('all',proj.movie_file,proj.movie_dat,...
        proj.nb_excitations,h_fig0);
end

% update project data
h_fig.UserData = proj;

% refresh data ratio calculations
cleanRatioCalc(h_fig);

% refresh plot colors
ud_plotColors(h_fig);

% refresh laser tab
h = guidata(h_fig);
h = setExpSet_buildExcArea(h,nExc,h_fig0);
guidata(h_fig,h);

% refresh laser plot
ud_expSet_excPlot(h_fig);

% refresh itnerface
ud_setExpSet_tabLaser(h_fig);
ud_setExpSet_tabCalc(h_fig);
ud_setExpSet_tabDiv(h_fig);


