function routine_simDK(h_fig)

h = guidata(h_fig);

%% define user parameters

% set molecule parameter values
N = []; % no. of molecules

% set experimental setup parameter values
w_pix = 1;
o_PSF = [0.5 0.75 1 1.5 2 3]*w_pix; % PSF std

%% set directories and file paths
% set parameter filename
pnamePrm = 'C:\Users\Mélodie\Downloads\Documents\';
fnamePrm = 'pattern02.mat';

if ~isempty(fnamePrm)
    pushbutton_simImpPrm_Callback({pnamePrm,fnamePrm}, [], h);
    h = guidata(h_fig);
    N = h.param.sim.molNb;
end

% set root filename
pname = 'C:\Users\Mélodie\Downloads\Documents\';
frootname = 'movies03_pattern02_L1000_Itot100_BG4-4_PSF-PS_';

% build file names
fname = cell(numel(N),numel(o_PSF));
for p1 = 1:numel(N)
    for p2 = 1:numel(o_PSF)
        fname{p1,p2} = cat(2,frootname, ...
            strrep(num2str(o_PSF(p2)),'.','-'));
    end
end

%% use MASH

% Build kinetic model

for p1 = 1:numel(N)

    set(h.edit_nbMol,'String',num2str(N(p1)));
    h = guidata(h_fig);
    edit_nbMol_Callback(h.edit_nbMol, [], h);

    updateFields(h_fig, 'sim');
    buildModel(h_fig);
    updateFields(h_fig, 'sim');

    for p2 = 1:numel(o_PSF)
        set(h.checkbox_convPSF,'Value',true);
        h = guidata(h_fig);
        checkbox_convPSF_Callback(h.checkbox_convPSF, [], h);

        set(h.edit_psfW1,'String',num2str(o_PSF(p2)));
        h = guidata(h_fig);
        edit_psfW1_Callback(h.edit_psfW1, [], h);

        set(h.edit_psfW2,'String',num2str(o_PSF(p2)));
        h = guidata(h_fig);
        edit_psfW2_Callback(h.edit_psfW2, [], h);

        h = guidata(h_fig);
        pushbutton_updateSim_Callback( ...
            h.pushbutton_updateSim, [], h);

        exportResults(h_fig,pname,fname{p1,p2});
    end
end

h = guidata(h_fig);
pushbutton_simRemPrm_Callback(obj, evd, h);