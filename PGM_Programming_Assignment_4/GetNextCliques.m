%GETNEXTCLIQUES Find a pair of cliques ready for message passing
%   [i, j] = GETNEXTCLIQUES(P, messages) finds ready cliques in a given
%   clique tree, P, and a matrix of current messages. Returns indices i and j
%   such that clique i is ready to transmit a message to clique j.
%
%   We are doing clique tree message passing, so
%   do not return (i,j) if clique i has already passed a message to clique j.
%
%	 messages is a n x n matrix of passed messages, where messages(i,j)
% 	 represents the message going from clique i to clique j. 
%   This matrix is initialized in CliqueTreeCalibrate as such:
%      MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);
%
%   If more than one message is ready to be transmitted, return 
%   the pair (i,j) that is numerically smallest. If you use an outer
%   for loop over i and an inner for loop over j, breaking when you find a 
%   ready pair of cliques, you will get the right answer.
%
%   If no such cliques exist, returns i = j = 0.
%
%   See also CLIQUETREECALIBRATE
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function [i, j] = GetNextCliques(P, messages)

N = length(P.cliqueList);
% initialization
% you should set them to the correct values in your code
a = 0;
b = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE

for i=1:N,
   for j=1:N,
       a = 0;
       b = 0;
	   if (P.edges(i,j)==1)
	   	   flag = 0;
		   if (length(messages(i,j).var)==0)
		       for k=1:N,
		          if(P.edges(k,i)==1)
		              if (length(messages(k,i).var)==0)
		                 if (k==j)
		                     flag = 0;
		                 else 
		                     flag = 1;
		                 endif
		                 break;
		              endif
		          endif
		       end
		       if (flag==1)
		          continue;
		       endif
		       a = i;
		       b = j;
		       break;
		   endif
	   endif
   end
   if (~(a==0))
       break;
   endif
end
if (i==N && j==N)
    i = 0;
    j = 0;
endif
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



return;
