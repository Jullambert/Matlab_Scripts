function diagonal = Zderivative_of_ZPML_diagonal(rho,hx,hz,m,n,W, omega)


%%=========================================================================
% This function computes the PML equations corresponding to the top and   
% lower boundaries                                                          
%
%
%
%
%
%%=========================================================================




diagonal=sparse(m*n,3);



for l=2:W/2
    
    
diagonal(1+l-1:n:end,1)=(-1/2/hz^2)*(1./rho(1+l-1:n:end)...
    + 1./rho(1+l-2:n:end))...
    +(-1/2/hz^2)*(1./rho(1+l-1:n:end)...
    + 1./rho(1+l:n:end));


diagonal(1+l:n:end,2)=(1/2/hz^2)*(1./rho(1+l-1:n:end)...
    + 1./rho(l+1:n:end));


diagonal(1+l-2:n:end,3)=(1/2/hz^2)*(1./rho(1+l-1:n:end)...
    + 1./rho(1+l-2:n:end));


end


for l=1:W/2 - 1
    
    
diagonal(n-W/2+ l:n:end,1)=(-1/2/hz^2)*(1./rho(n-W/2+l:n:end)...
    + 1./rho(n-W/2+l+1:n:end))...
    +(-1/2/hz^2)*(1./rho(n-W/2+l:n:end)...
    + 1./rho(n-W/2+l-1:n:end));


diagonal(n-W/2+l+1:n:end,2)=(1/2/hz^2)*(1./rho(n-W/2+l+1:n:end)...
    + 1./rho(n-W/2+l:n:end));



diagonal(n-W/2+l-1:n:end,3)=(1/2/hz^2)*(1./rho(n-W/2+l-1:n:end)...
    + 1./rho(n-W/2+l:n:end));
end




diagonal(1:n,1)=0;diagonal(end-n+1:end,1)=0;


%diagonal(:,1)=diagonal(:,1).*(1./rho);

diagonal(2:n+1,2)=0;diagonal(end-n+2:end,2)=0;

%diagonal(2:end,2)=diagonal(2:end,2).*(1./rho(1:end-1));

diagonal(1:n-1,3)=0;diagonal(end-n:end-1,3)=0;

%diagonal(1:end-1,3)=diagonal(1:end-1,2).*(1./rho(2:end));


diagonal_positions=[0 1 -1];




%% OK

% diagonal(n*m - (W/2)*n +1 :end,1)=(-1/2/hx^2)*(1./[rho(n*m - W*n +2 :end) 1] + 1./rho(n*m - W*n +1 :end))+...
%     (-1/2/hx^2)*(1./rho(n*m - W*n +1 :end) + 1./rho(n*m - W*n : end));
% diagonal_addz(n*m - W*n +2 :end,2)=(1/2/hx^2)*(1./rho(n*m - W*n +2 :end) + 1./rho(n*m - W*n +1 :end-1));
% diagonal_addz(n*m - W*n :end-1,3)=(1/2/hx^2)*(1./rho(n*m - W*n +1 :end) + 1./rho(n*m - W*n :end-1));

%% OK


% A = spdiags(diagonal_addz,[0 1 -1],sparse(m*n));
% A(:,1:W/2)=0;
% A(:,n-W/2+1:end)=0;
% [diagonal_addz, d]  = spdiags(A);
% 
% A = spdiags(diagonal_addmz,[0 1 -1],sparse(m*n));
% A(:,1:W/2)=0;
% A(:,n-W/2+1:end)=0;
% [diagonal_addmz, d]  = spdiags(A);




end