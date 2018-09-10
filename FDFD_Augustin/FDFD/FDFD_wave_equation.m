function [innerLaplacian_diag, PML_Lapl_diag, PML_Lapl_diagPos] = FDFD_wave_equation(m,n,h,c,ft,W,rho)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 
%
% (m,n)  : Size of the grid (in #grid points)
% h      : Step size
% c      : mean sound speed
% ft     : frequency (possibly vector)
% W      : 2*width of the PML (in # grid points) so that N+W = theretical side
% of domain
% 
%
% We use the FDFD frame and PML of [Hustedt,Operto,Virieux, 2004]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hx=h;
hz=h;
fmax=max(ft);
%Laplacian_X13 = sparse((m*n)*length(ft),m*n); 
Laplacian_X13 = sparse((m*n),m*n,length(ft)); 
Diagonal_X23  = sparse((m*n)*length(ft),m*n); 
innerLaplacian_diag = zeros(m*n*length(ft),5);

% Here the domain is taken column wise


% Checking the CFL condition
%==========================================================================
%if hx>(c/fmax)/12 || hz>(c/fmax)/12

 %   return
  
%end



                            % mean velocity
                            % Density (assumed to be constant)
rho = ones(m,n)*rho;                            
rho = rho(:);               %Rho devient un vecteur colonne
Specific_volume = 1./rho;   % Specific volume --> vecteur  colonne

%for iter_num=1:length(prob_size)

   




% o-------> X (n)
% |  
% |
% |
% v
% Z (m)

% Z is the initial wave direction of propagation

diagonal_positions=[0 1 -1 -n n];
 
diagonals=zeros(m*n,length(diagonal_positions));

size(diagonals)


%% Inside(-domain) equations (we leave left and right PML to 0)

for k=(W/2)*n +1:1:m*n - (W/2)*n
    
    
diagonals(k,1)=-(1/(2*(hz^2))) * (1/rho(k+1) + 1/rho(k) )...
    -(1/(2*(hz^2))) * (1/rho(k) + 1/rho(k-1))...
    -(1/(2*(hx^2))) * (1/rho(k+n) + 1/rho(k))...
    -(1/(2*(hx^2))) * (1/rho(k) + 1/rho(k-n));
    

diagonals(k+1,2)=(1/(2*(hz^2)))*(1/rho(k+1) + 1/rho(k)); 
    
diagonals(k-1,3)=(1/(2*(hz^2)))*(1/rho(k) + 1/rho(k-1));    

diagonals(k-n,4)=(1/(2*(hx^2)))*(1/rho(k) + 1/rho(k-n));

diagonals(k+n,5)=(1/(2*(hx^2)))*(1/rho(k) + 1/rho(k+n));

end
% 
% 
%% Proceeding the boundary and preparing for the PML




for l=1:W/2
        
% Setting Upper and lower PML values to 0    
diagonals(l:n:end,1)=0;
diagonals(n-l+1:n:end,1)=0;




diagonals(l+1:n:end,2)=0; % +1 diagonal
diagonals(n-l+2:n:end,2)=0;



if (l<W/2)
diagonals(l:n:end,3)=0;% -1 diagonal
end

diagonals(n-l:n:end,3)=0;

diagonals(1+l-1:n:end,4)=0;% -n diagonal
diagonals(n-l+1:n:end,4)=0;

% 
% 
diagonals(n+1+(l-1):n:end,5)=0;% +n diagonal
diagonals(2*n-l+1:n:end,5)=0;
% 
% See if needed



end


% Setting outer border to zero (not sure its necessary)

Specific_volume(1:n)=0;
Specific_volume(end- n +1:end)=0;

Specific_volume(1:n:end)=0;
Specific_volume(n:n:end)=0;




diagonals(1:n:end,1)=0;
diagonals(n:n:end,1)=0;

diagonals(2:n:end,2)=0;
diagonals(n+1:n:end,2)=0;

diagonals(n:n:end,3)=0;
diagonals(n-1:n:end,3)=0;

diagonals(1:n:end,4)=0;
diagonals(n:n:end,4)=0;

diagonals(n+1:n:end,5)=0;
diagonals(2*n:n:end,5)=0;


innerLaplacian_diag = spdiags(diagonals, diagonal_positions, sparse(m*n,m*n));
%repmat(diagonals; 
% A is the matrix giving the discrete Laplacian (i.e X_13 term)


% 
% disp('hello')


%% Creating the add-on diagonal for +/- z-PML and x-PML

[diagonal_Z_PML pos1] = Xderivative_of_ZPML_diagonal(rho,hx,hz,m,n,W);

%%

[diagonal_X_PML pos2] = Zderivative_of_XPML_diagonal(rho,hx,hz,m,n,W);

% 
% 
% %diagonal_X_PML=sparse(m*n,3);
% %diagonal_Z_PML=sparse(m*n,3);
% 
% 

%diagonals(:,1)=diagonal_Z_PML(:,1)+diagonal_X_PML(:,1)+diagonals(:,1);
%diagonals(:,2)=diagonal_Z_PML(:,2)+diagonals(:,2);
%diagonals(:,3)=diagonal_Z_PML(:,3)+diagonals(:,3);
%diagonals(:,4)=diagonal_X_PML(:,2)+diagonals(:,4);
%diagonals(:,5)=diagonal_X_PML(:,3)+diagonals(:,5);


diagonals(:,1)=diagonal_Z_PML(:,1)+diagonal_X_PML(:,1);
diagonals(:,2)=diagonal_X_PML(:,2);
diagonals(:,3)=diagonal_X_PML(:,3);
diagonals(:,4)=diagonal_Z_PML(:,2);
diagonals(:,5)=diagonal_Z_PML(:,3);


% %===========================
% %          o--->X
% %          |
% %          | 
% %          v
% %          Z
% %===========================
% 
% 
% 
% 
% %% ========================================================================
% %%=========================================================================
% %%




rho_pml_Z2=sparse(m,n);
rho_pml_X2=sparse(m,n);


rho_pml_Z1=ones(m,n);
rho_pml_X1=ones(m,n);


rho_pml_Z1(1:(W/2),:) = 0; %* (1+ 1i/omega);
rho_pml_Z1(end-(W/2) +1:end, :) = 0;


rho_pml_X1(:,1:W/2)= 0; 
rho_pml_X1(:,end-W/2+1:end)=0;


% rho_pml_X1=rho_pml_X1.';
% rho_pml_Z1=rho_pml_Z1.';

rho_pml_X1=rho_pml_X1(:);
rho_pml_Z1=rho_pml_Z1(:);


rho_pml_X1=rho_pml_X1.*rho;
rho_pml_Z1=rho_pml_Z1.*rho;


% %%
% % Prepared vectors to win time in the frequency loop
% 
% 
% 
rho_pml_Z2(1:(W/2),:) = 1; %* (1+ 1i/omega);
rho_pml_Z2(end-(W/2) +1:end, :) = 1;


rho_pml_X2(:,1:W/2)= 1; 
rho_pml_X2(:,end-W/2+1:end)=1;


% Coefficients for X PML

coeffX=zeros(m,n);
x=0:1:W/2-1;
xend=W/2-1:-1:0;
coeffX(:,1:W/2)=repmat(1-cos((pi/2)*(W/2-x)/(W/2)),m,1);
coeffX(:,end-W/2 +1:end)=repmat(1-cos((pi/2)*(W/2-xend)/(W/2)),m,1);


rho_pml_X2=rho_pml_X2.*coeffX;

coeffZ=zeros(m,n);
z=(0:1:W/2-1).';
zend=(W/2-1:-1:0).';
coeffZ(1:W/2,:)=repmat(1-cos((pi/2)*(W/2-z)/(W/2)),1,n);
coeffZ(end-W/2 +1:end,:)=repmat(1-cos((pi/2)*(W/2-zend)/(W/2)),1,n);

rho_pml_Z2=rho_pml_Z2.*coeffZ;




% rho_pml_X2=rho_pml_X2.';
% rho_pml_Z2=rho_pml_Z2.';

rho_pml_X2=rho_pml_X2(:);
rho_pml_Z2=rho_pml_Z2(:);


special_add_onX=zeros(m,n);
special_add_onZ=zeros(m,n);

special_add_onZ(1:(W/2),:)=1;
special_add_onZ(end-(W/2) +1:end, :) = 1;


special_add_onX(:,1:W/2)= 1; 
special_add_onX(:,end-W/2+1:end)=1;

% special_add_onX = special_add_onX.';
% special_add_onZ = special_add_onZ.';

special_add_onX = special_add_onX(:);
special_add_onZ = special_add_onZ(:);



%% 


annule1=1:n:m*n;
annule2=n:n:m*n;



diagonals_iter=zeros(size(diagonals));

cons=1; %% = Coefficient de la PML à adapter


%ft2=ft;

%ft=ft-1e6;


% Diagonals Matrix for all frequencies and for PML

diagonalsMatrix = zeros(m*n*length(ft),length(diagonal_positions));



for l=2:length(ft)+1
f=[0 ft];

 
omega = 2*pi*f(l);


diag_pml_Z = Zderivative_of_ZPML_diagonal((ones(size(rho_pml_Z2)) + rho_pml_Z2*(1i*cons/omega)).*rho,hx,hz,m,n,W, omega); % [0 -n n]

v_spec= ones(size(rho_pml_Z2))+ rho_pml_Z2*(1i*cons/omega);



diag_pml_Z(:,1)=diag_pml_Z(:,1).*(1./v_spec);

diag_pml_Z(2:end,2)=diag_pml_Z(2:end,2).*(1./v_spec(1:end-1));
diag_pml_Z(1:end-1,3)=diag_pml_Z(1:end-1,3).*(1./v_spec(2:end));






diag_pml_X = Xderivative_of_XPML_diagonal((ones(size(rho_pml_X2)) + rho_pml_X2*(1i*cons/omega)).*rho,hx,hz,m,n,W, omega); % [0 1 -1]

v_spec= ones(size(rho_pml_X2))+ rho_pml_X2*(1i*cons/omega);


% figure
% imagesc(abs(vec2mat(rho_pml_X1,n)));
% axis square
% figure
% 
% 
% figure
% imagesc(abs(vec2mat(rho_pml_X2*(1i*mean(c)*1e4/omega),n)))
% axis square
% figure
% 
% figure
% imagesc(abs(vec2mat(special_add_onX,n)))
% figure
% 

diag_pml_X(:,1)=diag_pml_X(:,1).*(1./v_spec);

diag_pml_X(1:end-n,2)=diag_pml_X(1:end-n,2).*(1./v_spec(n+1:end));
diag_pml_X(n+1:end,3)=diag_pml_X(n+1:end,3).*(1./v_spec(1:end-n));




% diagonal_positions=[0 1 -1 -n n];

diagonals_iter(:,1)=diagonals(:,1)+diag_pml_Z(:,1)+diag_pml_X(:,1);

diagonals_iter(:,2:3)=diagonals(:,2:3)+diag_pml_Z(:,2:3);

diagonals_iter(:,4:5)=diagonals(:,4:5)+diag_pml_X(:,2:3);

%% OK


% Setting the border to 0

diagonals_iter(annule1,1)=1;
diagonals_iter(annule2,1)=1;
diagonals_iter(1:n,1)=1;
diagonals_iter(end-n+1:end,1)=1;




%%========================================================================

diagonalsMatrix((l-2)*(m*n)+1:(l-1)*(m*n),:) = diagonals_iter;


end

PML_Lapl_diagPos = diagonal_positions; % colonnes matrices = position valeur de la diagonale du Laplacien

PML_Lapl_diag = diagonalsMatrix; % 


%end



end
