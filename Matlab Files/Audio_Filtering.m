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
        %% --------> Variables to change shape of Kaiser Window
          
            %High Band
%             Fc_H = 150;
%             del_F_H = 1; % Inversely proportional to Filter Order
%             A_PassH = 500;
%             A_StopH = 600;
%             del_PassH = (10^(A_PassH/20) -1) / (10^(A_PassH/20) +1);
%             del_StopH = 10^(-A_StopH/20);
%             delH = min(del_PassH, del_StopH);
% 
%             %Low Band
%             Fc_L = 100;
%             del_F_L = 10;
%             A_PassL = 700;
%             A_StopL = 500;
%             del_PassL = (10^(A_PassL/20) -1) / (10^(A_PassL/20) +1);
%             del_StopL = 10^(-A_StopL/20);
%             % All Window designs will have equal passband and stopband ripples
%             % therefor we must choose the minimun delta.
%             delL = min(del_PassL, del_StopL);
%             
%             
%             [alphaH, AH] = calculateAlpha(delH); % Calculate Kaiser Window shape parameter.
%             [alphaL, AL] = calculateAlpha(delL); % Calculate Kaiser Window shape parameter.   
            %%
        M = 50; % Filter Order
        alphaH = 7;
        alphaL = 0.5;
        Fc = 15; % Cut-off frequency for LPF
        
     % Variable Calculations
        N = info.TotalSamples; % Number of samples
        Fs = info.SampleRate; % Sample Rate
        
    % Data preparation
        % Create x-axis for frequency plots.
        frequency=linspace(-Fs/2,Fs/2,N)'; 
        % Take the DTFT of the audio files, absolute value, and shift for symmetry
        audio_FT = (fftshift(abs(fft(audio))));
        % Convert to decibles
        FT_db = mag2db(audio_FT);
        
        
%% Graphing Non-Noisy    
    % Find the max value of the 
    [max_value_FT, max_index_FT] = max(audio_FT);
    fund_freq = abs(frequency(max_index_FT)); % Fundamental Frequency of Tuning Fork
  
    %% Audio DTFT Magnitude Spectra plot
%     figure
%     subplot(2,1,1);
%     plot(frequency, FT,'b');
%     xlabel('Frequency (Hz)'); ylabel('Y(n)');
%     title('Audio DTFT Magnitude Spectra')
%     text(fund_freq ,max_value_FT, sprintf('%f Hz', fund_freq))
%     subplot(2,1,2);
%     plot(frequency, FT_db,'b');
%     xlabel('Frequency (Hz)'); ylabel('Amplitude (dB)');
%     title('Audio DTFT Magnitude Spectra in Decibels');
    
    % From the above plot, we can see that our frequency is calculated as
    % 415.8509 Hz. This is 0.4491 Hz away from the 415.3 Hz that is stamped
    % on the tuning fork. We can express this as a percentage: 0.4491/415.3
    % = 0.1081% away from the stamped frequency.
    
 %% Noisy Tuning Fork (BONUS)
  
    %Adding Random Numbers to audio
    noisy_audio = audio + randn(N, 1);

    % Take the DTFT of the audio files, absolute value, and shift for symmetry
    noisy_audio_FT = (fftshift(abs(fft(noisy_audio))));
    
    % Find Fundamental Frequency
    [max_Value_Noisy_FT, max_Index_Noisy_FT] = max(noisy_audio_FT);
    F_max = abs(frequency(max_Index_Noisy_FT));  
    
    % Create a BPF using 2 Kaiser Window low pass filters
    [kaiser_LPF1, n1] = kaiserLPF(alphaH,Fs,Fc,F_max,M,N);
    [kaiser_LPF2, n2] = kaiserLPF(alphaL,Fs,Fc,F_max,M,N);
    
    % Shited Kaiser IR to create a Bandpass filter.
    kaiser_BPF1 = real(kaiser_LPF1.*exp(j*2*pi*(F_max/Fs)*n1));
    kaiser_BPF2 = real(kaiser_LPF2.*exp(j*2*pi*(F_max/Fs)*n2));
    
    % DFT of the Kaiser BPF
    kaiser_BPF1_FT = abs(fftshift(fft(kaiser_BPF1,N)));
    kaiser_BPF2_FT = abs(fftshift(fft(kaiser_BPF2,N)));
    
    % All windows within kaiser_array will be applied to the audio signal
    kaiser_array = [kaiser_BPF1 ,kaiser_BPF2];
    % Pass kaiser array to my filter function
    clean_audio = myFilter(kaiser_array, noisy_audio_FT);
    % DFT of Clean Audio
    clean_audio_FT = abs(fftshift(fft(clean_audio)));
    
   %% Plots     
        % Overlaped Kaiser Windows
        figure
        hold on
        plot(n1, real(kaiser_BPF1),'b')
        plot(n2, real(kaiser_BPF2),'r')
        title('Overlapped Kaiser Windows in Time Domain')
        xlabel('n'); ylabel('h(n)')
        hold off
        
        figure
        hold on 
        plot(frequency, mag2db(kaiser_BPF1_FT), 'b')
        plot(frequency, mag2db(kaiser_BPF2_FT), 'r')
        title('Overlapped Kaiser BPF Windows')
        xlabel('f'); ylabel('H(f) (db)')
        hold off
        
        % Clean Audio
        figure
        hold on
        plot(frequency, audio_FT,'b')
        plot(frequency, clean_audio_FT,'r')
        title('Audio and Filtered/Cleaned Audio')
        xlabel('n'); ylabel('h(n)')
        hold off
    
    %% Listen to the filtered tone.
    
    audiowrite('Noisy_Audio.wav',noisy_audio,Fs)
    audiowrite('Clean_Noisy_Audio.wav',clean_audio,Fs)
    
    

