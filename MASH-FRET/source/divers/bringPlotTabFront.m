function bringPlotTabFront(prm,h_fig)
% bringPlotTabFront(tab_str,h_fig)
% bringPlotTabFront(tab_handle,h_fig)
% bringPlotTabFront(tab_ids,h_fig)
%
% Bring input plot tab front. Tab plot can be indicated by a specific string or by its handle.
%
% tab_str: plot tab's specific string
% tab_handle: handle to plot tab
% tab_ids: [1-by-5] indexes of plot tabs in each of the 5 modules
% h_fig: handle to main figure

% default
modname = {'S','VP','TP','HA','TA'};

% retrieve interface content
h = guidata(h_fig);
p = h.param;

% gather plot tab group handles
h_alltg = [h.uitabgroup_S_plot,h.uitabgroup_VP_plot,h.uitabgroup_TP_plot,...
    h.uitabgroup_HA_plot,h.uitabgroup_TA_plot];

% gather plot tab handles
h_tbS = [h.uitab_S_plot_vid,h.uitab_S_plot_traces,h.uitab_S_plot_distrib];
h_tbVP = [h.uitab_VP_plot_vid,h.uitab_VP_plot_avimg];
if isfield(h,'uitab_VP_plot_tr') && ishandle(h.uitab_VP_plot_tr)
    h_tbVP = [h_tbVP,h.uitab_VP_plot_tr];
end
h_tbTP = h.uitab_TP_plot_traces;
h_tbHA = [h.uitab_HA_plot_hist,h.uitab_HA_plot_mdlSlct];
h_tbTA = [h.uitab_TA_plot_TDP,h.uitab_TA_plot_BICGMM,h.uitab_TA_plot_dt,...
    h.uitab_TA_plot_BICDPH,h.uitab_TA_plot_mdl,h.uitab_TA_plot_sim];
h_alltb = {h_tbS,h_tbVP,h_tbTP,h_tbHA,h_tbTA};

if ischar(prm)
    % determine plot tab group
    mod = '';
    for m = 1:numel(modname)
        if contains(prm,modname{m})
            mod = modname{m};
            break
        end
    end
    if isempty(mod)
        disp('bringPlotTabFront: invalid option.')
        return
    end
    h_tg = h_alltg(contains(modname,mod));
    
    % determine plot tab
    switch prm
        case 'Svid'
            h_tab = h.uitab_S_plot_vid;
            p.sim.curr_plot(p.curr_proj) = 1;
        case 'Straj'
            h_tab = h.uitab_S_plot_traces;
            p.sim.curr_plot(p.curr_proj) = 2;
        case 'Shist'
            h_tab = h.uitab_S_plot_distrib;
            p.sim.curr_plot(p.curr_proj) = 3;
        case 'VPvid'
            h_tab = h.uitab_VP_plot_vid;
            p.movPr.curr_plot(p.curr_proj) = 1;
        case 'VPave'
            h_tab = h.uitab_VP_plot_avimg;
            p.movPr.curr_plot(p.curr_proj) = 2;
        case 'VPtr'
            h_tab = h.uitab_VP_plot_tr;
            p.movPr.curr_plot(p.curr_proj) = 3;
        case 'TPtraj'
            h_tab = h.uitab_TP_plot_traces;
            p.ttPr.curr_plot(p.curr_proj) = 1;
        case 'HAhist'
            h_tab = h.uitab_HA_plot_hist;
            p.thm.curr_plot(p.curr_proj) = 1;
        case 'HAbic'
            h_tab = h.uitab_HA_plot_mdlSlct;
            p.thm.curr_plot(p.curr_proj) = 2;
        case 'TAtdp'
            h_tab = h.uitab_TA_plot_TDP;
            p.TDP.curr_plot(p.curr_proj) = 1;
        case 'TAgmm'
            h_tab = h.uitab_TA_plot_BICGMM;
            p.TDP.curr_plot(p.curr_proj) = 2;
        case 'TAdt'
            h_tab = h.uitab_TA_plot_dt;
            p.TDP.curr_plot(p.curr_proj) = 3;
        case 'TAdph'
            h_tab = h.uitab_TA_plot_BICDPH;
            p.TDP.curr_plot(p.curr_proj) = 4;
        case 'TAmdl'
            h_tab = h.uitab_TA_plot_mdl;
            p.TDP.curr_plot(p.curr_proj) = 5;
        case 'TAsim'
            h_tab = h.uitab_TA_plot_sim;
            p.TDP.curr_plot(p.curr_proj) = 6;
        otherwise
            disp('bringPlotTabFront: unknown option')
            return
    end
    
    % save modifications
    h.param = p;
    guidata(h_fig,h);

elseif numel(prm)==1 && ishandle(prm)
    % determine module
    h_tab = prm;
    h_tg = h_tab.Parent;
    modid = find(h_alltg==h_tg,true);
    if isempty(modid)
        disp('bringPlotTabFront: unknown module.')
        return
    end
    
    % determine plot index
    plotid = find(h_alltb{modid}==prm);
    
    % update current project's current plot index
    if ~isempty(plotid)
        switch modname{modid}
            case 'S'
                p.sim.curr_plot(p.curr_proj) = plotid;
            case 'VP'
                p.movPr.curr_plot(p.curr_proj) = plotid;
            case 'TP'
                p.ttPr.curr_plot(p.curr_proj) = plotid;
            case 'HA'
                p.thm.curr_plot(p.curr_proj) = plotid;
            case 'TA'
                p.TDP.curr_plot(p.curr_proj) = plotid;
        end
        
        % save modifications
        h.param = p;
        guidata(h_fig,h);
    end
    
elseif numel(prm)==5
    h_tab = [h_tbS(prm(1)),h_tbVP(prm(2)),h_tbTP(prm(3)),h_tbHA(prm(4)),...
        h_tbTA(prm(5))];
    h_tg = h_alltg;
end

% bring plot tab front
for t = 1:numel(h_tg)
    h_tg(t).SelectedTab = h_tab(t);
end
