
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% CODED QPSK  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generate bits
Bits =randi([0,1],1,21000);
Coded_Bits=kron(Bits,[1 1 1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%  INTERLEAVER SECTION %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%a zero is added to the encoded data to have 64 symbols at the input of the mapper before the IFFT block
Coded_Bits64=[];
for i=1:63000 
if mod(i,63)==0
Coded_Bits64=[Coded_Bits64 Coded_Bits(i) 0];
else
Coded_Bits64=[Coded_Bits64 Coded_Bits(i)];
end
end
%use reshape function 
Reshaped_Coded_Bits=reshape(Coded_Bits64,8,16,[]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% MAPPER SECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%mapping data to genereate QPSK symbole
QPSK_Coded_Bits = QPSK_Reshaped_Mapper (Reshaped_Coded_Bits);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% 64-point IFFT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%reshape to have OFDM symbol which consists of 32 QPSK symbol

Reshaped_QPSK_Coded_Bits=reshape(QPSK_Coded_Bits,[64,500]);
IFFT_Coded_OutPut=ifft(Reshaped_QPSK_Coded_Bits,64);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% ADD CYCLIC ECTENTION %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%i will take last 6 symboles and add them in the first 

for i=1:size(IFFT_Coded_OutPut,2)%adding cyclic prefix for every OFDM symbol
a=IFFT_Coded_OutPut(59:end,i);
IFFT_Coded_OutPut_After_ACE(:,i)=vertcat(a,IFFT_Coded_OutPut(:,i));
end
c=1;
Axis=1:15;
for range=1:15
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% CHANNEL SECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%QPSK Flat fading time invariant AWGN channel .
Noise_QPSK_coded_Flat =  Flat_Fading_AWGNchannel(IFFT_Coded_OutPut_After_ACE,(1/3),range);%1/3->energy for QPSK UNCODED

%QPSK Frequency selective Fading channel
channel=[0.8 0 0 0 0 0 0 0 0 0 0.6] ;
Noise_QPSK_coded_Freq_selective = Frq_Selective_Fading_Channel(channel,IFFT_Coded_OutPut_After_ACE,(1/3),range);

%%%%%%%%%%%%%%%%%%%%%%%%%RECEIVER%%%%%%%%%%%%%%%%%%%%%%%%

%deconvolution to executing channel equalization

for i = 1:size(Noise_QPSK_coded_Freq_selective,2)%executing channel equalization using deconvolution
Decov_Noise_QPSK_coded_Freq_selective(:,i)=deconv(Noise_QPSK_coded_Freq_selective(:,i),channel);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% FFT SECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%removing the cyclic prefix then FFT to reverse the IFFT block

%QPSK Flat fading time invariant AWGN
FFT_Noise_QPSK_coded_Flat=fft(Noise_QPSK_coded_Flat(7:end,:),64);

%QPSK Frequency selective Fading
FFT_Noise_QPSK_coded_Freq_selective=fft(Decov_Noise_QPSK_coded_Freq_selective(7:end,:),64);

%reshapping the recieved data before demapping

%QPSK Flat fading time invariant AWGN
Received_QPSK_coded_Flat=reshape(FFT_Noise_QPSK_coded_Flat,4,16,500);

%QPSK Frequency selective Fading
Received_QPSK_coded_Freq_selective=reshape(FFT_Noise_QPSK_coded_Freq_selective,4,16,500);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% DEMAPPER SECTION %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%QPSK Flat fading time invariant AWGN
 Demaped_QPSK_coded_Flat= QPSK_Reshaped_Demapper(Received_QPSK_coded_Flat);
 
 %QPSK Frequency selective Fading
  Demaped_QPSK_coded_Freq_selective= QPSK_Reshaped_Demapper(Received_QPSK_coded_Freq_selective);
 
 %reshape demapped bits 
 
 %QPSK Flat fading time invariant AWGN
 Reshaped_Demaped_QPSK_coded_Flat=reshape(Demaped_QPSK_coded_Flat,1,64000);

 %QPSK Frequency selective Fading
 Reshaped_Demaped_QPSK_coded_Freq_selective=reshape(Demaped_QPSK_coded_Freq_selective,1,64000);
 
%removing the added zero that was added to complete the 64 bits
Final_QPSK_coded_Flat=[];
Final_QPSK_coded_Freq_selective=[];
for i = 1:64000
if(mod(i,64)~=0)
Final_QPSK_coded_Flat=[Final_QPSK_coded_Flat Reshaped_Demaped_QPSK_coded_Flat(i)];
Final_QPSK_coded_Freq_selective=[Final_QPSK_coded_Freq_selective Reshaped_Demaped_QPSK_coded_Freq_selective(i)];
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% CALCULATE "BER" SECTION %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%rearenge demaped coded bits 
[Coded_Bits_QPSK_Flat_R] = REARANGE_ARRAY(Bits,Final_QPSK_coded_Flat);
[Coded_Bits_QPSK_Freq_selective_R] = REARANGE_ARRAY(Bits,Final_QPSK_coded_Freq_selective);

%QPSK Flat fading time invariant AWGN
BER_QPSK_coded_Flat(c)=CALCULATE_BER(Bits,Coded_Bits_QPSK_Flat_R,(1/3),range);%energy =1/3 for uncoded QPSK

%QPSK Frequency selective Fading
BER_QPSK_coded_Freq_selective(c)=CALCULATE_BER(Bits,Coded_Bits_QPSK_Freq_selective_R,1/3,range);%energy =1/3 for uncoded QPSK

c=c+1;
end
figure(1)
semilogy(Axis,BER_QPSK_coded_Flat,'b') 
title('QPSK in flat fading channel using coding') 
xlabel('SNR');
ylabel('BER'); 
figure(2)
semilogy(Axis,BER_QPSK_coded_Freq_selective,'r') 
title('QPSK in frequency selective fading channel using coding') 
xlabel('SNR');
ylabel('BER'); 
figure(3)
semilogy(Axis,BER_QPSK_coded_Flat,'b') 
hold on
semilogy(Axis,BER_QPSK_coded_Freq_selective,'r') 
grid on
title(' Coded  Flat  /  Freq  Selctive  QPSK  ') 
xlabel('Eb/No');
ylabel('BER'); 
legend('BER_QPSK_coded_Flat','BER_QPSK_coded_Freq_selective') 




    








