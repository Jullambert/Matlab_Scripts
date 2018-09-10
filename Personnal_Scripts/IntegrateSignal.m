%% CASE 2

%% INPUTS

% Integrate the discrete function y from x=3 to 6 
% with y vs x data given as (1,2), (2,7), (4,16), (6.5,18)
% Defining the x-array
x=[1  2  4  6.5];
% Defining the y-array
y=[2  7  16  18];
% Lower limit of integration, a
a=3;
% Upper limit of integration, b
b=6;
%% DISPLAYING INPUTS

disp('CASE#2')
disp('LOWER LIMIT AND UPPER LIMITS OF INTEGRATION DO not MATCH x(1) AND x(LAST)')
disp('  ')
disp('INPUTS')
disp('The x-data is')
x
disp('The y-data is')
y
fprintf('  Lower limit of integration, a= %g',a)
fprintf('\n  Upper limit of integration, b= %g',b)
% Choose how many divisions you want for splining from a to b
n=1000;
fprintf('\n  Number of subdivisions used for splining = %g',n)
disp('  ')
disp('  ')

%% THE CODE

xx=a:(b-a)/n:b;
% Using spline to approximate the curve from x(1) to x(last)
yy=spline(x,y,xx);
intvalue=trapz(xx,yy);

%% DISPLAYING OUTPUTS

disp('OUTPUTS')
fprintf('  Value of integral is = %g',intvalue)
disp('  ')
disp('___________________________________________')