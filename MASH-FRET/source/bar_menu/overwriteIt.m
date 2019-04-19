function OutfName = overwriteIt(fName, pName, h_fig)
% Tcheck the existence of a file named fName in pName and ask the user for
% overwriting (choice can be conservefor further conflicts).
% "fName" >> file name.
% "pName" >> file path.
% "h_fig" >> MASH figure handle.
% "OutfName" >> file name with an index inserted (if exists).
% "number" >> index (if exists).

% Requires external function: setCorrectPath.
% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

OutfName = [];

fullPath = ~isempty(strfind(pName, filesep));
% set correct saving path
if fullPath
    pth = pName;
else
    pth = [setCorrectPath(pName, h_fig) filesep];
end
            
if exist([pth fName], 'file')
    saveIt = 1;
    h = guidata(h_fig);
    ask = h.param.OpFiles.overwrite_ask;

    if ask
        openWindow(h_fig);
        h = guidata(h_fig);
        uiwait(h.OF.figure2);

        h = guidata(h_fig);

        saveIt = h.OF.output(1);
        ovrwrtIt = h.OF.output(2);% no = 0, yes = 1, always no = 2, always yes = 3

        h = rmfield(h, 'OF');

        if ovrwrtIt >= 2
            h.param.OpFiles.overwrite_ask = 0;
            ovrwrtIt = ovrwrtIt - 2;
            h.param.OpFiles.overwrite = ovrwrtIt;% yes = 1, no = 0
        end
        
        guidata(h_fig, h);
        
        ud_menuOverwrite(h_fig);
        
    else
        ovrwrtIt = h.param.OpFiles.overwrite;% no = 0, yes = 1
    end

    if saveIt && ~ovrwrtIt

        OutfName = fName;

        number = 1;
        [o,mainName,Fext] = fileparts(fName);
        while exist([pth OutfName], 'file')
            number = number + 1;
            OutfName = [mainName '(' num2str(number) ')' Fext];
        end
        
    elseif saveIt && ovrwrtIt
        OutfName = fName;
    end
    
else
    OutfName = fName;
end


function openWindow(h_fig)
% Open modal window for overwriteIt function
% "h_fig" >> MASH figure handle

% Requires external function: exitWindow.
% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

h = guidata(h_fig);

msgStr = 'Files already exist. Overwrite them?';

h.OF.figure2 = figure('WindowStyle', 'modal', 'NumberTitle', 'off', ...
    'MenuBar', 'none', 'Units', 'pixel', 'Visible', 'off', 'Name', ...
    'Overwrite files', 'Resize', 'off', 'Color', [0.94 0.94 0.94], ...
    'CloseRequestFcn', {@exitWindow, h_fig});

% set figure position
set(h.OF.figure2, 'Position', [0,0,400,90]);
set(h.OF.figure2, 'Units', 'normalized');
pos_fig_norm = get(h.OF.figure2, 'Position');
set(h.OF.figure2, 'Position', [0.5-pos_fig_norm(3)/2,0.5-pos_fig_norm(4)/2,...
                               pos_fig_norm(3),pos_fig_norm(4)]);

% create controls
text1 = uicontrol('Style', 'text', 'String', msgStr, 'Units', 'normalized', ...
    'HorizontalAlignment', 'center', 'FontSize', 10);
set(text1, 'Position', [0,0.75,1,0.2]);

h.OF.pushbutton_yes = uicontrol('Style', 'pushbutton', 'String', 'Yes', ...
    'Units', 'normalized', 'Callback', {@exitWindow, h_fig});
set(h.OF.pushbutton_yes, 'Position', [0.25,0.45,0.15,0.1*319/(1.5*89)]);

pushbutton_no = uicontrol('Style', 'pushbutton', 'String', 'No', 'Units', ...
    'normalized', 'Callback', {@exitWindow, h_fig});
set(pushbutton_no, 'Position', [0.55,0.45,0.15,0.1*319/(1.5*89)]);

h.OF.cb = uicontrol('Style', 'checkbox', 'String', 'Remember my choice.', ...
    'Units', 'normalized');
set(h.OF.cb, 'Position', [0.1,0.22,0.98,0.15]);

str_advice = '(can be modified in menu Options > Overwrite files)';

text2 = uicontrol('Style', 'text', 'String', str_advice, 'Units', ...
    'normalized', 'HorizontalAlignment', 'left');
set(text2, 'Position', [0.1,0.05,1,0.15]);

guidata(h_fig, h);
set(h.OF.figure2, 'Visible', 'on');


function exitWindow(obj, evd, h_fig)
% Save overwriting choice at modal window closing
% "obj" >> modal figure handle
% "evd" >> event structure
% "h_fig" >> MASH figure handle

% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

h = guidata(h_fig);

saveIt = 1;
ovrwrtIt = 0;

if obj == h.OF.figure2
    saveIt = 0;
    
elseif obj == h.OF.pushbutton_yes
    ovrwrtIt = 1;
end

% no = 0, yes = 1, always no = 2, always yes = 3
ovrwrtIt = ovrwrtIt + 2*get(h.OF.cb, 'Value');

h.OF.output = [saveIt, ovrwrtIt];
guidata(h_fig, h);
delete(h.OF.figure2);

