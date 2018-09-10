load('bl ep-select ep but 20171221_1010-emg1_TMS_Session1.mat');
time=linspace(-0.05,0.5,512);



figure()
plot(squeeze(data(2,1,:,:,:,find(time>=0.015&time<=0.05))))

size(data)
