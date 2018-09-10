function [diagonal,diagonal_position] = Zderivative_of_XPML_diagonal(rho,hx,hz,m,n,W)


%%=========================================================================
% This function computes the PML equations corresponding to the left and   
% right boundaries                                                          
%
%
%
%
%
%%=========================================================================


diagonal_addz=sparse(m*n,3);
diagonal_addmz=sparse(m*n,3);



diagonal_addmz(1:(W/2)*n,1)=(-1/2/hz^2)*(1./rho(2:(W/2)*n +1) + 1./rho(1:(W/2)*n))...
    +(-1/2/hz^2)*(1./rho(1:(W/2)*n) + 1./[1; rho(1:(W/2)*n - 1)]);

diagonal_addmz(2:(W/2)*n+1,2)=(1/2/hz^2)*(1./rho(2: (W/2)*n + 1) + 1./rho(1:(W/2)*n));
diagonal_addmz(1:(W/2)*n -1,3)=(1/2/hz^2)*(1./rho(2: (W/2)*n) + 1./rho(1: (W/2)*n -1));


%% OK

diagonal_addz(n*m - (W/2)*n +1 :end,1)=(-1/2/hz^2)*(1./[rho(n*m - (W/2)*n +2 :end); 1] ...
    + 1./rho(n*m - (W/2)*n +1 :end))+...
    (-1/2/hz^2)*(1./rho(n*m - (W/2)*n +1 :end) + 1./rho(n*m - (W/2)*n : end-1));

diagonal_addz(n*m - (W/2)*n +2 :end,2)=(1/2/hz^2)*(1./rho(n*m - (W/2)*n +2 :end)...
    + 1./rho(n*m - (W/2)*n +1 :end-1));
diagonal_addz(n*m - (W/2)*n :end-1,3)=(1/2/hz^2)*(1./rho(n*m - (W/2)*n +1 :end) + 1./rho(n*m - (W/2)*n :end-1));

%% OK


diagonal = diagonal_addz + diagonal_addmz;

Es=vec2mat(diagonal(:,1),n); Es(:,1:W/2)=0; Es(:,end-W/2+1:end)=0; 
Es(1,:)=0; Es(end,:)=0;
Es=Es.'; diagonal(:,1)=Es(:);


Es2=vec2mat([diagonal(2:end,2); 0],n); Es2(:,1:W/2)=0; Es2(:,end-W/2+1:end)=0; 
Es2(1,:)=0; Es2(end,:)=0;

Es2=Es2.';
Es2=Es2(:); size(Es2) 
diagonal(:,2)=[0; Es2(1:end-1)];
Es3=vec2mat([0; diagonal(1:end-1,3)],n); Es3(:,1:W/2)=0; Es3(:,end-W/2+1:end)=0; 
Es3(1,:)=0; Es3(end,:)=0;
Es3=Es3.';
Es3=Es3(:); diagonal(:,3)=[Es3(2:end); 0];

diagonal_position=[0 1 -1];





end