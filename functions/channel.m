function [Noise_sig,RR] = channel(Bits,Energy,range)

      
    N0=Energy/(10.^(range/10));
    AWGN=randn(1,length(Bits)).*sqrt(N0/2)+1i*randn(1,length(Bits)).*sqrt(N0/2);
    v1=randn(1,length(Bits));
    v2=1i*randn(1,length(Bits));
    RR=sqrt(0.5)*(v1+v2); %insted of RR=sqrt((v1)^2+(v2)^2)*(sqrt(2)) 
    Noise_sig=RR.*Bits+AWGN;

end

