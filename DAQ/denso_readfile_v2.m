% denso_readfile  Read command file for Denso robot.
%
% Dependency: you need BenTools installed to get this m-file running.
%
% See denso_example_file.tsv to see the file format.

% *August 2014/ Julien : add the sinusoidal displacement (relative = 3)
% along the y axis according to the Amp value (peak to peak) and the
% spatial frequence [1/mm] of a tsv files.

if(~exist('debug_mode','var'))
  disp('debug mode on')
  debug_mode=1;
end

%% Input from LabVIEW
% To run this m-file in MATLAB ouside of the LabVIEW program,
% to replace the input from LabVIEW, execute manually the following :
if debug_mode % Not to be executed in LabIEW. Only for testing in MATLAB.
  %     file = 'D:\MATLAB\DensoRobot\denso_test.tsv';
  clear all; %close all;
  figure
  file = 'C:\Users\jullambert\Dropbox\UCL_SMP\robot_program\Julien\TestSinusoidalMovement.tsv'; %(Adapt the path for your installation.)
  Xinit=0;
  Yinit=0;
  Zinit=15;
  Rzinit=0;
  Xref=0;
  Yref=0;
  Zref=0;
  Rzref=0;
  
  Trial=1;
  
end

%% Parameters
Fs= 1000; %  sample frequency
Aglob=100000; % maximal acceleration mm/s² or deg/s²
Dirs={'X','Y','Z','Rz'};

%% Read file
[N,T,ColNames] = stdtextread(file);  %(stdtextread is a function from BenTools" toolbox)
lines=N(:,1)==Trial;% select the trial
N=N(lines,:);
Sm = []; % Sm: Structure containing per-Movement data
for j = 1 : length(ColNames);
  ColNames{j}(ColNames{j}=='"') = []; % Suppress annoying quote chars added by OpenOffice.Calc, if any.
  Sm.(ColNames{j}) = N(:,j);
end

% for relative movements
if(isfield(Sm,'Relative'))
  for iMov = 1 : length(Sm.X)
    if(Sm.Relative(iMov)==1 || Sm.Relative(iMov)==3 )
      Sm.X(iMov)=Xref+Sm.X(iMov);
      Sm.Y(iMov)=Yref+Sm.Y(iMov);
      Sm.Z(iMov)=Zref+Sm.Z(iMov);
      Sm.Rz(iMov)=Rzref+Sm.Rz(iMov);
      disp(Sm.Relative(iMov))
    end
  end
end

% if you want to control Acc for each movement
if(~isfield(Sm,'Acc'))
  for iMov = 1 : length(Sm.X)
    Sm.Acc(iMov)=Aglob;
  end
end



%% One row per Movement (Sm) -> One row per Cycle (Sc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Sc = []; % Sc: Structure containing per-Cycle data
for j = 1 : length(ColNames)
  Sc.(ColNames{j}) = zeros(1,sum(Sm.NrOfCycles));
end

for iMov = 1 : length(Sm.X)
  % i0, i1: first and last indexes of cycles during movement #iMov
  i1 = sum(Sm.NrOfCycles(1:iMov));
  i0 = i1 - Sm.NrOfCycles(iMov) + 1;
  
  % Values staying constant during movement
  Sc.TrialNo(i0:i1) = Sm.TrialNo(iMov);
  Sc.MovNo(i0:i1) = Sm.MovNo(iMov);
  if Sm.Fx_control(iMov) < 2, Sc.Fx(i0:i1) = Sm.Fx(iMov); end % F*_control: 0: no force control, 1: constant, 2: ramp
  if Sm.Fy_control(iMov) < 2, Sc.Fy(i0:i1) = Sm.Fy(iMov); end
  if Sm.Fz_control(iMov) < 2, Sc.Fz(i0:i1) = Sm.Fz(iMov); end
  Sc.Fx_control(i0:i1) = Sm.Fx_control(iMov);
  Sc.Fy_control(i0:i1) = Sm.Fy_control(iMov);
  Sc.Fz_control(i0:i1) = Sm.Fz_control(iMov);
  if isfield(Sm,'Relative'), Sc.Relative(i0:i1) = Sm.Relative(iMov);
  else Sc.Relative(i0:i1) = 0; end
  
  % Values changing linearly (except during pauses)
  % -Position:
  
  if iMov == 1
    % Initial position
    init.X = Xinit;
    init.Y = Yinit;
    init.Z = Zinit;
    init.Rz= Rzinit;
  else
    init.X = Sm.X(iMov-1);
    init.Y = Sm.Y(iMov-1);
    init.Z = Sm.Z(iMov-1);
    init.Rz = Sm.Rz(iMov-1);
  end
  
  % for type 2 relative movements
  if(Sm.Relative(iMov) == 2)
    init.X = 0;
    init.Y = 0;
    init.Z = 0;
    init.Rz = 0;
  end
  
  if Sm.MovNo(iMov) ~= 0
    T=Sm.NrOfCycles(iMov);
    A=Sm.Acc(iMov);
    
    for ii=1:length(Dirs)
      D=Sm.(Dirs{ii})(iMov)-init.(Dirs{ii}); % displacement to make
      t=(A*T/Fs-sqrt(A^2*(T/Fs)^2-4*A*abs(D)))/(2*A)*Fs; % acc/decceleration duration
      acc=zeros(1,ceil(T));
      % acceleration is not set exactly to A to compensate for over
      % or undershoot
      if(t~=0)
        acc(1:ceil(t))=A*sign(D)*t/ceil(t);
        acc(end-floor(t):end)=-A*sign(D)*t/ceil(t);
      end
      Sc.(Dirs{ii})(i0:i1) = init.(Dirs{ii}) + cumsum(cumsum(acc))/Fs/Fs;
    end
  else % Pause
    for ii=1:length(Dirs)
      Sc.(Dirs{ii})(i0:i1)  = Sm.(Dirs{ii})(iMov);
    end
  end
  
  % for type 3 relative movements [= sinusoidal displacement]
   if(Sm.Relative(iMov)== 3)
       if iMov == 1
                Sc.Y(i0:i1) = linspace (init.Y,Sm.Y(iMov),Sm.NrOfCycles(iMov)) ; %  + Yref : sinon pas de mvt % à la reference
                Time = linspace (0,Sm.NrOfCycles(iMov),Sm.NrOfCycles(iMov));
                Velocity = abs((Sm.Y(iMov) - init.Y)/(Sm.NrOfCycles(iMov)/1000));
       else
                Sc.Y(i0:i1) = linspace (Sm.Y(iMov-1),Sm.Y(iMov),Sm.NrOfCycles(iMov)) ;
                Time = linspace (Sm.NrOfCycles(iMov-1),Sm.NrOfCycles(iMov),Sm.NrOfCycles(iMov));
                Velocity = abs((Sm.Y(iMov) - Sm.Y(iMov-1))/(Sm.NrOfCycles(iMov)/1000));    
       end
       
    Sc.Z(i0:i1) = ((Sm.Amp(iMov)/2 .* sin(((2*pi*Sm.Spat_Freq(iMov))*Velocity).*Time/1000)))+ Sm.Amp(iMov)/2 + Zref;
    
  end 
  
  
  
  % -Force control:
  if Sm.Fx_control(iMov) == 2 % F*_control: 0: no force control, 1: constant, 2: ramp
    if iMov == 1, f0 = 0;
    else          f0 = Sm.Fx(iMov-1);
    end
    tmp = linspace(f0, Sm.Fx(iMov), Sm.NrOfCycles(iMov)+1);
    Sc.Fx(i0:i1) = tmp(2:end);
  end
  if Sm.Fy_control(iMov) == 2 % F*_control: 0: no force control, 1: constant, 2: ramp
    if iMov == 1, f0 = 0;
    else          f0 = Sm.Fy(iMov-1);
    end
    tmp = linspace(f0, Sm.Fy(iMov), Sm.NrOfCycles(iMov)+1);
    Sc.Fy(i0:i1) = tmp(2:end);
  end
  if Sm.Fz_control(iMov) == 2 % F*_control: 0: no force control, 1: constant, 2: ramp
    if iMov == 1, f0 = 0;
    else          f0 = Sm.Fz(iMov-1);
    end
    tmp = linspace(f0, Sm.Fz(iMov), Sm.NrOfCycles(iMov)+1);
    Sc.Fz(i0:i1) = tmp(2:end);
  end
  
  % Trigger Camera
  Sc.TrigCam(i0:i1) = Sm.TrigCam(iMov);
  
  %     %Temperatures of stimulation
  %     if(isfield(Sm,'Temp_box0'))
  %         Sc.Temp_box0(i0:i1) = Sm.Temp_box0(iMov);
  %         Sc.Temp_box1(i0:i1) = Sm.Temp_box1(iMov);
  %         Sc.Temp_box2(i0:i1) = Sm.Temp_box2(iMov);
  %     else
  %         Sc.Temp_box0(i0:i1) = zeros(size(Sc.TrigCam(i0:i1)));
  %         Sc.Temp_box1(i0:i1) = zeros(size(Sc.TrigCam(i0:i1)));
  %
  %     end
  
  %Flags of stimulation
  if(isfield(Sm,'Flags'))
    Sc.Flags(i0:i1) = Sm.Flags(iMov);
  else
    Sc.Flags(i0:i1) = zeros(size(Sc.TrigCam(i0:i1)));
  end
  Sc.MvtNo(i0:i1) = ones(size(Sc.TrigCam(i0:i1)))*iMov;
  
  % # cycles
  Sc.NrOfCycles(:) = 1; %<TODO: cas of pauses (MovNo=0): in one row>
end

% %% Structure -> Matrix (Output for LabVIEW)
% RobotInput = zeros(length(Sc.X),length(ColNames));
% for j = 1 : length(ColNames)
%     RobotInput(:,j) = Sc.(ColNames{j});
% end

%% Variable separated for LabView
X = Sc.X;
Y = Sc.Y;
Z = Sc.Z;
Rz= Sc.Rz;
Fx = Sc.Fx;
Fy = Sc.Fy;
Fz = Sc.Fz;
Fx_control = Sc.Fx_control;
Fy_control = Sc.Fy_control;
Fz_control = Sc.Fz_control;
TrigCam = Sc.TrigCam;
% Temp_box0 = Sc.Temp_box0;
% Temp_box1 = Sc.Temp_box1;
% Temp_box2 = Sc.Temp_box2;
Relative = Sc.Relative;
Flags=Sc.Flags;
MvtNo=Sc.MvtNo;
disp('ok');


%% Debug: Plot
if(~exist('debug_mode','var'))
  disp('debug mode on')
  debug_mode=1;
end
if debug_mode % Not to be executed in LabVIEW environement. Evaluate manually in MATLAB for debug purpuse.
  a(1)=subplot(4,1,[1 2]);
  pos=[X' Y' Z' Rz'];
  plot(1:length(pos),pos);
  legend X Y Z Rz;
  
  a(2)=subplot(4,1,3);
  vit=diff(pos)*1000;
  plot(1:length(vit),vit);
  legend X Y Z Rz;

  a(4)=subplot(4,1,4);
  acc=diff(vit)*1000;
  plot(1:length(acc),acc);
  legend X Y Z Rz;

%   a(4)=subplot(4,1,4);
%   plot(1:length(X),Flags,'k');
end
linkaxes(a([1 2 4]),'x')
