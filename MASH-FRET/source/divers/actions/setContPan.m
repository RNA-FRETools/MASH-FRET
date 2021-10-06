function setContPan(str, state, h_fig)
% setContPan update the action "str" in the action panel "edit_contPan".
%
% Last update: 20th of February 2019 by Mélodie C.A.S Hadzic
% --> fix find edit fields to display action in

% default
nLmax = 100;
colRed = [1 0.9 0.9];
colGreen = [0.9 1 0.9];
colYellow = [1 1 0.9];
colOrange = [1 0.95 0.9];
colWhite = [1 1 1];

h = guidata(h_fig);

if h.mute_actions
    return
end

switch state
    case 'error'
        colBg = colRed;
    case 'success'
        colBg = colGreen;
    case 'process'
        colBg = colYellow;
    case 'warning'
        colBg = colOrange;
    otherwise
        colBg = colWhite;
end

if ~iscell(str)
    n = strfind(str, '\n');
    if ~isempty(n)
        newStr{1,1} = str(1:n(1)-1);
        for i = 1:numel(n)-1
            newStr{size(newStr,1)+1,1} = str(n(i)+2:n(i+1)-1);
        end
        newStr{size(newStr,1)+1,1} = str(n(numel(n))+2:numel(str));
    else
        newStr{1,1} = str;
    end
    str = newStr;
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
t = [hr ':' m ' '];
str{1,1} = [t,str{1,1}];

% append log file with action
str2save = cell(size(str));
str2save{1} = str{1};
for i = 2:numel(str)
    str2save{i} = [repmat(' ',[1,length(t)]),str{i}];
end
success = saveActPan(str2save, h_fig);
if ~success
    disp('Impossible to append actions in daily log file.');
end
for i = 1:numel(str2save,1)
    disp(str2save{i});
end

% update control panel
str0 = get(h.edit_actPan,'userdata');
if size(str0,1)>1
    str0 = str0';
end
if size(str,1)>1
    str = str';
end
str = [str,str0];
if numel(str)>nLmax
    str((nLmax+1):end) = [];
end

strWrap = wrapActionString('none',h.edit_actPan,...
    [h.figure_dummy,h.text_dummy],str);
set(h.edit_actPan, 'String', strWrap, 'BackgroundColor', colBg,'userdata',...
    str);
drawnow;
