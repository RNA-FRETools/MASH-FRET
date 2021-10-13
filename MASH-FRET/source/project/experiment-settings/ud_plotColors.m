function ud_plotColors(h_fig)
% ud_plotColors(h_fig)
%
% check for missing/extra plot color in project parameters and adjust
% accordingly.
%
% h_fig: handle to figure "Experiment settings"

proj = h_fig.UserData;

nFRET = size(proj.FRET,1);
nS = size(proj.S,1);
defclr = getDefTrClr(proj.nb_excitations,proj.excitations,proj.nb_channel,...
    nFRET,size(proj.S,1));
if size(proj.colours{1},1)<proj.nb_excitations
    proj.colours{1} = cat(1,proj.colours{1},...
        defclr{1}((size(proj.colours{1},1)+1):proj.nb_excitations,:));
elseif size(proj.colours{1},2)<proj.nb_channel
    proj.colours{1} = cat(2,proj.colours{1},...
        defclr{1}(:,(size(proj.colours{1},2)+1):proj.nb_channel));
end
proj.colours{1} = proj.colours{1}(1:proj.nb_excitations,1:proj.nb_channel);

if size(proj.colours{2},1)<nFRET
    proj.colours{2} = cat(1,proj.colours{2},...
        defclr{2}((size(proj.colours{2},1)+1):nFRET,:));
end
proj.colours{2} = proj.colours{2}(1:nFRET,:);

if size(proj.colours{3},1)<size(proj.S,1)
    proj.colours{3} = cat(1,proj.colours{3},...
        defclr{3}((size(proj.colours{3},1)+1):nS,:));
end
proj.colours{3} = proj.colours{3}(1:nS,:);

h_fig.UserData = proj;
