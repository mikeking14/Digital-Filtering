%%Matlab Script to capture audio from computer and display time
%%domain/frequency domain plots.

clc; clear all; close all; clearvars

%% Data Processing
[audio,Fs] = audioread('tuning_fork1.wav');

%Adding Random Numbers to audio
rand_Numbers = randn([length(audio) 1]);
rand_scale = max(audio)/max(rand_Numbers)
rand_Audio = rand_scale * rand_Numbers + audio; %scale random numbers down


% Impulse Response
n = [0:1:50];
h = (2/5)*sinc((2/5).*n);

% Fourier Tranform
f=linspace(-Fs/2,Fs/2,length(audio)); 

% Take the DFT of the audio files, absolute value, and shift for symmetry
FT = (fftshift(abs(fft(audio))));
rand_FT = (fftshift(abs(fft(rand_Audio))));

% Convolution between audio and impulse in time to multiply in frequency
ImpulseResponse = conv(audio,h);

%% Graphing Stuff
[max_value_audio,index]= max(audio);
max_value = max(FT);

subplot(2,1,1)
plot(h)
%plot(ImpulseResponse);
title('H(n) in Time Domain')

subplot(2,1,2)
plot(fftshift(abs(fft(h))))
title('H(n) in Frequency Domain')

%% Regular Audio Plots
figure
%subplot(4,1,1)
plot(f, FT,'b');
xlabel('Frequency (Hz)'); ylabel('Y(n)');
title('Audio Magnitude Spectra')

figure
subplot(2,1,1)
plot(f, 20*log10(rand_FT),'b');
xlabel('Frequency (Hz)'); ylabel('Y(n) in Decibels');
title('Random_Audio Magnitude Spectra in Decibels')
subplot(2,1,2)
plot(f, (rand_FT),'b');
xlabel('Frequency (Hz)'); ylabel('Y(n)');
title('Random_Audio Magnitude Spectra')

figure
%subplot(4,2,2)
plot(f, audio,'b');
xlabel('Time'); ylabel('Amplitude');
title('Time Domain Audio Plot')






