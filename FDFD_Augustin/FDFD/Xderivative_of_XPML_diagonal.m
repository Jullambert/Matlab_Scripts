function diagonal = Xderivative_of_XPML_diagonal(rho,hx,hz,m,n,W, omega)



%%=========================================================================
% This function computes the PML equations corresponding to the left and   
% right boundaries                                                          
%
%
%
%
%
%%=========================================================================



diagonal=sparse(m*n,3);




%%


diagonal(n+1:(W/2)*n,1)=(-1/2/hx^2)*(1./rho(n+1:(W/2)*n)...
    + 1./rho(2*n+1:(W/2)*n + n)) + (-1/2/hx^2)*(1./rho(n+1:(W/2)*n)...
    + 1./rho(1:(W/2)*n-n));


diagonal(2*n+1:n + (W/2)*n,3)=(1/2/hx^2)*(1./rho(2*n+1:n+(W/2)*n)...
    + 1./rho(n+1:(W/2)*n));

diagonal(1:(W/2)*n -n,2)=(1/2/hx^2)*(1./rho(n+1:(W/2)*n)...
    + 1./rho(1:(W/2)*n - n));



%% OK b


diagonal(end-(W/2)*n +1:end-n,1)=(-1/2/hx^2)*(1./rho(end-(W/2)*n +1 :end-n)...
    + 1./rho(end-(W/2)*n +1 -n :end-2*n)) + (-1/2/hx^2)*(1./rho(end-(W/2)*n +1 :end-n)...
    + 1./rho(end-(W/2)*n +n +1:end));

diagonal(end-(W/2)*n +1 + n :end,3)=(1/2/hx^2)*(1./rho(end-(W/2)*n +1:end-n)...
    + 1./rho(end-(W/2)*n + n  + 1:end));

diagonal(end-(W/2)*n -n +1:end-2*n,2)=(1/2/hx^2)*(1./rho(end-(W/2)*n +1:end-n)...
    + 1./rho(end-(W/2)*n -n +1:end-2*n));

diagonal_positions=[0 -n n];

%% OK b


diagonal(1:n:end,1)=0;diagonal(n:n:end,1)=0;

diagonal(1:n:end-n,2)=0;diagonal(n:n:end-n,2)=0;


diagonal(n+1:n:end,3)=0;diagonal(2*n:n:end,3)=0;







end