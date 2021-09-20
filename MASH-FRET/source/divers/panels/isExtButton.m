function status = isExtButton(h_but)
%status = isExtButton(h_but)
%
% Identify if the input button is a panel extend/collapse button and return
% panel status
%
% h_but: handle to input button
% status: 0 if panel is not extendable
%         1 if panel is extended
%         2 if panel is collapsed

switch h_but.String
    case char(9650)
        status = 1;
    case char(9660)
        status = 2;
    otherwise
        status = 0;
end