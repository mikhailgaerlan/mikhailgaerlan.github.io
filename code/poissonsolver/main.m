params = ...
    [0 1   0.5  ;...
    1 1.5 2  ;...
    2 3   0.5;...
    5 3   1  ;...
    5 5   3  ];
n = size(params,1); errors = zeros(n,1); ms = zeros(n,1);
for i = 1:n
    for m = 10:1000
        h = 1/(m+1);
        a=params(i,1);b=params(i,2);g=params(i,3);
        [X,Y]=meshgrid(h:h:1-h);
        x = X(1,:);y = Y(:,1);
        F = f(X,Y,a,b,g);
        b0 = v(x,0,a,b,g);b1 = v(x,1,a,b,g);
        c0 = v(0,y,a,b,g);c1 = v(1,y,a,b,g);
        Vapprox = solvePoisson(m,F,b0,b1,c0,c1);
        Vactual = v(X,Y,a,b,g);
        error = max(abs(Vapprox(:)-Vactual(:)));
        if error < 5.0e-4
            errors(i)=error; ms(i)=m;
            surf(X,Y,F);saveas(gcf,strcat("../Figures/poisson_rhs_",int2str(i),".png"));
            surf(X,Y,Vapprox);saveas(gcf,strcat("../Figures/poisson_approx_",int2str(i),".png"));
            surf(X,Y,Vactual);saveas(gcf,strcat("../Figures/poisson_actual_",int2str(i),".png"));
            break;
        end
    end
end
matrix2latex(errors,'../Tables/poissonerrors.tex','alignment','r','format','%-.15e');
matrix2latex(ms,'../Tables/poissonms.tex','alignment','r','format','%-4d');

function true = v(x,y,a,b,g)
true = y.^a.*sin(b.*pi.*x).*cos(g.*pi.*y);
end

function fun = f(x,y,a,b,g)
fun = b.^2.*pi.^2.*y.^a.*sin(b.*pi.*x).*cos(g.*pi.*y)...
    -a.*(a-1).*y.^(a-2).*sin(b.*pi.*x).*cos(g.*pi.*y)...
    +2.*a.*g.*pi.*y.^(a-1).*sin(b.*pi.*x).*sin(g.*pi.*y)...
    +g.^2.*pi.^2.*y.^a.*sin(b.*pi.*x).*cos(g.*pi.*y);
end