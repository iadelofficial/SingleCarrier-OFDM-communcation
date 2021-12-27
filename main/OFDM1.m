clear classes
close all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% UNCODED QPSK  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generate bits
Bits =randi([0,1],1,64000);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%  INTERLEAVER SECTION %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%use reshape function 
Reshaped_Bits=reshape(Bits,8,16,[]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% MAPPER SECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%mapping data to genereate QPSK symbole
QPSK_Bits = QPSK_Reshaped_Mapper (Reshaped_Bits);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% 64-point IFFT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%reshape to have OFDM symbol which consists of 32 QPSK symbol

Reshaped_QPSK_Bits=reshape(QPSK_Bits,[64,500]);
IFFT_OutPut=ifft(Reshaped_QPSK_Bits,64);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% ADD CYCLIC ECTENTION %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%i will take last 6 symboles and add them in the first 

for i=1:size(IFFT_OutPut,2)%adding cyclic prefix for every OFDM symbol
a=IFFT_OutPut(59:end,i);
IFFT_OutPut_After_ACE(:,i)=vertcat(a,IFFT_OutPut(:,i));
end
c=1;
Axis=0:15;
for range=0:15
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% CHANNEL SECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%QPSK Flat fading time invariant AWGN channel .
Noise_QPSK_Uncoded_Flat =  Flat_Fading_AWGNchannel(IFFT_OutPut_After_ACE,1,range);%1->energy for QPSK UNCODED

%QPSK Frequency selective Fading channel
channel=[0.8 0 0 0 0 0 0 0 0 0 0.6] ;
Noise_QPSK_Uncoded_Freq_selective = Frq_Selective_Fading_Channel(channel,IFFT_OutPut_After_ACE,1,range);

%%%%%%%%%%%%%%%%%%%%%%%%%RECEIVER%%%%%%%%%%%%%%%%%%%%%%%%

%deconvolution to executing channel equalization

for i = 1:size(Noise_QPSK_Uncoded_Freq_selective,2)%executing channel equalization using deconvolution
Decov_Noise_QPSK_Uncoded_Freq_selective(:,i)=deconv(Noise_QPSK_Uncoded_Freq_selective(:,i),channel);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% FFT SECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%removing the cyclic prefix then FFT to reverse the IFFT block

%QPSK Flat fading time invariant AWGN
FFT_Noise_QPSK_Uncoded_Flat=fft(Noise_QPSK_Uncoded_Flat(7:end,:),64);

%QPSK Frequency selective Fading
FFT_Noise_QPSK_Uncoded_Freq_selective=fft(Decov_Noise_QPSK_Uncoded_Freq_selective(7:end,:),64);

%reshapping the recieved data before demapping

%QPSK Flat fading time invariant AWGN
Received_QPSK_Uncoded_Flat=reshape(FFT_Noise_QPSK_Uncoded_Flat,4,16,500);

%QPSK Frequency selective Fading
Received_QPSK_Uncoded_Freq_selective=reshape(FFT_Noise_QPSK_Uncoded_Freq_selective,4,16,500);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% DEMAPPER SECTION %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%QPSK Flat fading time invariant AWGN
 Demaped_QPSK_Uncoded_Flat= QPSK_Reshaped_Demapper(Received_QPSK_Uncoded_Flat);
 
 %QPSK Frequency selective Fading
  Demaped_QPSK_Uncoded_Freq_selective= QPSK_Reshaped_Demapper(Received_QPSK_Uncoded_Freq_selective);
 
 %reshape demapped bits 
 
 %QPSK Flat fading time invariant AWGN
 Reshaped_Demaped_QPSK_Uncoded_Flat=reshape(Demaped_QPSK_Uncoded_Flat,1,64000);

 %QPSK Frequency selective Fading
 Reshaped_Demaped_QPSK_Uncoded_Freq_selective=reshape(Demaped_QPSK_Uncoded_Freq_selective,1,64000);
 
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% CALCULATE "BER" SECTION %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%QPSK Flat fading time invariant AWGN
BER_QPSK_Uncoded_Flat(c)=CALCULATE_BER(Bits,Reshaped_Demaped_QPSK_Uncoded_Flat,1,range);%energy =1 for uncoded QPSK

%QPSK Frequency selective Fading
BER_QPSK_Uncoded_Freq_selective(c)=CALCULATE_BER(Bits,Reshaped_Demaped_QPSK_Uncoded_Freq_selective,1,range);%energy =1 for uncoded QPSK

c=c+1;
end
figure(1)
semilogy(Axis,BER_QPSK_Uncoded_Flat,'b') 
title('QPSK in flat fading channel using no coding') 
xlabel('SNR');
ylabel('BER'); 
figure(2)
semilogy(Axis,BER_QPSK_Uncoded_Freq_selective,'r') 
title('QPSK inin frequency selective fading channel using no coding') 
xlabel('SNR');
ylabel('BER'); 



    








