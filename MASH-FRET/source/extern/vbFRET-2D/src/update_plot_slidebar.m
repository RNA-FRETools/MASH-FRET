function update_plot_slidebar(dat)
% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

%pass information to vbFRET gui
% get the main_gui handle (access to the gui)
vbFRET_handle = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data = guidata(vbFRET_handle);

% set number of traces (slide bar must be at least 1 to prevent errors)
N = max(1,length(dat.labels));

if N > 1
    plot1Slider_editText_string = dat.labels{1};
    plot1SliderFraction_editText_string = sprintf('1 of %d',N);
    plot1_slider_max = N;
    plot1_slider_min = 1;
    plot1_slider_enable = 'on';
    plot1Slider_editText_enable = 'on';
    plot1SliderFraction_editText_enable = 'on';

    % make small slider step 1, large slider step 10
    plot1_slider_sliderStep = [(1/(N-1)) min(1,(10/(N-1)))];
else
    plot1_slider_max = 1;
    plot1_slider_min = 0;
    if isempty(dat.labels)
        plot1Slider_editText_string = '';
        plot1SliderFraction_editText_string = '';
        plot1_slider_enable = 'off';
        plot1Slider_editText_enable = 'off';
        plot1SliderFraction_editText_enable = 'off';

    else
        plot1Slider_editText_string = dat.labels{1};
        plot1SliderFraction_editText_string = sprintf('1 of %d',N);
        plot1_slider_enable = 'inactive';
        plot1Slider_editText_enable = 'inactive';
        plot1SliderFraction_editText_enable = 'inactive';
    end        
    % dummy value
    plot1_slider_sliderStep = [.1 .1];
end

% set plot slider value back to 1
set(vbFRET_data.plot1_slider,'Value',1);
% update the rest of the plot slider settings
set(vbFRET_data.plot1_slider,'Max',plot1_slider_max);
set(vbFRET_data.plot1_slider,'Min',plot1_slider_min);
set(vbFRET_data.plot1_slider,'SliderStep',plot1_slider_sliderStep);
set(vbFRET_data.plot1_slider,'Enable',plot1_slider_enable);

% update label display edit text 
set(vbFRET_data.plot1Slider_editText,'String', plot1Slider_editText_string);
set(vbFRET_data.plot1Slider_editText,'Enable',plot1Slider_editText_enable);


% update trace number display edit text
set(vbFRET_data.plot1SliderFraction_editText,'String', plot1SliderFraction_editText_string );
set(vbFRET_data.plot1SliderFraction_editText,'Enable',plot1SliderFraction_editText_enable);

% update plot
% plot_opts = init_plot;
plotFRET(vbFRET_data.axes1, dat, vbFRET_data.plot, 1);