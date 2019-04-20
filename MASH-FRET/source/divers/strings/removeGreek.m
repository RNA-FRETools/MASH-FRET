function str = removeGreek(str_greek)
% str = removeGreek(str_greek);
%
% Replace greek unicode symbols from input string by phonetics and return 
% text-only string.
%
% str_greek: string or cells of strings containing greek symbols
% str:       corresponding symbol-free string or cells of strings 

% created: by MH, 20.4.2019

symb_txt = {'alpha','beta','gamma','delta','epsilon','zeta','eta','theta',...
    'iota','kappa','lambda','mu','nu','xi','omicron','pi','rho','sigmaf',...
    'sigma','tau','upsilon','phi','chi','psi','omega'};

if ~iscell(str_greek)
    str_greek = {str_greek};
    cellup = 0;
else
    cellup = 1;
end

S = numel(str_greek);
str = cell(1,S);

for s = 1:S
    str{s} = str_greek{s};
    for i = 1:numel(symb_txt)
        str{s} = strrep(str{s},char(944+i),symb_txt{i});
    end
end

if ~cellup
    str = str{1};
end