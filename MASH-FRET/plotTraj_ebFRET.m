function plotTraj_ebFRET(pname,fname,J)
% | Export figures of ebFRET-exported trace file (.mat) to .pdf file.
% |
% | command: plotTraj_ebFRET(pname,fname,J);
% | pname >> source directory
% | fname >> source file
% | J >> state configuration to export (number of states)
% |
% | example: plotTraj_ebFRET('C:\MyDataFolder\experiment_01\traces_processing\ebFRET\','data_ebFRET.mat',2);

% Last update: 18th of February 2019 by Mélodie Hadzic
% --> update help section

exp_ascii = true;
exp_fig = true;

% correct source directory
if ~strcmp(pname(end),filesep)
    pname = cat(2,pname,filesep);
end


fprintf('\nProcessing file:\n%s%s\n...',pname,fname);

if exp_fig
    % diverse settings
    win_split = [3,2]; % graph splitting
    fig_format = 1; % (1)pdf (2)png (3)jpg

    int_id = false(win_split(2),2*win_split(1));
    fret_id = false(win_split(2),2*win_split(1));
    for l = 1:2*win_split(1)
        if mod(l,2)~=0
            int_id(:,l) = true;
        else
            fret_id(:,l) = true;
        end
    end
    int_id = int_id(:);     fret_id = fret_id(:);
    int_id = find(int_id); fret_id = find(fret_id);
    
    if fig_format==1
        temp_dir = cat(2,pname,'temp',filesep);
        if ~exist(temp_dir,'dir')
            mkdir(temp_dir);
        end
        nfig = 1;
    end
end


if exp_fig
    %% create figure
    units_0 = get(0, 'Units');
    set(0, 'Units', 'pixels');
    pos_0 = get(0, 'ScreenSize');
    set(0, 'Units', units_0);
    hmig = pos_0(4); % A4 format
    wmig = hmig*21/29.7;
    xmig = (pos_0(3) - wmig)/2;
    ymig = (pos_0(4) - hmig)/2;

    h_fig = figure('Visible', 'off', 'Units', 'pixels', 'Position', ...
        [xmig ymig wmig hmig], 'Color', [1 1 1], 'Name', 'Preview', ...
        'NumberTitle', 'off', 'menuBar', 'none', 'PaperOrientation', ...
        'portrait', 'PaperType', 'A4');
    
    m_prev = 1;
    ax_id = 1;
end

%% import data
data = [];

try
    data_f = importdata(cat(2,pname,fname));
    F = size(data_f.series,2);
    
catch err
    fprintf(cat(2,'\n',err.message));
    return;
end

for f = 1:F
    try
        data = cat(3,data,cat(2,data_f.series(f).time,data_f.series(f).donor, ...
            data_f.series(f).acceptor,data_f.series(f).signal, ...
            data_f.analysis(J).viterbi(f).mean));
    catch err
        fprintf(cat(2,'\n',err.message));
    end
end

for f = 1:F
    
    if exp_fig
        try
            subplot(2*win_split(1),win_split(2),int_id(ax_id));
            plot(data(:,1,f), data(:,[2,3],f));
            title(cat(2,'mol ',num2str(f)));
            xlim([data(1,1,f),data(end,1,f)]);

            subplot(2*win_split(1),win_split(2),fret_id(ax_id));
            plot(data(:,1,f), data(:,[4,5],f));
            xlim([data(1,1,f),data(end,1,f)]);
            ylim([0 1]);

        catch err
            fprintf(cat(2,'\n',err.message));
        end

        ax_id = ax_id + 1;

        if ~mod(f,prod(win_split)) || f == F
            setProp(get(h_fig, 'Children'), 'Units', 'normalized');
            set(h_fig, 'Units', 'centimeters');
            mg = 1;
            pos = [0 0 (21-2*mg) (29.7-2*mg*29.7/21)];
            set(h_fig,'Position',pos,'PaperPositionmode','manual', ...
                'PaperUnits','centimeters','PaperSize',[pos(3)+2 pos(4)+2], ...
                'PaperPosition',[mg mg pos(3) pos(4)]);

            switch fig_format
                case 1 % pdf
                    [o,fn,o] = fileparts(fname);
                    fname_fig{nfig} = cat(2, temp_dir, fn, ...
                        num2str(m_prev), '-', num2str(f), '.pdf');
                    print(h_fig, fname_fig{nfig}, '-dpdf');
                    nfig = nfig + 1;

                case 2 % png
                    [o,fn,o] = fileparts(fname);
                    fname_fig = cat(2,fn,num2str(m_prev),'-',num2str(f),'.png');
                    print(h_fig, cat(2,pname,fname_fig),'-dpng');

                case 3 % jpg
                    [o,fn,o] = fileparts(fname);
                    fname_fig = cat(2,fn,num2str(m_prev),'-',num2str(f),'.jpg');
                    print(h_fig, cat(2,pname,fname_fig),'-djpeg');
            end

            delete(h_fig);
            m_prev = f + 1;
            ax_id = 1;

            if ~mod(f,prod(win_split)) && f < F
                h_fig = figure('Visible', 'off', 'Units', 'pixels', 'Position', ...
                    [xmig ymig wmig hmig], 'Color', [1 1 1], 'Name', 'Preview', ...
                    'NumberTitle', 'off', 'menuBar', 'none', 'PaperOrientation', ...
                    'portrait', 'PaperType', 'A4');
            end
        end
    end
    
    if exp_ascii
        [o,fn,o] = fileparts(fname);
        fname_m = cat(2,fn,sprintf('mol%i.txt',f));
        f_id = fopen(cat(2,pname,fname_m),'Wt');
        fprintf(f_id,cat(2,repmat('%d\t',1,5),'\n'),data(:,1:5,f)');
        fclose(f_id);
    end
end

if exp_fig && fig_format == 1 % *.pdf
    [o,fn,o] = fileparts(fname);
    fname_pdf = cat(2,pname,fn,'.pdf');
    try
        append_pdfs(fname_pdf, fname_fig{:});
        rmdir(temp_dir);

    catch err
        fprintf(cat(2,'Impossible to save figures to PDm file.\n\n',...
            'MATLAB error: ',err.message,'\n\n', ...
            'Advice: change the export format to *.png or *.jpg\n'));
    end
end

fprintf('\n%i files processed: figures successfully exported.\n',F)
    



function setProp(h, prop, val, varargin)

h = reshape(h,1,numel(h));

condition = ~isempty(varargin) && size(varargin,2) == 2 && ...
    ~isempty(varargin{1}) && ~isempty(varargin{2});
if condition
    propCond = varargin{1};
    valCond = varargin{2};
else
    propCond = [];
    valCond = [];
end

for i = 1:numel(h)
    if isprop(h(i),'Children')
        h_obj = get(h(i), 'Children');
        if ~isempty(h_obj)
            setProp(h_obj, prop, val, propCond, valCond);
        end
    end
    if condition && isprop(h(i),prop) && isprop(h(i), propCond) && ...
            isequal(get(h(i), propCond), valCond)
        set(h(i), prop, val);
        
    elseif ~condition && isprop(h(i),prop)
        set(h(i), prop, val);
    end
end