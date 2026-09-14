function schm = buildstransscheme(D,type)
% schm = buildstransscheme(D,type)
%
% Builds transition scheme matrix from input dimension and type of
% transitions.
%
% D: number of states (dimension)
% type: transition type 'uncoupled', 'irrloop', 'acyclic', 'acyclic 
%       initiation', 'coupled' or 'generalized coxian'
% schm: [D+2-by-D+2] transition scheme where first and last rows/columns
%       are transitions from/to absorbing states.

switch type
    case 'uncoupled' %   out out out
        ip = ones(1,D); % ^   ^   ^
        ep = ones(D,1); % C1  C2  C3
        tp = zeros(D); %  ^   ^   ^
                   %      in  in  in 
        
    case 'irrloop' %                      out
        ip = [1,zeros(1,D-1)]; %           ^
        ep = [zeros(D-1,1);1]; % C1 > C2 > C3
        tp = zeros(D); %         ^
        for d = 1:D-1 %          in
            tp(d,d+1) = 1;
        end
        
    case 'acyclic' %                       out
        ip = ones(1,D);   %                ^
        ep = [zeros(D-1,1);1]; % C1 > C2 > C3
        tp = zeros(D); %         ^    ^    ^
        for d = 1:D-1 %          in   in   in
            tp(d,d+1) = 1;
        end
        
    case 'acyclic initiation' %            out            out            out
        ip = ones(D,1); %                  ^              ^              ^
        for d = 1:(D-1) %        C1 > C2 > C3 / C1 > C2 > C3 / C1 > C2 > C3 
            ip = cat(2,ip,... %  ^    ^    ^    ^         ^    ^
                [ones(d,1);... % in   in   in   in        in   in
                zeros(D-d,1)]);
        end
        ep = [zeros(D-1,1);1];
        tp = zeros(D);
        for d = 1:D-1
            tp(d,d+1) = 1;
        end
        
    case 'coupled' %         in > C3 > out
        ip = ones(1,D); %        //\\
        ep = ones(D,1); % out < C1==C2 > out
        tp = ones(D); %         ^   ^
        tp(~~eye(D)) = 0; %     in  in
        
    case 'generalized coxian' % out  out  out
        ip = ones(1,D); %       ^    ^    ^
        ep = ones(D,1); %       C1 > C2 > C3
        tp = zeros(D); %        ^    ^    ^
        for d = 1:D-1 %         in   in   in
            tp(d,d+1) = 1;
        end
        
    otherwise
        disp(['MLPH>buildstransscheme: transition scheme type not ',...
            'recognized.']);
        schm = [];
        return
end

schm = [];
for s = 1:size(ip,1)
    schm = cat(3,schm,[0,ip(s,:),0; zeros(D,1),tp,ep; zeros(1,D+2)]);
end
