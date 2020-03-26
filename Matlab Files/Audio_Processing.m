%% Matlab Script to Analyze audio from computer and display time domain/frequency domain plots.
%% 2.2 Analyse Audio

% Initialize Workspace
    clc; clear all; close all; clearvars

% Read Audio file
    [audio,Fs] = audioread('tuning_fork1.wav');

% Data preparation

    % Create x-axis for frequency plots.
    f=linspace(-Fs/2,Fs/2,length(audio)); 
    
    % Take the DTFT of the audio files, absolute value, and shift for symmetry
    FT = (fftshift(abs(fft(audio))));
    % Convert to decibles
    FT_db = mag2db(FT);
    
    
% Graphing    
    % Find the max value of the 
    [max_value_FT, max_index_FT] = max(FT);
    fundamental_freq = abs(f(max_index_FT));
    
    % Audio DTFT Magnitude Spectra plot
    figure
    subplot(2,1,1);
    plot(f, FT,'b');
    xlabel('Frequency (Hz)'); ylabel('Y(n)');
    title('Audio DTFT Magnitude Spectra')
    text(fundamental_freq ,max_value_FT, sprintf('%f Hz', fundamental_freq))
    subplot(2,1,2);
    plot(f, FT_db,'b');
    xlabel('Frequency (Hz)'); ylabel('Y(n)');
    title('Audio DTFT Magnitude Spectra in Decibels')
    
    % From the above plot, we can see that our frequency is calculated as
    % 415.8509 Hz. This is 0.4491 Hz away from the 415.3 Hz that is stamped
    % on the tuning fork. We can express this as a percentage: 0.4491/415.3
    % = 0.1081% away from the stamped frequency.

    
    
    %% Noisy Tuning Fork (BONUS)
  
    %Adding Random Numbers to audio
    noisy_numbers = randn([length(audio) 1]);
    noisy_scale = max(audio)/max(noisy_numbers);
    noisy_audio = noisy_scale * noisy_numbers + audio; %scale noisy numbers down                            
     
    % Take the DTFT of the audio files, absolute value, and shift for symmetry
    noisy_FT = (fftshift(abs(fft(noisy_audio))));
    % Convert to decibles
    noisy_FT_db = mag2db(noisy_FT);
    
    % Find Fundamental Frequency
    [max_value_noisy_FT, max_index_noisy_FT] = max(noisy_FT);
    fun_noisy_freq = abs(f(max_index_noisy_FT));     

    % Create a bandpass filter
    bpFilt = designfilt('bandpassfir', ...
                        'FilterOrder', 30, ...
                        'CutoffFrequency1', fun_noisy_freq - 100,... 
                        'CutoffFrequency2', fun_noisy_freq + 100,...
                        'SampleRate', Fs);
    
    % Design Filter Tool
    filtered_audio = filter(bpFilt,noisy_audio);
    noisy_Filtered_FT = (fftshift(abs(fft(filtered_audio))));
    figure
    subplot(3,1,1)
    plot(f,noisy_FT)
    title('Noisy FT')
    subplot(3,1,2)
    plot(f, noisy_Filtered_FT);
    title('Noisy Filtered FT')
    
    % Listen to the filtered tone.
    audiowrite('Noisy_Audio.wav',noisy_audio,Fs)
    audiowrite('Filtered_Noisy_Audio.wav',filtered_audio,Fs)
    





% Impulse Response
%    n = [0:1:50];
%    h = (2/5)*sinc((2/5).*n);


    
% Convolution between audio and impulse in time to multiply in frequency
%    ImpulseResponse = conv(audio,h);



% Noisy Audio Plots?
%     figure
%     subplot(2,1,1)
%     plot(f, noisy_FT,'b');
%     xlabel('Frequency (Hz)'); ylabel('Y(n) in Decibels');
%     title('Noisy_Audio Magnitude Spectra')
%     subplot(2,1,2)
%     plot(f, (noisy_FT_db),'b');
%     xlabel('Frequency (Hz)'); ylabel('Y(n)');
%     title('Noisy_Audio Magnitude Spectra in Decibels v')

    





