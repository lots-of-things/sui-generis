% Will McFadden (wmcfadden)
% working on a problem from (van Kampen)
% Basic premise:  an individual has a distribution of some number of
% children, each of his children has the same distribution, what is the
% distribution for the whole family size after n generations.  

lam = 1;
stoT = 0;
stoP = exp(-lam);
cnt = 0;
for n = 1:6
    cnt = cnt+1
    m = zeros(1,n);
    while(m(1)<6)
        stoT = [stoT n+sum(m)];
        stoP = [stoP exp(-lam*(1+n))*prod(lam.^m)/prod(factorial(m))*lam^n/factorial(n)];
        ind = length(m);
        m(ind) = m(ind)+1
        while(ind>1&&m(ind)==6)
            m(ind-1)=m(ind-1)+1;
            m(ind)=0;
%             m(ind:end)=m(ind-1);
            ind = ind-1;
        end
    end
end

allT = min(stoT):max(stoT);
allP = zeros(size(allT));

for(i=1:length(allT))
    allP(i) = sum(stoP(stoT==allT(i)));
end

cntT = [];
for i = 1:30000
   i
   n = poissrnd(lam); 
   T = n;
   for j = 1:n
       m = poissrnd(lam);
       T = T + m;
   end
   cntT = [cntT T];
end

cnt2 = [];
for j = min(cntT):max(cntT)
    cnt2 = [cnt2 sum(cntT==j)];
end

f_T = 1:max(allT);
f_P = exp(-lam);
g_P = exp(-lam);
for T=f_T
    n = 1:T;
    f_P = [f_P exp(-lam)*lam^T*sum((exp(-lam).^n)./factorial(n)./factorial(T-n).^n)];
    g_P = [g_P exp(-lam)*lam^T*(exp(exp(-lam)/factorial(T-1))-1)];
end

figure;
plot(allT,f_P,'o');
hold on
plot(allT(4:end),g_P(4:end),'k.');
plot(min(cntT):max(cntT),cnt2/sum(cnt2),'g')
plot(allT,allP,'r.');


% lam = 2;
% for n = 1:6
%     stoT = [stoT n];
%     stoP = [stoP exp(-lam)/factorial(n)*lam^n];
% end