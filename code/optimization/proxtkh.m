function u = proxtkh(x,t)
%Prox-operator of t*||x||_1
%   input  - x  vector of length n
%          - t  constant
%   output - u  vector of length n
n = length(x); u = zeros(n,1);
for i = 1:n
    u(i) = sign(x(i))*max([abs(x(i))-t,0]);
end
end
