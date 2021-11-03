function setContPan(str, state, h_fig)
% setContPan update the action "str" in the action panel "edit_contPan".
%
% Last update: 20th of February 2019 by Mélodie C.A.S Hadzic
% --> fix find edit fields to display action in

% default
nLmax = 100;
colRed = [1 0.85 0.85];
colGreen = [0.85 1 0.85];
colYellow = [1 1 0.85];
colOrange = [1 0.925 0.85];
colWhite = [1 1 1];

h = guidata(h_fig);

if h.mute_actions
    return
end

switch state
    case 'error'
        str_icon = char(9888);
        clr_icon = [1,0.5,0.5];
        str_status = 'Warning!';
        colBg = colRed;
    case 'success'
        clr_icon = [0,0.5,0];
        str_icon = char(10004);
        str_status = 'Success!';
        colBg = colGreen;
    case 'process'
        str_icon = char(8987);
        clr_icon = [0,0,1];
        str_status = 'Processing...';
        colBg = colYellow;
    case 'warning'
        clr_icon = [1,0.5,0.5];
        str_icon = char(9888);
        str_status = ' Warning!';
        colBg = colOrange;
    otherwise
        clr_icon = [];
        str_icon = '';
        str_status = '';
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
str2save = str;
str2save{1,1} = [t,str2save{1,1}];

% append log file with action
for i = 2:numel(str2save)
    str2save{i} = [repmat(' ',[1,length(t)]),str2save{i}];
end
success = saveActPan(str2save, h_fig);
if ~success
    disp('Impossible to append actions in daily log file.');
end
for i = 1:numel(str2save)
    disp(str2save{i});
end

% make last action bold
if size(str,1)>1
    str = str';
end
str2disp = str;
str2disp{1} = ['*** ',str2disp{1}];
str2disp{end} = [str2disp{end},' ***'];

% concatenate with old actions
str0 = get(h.edit_actPan,'userdata');
if size(str0,1)>1
    str0 = str0';
end
str = [str,str0];
str2disp = [str2disp,str0];
if numel(str)>nLmax
    str((nLmax+1):end) = [];
    str2disp((nLmax+1):end) = [];
end

% strWrap = wrapActionString('none',h.edit_actPan,...
%     [h.figure_dummy,h.text_dummy],str);

if ~isempty(str_status)
    set(h.text_statusIcon,'String',str_icon,'ForegroundColor',clr_icon);
    set(h.text_status,'String',str_status);
    set(h.edit_actPan,'BackgroundColor',colBg);
end
set(h.edit_actPan,'String',str2disp,'userdata',str);

drawnow;
