function y = lasso(A,b,tau,x)
%Function to optimize
%   input  - x    vector of length n
%            A    given matrix of size n x n
%            b    given vector of length n
%            tau  weighting parameter
%   output - y    function value
y = (1/2)*norm(A*x-b,2)^2+tau*norm(x,1);
end