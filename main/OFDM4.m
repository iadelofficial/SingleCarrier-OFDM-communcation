
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% CODED 16QAM  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generate bits
Bits =randi([0,1],1,42000);
Coded_Bits=kron(Bits,[1 1 1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%  INTERLEAVER SECTION %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%a zero is added to the encoded data to have 64 symbols at the input of the mapper before the IFFT block
Coded_Bits64=[];
for i=1:126000
    if mod(i,126)==0
        Coded_Bits64=[Coded_Bits64 Coded_Bits(i) 0 0];
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
QAM_16_Coded_Bits = QAM_16_Reshaped_Mapper (Reshaped_Coded_Bits);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% 64-point IFFT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%reshape to have OFDM symbol which consists of 32  16QAM symbol

Reshaped_QAM_16_Coded_Bits=reshape(QAM_16_Coded_Bits,[32,1000]);
IFFT_Coded_OutPut=ifft(Reshaped_QAM_16_Coded_Bits,32);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% ADD CYCLIC ECTENTION %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



for i=1:size(IFFT_Coded_OutPut,2)%adding cyclic prefix for every OFDM symbol
a=IFFT_Coded_OutPut(25:end,i);
IFFT_Coded_OutP4ut_After_ACE(:,i)=vertcat(a,IFFT_Coded_OutPut(:,i));
end
c=1;
Axis=1:11;
eee=1;
for range=1:11
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% CHANNEL SECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%QPSK Flat fading time invariant AWGN channel .
Noise_16QAM_coded_Flat =  Flat_Fading_AWGNchannel(IFFT_Coded_OutP4ut_After_ACE,(2.5/3),range);%2.5/3->energy for QPSK UNCODED

%QPSK Frequency selective Fading channel
channel=[0.8 0 0 0 0 0 0 0 0 0 0.6] ;
Noise_16QAM_coded_Freq_selective = Frq_Selective_Fading_Channel(channel,IFFT_Coded_OutP4ut_After_ACE,(2.5/3),range);

%%%%%%%%%%%%%%%%%%%%%%%%%RECEIVER%%%%%%%%%%%%%%%%%%%%%%%%

%deconvolution to executing channel equalization

for i = 1:size(Noise_16QAM_coded_Freq_selective,2)%executing channel equalization using deconvolution
Decov_Noise_16QAM_coded_Freq_selective(:,i)=deconv(Noise_16QAM_coded_Freq_selective(:,i),channel);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% FFT SECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%removing the cyclic prefix then FFT to reverse the IFFT block

%QPSK Flat fading time invariant AWGN
FFT_Noise_16QAM_coded_Flat=fft(Noise_16QAM_coded_Flat(9:end,:),32);

%QPSK Frequency selective Fading
FFT_Noise_16QAM_coded_Freq_selective=fft(Decov_Noise_16QAM_coded_Freq_selective(9:end,:),32);

%reshapping the recieved data before demapping

%QPSK Flat fading time invariant AWGN
Received_16QAM_coded_Flat=reshape(FFT_Noise_16QAM_coded_Flat,2,16,1000);

%QPSK Frequency selective Fading
Received_16QAM_coded_Freq_selective=reshape(FFT_Noise_16QAM_coded_Freq_selective,2,16,1000);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% DEMAPPER SECTION %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%QPSK Flat fading time invariant AWGN
 Demaped_16QAM_coded_Flat= QAM_16_Reshaped_Demapper(Received_16QAM_coded_Flat);
 
 %QPSK Frequency selective Fading
  Demaped_16QAM_coded_Freq_selective= QAM_16_Reshaped_Demapper(Received_16QAM_coded_Freq_selective);
 
 %reshape demapped bits 
 
 %QPSK Flat fading time invariant AWGN
 Reshaped_Demaped_16QAM_coded_Flat=reshape(Demaped_16QAM_coded_Flat,1,128000);

 %QPSK Frequency selective Fading
 Reshaped_Demaped_16QAM_coded_Freq_selective=reshape(Demaped_16QAM_coded_Freq_selective,1,128000);
 
%removing the added zero that was added to complete the 64 bits
Final_16QAM_coded_Flat=[];
Final_16QAM_coded_Freq_selective=[];

for i = 1:128000
if(mod(i,127)~=0&&mod(i,128)~=0)
Final_16QAM_coded_Flat=[Final_16QAM_coded_Flat Reshaped_Demaped_16QAM_coded_Flat(i)];
Final_16QAM_coded_Freq_selective=[Final_16QAM_coded_Freq_selective Reshaped_Demaped_16QAM_coded_Freq_selective(i)];
end
end
eee=eee+1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% CALCULATE "BER" SECTION %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%rearenge demaped coded bits 
[Coded_Bits_16QAM_Flat_R] = REARANGE_ARRAY(Bits,Final_16QAM_coded_Flat);
[Coded_Bits_16QAM_Freq_selective_R] = REARANGE_ARRAY(Bits,Final_16QAM_coded_Freq_selective);

%QPSK Flat fading time invariant AWGN
BER_16QAMcoded_Flat(c)=CALCULATE_BER(Bits,Coded_Bits_16QAM_Flat_R,(2.5/3),range);%energy =2.5/3 for uncoded QPSK

%QPSK Frequency selective Fading
BER_16QAM_coded_Freq_selective(c)=CALCULATE_BER(Bits,Coded_Bits_16QAM_Freq_selective_R,2.5/3,range);%energy =2.5/3 for uncoded QPSK

c=c+1;
end
figure(1)
semilogy(Axis,BER_16QAMcoded_Flat,'b') 
title('QPSK in flat fading channel using coding') 
xlabel('SNR');
ylabel('BER'); 
figure(2)
semilogy(Axis,BER_16QAM_coded_Freq_selective,'r') 
title('QPSK in frequency selective fading channel using coding') 
xlabel('SNR');
ylabel('BER'); 
figure(3)
semilogy(Axis,BER_16QAMcoded_Flat,'b') 
hold on
semilogy(Axis,BER_16QAM_coded_Freq_selective,'r') 
grid on
title('16QAM') 
xlabel('Eb/No');
ylabel('BER'); 
legend('BER_QPSK_coded_Flat','BER_QPSK_coded_Freq_selective') 




    








