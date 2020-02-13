function dispMatlabErr(err)
% dispMatlabErr(err)
%
% Display error message and tracking in MATLAB command window
%
% err: MException catched when an error occurs

disp('An error occurred:')
disp(err.message);
for i = 1:size(err.stack,1)
    disp(['function: ' err.stack(i,1).name ', line: ' ...
        num2str(err.stack(i,1).line)]);
end