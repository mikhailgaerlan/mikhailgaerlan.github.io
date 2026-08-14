function [x,errors,times] = proximalmethod(g,h,grad,prox,x0,tol,xs,method,print)
%Proximal gradient method to min f(x) = g(x) + h(x)
%   input  - g       differentiable function
%          - h       function with prox-operator
%          - grad    gradient of g
%          - prox    prox-operator of h
%          - x0      starting point
%          - tol     error tolerance
%          - xs      true solution
%          - method  step size method options:
%                    'fixedsize'
%                    'linesearch'
%          - print   option to display error
%   output - x       minimizer approximation
%          - times   cpu time
%          - errors  relative error
tic; k = 0; x = x0; error = 1e2*tol; truenorm = norm(xs);
stepsizemethod = strcat(method,'(x,gr,k)');

histlength = 200;
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
    gr = grad(x);
    t = eval(stepsizemethod);
    x = x - t * gradmap(x,gr,t);
    
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
    if (k > histlength && abs(newerror-olderror) <= 1e-2)
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

%-----------------------
%     Gradient Map
%-----------------------
    function z = gradmap(x,gr,t)
        z = (x - prox(x-t*gr,t))/t;
    end

%========================================
%
%           Step Size Rules
%
%========================================

    %-----------------------
    %      Fixed Size
    %-----------------------
    function t = fixedsize(x,gr,k)
        t = 1e-2;
    end

    %-----------------------
    %      Line Search
    %-----------------------
    function t = linesearch(x,gr,k)
        t = 10; beta = 0.7; gx = g(x);
        
        G = gradmap(x,gr,t); 
        while g(x - t * G) > gx - t * (gr' * G) + (t/2) * norm(G)^2
            t = beta*t; G = gradmap(x,gr,t);
        end
    end

end