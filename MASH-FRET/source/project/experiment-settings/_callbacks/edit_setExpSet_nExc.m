function edit_setExpSet_nExc(obj,evd,h_fig,h_fig0)

% retrieve project data
proj = h_fig.UserData;

% adjust number of lasers
nExc = str2double(get(obj,'string'));
if isempty(nExc)
    nExc = 1;
end
if nExc<1
    nExc = 1;
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

% update video param
h = guidata(h_fig);
proj = updateProjVideoParam(proj,h.radio_impFileMulti.Value);

% recalculate average images
if proj.is_movie
    setContPan('Recalculate average images...','process',h_fig0);
    nMov = numel(proj.movie_file);
    proj.aveImg = cell(nMov,proj.nb_excitations+1);
    for c = 1:nMov
        proj.aveImg(c,:) = calcAveImg('all',proj.movie_file{c},...
            proj.movie_dat{c},proj.nb_excitations,h_fig0,...
            1:min([proj.movie_dat{c}{3},100]));
    end
    setContPan('Average images successfully recalculated!','success',...
        h_fig0);
end

% update project data
h_fig.UserData = proj;

% refresh data ratio calculations
cleanRatioCalc(h_fig);

% refresh plot colors
ud_plotColors(h_fig);

% refresh trajectory file import options
ud_trajImportOpt(h_fig);

% refresh time, intensity and state sequence sections in file structure tab
h = guidata(h_fig);
proj = h_fig.UserData;
if isfield(h,'tab_fstrct') && ishandle(h.tab_fstrct)
    h = setExpSet_buildTimeArea(h,proj.excitations);
end

% refresh laser tab
h = setExpSet_buildExcArea(h,nExc,h_fig0);
guidata(h_fig,h);

% refresh laser plot
ud_expSet_excPlot(h_fig);

% refresh itnerface
ud_setExpSet_tabLaser(h_fig);
ud_setExpSet_tabCalc(h_fig);
ud_setExpSet_tabFstrct(h_fig);
ud_setExpSet_tabDiv(h_fig);


