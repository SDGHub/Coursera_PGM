function out = ReorderFactorVariables(in)   
% Function accepts a factor and reorders the factor variables  
% such that they are in ascending order  

[S, I] = sort(in.var);  

out.var = S;  
out.card = in.card(I);  

allAssignmentsIn = IndexToAssignment(1:prod(in.card), in.card);  
allAssignmentsOut = allAssignmentsIn(:,I); % Map from in assgn to out assgn  
out.val(AssignmentToIndex(allAssignmentsOut, out.card)) = in.val;  

end  