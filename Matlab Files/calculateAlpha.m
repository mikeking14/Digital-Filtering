% Script to calculate and return the value of alpha (shape parameter) for a
% Kaiser Window
 function [alpha,A] = calculateAlpha(delta)

    % 1. Delta Already Minimum
    % 2. Find A in decibles
    A = -20*log10(delta);
    
    % 3. Calculate alpha
    if A>50
        alpha = 0.1102*(A-8.7);
    elseif (21 < A)&& (A < 50)
        alpha = 0.5842*( (A-21)^0.4) + 0.07886*(A-21);
    else
        alpha = 0;        
    end

    
 end
