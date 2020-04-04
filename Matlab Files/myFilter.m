function clean_audio = myFilter(window_array, audio)
   
    clean_audio_FT = fft(audio,length(audio));

    [r,c] = size(window_array);
    for i =1:c
        clean_audio_FT = clean_audio_FT.*fft(window_array(:,i),length(audio));
    end
    
    clean_audio = ifft(clean_audio_FT);
end
