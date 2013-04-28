%COMPUTEEXACTMARGINALSBP Runs exact inference and returns the marginals
%over all the variables (if isMax == 0) or the max-marginals (if isMax == 1). 
%
%   M = COMPUTEEXACTMARGINALSBP(F, E, isMax) takes a list of factors F,
%   evidence E, and a flag isMax, runs exact inference and returns the
%   final marginals for the variables in the network. If isMax is 1, then
%   it runs exact MAP inference, otherwise exact inference (sum-prod).
%   It returns an array of size equal to the number of variables in the 
%   network where M(i) represents the ith variable and M(i).val represents 
%   the marginals of the ith variable. 
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function M = ComputeExactMarginalsBP(F, E, isMax)

% initialization
% you should set it to the correct value in your code
M = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Implement Exact and MAP Inference.

a = CreateCliqueTree(F,E);
b = CliqueTreeCalibrate(a,isMax);

vs = [];
for i=1:length(a.cliqueList),
   vs = union(vs, a.cliqueList(i).var);
end

N = length(vs);
M = repmat(struct('var', [], 'card', [], 'val', []), N, 1);
factors = 1:N;
for i=1:length(a.cliqueList),
   vars = a.cliqueList(i).var;
   for j=1:length(vars),
      v = vars(j);
      rest = setdiff(vars,v);
      f = struct('var', [], 'card', [], 'val', []);
      if (isMax==0)
          f = FactorMarginalization(b.cliqueList(i), rest);
          f.val = f.val./sum(f.val);
          else
          f = FactorMaxMarginalization(b.cliqueList(i), rest);
      endif  
      M(v) = f;
   end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
