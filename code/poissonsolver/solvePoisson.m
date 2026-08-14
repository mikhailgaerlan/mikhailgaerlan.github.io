function V = solvePoisson(m,F,b0,b1,c0,c1)
%Solve two-dimensional Poisson's equation
%   input  - m            matrix size
%            F            right-hand side
%            b0,b1,c0,c1  boundary conditions
%   output - V            solution matrix
h = 1/(m+1);G = h^2*F;
G(1,:) = G(1,:)+b0; G(end,:) = G(end,:)+b1;
G(:,1) = G(:,1)+c0; G(:,end) = G(:,end)+c1;  
G = multZ(h,multZ(h,G.').');
V = zeros(m,m);
for k = 1:m
    for j = 1:m
        V(j,k) = G(j,k)/(l(h,j)+l(h,k));
    end
end
V = multZ(h,multZ(h,V.').');
end

function lam = l(h,j)
    lam = 2*(1-cos(pi*h*j));
end

function W = multZ(h,V)
%Multiply ZV where Z is the eigenvector matrix of T_m
%   input  - V is an n x n matrix
%   output - W = ZV
m = size(V,1);
Vt = vertcat(zeros(1,m),V,zeros(m+1,m));
Wt = fft(Vt);
W = -sqrt(2*h)*imag(Wt(2:m+1,:));
end