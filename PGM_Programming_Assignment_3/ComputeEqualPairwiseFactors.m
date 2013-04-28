function factors = ComputeEqualPairwiseFactors (images, K)
% This function computes the pairwise factors for one word in which every
% factor value is set to be 1.
%
% Input:
%   images: An array of structs containing the 'img' value for each
%     character in the word.
%   K: The alphabet size (accessible in imageModel.K for the provided
%     imageModel).
%
% Output:
%   factors: The pairwise factors for this word. Every entry in the factor
%     vals should be 1.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

n = length(images);

factors = repmat(struct('var', [], 'card', [K,K], 'val', []), n - 1, 1);

% Your code here:
   t = zeros(1,K*K);
   i = 1;
   for j = 1:K,
       for k = 1:K,
          t(i) = pairwiseModel(k,j);
          i = i + 1;
       end       
   end   
   
for i=1:n-1,
   factors(i).var = [i,i+1];
   factors(i).val = t;
end

end
