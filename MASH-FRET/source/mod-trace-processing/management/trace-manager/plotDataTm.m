function plotDataTm(h_fig)

% Last update by MH, 26.7.2019
% >> handle error occurring when changing molecule in display before plot 
%    is completed

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);
isBot = nFRET | nS;

mol = p.curr_mol(proj);
prm = p.proj{proj}.prm{mol};
nDisp = size(h.tm.checkbox_molNb,2);

for i = 1:nDisp
    cla(h.tm.axes_itt(i));
    cla(h.tm.axes_itt_hist(i));
    if isBot
        cla(h.tm.axes_frettt(i));
        cla(h.tm.axes_hist(i));
    end
    
    mol_nb = str2num(get(h.tm.checkbox_molNb(i),'String'));
    if h.tm.molValid(mol_nb)
        shad = 'white';
    else
        shad = get(h.tm.checkbox_molNb(i),'BackgroundColor');
    end
    set([h.tm.axes_itt(i),h.tm.axes_itt_hist(i)],'Color',shad);
    if isBot
        set([h.tm.axes_frettt(i),h.tm.axes_hist(i)],'Color',shad);
    end
end
drawnow;

for i = 1:nDisp
    
    % MH, 26.7.2019
    if ~ishandle(h.tm.checkbox_molNb(i))
        break;
    end
    
    mol_nb = str2num(get(h.tm.checkbox_molNb(i), 'String'));

    axes.axes_traceTop = h.tm.axes_itt(i);
    axes.axes_histTop = h.tm.axes_itt_hist(i);
    if isBot
        axes.axes_traceBottom = h.tm.axes_frettt(i);
        axes.axes_histBottom = h.tm.axes_hist(i);
    end

    plotData(mol_nb, p, axes, prm, 0);
    
    if h.tm.molValid(mol_nb)
        shad = 'white';
    else
        shad = get(h.tm.checkbox_molNb(i),'BackgroundColor');
    end
    set([h.tm.axes_itt(i),h.tm.axes_itt_hist(i)],'Color',shad);
    if isBot
        set([h.tm.axes_frettt(i),h.tm.axes_hist(i)],'Color',shad);
        if i ~= size(h.tm.checkbox_molNb,2)
            set(get(h.tm.axes_frettt(i), 'Xlabel'), 'String', '');
            set(get(h.tm.axes_itt_hist(i), 'Xlabel'), 'String', '');
        end
    elseif i ~= size(h.tm.checkbox_molNb,2)
        set(get(h.tm.axes_itt(i), 'Xlabel'), 'String', '');
        set(get(axes.axes_histTop, 'Xlabel'), 'String', '');
    end
    set(h.tm.checkbox_molNb(i), 'Value', h.tm.molValid(mol_nb));
    drawnow;
end
