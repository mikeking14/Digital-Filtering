% This function creates a Kaiser Low Pass Filter(LPF). It accepts alpha -
% shape parameter of the window, Fs - sampling frequeny, Fc - LPF cut off
% frequency, F_max - maximum frequeny within the FT signal, M -
% filter order, and N - number of samples in the signal.


function [kaiser_LPF,n] = kaiserLPF(alpha,Fs,Fc,F_max,M,N)

%% Create the Low Pass Filter
    % Define Characteristics of the window        
        L = 2*M;
        Z = L + 1;
        n = linspace(0,L,Z)';           % Create axis for time
        f = linspace(-Fs/2,Fs/2,N)';     % Create axis for frequency

    % Truncate the ideal LPF, and shift it right by L to make it causal.
        LPF = ( (2*Fc)/Fs ) * sinc( ((2*Fc)/Fs)*(n-M) );

    % Create the bessel function for the kaiser window calculation
        beta = alpha * sqrt(n.*(2*M-n))/M; % From textbook pg.555 equation 10.2.9
        kaiser_Window = besseli(0,beta)./besseli(0,alpha); % Create the Kaiser Window

    % Finite Causal IR by multiplying hd_LPF with kaiser_Window.
        kaiser_LPF = LPF .* kaiser_Window;
    
    %% Plot the Kaiser Window
    figure
    subplot(2,1,1)
    plot(n,real(kaiser_Window))
    title('Kaiser Window in Time Dommain')
    xlabel('n'); ylabel('Amplitude)')
    subplot(2,1,2)
    plot(f,mag2db(real(fftshift(fft(kaiser_LPF,N)))))
    title(sprintf('Single Kaiser Windowed LPF: alpha: %f : Fc: %f', alpha, Fc))
    xlabel('n'); ylabel('Amplitude (db)');
    
end
