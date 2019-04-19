function updateActPan(act, h_fig, varargin)
% Actualise actions listed in control panel.
% "newAct" >> action to append to action panel
% "h_fig" >> MASH figure handle
% "varargin" >> color string: "success", "process" or "error"

% Last update: 19th of February 2019 by Mélodie C.A.S Hadzic
% --> append log file for each action displayed

newAct = act;

if ~iscell(newAct)
    n = strfind(newAct, '\n');
    if ~isempty(n)
        newAct_cell{1,1} = newAct(1:n(1)-1);
        for i = 1:numel(n)-1
            newAct_cell{size(newAct_cell,1)+1,1} = ...
                ['         ' newAct(n(i)+2:n(i+1)-1)];
        end
        newAct_cell{size(newAct_cell,1)+1,1} = ...
            ['         ' newAct(n(numel(n))+2:numel(newAct))];
    else
        newAct_cell{1,1} = newAct;
    end
    newAct = newAct_cell;
else
    if numel(newAct) > 1
        for i = 2:numel(newAct)
            newAct{i} = ['         ' newAct{i}];
        end
    end
end

% get and format date
dateTime = clock;
hr = num2str(dateTime(4));
if length(hr) == 1
    hr = ['0' hr];
end
m = num2str(dateTime(5));
if length(m) == 1
    m = ['0' m];
end

% add time to the new action string
newAct_nkd = newAct;
t = [hr ':' m ' -- '];
newAct{1,1} = [t newAct{1,1}];

% append log file with action
success = saveActPan(newAct, h_fig);
if ~success
    disp('Impossible to append actions in daily log file.');
end

% update action list
h = guidata(h_fig);
if isfield(h, 'figure_actPan') && ishandle(h.figure_actPan)
    % get old actions
    h_pan = guidata(h.figure_actPan);
    oldLst = get(h_pan.text_actions, 'String');
    if ~iscell(oldLst)
        oldLst_cell{1,1} = oldLst;
        oldLst = oldLst_cell;
    end

    % get number of old actions
    if size(newAct,2)>size(newAct,1)
        newAct = newAct';
    end
    lst = vertcat(oldLst, newAct);
    lastRow = size(lst,1);

    % remove actions older than the 30th line
    if lastRow > 30
        newLst = {};
        for i = lastRow-29:lastRow
            newLst{size(newLst,1)+1,1} = lst{i,1};
        end
        lst = newLst;
        lastRow = 29;
    end

    set(h_pan.text_actions, 'String', lst);
    set(h_pan.text_actions, 'ListboxTop', lastRow, 'Value', lastRow);
    if ~isempty(varargin)
        if strcmp(varargin{1}, 'error')
            str_err = {};
            if ~iscell(act)
                n = strfind(act, '\n');
                if ~isempty(n)
                    str_err{1,1} = act(1:n(1)-1);
                    for i = 1:numel(n)-1
                        str_err{size(str_err,1)+1,1} = act(n(i)+2:n(i+1)-1);
                    end
                    str_err{size(str_err,1)+1,1} = act(n(numel(n))+2:numel(act));
                else
                    str_err{1,1} = act;
                end
            else
                str_err = act;
            end
            helpdlg(str_err);
            set(h_pan.text_actions, 'BackgroundColor', [1 0.75 0.75]);
        elseif strcmp(varargin{1}, 'success')
            set(h_pan.text_actions, 'BackgroundColor', [0.75 1 0.75]);
        elseif strcmp(varargin{1}, 'process')
            set(h_pan.text_actions, 'BackgroundColor', [1 1 0.75]);
        end
    else
        set(h_pan.text_actions, 'BackgroundColor', [1 1 1]);
    end
end

for i = 1:size(newAct,1)
    disp(newAct{i,1});
end


