function [x,errors,times] = subgradientmethod(f,grad,x0,tol,xs,method,print)
%Subgradient method to minimize f(x)
%   input  - f       function to minimize
%          - grad    subgradient of f
%          - x0      starting point
%          - tol     error tolerance
%          - xs      true solution
%          - method  step size method options:
%                    'fixedsize'
%                    'fixedlength'
%                    'diminishing'
%          - print   option to display error
%   output - x       minimizer approximation
%          - times   cpu time
%          - errors  relative error
tic; k = 0; x = x0; error = 1e2*tol; truenorm = norm(xs);
stepsizemethod = strcat(method,'(x,k)');

histlength = 1000;
errorhist = ones(histlength,1);

%========================================
%
%             Begin algorithm
%
%========================================
while error >= tol
    
    %-----------------
    %   Update Step
    %-----------------
    k = k + 1;
    t = eval(stepsizemethod);
    x = x - t*grad(x);
    
    %-----------------
    %      Error
    %-----------------
    olderror = mean(errorhist);
    errorhist = circshift(errorhist,1);
    error = norm(x-xs)/truenorm;
    errorhist(1) = error;
    newerror = mean(errorhist);
    
    if print; disp(error); end
    errors(k) = error;
    times(k) = toc;
    
    
    %----------------------
    %  Stopping criteria
    %----------------------
    if (k > histlength && abs(newerror-olderror) <= 1e-6)
        disp('Did not converge.');
        break;
    end
end
if error < tol; disp('Converged.'); end
%========================================
%
%            End algorithm
%
%========================================

if print; semilogy(times,errors); end

%========================================
%
%           Step Size Rules
%
%========================================

    %-----------------------
    %      Fixed Size
    %-----------------------
    function t = fixedsize(x,k)
        t = 1e-2;
    end

    %-----------------------
    %      Fixed Length
    %-----------------------
    function t = fixedlength(x,k)
        t = 1.6e-2/norm(grad(x));
    end

    %-----------------------
    %      Diminishing
    %-----------------------
    function t = diminishing(x,k)
        t = 1.6e-2/k;
    end

end