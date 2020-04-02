function M = filterOrder(A,Fs,delta_F)

if A>21
    D = (A-7.95)/14.36;
elseif A <= 21
    D = 0.922;

M = (D*Fs)/ delta_F;

end
