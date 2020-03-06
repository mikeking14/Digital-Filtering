%%Matlab Script to capture audio from computer and display time
%%domain/frequency domain plots.

clc
close all
clear all
%%
Fs = 44100 ; 
L = 5;
nBits = 16 ; 
f = Fs*(0:(L/2))/L;
nChannels = 1 ; 

% Audio Device setup
info = audiodevinfo;
deviceReader = audioDeviceReader; % read the devices
devices = getAudioDevices(deviceReader) % put the audio devices in an object called devices

ID = 5; % -1 is default audio input device
recObj = audiorecorder(Fs,nBits,nChannels,ID);
disp('Start speaking.')
pause(1);
recordblocking(recObj,5);
disp('End of Recording.');
play(recObj);
y = getaudiodata(recObj);
%%

filename = 'test.wav';
audiowrite(filename,y,Fs);

%%
% Impulse Response
n = [0:1:50]
h = (2/5)*sinc((2/5).*n)

% Fourier Stuff
f=linspace(-Fs/2,Fs/2,length(y)) 
fourierTransform = fft((y));
fourier_Transform = (fftshift(abs(fourierTransform)));
fourier_Transform_DB = mag2db(fourier_Transform);

ImpulseResponse = conv(y,h);
% Graphs and stuff
figure
hold on
plot(y)
plot(h)
plot(ImpulseResponse);
title('Time Domain Audio Plot')
hold off

figure
plot(fftshift(abs(fft(h))))
title('H(n) in Frequency Domain')

figure
hold on
plot(f,fourier_Transform_DB)
plot(f, fourier_Transform);
title('Frequency Domain Audio Plot')
