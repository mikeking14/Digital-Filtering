%% This matlab script will capture 

    %% Initialize Workspace
        clc; clear; close all; clearvars
            filename = 'Audio Files/testing1m.wav';

        % Create Audio File
            % Uncomment if you havent recorded any audio yet.
            ID = -1; % Set the device (-1 is default audio device)
             audioCapture(10,filename,ID);    

        % Read Audio file
            audio = audioread(filename);
            info = audioinfo(filename);  

        % Variable Declaration
            M = 2000; % Filter Order
            alphaH = 7; % Alpha shape parameter of Kaiser window
            alphaL = 0.5; % Alpha shape parameter of Kaiser window
            Fc = 100; % Cut-off frequency for LPF

         % Variable Calculations
            N = info.TotalSamples; % Number of samples
            Fs = info.SampleRate; % Sample Rate
  
    %% Non-Noisy    

        % Data preparation
            % Create x-axis for frequency plots.
                frequency=linspace(-Fs/2,Fs/2,N)'; 
            % Take the DTFT of the audio files, absolute value, and shift for symmetry
                audio_FT = (fftshift(abs(fft(audio))));
            % Convert to decibles
                FT_db = mag2db(audio_FT);    

        % Find the max value of the 
            [max_value_FT, max_index_FT] = max(audio_FT);
            fund_freq = abs(frequency(max_index_FT)); % Fundamental Frequency of Tuning Fork

        % Audio DTFT Magnitude Spectra plot
            figure
            subplot(2,1,1);
            plot(frequency, audio_FT,'b');
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
                noisy_audio = audio + randn(N,1) * max(audio);

            % Take the DTFT of the audio files, absolute value, and shift for symmetry
                noisy_audio_FT = (fftshift(abs(fft(noisy_audio))));

            % Find Fundamental Frequency 
                [max_value_noisy_FT, max_index_noisy_FT] = max(noisy_audio_FT);
                F_max = abs(frequency(max_index_noisy_FT)); % Fundamental Frequency of Tuning Fork

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
                kaiser_array = [kaiser_BPF1,kaiser_BPF2];
            % Pass kaiser array to my filter function
                filtered_audio = myFilter(kaiser_array, noisy_audio);
            % DFT of Clean Audio
                filtered_audio_FT = fftshift(abs(fft(filtered_audio)));
    
                
    %% Final plots    
        % Overlaped Kaiser Windowed BPF's
            % Time Domain
                figure
                hold on
                plot(n1, real(kaiser_BPF1),'b')
                plot(n2, real(kaiser_BPF2),'r')
                title('Overlapped Kaiser Windows in Time Domain')
                xlabel('n'); ylabel('h(n)'), legend
                hold off
            % Frequency Domain
                figure
                hold on 
                plot(frequency, mag2db(kaiser_BPF1_FT), 'b')
                plot(frequency, mag2db(kaiser_BPF2_FT), 'r')
                title('Overlapped Kaiser BPF Windows')
                xlabel('f'); ylabel('H(f) (db)'), legend
                hold off

        % Audio vs Filtered Audio
                figure
                hold on
                plot(frequency, mag2db(audio_FT),'b')
                plot(frequency, mag2db(filtered_audio_FT),'r')
                title('Audio and Filtered/Cleaned Audio')
                xlabel('n'); ylabel('H(f) (db)'), legend('Audio', 'Filtered Audio')
                hold off
    
                
    %% Audio Out files.
        
        disp('Playing: Audio')
        soundsc(audio, Fs);
        pause(11);
   
        audiowrite('Audio Files/Noisy_Audio.wav',noisy_audio,Fs)
        disp('Playing: noisy_audio')
        soundsc(noisy_audio, Fs);
        pause(11);
       
        audiowrite('Audio Files/Filtered_Audio.wav',filtered_audio,Fs)
        disp('Playing: filtered_audio)')
        soundsc(filtered_audio, Fs);

    

