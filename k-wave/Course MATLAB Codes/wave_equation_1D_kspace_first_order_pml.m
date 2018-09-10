% Script to solve the 1D homogeneous wave equation written as coupled
% first-order equations using a k-space scheme. A perfectly matched layer
% (PML) is implemented to simulate an infinite domain.
%
% author: Bradley Treeby
% date: 10th August 2017
% last update: 10th August 2017

clearvars;

% =========================================================================
% SIMULATION PARAMETERS
% =========================================================================

% define literals (hard coded numbers)
Nx          = 100;             % number of grid points
dx          = 1e-3;            % grid point spacing (m)
c0          = 1500;            % sound speed (m/s)
rho0        = 1000;            % density (kg/m^3)
Nt          = 200;             % number of time steps
CFL         = 0.5;             % Courant–Friedrichs–Lewy number
PML_alpha   = 2;               % PML absorption (nepers/grid point)
PML_size    = 10;              % PML size (grid points)

% set the time step based on the CFL number
dt = CFL * dx / c0;     % size of time step (s)

% =========================================================================
% INITIAL CONDITIONS
% =========================================================================

% set the initial pressure to be a Gaussian
p = exp(-( (1:Nx) - Nx/4).^2 / (2 * (Nx/30)^2));

% set the initial density to be proportional to the pressure
rho = p / c0^2;

% set the initial velocity to be zero
u = 0;

% =========================================================================
% DERIVATIVE VARIABLES
% =========================================================================

% define the set of wavenumbers
kx = (-pi/dx):2*pi/(dx*Nx):(pi/dx - 2*pi/(dx*Nx));

% shift the order of the wavenumbers (the FFT in MATLAB assumes the
% frequency axis starts at DC) 
kx = ifftshift(kx);
 
% compute the k-space operator
k = abs(kx);
kappa = sinc(c0 * k * dt / 2);

% =========================================================================
% PERFECTLY MATCHED LAYER
% =========================================================================

% convert absorption value from Neper/grid point to Nepers/s
PML_alpha = PML_alpha * c0 / dx;

% define the absorption profile within the PML
PML_j = 1:PML_size;
alpha_profile = PML_alpha .* (PML_j ./ PML_size).^4;

% define the absorption profile within the PML on the staggered grid
alpha_profile_sg_left = PML_alpha .* ( (PML_j - 0.5) ./ PML_size).^4;
alpha_profile_sg_right = PML_alpha .* ( (PML_j + 0.5) ./ PML_size).^4;

% add the profile to the absorption variable
alpha = zeros(1, Nx);
alpha(1:PML_size) = flip(alpha_profile);
alpha(end - PML_size + 1:end) = alpha_profile;

alpha_sg = zeros(1, Nx);
alpha_sg(1:PML_size) = flip(alpha_profile_sg_left);
alpha_sg(end - PML_size + 1:end) = alpha_profile_sg_right;

% exponentiation
pml = exp(-alpha * dt / 2);
pml_sg = exp(-alpha_sg * dt / 2);

% =========================================================================
% TIME LOOP
% =========================================================================

% open a new figure window
figure;

% calculate pressure in a loop
for n = 1:Nt
    
    % update u
    u = pml_sg .* ( pml_sg .* u - (dt / rho0) * real(ifft(1i .* kx .* exp(1i .* kx .* dx/2) .* kappa .* fft(p))) );

    % update rho
    rho = pml .* ( pml .* rho - (dt * rho0) * real(ifft(1i .* kx .* exp(-1i .* kx .* dx/2) .* kappa .* fft(u))) );
    
    % update p
    p = c0^2 * rho;
    
    % plot the pressure field
    plot(p);
    hold on;
    plot([PML_size, PML_size], [0, 1], 'k--');
    plot(Nx - [PML_size, PML_size] + 1, [0, 1], 'k--');
    hold off;
    set(gca, 'XLim', [1, Nx], 'YLim', [0, 1]);
    drawnow;
    
end

% =========================================================================
% VISUALISATION
% =========================================================================

% plot the PML
figure;
subplot(2, 1, 1);
plot(alpha, 'k-');
xlabel('Grid Index');
ylabel('\alpha (Np/s)');

subplot(2, 1, 2);
plot(pml, 'k-');
xlabel('Grid Index');
ylabel('exp(-\alpha \Delta t/2)');