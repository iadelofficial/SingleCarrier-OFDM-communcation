function [Noise_sig] =  Flat_Fading_AWGNchannel(Bits,Energy,range)
N0=Energy/(10.^(range/10));
AWGN=randn(size(Bits,1),size(Bits,2)).*sqrt(N0/2)+1i*randn(size(Bits,1),size(Bits,2)).*sqrt(N0/2);
Noise_sig=Bits+AWGN;

end

