
y = square(2*pi*300000*t,66);%+randn(size(t))/10;


t = 0:1/10e6:0.00066;
y = 200*sin(2*pi*300000*t);
figure
plot(y)

t=[0:1/10e6:0.00066,zeros(3400,1)'];
y=200*sin(2*pi*300000*t);
Y=repmat(y,1,1000);
figure
plot(y)
figure
plot(Y)
Vrms=rms(Y);
AveragePower = Vrms^2/sqrt(745^2+158^2)