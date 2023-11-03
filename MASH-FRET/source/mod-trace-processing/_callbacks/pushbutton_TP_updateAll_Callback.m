function pushbutton_TP_updateAll_Callback(obj, evd, h_fig)
% pushbutton_TP_updateAll_Callback([],[],h_fig)
% pushbutton_TP_updateAll_Callback(opt0,[],h_fig)
%
% h_fig: handle to main figure
% opt0: string indicating the most advanced stage to which the analysis 
%       must start.


% Last update by MH, 14.1.2020: separate trace update into 3 successive processes (1) update all intensity correction (2) calculate gamma factors (3) discretize traces; this allows stable ES histogram for linear regression

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
nMol = size(p.proj{proj}.coord_incl,2);

setContPan('Process all molecule data ...','process',h_fig);

% loading bar parameters
if loading_bar('init',h_fig ,3*nMol,'Process all molecule ...')
  return
end
h = guidata(h_fig);
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h);

try
    % display action
    disp('correct intensities...');
    
    % update all intensities
    opt = cell(1,nMol);
    for m = 1:nMol
        % reset traces according to changes in parameters
        [p,opt{m}] = resetMol(m, 'ttPr', p);
        p = plotSubImg(m, p, []);
        [p,~] = updateIntensities(opt{m},m,p,h_fig);

        % loading bar update
        if loading_bar('update',h_fig)
            h = guidata(h_fig);
            h.param = p;
            guidata(h_fig, h);
            return
        end
    end

    % added by MH, 14.1.2020
    % calculate correction factors and discretize traces
    disp('calculate correction factors...');
    for m = 1:nMol
        if strcmp(opt{m}, 'gamma') || strcmp(opt{m}, 'debleach') || ...
                strcmp(opt{m}, 'denoise') || strcmp(opt{m}, 'cross') || ...
                strcmp(opt{m}, 'ttBg') || strcmp(opt{m}, 'ttPr')
            p = updateGammaFactor(h_fig,m,p);
        end
        
        % loading bar update
        if loading_bar('update',h_fig)
            h = guidata(h_fig);
            h.param = p;
            guidata(h_fig, h);
            return
        end
    end
    for m = 1:nMol
        disp(cat(2,'infer state sequences for molecule n:°',num2str(m)));
        p = updateStateSequences(h_fig, m, p);

        % loading bar update
        if loading_bar('update',h_fig)
            h = guidata(h_fig);
            h.param = p;
            guidata(h_fig, h);
            return
        end
    end

catch err
    updateActPan(['An error occurred during processing of molecule n:°' ...
        num2str(m) ':\n' err.message],h_fig,'error');
    for i = 1:size(err.stack,1)
        disp(['function: ' err.stack(i,1).name ', line: ' ...
            num2str(err.stack(i,1).line)]);
    end
    h = guidata(h_fig);
    h.param = p;
    guidata(h_fig, h);
    return
end

% update project data (dwelltimes in particular)
h.param = p;
guidata(h_fig, h);
[dat,ok] = checkField(p.proj{proj},'',h_fig);
if isempty(dat)
    return
end
if ok==2
    h = guidata(h_fig);
    p = h.param;
end
p.proj{p.curr_proj} = dat;

% set default HA and TA parameters
p = importHA(p,p.curr_proj);
p = importTA(p,p.curr_proj);

% collect processed data
h = guidata(h_fig);
h.param = p;
guidata(h_fig, h);

loading_bar('close',h_fig);

updateFields(h_fig);

setContPan('Update completed !','success',h_fig);
