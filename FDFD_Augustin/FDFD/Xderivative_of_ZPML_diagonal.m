function [diagonal,diagonal_positions] = Xderivative_of_ZPML_diagonal(rho,hx,hz,m,n,W)

%%=========================================================================
% This function computes the PML equations corresponding to the top and   
% lower boundaries                                                          
%
%
%
%
%
%%=========================================================================





diagonal_addx=sparse(m*n,3);
diagonal_addmx=sparse(m*n,3);



%%

for l=1:(W/2) % -X/Left PML
    
diagonal_addmx(1+l-1:n:end,1)=(-1/2/hx^2)*(1./rho(1+l-1:n:end)...
    + 1./[rho(n+1+l-1:n:end); 1])+(-1/2/hx^2)*(1./rho(1+l-1:n:end)...
    + 1./[1; rho(1+l-1:n:end-n)]);

diagonal_addmx(n+1+l-1:n:end,3)=(1/2/hx^2)*(1./rho(1+l-1:n:end-n)...
    + 1./rho(n+1+l-1:n:end));  %% +n diagonal


diagonal_addmx(1+l-1:n:end-n,2)=(1/2/hx^2)*(1./rho(n+1+l-1:n:end)...
    + 1./rho(1+l-1:n:end-n)); %% -n diagonal

end

%% OK


for l=1:(W/2) % +X/Right PML
    
diagonal_addx(n- W/2 +1 + (l-1) :n:end,1)=(-1/2/hx^2)*(1./rho(n- W/2 +1 + (l-1) :n:end) ...
    + 1./[1; rho(n- W/2 +1 + (l-1) :n:end-n)])...
    +(-1/2/hx^2)*(1./rho(n- W/2 +1 + (l-1) :n:end)...
    + 1./[rho(n- W/2 +1 + (l-1) + n:n:end); 1]);



diagonal_addx(n + n- W/2 +1 + (l-1) :n: end,3)=(1/2/hz^2)*(1./rho(n - W/2 +1 + (l-1) :n: end-n)...
    + 1./rho(n + n - W/2 +1 + (l-1) :n: end));


diagonal_addx(n- W/2 +1 + (l-1) :n: end-n,2)=(1/2/hz^2)*(1./rho(n- W/2 +1 + (l-1) :n: end-n)...
    + 1./rho(2*n- W/2 +1 + (l-1) :n: end));

end

%% OK


diagonal=diagonal_addmx + diagonal_addx;

Es=vec2mat(diagonal(:,1),n); Es(1:W/2,:)=0; Es(end-W/2+1:end,:)=0; 
Es(:,1)=0; Es(:,end)=0;
Es=Es.'; diagonal(:,1)=Es(:);



Es2=vec2mat([zeros(n,1); diagonal(n+1:end,2)],n); Es2(1:W/2,:)=0; Es2(end-W/2+1:end,:)=0; 
Es2(:,1)=0; Es2(:,end)=0;
Es2=Es2.'; % -n
Es2=Es2(:); diagonal(:,2)=[Es2(n+1:end); zeros(n,1)];

Es3=vec2mat([diagonal(n+1:end,3); zeros(n,1)],n); Es3(1:W/2,:)=0; Es3(end-W/2+1:end,:)=0; 
Es3(:,1)=0; Es3(:,end)=0;
Es3=Es3.'; % + n
Es3=Es3(:); diagonal(:,3)=[zeros(n,1); Es3(1:end-n)];

diagonal_positions=[0 -n n];

end