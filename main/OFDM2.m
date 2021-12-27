clear classes
close all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% UNCODED 16QAM %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generate bits
Bits =randi([0,1],1,128000);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%  INTERLEAVER SECTION %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%use reshape function 
Reshaped_Bits=reshape(Bits,8,16,[]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% MAPPER SECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%mapping data to genereate 16QAM symbole
QAM_16_Bits = QAM_16_Reshaped_Mapper(Reshaped_Bits);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% 64-point IFFT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%reshape to have OFDM symbol which consists of 32 QPSK symbol

Reshaped_16QAM_Bits=reshape(QAM_16_Bits,[64,500]);
IFFT_OutPut=ifft(Reshaped_16QAM_Bits,64);

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
Noise_16QAM_Uncoded_Flat =  Flat_Fading_AWGNchannel(IFFT_OutPut_After_ACE,2.5,range);%1->energy for 16 QAM UNCODED

%QPSK Frequency selective Fading channel
channel=[0.8 0 0 0 0 0 0 0 0 0 0.6] ;
Noise_16QAM_Uncoded_Freq_selective = Frq_Selective_Fading_Channel(channel,IFFT_OutPut_After_ACE,2.5,range);

%%%%%%%%%%%%%%%%%%%%%%%%%RECEIVER%%%%%%%%%%%%%%%%%%%%%%%%

%deconvolution to executing channel equalization

for i = 1:size(Noise_16QAM_Uncoded_Freq_selective,2)%executing channel equalization using deconvolution
Decov_Noise_16QAM_Uncoded_Freq_selective(:,i)=deconv(Noise_16QAM_Uncoded_Freq_selective(:,i),channel);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% FFT SECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%removing the cyclic prefix then FFT to reverse the IFFT block

%QPSK Flat fading time invariant AWGN
FFT_Noise_16QAM_Uncoded_Flat=fft(Noise_16QAM_Uncoded_Flat(7:end,:),64);

%QPSK Frequency selective Fading
FFT_Noise_16QAM_Uncoded_Freq_selective=fft(Decov_Noise_16QAM_Uncoded_Freq_selective(7:end,:),64);

%reshapping the recieved data before demapping

%QPSK Flat fading time invariant AWGN
Received_16QAM_Uncoded_Flat=reshape(FFT_Noise_16QAM_Uncoded_Flat,4,16,500);

%QPSK Frequency selective Fading
Received_16QAM_Uncoded_Freq_selective=reshape(FFT_Noise_16QAM_Uncoded_Freq_selective,4,16,500);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% DEMAPPER SECTION %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%QPSK Flat fading time invariant AWGN
 Demaped_16QAM_Uncoded_Flat= QAM_16_Reshaped_Demapper(Received_16QAM_Uncoded_Flat);
 
 %QPSK Frequency selective Fading
  Demaped_16QAM_Uncoded_Freq_selective= QAM_16_Reshaped_Demapper(Received_16QAM_Uncoded_Freq_selective);
 
 %reshape demapped bits 
 
 %QPSK Flat fading time invariant AWGN
 Reshaped_Demaped_16QAM_Uncoded_Flat=reshape(Demaped_16QAM_Uncoded_Flat,1,128000);

 %QPSK Frequency selective Fading
 Reshaped_Demaped_16QAM_Uncoded_Freq_selective=reshape(Demaped_16QAM_Uncoded_Freq_selective,1,128000);
 
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% CALCULATE "BER" SECTION %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%QPSK Flat fading time invariant AWGN
BER_16QAM_Uncoded_Flat(c)=CALCULATE_BER(Bits,Reshaped_Demaped_16QAM_Uncoded_Flat,1,range);%energy =1 for uncoded QPSK

%QPSK Frequency selective Fading
BER_16QAM_Uncoded_Freq_selective(c)=CALCULATE_BER(Bits,Reshaped_Demaped_16QAM_Uncoded_Freq_selective,1,range);%energy =1 for uncoded QPSK

c=c+1;
end
figure(1)
semilogy(Axis,BER_16QAM_Uncoded_Flat,'b') 
title('16QAM in flat fading channel using no coding') 
xlabel('SNR');
ylabel('BER'); 
figure(2)
semilogy(Axis,BER_16QAM_Uncoded_Freq_selective,'r') 
title('16QAM inin frequency selective fading channel using no coding') 
xlabel('SNR');
ylabel('BER'); 



    








