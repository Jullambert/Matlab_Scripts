% Script to solve the 1D homogeneous wave equation written as coupled
% first-order equations using a k-space scheme. This demonstrates wave
% wrapping due to the periodicity assumed by the FFT.
%
% author: Bradley Treeby
% date: 10th August 2017
% last update: 10th August 2017

clearvars;

% =========================================================================
% SIMULATION PARAMETERS
% =========================================================================

% define literals (hard coded numbers)
Nx   = 100;             % number of grid points
dx   = 1e-3;            % grid point spacing (m)
c0   = 1500;            % sound speed (m/s)
rho0 = 1000;            % density (kg/m^3)
Nt   = 400;              % number of time steps
CFL  = 0.5;             % Courant–Friedrichs–Lewy number

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
% TIME LOOP
% =========================================================================

% open a new figure window
figure;

% calculate pressure in a loop
for n = 1:Nt
    
    % update u
    u = u - (dt / rho0) * real(ifft(1i .* kx .* exp(1i .* kx .* dx/2) .* kappa .* fft(p)));

    % update rho
    rho = rho - (dt * rho0) * real(ifft(1i .* kx .* exp(-1i .* kx .* dx/2) .* kappa .* fft(u)));  
    
    % update p
    p = c0^2 * rho;
    
    % plot the pressure field
    plot(p);
    set(gca, 'XLim', [1, Nx], 'YLim', [0, 1]);
    drawnow;
    
end