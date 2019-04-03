function str = removeHtml(str_html)
% str = removeHtml(str_html);
%
% Remove html tags from input string and return text-only string.
%
% str_html: string or cells of strings containing html tags
% str:      corresponding html-free string or cells of strings 

% created: by MH, 2.4.2019

if ~iscell(str_html)
    str_html = {str_html};
    cellup = 0;
else
    cellup = 1;
end

S = numel(str_html);
str = cell(1,S);

for s = 1:S

    str{s} = '';

    id_i = strfind(str_html{s},'<');
    id_o = strfind(str_html{s},'>');

    keep = true(1,length(str_html{s}));
    for i = 1:numel(id_i)
        o = find(~isnan(id_o) & id_o>id_i(i), 1);
        if ~isempty(o)
            o = o(1);
            keep(id_i(i):id_o(o)) = false;
            id_o(o) = NaN;
        end
    end

    str{s} = str_html{s}(keep);
end

if ~cellup
    str = str{1};
end
