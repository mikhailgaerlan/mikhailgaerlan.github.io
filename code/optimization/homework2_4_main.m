clear all; format long e; rng('default');

%=================================================
%
%                 Initialization
%
%=================================================
m = 100; n = 500; s = 5;
A = randn(m,n);
xs = zeros(n,1); picks = randperm(n); xs(picks(1:s)) = randn(s,1);
b = A*xs;

g = @(x,tau) (1/2)*norm(A*x-b)^2;
h = @(x,tau) tau*norm(x,1);
f = @(x,tau) g(x,tau)+h(x,tau);
subgrad = @(x,tau) A'*(A*x-b)+tau*sign(x);
grad = @(x,tau) A'*(A*x-b);
prox = @(x,tau) proxtkh(x,tau);

%%
%=================================================
%
%               Subgradient method
%
%=================================================
tol = 1e-6; method = 'diminishing'; x = zeros(n,1);
times = [0]; errors = [norm(x-xs)/norm(xs)];
taus = [10.^(5:-1:-10),10.^(5:-1:-5)];

for tau = taus
    [x,error,time] = subgradientmethod(@(x) f(x,tau),...
        @(x) subgrad(x,tau),x,tol,xs,method,false);
    times = [times,times(end)+time];
    errors = [errors,error];
end; disp('Done.')

%-----------------------
%     Time vs. Error
%-----------------------
figure(1); semilogy(times,errors); ax = gca;
xlabel('time (s)'); ylabel('error');
ax.YAxis.MinorTickValues = [1e-6,1e-4,1e-2];
set(gca,'fontsize',22,'YMinorGrid','on','MinorGridLineStyle','-');
saveas(gcf,'time_error_sub.png')

%-----------------------
%     Compare xs to x
%-----------------------
maxes = max(abs([max(xs),min(xs)])); figure(2);
subplot(3,1,1); plot(xs); ylim([-maxes,maxes]);
ylabel('xs'); set(gca,'fontsize',22);
subplot(3,1,2); plot(x); ylim([-maxes,maxes]);
ylabel('x'); set(gca,'fontsize',22);
subplot(3,1,3); plot(abs(x-xs)); 
ylabel('|x-xs|'); set(gca,'fontsize',22);
saveas(gcf,'compare_sub.png');

%%
%=================================================
%
%            Proximal gradient method
%
%=================================================
tol = 1e-6; method = 'linesearch'; x = zeros(n,1);
times = [0]; errors = [norm(x-xs)/norm(xs)];

taus = [10.^(-5:3),10.^(3:-1:-5)];
for tau = taus
    [x,error,time] = proximalmethod(@(x) g(x,tau),@(x) h(x,tau),...
        @(x) grad(x,tau),@(x,t) prox(x,t*tau),x,tol,xs,method,false);
    times = [times,times(end)+time];
    errors = [errors,error];
end; disp('Done.')

%-----------------------
%     Time vs. Error
%-----------------------
figure(1); semilogy(times,errors); ax = gca;
xlabel('time (s)'); ylabel('error');
ax.YAxis.MinorTickValues = [1e-6,1e-4,1e-2];
set(gca,'fontsize',22,'YMinorGrid','on','MinorGridLineStyle','-');
saveas(gcf,'time_error_prox.png')

%-----------------------
%    Compare xs to x
%-----------------------
maxes = max(abs([max(xs),min(xs)])); figure(2);
subplot(3,1,1); plot(xs); ylim([-maxes,maxes]);
ylabel('xs'); set(gca,'fontsize',22);
subplot(3,1,2); plot(x); ylim([-maxes,maxes]);
ylabel('x'); set(gca,'fontsize',22);
subplot(3,1,3); plot(abs(x-xs)); 
ylabel('|x-xs|'); set(gca,'fontsize',22);
saveas(gcf,'compare_prox.png');