%% Matlab Script to Analyze audio from computer and display time domain/frequency domain plots.

%% Initialize Workspace
    clc; clear; close all; clearvars
    
    % Create Audio File
        %Uncomment if you havent recorded any audio yet.
        %audio = audioCapture(10,filename);    
    
    % Read Audio file
        filename = 'tuning_fork1.wav';
        audio = audioread(filename);
        info = audioinfo(filename);

    % Variable Declaration    
        % Variables to change shape of Kaiser Window
        delta_F_H = 0.5;
        delta_F_L = 0.5;
        Fc_H = 500; % Low-pass filter cut off frequency
        Fc_L = 400; % Low-pass filter cut off frequency
        % Calculated deltas from cut off frequency and transition width
        delta_PassH = Fc_H - (1/2 * delta_F_H); 
        delta_StopH = Fc_H + (1/2 * delta_F_H);
        delta_PassL = Fc_L - (1/2 * delta_F_L); 
        delta_StopL = Fc_L + (1/2 * delta_F_L);
        
     % Variable Calculations
        N = info.TotalSamples; % Number of samples
        Fs = info.SampleRate; % Sample Rate
        [alpha1, A1] = calculateAlpha(delta_PassH,delta_StopH); % Calculate Kaiser Window shape parameter. (make sure to calculate)
        [alpha2, A2] = calculateAlpha(delta_PassL,delta_StopL); % Calculate Kaiser Window shape parameter. (make sure to calculate)

    % Data preparation
        % Create x-axis for frequency plots.
        frequency=linspace(-Fs/2,Fs/2,length(audio))'; 
        % Take the DTFT of the audio files, absolute value, and shift for symmetry
        FT = (fftshift(abs(fft(audio))));
        % Convert to decibles
        FT_db = mag2db(FT);
        
    
%% Graphing    
    % Find the max value of the 
    [max_value_FT, max_index_FT] = max(FT);
    fund_freq = abs(frequency(max_index_FT)); % Fundamental Frequency of Tuning Fork
    
    % Audio DTFT Magnitude Spectra plot
    figure
    subplot(2,1,1);
    plot(frequency, FT,'b');
    xlabel('Frequency (Hz)'); ylabel('Y(n)');
    title('Audio DTFT Magnitude Spectra')
    text(fund_freq ,max_value_FT, sprintf('%f Hz', fund_freq))
    subplot(2,1,2);
    plot(frequency, FT_db,'b');
    xlabel('Frequency (Hz)'); ylabel('Amplitude (dB)');
    title('Audio DTFT Magnitude Spectra in Decibels');
    
    % From the above plot, we can see that our frequency is calculated as
    % 415.8509 Hz. This is 0.4491 Hz away from the 415.3 Hz that is stamped
    % on the tuning fork. We can express this as a percentage: 0.4491/415.3
    % = 0.1081% away from the stamped frequency.
    
    
    
 %% Noisy Tuning Fork (BONUS)
  
    %Adding Random Numbers to audio
    noisy_Audio = audio + randn(N, 1);

    % Take the DTFT of the audio files, absolute value, and shift for symmetry
    noisy_FT = (fftshift(abs(fft(noisy_Audio))));
    
    % Find Fundamental Frequency
    [max_Value_Noisy_FT, max_Index_Noisy_FT] = max(noisy_FT);
    fund_Noisy_Freq = abs(frequency(max_Index_Noisy_FT));     
    
    % Create a band pass filter using 2 Kaiser Window low pass filters
    [kaiser_H,n1] = kaiserLPF(A1,alpha1,delta_PassH,delta_StopH, delta_F_H,Fc_H,Fs,N);
    [kaiser_L,n2] = kaiserLPF(A2,alpha2,delta_PassL,delta_StopL,delta_F_L,Fc_L,Fs,N);
    kaiser_H_FT = fftshift(abs(fft(kaiser_H)));
    kaiser_L_FT = fftshift(abs(fft(kaiser_L)));

    % Plot the Kaiser Window 
    f = linspace(-Fs/2,Fs/2,N)';
    figure
    hold on
    plot(f,(kaiser_H_FT))
    plot(f,(kaiser_L_FT))
    title('Kaiser Window Overlap')
   
    % Listen to the filtered tone.
    audiowrite('Noisy_Audio.wav',noisy_Audio,Fs)
    


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

    





