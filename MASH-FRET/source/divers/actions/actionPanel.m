function varargout = actionPanel(varargin)
% Last Modified by GUIDE v2.5 04-Mar-2014 08:28:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @actionPanel_OpeningFcn, ...
                   'gui_OutputFcn',  @actionPanel_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


function actionPanel_OpeningFcn(obj, evd, h, varargin)
setProp([obj; get(obj, 'Children')], 'Units', 'normalized');

set(h.text_actions, 'Position', [0 0 1 1]);

h.figure_MASH = varargin{1};
opos = get(h.figure_MASH, 'OuterPosition');
set(obj, 'OuterPosition', [opos(1),0,opos(3),1-opos(4)]);
h.output = obj;
guidata(obj, h);


function varargout = actionPanel_OutputFcn(obj, evd, h) 
varargout{1} = h.output;


function figureActPan_ResizeFcn(obj, evd, h)
set(h.text_actions, 'Position', [0 0 1 1]);


function figureActPan_CloseRequestFcn(obj, evd, h)
set(obj, 'Visible', 'off');
h_call = guidata(h.figure_MASH);
set(h_call.menu_showActPan, 'Checked', 'off');
