function plotTraj(varargin)
% Plot several trajectories from a set of *.txt file exported from MASH and
% export data to a pdf file.
% input arg1: folder path containing ASCII files
% input arg2: root file name (with a * instead of the molecule number)

% ex: plotTraj_ebFRET(['D:\analysis\MASHsmFRET_test\publication\' ...
%     'traces_processing\traces_ASCII\length_6400_VbFRET\'], ...
%     'length_1600_VbFRET_mol*of100.txt');

exp_ascii = true;

% foldder path (with ending file separator)
if numel(varargin)>0 && ~isempty(varargin{1})
    pname = varargin{1};
else
    fprintf('argument 1 missing (folder path): process aborted\n');
end
if ~strcmp(pname(end),filesep)
    pname = cat(2,pname,filesep);
end

% root file name with a "*" character replacing the molecule number
if numel(varargin)>1 && ~isempty(varargin{2})
    rname = varargin{2};
else
    fprintf('argument 2 missing (root file name): process aborted\n');
end

fprintf('\nProcessing file:\n%s%s\n...',pname,rname);

% diverse settings
win_split = [3,2]; % graph splitting
col = [1 2 3 4 5]; % data column [time don acc fret discr]
fig_format = 2; % (1)pdf (2)png (3)jpg

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

%% import data
fList = dir(cat(2,pname,rname));
F = size(fList,1);
m_prev = 1;
ax_id = 1;
N = 0;
data = [];


ms = [];
for f = 1:F
    ms = cat(2,ms,sscanf(fList(f,1).name,strrep(rname,'*','%i')));
    fname = fList(f,1).name;
    data_f = importdata(cat(2,pname,fname));
    if isstruct(data_f)
        data_f = data_f.data;
    end
    data = cat(3,data,data_f);
end
[o,id_f] = sort(ms,'ascend');

for f = id_f
    N = N + 1;
    m = ms(f);
    
    subplot(2*win_split(1),win_split(2),int_id(ax_id));
    plot(data(:,col(1),f), data(:,[col(2) col(3)],f));
    title(cat(2,'mol ',num2str(m)));
    xlim([data(1,col(1),f),data(end,col(1),f)]);
    
    subplot(2*win_split(1),win_split(2),fret_id(ax_id));
    plot(data(:,col(1),f), data(:,[col(4) col(5)],f));
    xlim([data(1,col(1),f),data(end,col(1),f)]);
    
    ax_id = ax_id + 1;
    
    if ~mod(N,prod(win_split)) || N == F
        setProp(get(h_fig, 'Children'), 'Units', 'normalized');
        set(h_fig, 'Units', 'centimeters');
        mg = 1;
        pos = [0 0 (21-2*mg) (29.7-2*mg*29.7/21)];
        set(h_fig,'Position',pos,'PaperPositionmode','manual', ...
            'PaperUnits','centimeters','PaperSize',[pos(3)+2 pos(4)+2], ...
            'PaperPosition',[mg mg pos(3) pos(4)]);

        switch fig_format
            case 1 % pdf
                [o,fn,o] = fileparts(strrep(rname,'*',''));
                fname_fig = cat(2,fn,'.ps');
                print(h_fig, cat(2,pname,fname_fig),'-dpsc','-append');

            case 2 % png
                [o,fn,o] = fileparts(strrep(rname,'*',cat(2, ...
                    num2str(m_prev),'-',num2str(m))));
                fname_fig = cat(2,fn,'.png');
                print(h_fig, cat(2,pname,fname_fig),'-dpng');

            case 3 % jpg
                [o,fn,o] = fileparts(strrep(rname,'*',cat(2, ...
                    num2str(m_prev),'-',num2str(m))));
                fname_fig = cat(2,fn,'.jpg');
                print(h_fig, cat(2,pname,fname_fig),'-djpeg');
        end

        delete(h_fig);
        m_prev = m + 1;
        ax_id = 1;
                    
        if ~mod(N,prod(win_split)) && N < F
            h_fig = figure('Visible', 'off', 'Units', 'pixels', 'Position', ...
                [xmig ymig wmig hmig], 'Color', [1 1 1], 'Name', 'Preview', ...
                'NumberTitle', 'off', 'menuBar', 'none', 'PaperOrientation', ...
                'portrait', 'PaperType', 'A4');
        end
    end
    
    if exp_ascii
        [o,fn,o] = fileparts(strrep(rname,'*',num2str(m)));
        fname_m = cat(2,fn,'.txt');
        f_id = fopen(cat(2,pname,fname_m),'Wt');
        fprintf(f_id,cat(2,repmat('%d\t',1,size(col,2)),'\n'),data(:,col)');
    end
end

if fig_format == 1 % *.pdf
    [o,fname_pdf,o] = fileparts(fname_fig);
    fname_pdf = cat(2,fname_pdf,'.pdf');
    try
        ps2pdf('psfile', cat(2,pname,fname_fig), 'pdffile', cat(2,pname,...
            fname_pdf));
        delete(cat(2,pname,fname_fig));
        
    catch err
        disp(['Impossible to save figures to PDm file.\n\n' ...
            'mATLAB error: ' err.message '\n\n' ...
            'Advice: change in the option menu (>Edit) the export ' ...
            'format to *.png or *.jpg']);
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