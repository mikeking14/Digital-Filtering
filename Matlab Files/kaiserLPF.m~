function [kaiser_LPF,n] = kaiserLPF(A,alpha, delta_Pass, delta_Stop, delta_F, Fc, Fs, N)
%% Create the Low Pass Filter
    % Define Characteristics of the window        
        M = filterOrder(A, Fs, delta_F);
        L = M/2;
        Z = 2*L+1;
        n = linspace(0,L,Z)';
        
    % Truncate the ideal LPF, and shift it right by L to make it causal.
        Hd_LPF = ( (2*Fc)/Fs ) * sinc( ((2*Fc)/Fs)*(n-M) );

    % Create the bessel function for the kaiser window calculation
        beta = alpha * sqrt(n.*(2*M-n))/M; % Taking from textbook pg.555 equation 10.2.9
        kaiser_Window = besseli(0,beta)./besseli(0,alpha);

    % Finite Causal IR by multiplying hd_LPF with kaiser_Window.
        kaiser_LPF = Hd_LPF .* kaiser_Window;
     
        
end
