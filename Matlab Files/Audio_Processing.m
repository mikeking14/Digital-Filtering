%%Matlab Script to capture audio from computer and display time
%%domain/frequency domain plots.

clc; clear all; close all

%% Data Processing
[audio,Fs] = audioread('tuning_fork_comRoom.wav');

% Impulse Response
n = [0:1:50];
h = (2/5)*sinc((2/5).*n);

% Fourier Tranform
f=linspace(-Fs/2,Fs/2,length(audio)); 

% Take the DFT of the audio file, absolute value, and shift for symmetry
fourierTransform = (fftshift(abs(fft(audio))));

% Convolution between audio and impulse in time to multiply in frequency
ImpulseResponse = conv(audio,h);

%% Graphing Stuff
[max_value_audio,index]= max(audio);
max_value = max(fourierTransform);

subplot(2,1,1)
plot(h)
%plot(ImpulseResponse);
title('H(n) in Time Domain')

subplot(2,1,2)
plot(fftshift(abs(fft(h))))
title('H(n) in Frequency Domain')

%% Regular Audio Plots
subplot(2,1,1)
plot(f, fourierTransform,'b');
text(414.9,85.6125,sprintf('Resonant Frequency: 414.9'))
xlabel('Frequency (Hz)'); ylabel('Y(n)');
%xlim([-800 800]);
title('Frequency Domain Audio Plot')

subplot(2,1,2)
plot(f, audio,'b');
text(414.9,85.6125,sprintf('Resonant Frequency: 414.9'))
xlabel('Time'); ylabel('Amplitude');
title('Time Domain Audio Plot')

%% Noisy Audio Plots
%subplot(2,1,2)
%plot(noisy_audio)
%title('Noisy Audio Time Domain')

%subplot(2,1,2)
%plot(noisy_audio)
%title('Noisy Audio Frequency Domain')





