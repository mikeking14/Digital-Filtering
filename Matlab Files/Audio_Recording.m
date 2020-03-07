%%Matlab Script to capture audio from computer and display time
%%domain/frequency domain plots.

clc; close all; clear all

%% Data Processing
Fs = 44100 ; 
f = Fs*(0:(L/2))/L;
L = 5;

% Impulse Response
n = [0:1:50]
h = (2/5)*sinc((2/5).*n)

% Fourier Stuff
f=linspace(-Fs/2,Fs/2,length(y)); 
fourierTransform = fft((y));
fourier_Transform = (fftshift(abs(fourierTransform)));
fourier_Transform_DB = mag2db(fourier_Transform);

ImpulseResponse = conv(y,h);

%% Graphs and stuff
figure
plot(y)
plot(h)
plot(ImpulseResponse);
title('Time Domain Audio Plot')

figure
plot(fftshift(abs(fft(h))))
title('H(n) in Frequency Domain')

figure
hold on
plot(f,fourier_Transform_DB,'r')
plot(f, fourier_Transform,'b');
title('Frequency Domain Audio Plot')
legend('Db','Regular')
