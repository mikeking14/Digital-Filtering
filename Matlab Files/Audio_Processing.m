%%Matlab Script to capture audio from computer and display time
%%domain/frequency domain plots.

clc; close all; clear all

%% Data Processing
Fs = 44100 ; 
% ----------------- V Do we need this? v-----------------
L = 5;
f = Fs*(0:(L/2))/L;
% ----------------- ^ Do we need this? ^ -----------------

[y,Fs] = audioread('tuning_fork.wav');

% Impulse Response
n = [0:1:50];
h = (2/5)*sinc((2/5).*n);

% Fourier Stuff
f=linspace(-Fs/2,Fs/2,length(y)); 
fourierTransform = fft((y));
fourier_Transform = (fftshift(abs(fourierTransform)));

% Convolution between audio and impulse in time to multiply in frequency
ImpulseResponse = conv(y,h);

%% Graphing Stuff
[max_value,index]= max(fourierTransform);

figure
plot(h)
%plot(ImpulseResponse);
title('Time Domain Audio Plot')

figure
plot(fftshift(abs(fft(h))))
title('H(n) in Frequency Domain')

figure
hold on
plot(f, fourier_Transform,'b');
text(max_value,index,'Resonant Frequency');
xlabel('Frequency (Hz)'); ylabel('Y(n)');
xlim([-800 800]);
title('Frequency Domain Audio Plot')

