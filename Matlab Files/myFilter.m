% This filter accepts an array of filters of any size, as well as an audio
% signal. It then applies each filter to the audio signal and returns the
% filtered signal.

function clean_audio = myFilter(window_array, audio)
    % DFT of the clean audio signal
    clean_audio_FT = fft(audio,length(audio));
    
    % number of rows and columns in window array
    [r,c] = size(window_array);
    for i =1:c
        % Apply Window(i) in window array to the clean audio
        clean_audio_FT = clean_audio_FT.*fft(window_array(:,i),length(audio));
    end
    
    % return the IDFT of the clean audio
    clean_audio = ifft(clean_audio_FT);
    
end
