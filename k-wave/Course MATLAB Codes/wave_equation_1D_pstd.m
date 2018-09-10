% Script to solve the 1D homogeneous wave equation using a pseudospectral
% time domain scheme where the spatial derivatives are calculated using a
% Fourier collocation spectral method, and time integration is performed
% using a second-order accurate finite-difference scheme.
%
% author: Bradley Treeby
% date: 8th August 2017
% last update: 5th September 2017

clearvars;

% =========================================================================
% SIMULATION PARAMETERS
% =========================================================================

% define literals (hard coded numbers)
Nx  = 100;              % number of grid points
dx  = 1e-3;             % grid point spacing (m)
c0  = 1500;             % sound speed (m/s)
Nt  = 50;               % number of time steps
CFL = 0.5;              % Courant–Friedrichs–Lewy number

% set the time step based on the CFL number
dt = CFL * dx / c0;     % size of time step (s)
 
% =========================================================================
% INITIAL CONDITIONS
% =========================================================================

% set the initial pressure to be a Gaussian
p_n = exp(-( (1:Nx) - Nx/2).^2 / (2 * (Nx/30)^2));
 
% set pressure at time step (n - 1) to be equal to (n)
p_nm1 = p_n;
 
% set pressure at time step (n + 1) to be zero
p_np1 = zeros(size(p_n));

% =========================================================================
% DERIVATIVE VARIABLES
% =========================================================================

% define the set of wavenumbers
kx = (-pi/dx):2*pi/(dx*Nx):(pi/dx - 2*pi/(dx*Nx));

% shift the order of the wavenumbers (the FFT in MATLAB assumes the
% frequency axis starts at DC) 
kx = ifftshift(kx);
 
% =========================================================================
% TIME LOOP
% =========================================================================

% open a new figure window
figure;

% calculate pressure in a loop
for n = 1:Nt
    
    % calculate the new value for the pressure at time step (n + 1)
    p_np1 = 2*p_n - p_nm1 + dt^2 * c0.^2 * real(ifft( -kx.^2 .* fft(p_n)));
            
    % copy the value for the pressure at time step (n) to (n - 1)
    p_nm1 = p_n;

    % copy the value for the pressure at time step (n + 1) to (n)
    p_n = p_np1;
    
    % plot the pressure field
    plot(p_np1);
    set(gca, 'XLim', [1, Nx], 'YLim', [0, 1]);
    drawnow;
    pause(0.05);
    
end