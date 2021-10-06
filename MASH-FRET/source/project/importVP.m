function p = importVP(p,projs)
% p = importVP(p,projs)
%
% Ensure proper import of input projects' VP processing parameters.
%
% p: structure containing interface parameters
% projs: indexes of projects

% define molecule processing parameters applied (prm) and to apply (curr)
for i = projs
    % initializes current video frame and plot
    p.movPr.curr_frame(i) = 1;
    p.movPr.curr_plot(i) = 1;
end