% Noise filter accepts the the discrete fourier transform (DFT) of a
% signal and two filters. These filters are applied to the DFT, and the
% inverse DFT is returned.
function cleanRec = noiseFilter(signal, filter1, filter2)
    %% 4.0: Application of Filters to Signal
    cleanRec = fft(signal,length(signal)).*fft(filter1,length(signal));
    cleanRec = cleanRec.*fft(filter2,length(signal));
    cleanRec = ifft(cleanRec);
end