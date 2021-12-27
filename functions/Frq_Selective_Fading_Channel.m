function [Noise_sig] = Frq_Selective_Fading_Channel(channel,Bits,Energy,range)
N0=Energy/(10.^(range/10));
AWGN=randn(size(Bits,1),size(Bits,2)).*sqrt(N0/2)+1i*randn(size(Bits,1),size(Bits,2)).*sqrt(N0/2);
%convolving the OFDM symbols with the channel and adding AWGN noise
for i = 1:size(Bits,2)
Noise_sig(:,i)=conv(Bits(:,i)+AWGN(:,i),channel);
end
end

