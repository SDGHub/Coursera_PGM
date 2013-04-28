%CLIQUETREECALIBRATE Performs sum-product or max-product algorithm for 
%clique tree calibration.

%   P = CLIQUETREECALIBRATE(P, isMax) calibrates a given clique tree, P 
%   according to the value of isMax flag. If isMax is 1, it uses max-sum
%   message passing, otherwise uses sum-product. This function 
%   returns the clique tree where the .val for each clique in .cliqueList
%   is set to the final calibrated potentials.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function P = CliqueTreeCalibrate(P, isMax)


% Number of cliques in the tree.
N = length(P.cliqueList);

% Setting up the messages that will be passed.
% MESSAGES(i,j) represents the message going from clique i to clique j. 
MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% We have split the coding part for this function in two chunks with
% specific comments. This will make implementation much easier.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% YOUR CODE HERE
% While there are ready cliques to pass messages between, keep passing
% messages. Use GetNextCliques to find cliques to pass messages between.
% Once you have clique i that is ready to send message to clique
% j, compute the message and put it in MESSAGES(i,j).
% Remember that you only need an upward pass and a downward pass.
%

if (isMax==1)
    for h=1:N,
       P.cliqueList(h).val = log(P.cliqueList(h).val);
    end
endif

[i,j] = GetNextCliques(P,MESSAGES);
while ~(i==0)
    from = P.cliqueList(i);
    to = P.cliqueList(j);
    tempF = struct('var', [], 'card', [], 'val', []);
    for a=1:N,
       if ~(length(MESSAGES(a,i).var)==0 || (a==j))
            if (length(tempF.var)==0)
                tempF = MESSAGES(a,i);
            else
                if (isMax==0)
                    tempF = FactorProduct(MESSAGES(a,i),tempF);
                else
                    tempF = FactorSum(MESSAGES(a,i),tempF);
                endif
            endif
       endif
    end
    if (isMax==0)
        tempF = FactorProduct(P.cliqueList(i),tempF);
        else
        tempF = FactorSum(P.cliqueList(i),tempF);
    endif 

    sepset = intersect(from.var,to.var);
    sumout = setdiff(tempF.var,sepset);
    if (isMax==0)
        m = FactorMarginalization(tempF, sumout);
    else
        m = FactorMaxMarginalization(tempF, sumout);
    endif
    
    if (isMax==0)
        m.val = m.val./sum(m.val);
    endif
    MESSAGES(i,j) = m;
    [i,j] = GetNextCliques(P,MESSAGES);
endwhile

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Now the clique tree has been calibrated. 
% Compute the final potentials for the cliques and place them in P.

for i=1:N,
   start = P.cliqueList(i);
   for j=1:N,
      if (P.edges(i,j)==1)
           if (isMax==0)
               start = FactorProduct(start, MESSAGES(j,i));
           else
               start = FactorSum(start, MESSAGES(j,i));
           endif
      endif
   end
   P.cliqueList(i) = start;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



return
