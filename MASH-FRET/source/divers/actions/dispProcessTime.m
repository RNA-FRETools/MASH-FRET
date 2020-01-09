function ok = dispProcessTime(t,questStr)
% Pauses process, opens question dialog box showing time in hours/minutes/seconds and asking yes/no question to user, and returns user's choice.
% 
% t: processing time
% questStr: yes/no question string
%
% ok: user's choice yes (1) or no (0)

% Last update by MH, 5.12.2019
% >> move script that shows processing time and asks confirmation to user
%  from exportResults.m to this separate function

ok = 1;

t_h = t/3600;
t_min = (t_h - floor(t_h))*60;
t_sec = round((t_min - floor(t_min))*60);

estm_str = [];
if floor(t_h)>0
    estm_str = [num2str(floor(t_h)) 'h '];
end
if floor(t_min)>0
    estm_str = [estm_str num2str(floor(t_min)) 'min '];
end
estm_str = [estm_str num2str(t_sec) 's'];

choice = questdlg({['Estimated time: ',estm_str],questStr},...
    'Processing time','Yes','No','Yes');

if ~strcmp(choice,'Yes')
    ok = 0;
end
