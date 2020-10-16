function link_str = getDocLink(sect)

base = 'https://rna-fretools.github.io/MASH-FRET/';
base_sim = cat(2,base,'simulation/');
base_vp = cat(2,base,'video-processing/');
base_tp = cat(2,base,'trace-processing/');
base_ha = cat(2,base,'histogram-analysis/');
base_ta = cat(2,base,'transition-analysis/');

link_str = '';

switch sect
    
    % simulation
    case 'video parameters'
        link_str = cat(2,base_sim,'panels/panel-video-parameters.html');
    case 'molecules'
        link_str = cat(2,base_sim,'panels/panel-molecules.html');
    case 'experimental setup'
        link_str = cat(2,base_sim,'panels/panel-experimental-setup.html');
    case 'sim export options'
        link_str = cat(2,base_sim,'panels/panel-export-options.html');
    case 'sim visualization'
        link_str = cat(2,base_sim,'panels/area-visualization.html');
    
    % video processing
    case 'vp visualization'
        link_str = cat(2,base_vp,'panels/area-visualization.html');
    case 'vp plot'
        link_str = cat(2,base_vp,'panels/panel-plot.html');
    case 'experiment settings'
        link_str = cat(2,base_vp,'panels/panel-experiment-settings.html');
    case 'edit video'
        link_str = cat(2,base_vp,'panels/panel-edit-video.html');
    case 'molecule coordinates'
        link_str = cat(2,base_vp,'panels/panel-molecule-coordinates.html');
    case 'intensity integration'
        link_str = cat(2,base_vp,'panels/panel-intensity-integration.html');
    case 'project options'
        link_str = cat(2,base_vp,'functionalities/set-project-options.html');
    case 'mapping tool'
        link_str = cat(2,base_vp,'functionalities/use-mapping-tool.html');
    case 'vp import options'
        link_str = cat(2,base_vp,'functionalities/set-coordinates-import-options.html');
    case 'vp export options'
        link_str = cat(2,base_vp,'functionalities/set-export-options.html');
    
    % trace processing
    case 'tp project management'
        link_str = cat(2,base_tp,'panels/area-project-management.html');
    case 'sample management'
        link_str = cat(2,base_tp,'panels/panel-sample-management.html');
    case 'tp plot'
        link_str = cat(2,base_tp,'panels/panel-plot.html');
    case 'sub-images'
        link_str = cat(2,base_tp,'panels/panel-subimage.html');
    case 'background correction'
        link_str = cat(2,base_tp,'panels/panel-background-correction.html');
    case 'cross-talks'
        link_str = cat(2,base_tp,'panels/panel-cross-talks.html');
    case 'denoising'
        link_str = cat(2,base_tp,'panels/panel-denoising.html');
    case 'photobleaching'
        link_str = cat(2,base_tp,'panels/panel-photobleaching.html');
    case 'factor corrections'
        link_str = cat(2,base_tp,'panels/panel-factor-corrections.html');
    case 'find states'
        link_str = cat(2,base_tp,'panels/panel-find-states.html');
    case 'tp visualization'
        link_str = cat(2,base_tp,'panels/area-visualization.html');
    case 'tp import options'
        link_str = cat(2,base_tp,'functionalities/set-import-options.html');
    case 'tp export options'
        link_str = cat(2,base_tp,'functionalities/set-export-options.html');
    case 'trace manager'
        link_str = cat(2,base_tp,'functionalities/tm-overview.html');
    case 'background analyzer'
        link_str = cat(2,base_tp,'functionalities/use-background-analyzer.html');
        
    % histogram analysis
    case 'ha project management'
        link_str = cat(2,base_ha,'panels/area-management.html');
    case 'ha plot'
        link_str = cat(2,base_ha,'panels/panel-histogram-and-plot.html');
    case 'ha state configuration'
        link_str = cat(2,base_ha,'panels/panel-state-configuration.html');
    case 'state populations'
        link_str = cat(2,base_ha,'panels/panel-state-populations.html');
    case 'ha visualization'
        link_str = cat(2,base_ha,'panels/area-visualization.html');
        
    % transition analysis
    case 'ta project management'
        link_str = cat(2,base_ta,'panels/area-management.html');
    case 'ta plot'
        link_str = cat(2,base_ta,'panels/panel-transition-density-plot.html');
    case 'ta state configuration'
        link_str = cat(2,base_ta,'panels/panel-state-configuration.html');
    case 'state lifetimes'
        link_str = cat(2,base_ta,'panels/panel-state-transition-rates.html');
    case 'kinetic model'
        link_str = cat(2,base_ta,'panels/panel-state-transition-rates.html');
    case 'ta export options'
        link_str = cat(2,base_ta,'functionalities/set-export-options.html');
        
end

