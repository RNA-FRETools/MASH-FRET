function pushbutton_preview_Callback(obj, evd, h_fig)
% pushbutton_preview_Callback([],[],h_fig)
% pushbutton_preview_Callback(imgfile,[],h_fig)
%
% h_fig: handle to main figure
% imgfile: {1-by-1} destination image file for preview

% Last update, 10.4.2019 by MH: display processing action when creating figure preview (slow process)

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
incl = p.proj{proj}.coord_incl;
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);
[o,m_valid,o] = find(incl);

prm = p.proj{proj}.exp.fig;
molPerFig = prm{1}(3);
min_end = min([molPerFig numel(m_valid)]);
p_fig.isSubimg = prm{1}(4);
p_fig.isHist = prm{1}(5);
p_fig.isDiscr = prm{1}(6);
p_fig.isTop = prm{2}{1}(1);
p_fig.topExc = prm{2}{1}(2);
p_fig.topChan = prm{2}{1}(3);
if nFRET > 0 || nS > 0
    p_fig.isBot = prm{2}{2}(1);
    p_fig.botChan = prm{2}{2}(2);
else
    p_fig.isBot = 0;
    p_fig.botChan = 0;
end

% added by MH, 10.4.2019
disp('building figure preview in process ...');

h_fig_mol = [];
m_i = 0;
for m = m_valid(1:min_end)
    m_i = m_i + 1;
    h_fig_mol = buildFig(p, m, m_i, molPerFig, p_fig, h_fig_mol);
end

if iscell(obj)
    figfile = obj{1};
    print(h_fig_mol,figfile,'-dpng');
    close(h_fig_mol);
else
    set(h_fig_mol, 'Visible', 'on');
    
    % added by MH, 10.4.2019
    disp('figure preview successfully built.');
end


