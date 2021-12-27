
close all
% Generate bits
Bits =randi([0,1],1,120000);
Coded_Bits=kron(Bits,[1 1 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%MAPPER SECTION OF QPSK %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%UNCODED%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Loop_End=length(Bits);
Bits_QPSK = QPSK_Mapper (Bits,Loop_End);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CODED%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Coded_Loop_End=length(Coded_Bits);
Coded_Bits_QPSK = QPSK_Mapper (Coded_Bits,Coded_Loop_End);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%MAPPER SECTION OF 16_QAM %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%UNCODED%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Bits_16QAM= QAM_16_TX (Bits,Loop_End);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CODED%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Coded_Bits_16QAM= QAM_16_TX (Coded_Bits,Coded_Loop_End);

%%%%%%%%%%%%%%%%%%%%%%%% FINISH MAPPER STAGE %%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% CHANNEL SECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     if x =='Uncoded_QPSK'
%         Energy = 1;
%     elseif x=='coded_QPSK'
%         Energy= 1/3 ;
%     elseif x=='Uncoded_16QAM'
%         Energy=2.5;
%     elseif x=='coded_16QAM'
%         Energy=2.5/3;   
%     end
c=1;
Axis =-20:20;
for range=-20:20
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%UNCODED%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [Nois_QPSK,RR1] = channel(Bits_QPSK,1,range);
    [Nois_16QAM,RR2] = channel(Bits_16QAM,2.5,range);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CODED%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    [Nois_Coded_QPSK,RR3] = channel(Coded_Bits_QPSK,(1/3),range);
    [Nois_Coded_16QAM,RR4] = channel(Coded_Bits_16QAM,(2.5/3),range);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% DEMAPPER SECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%UNCODED%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Nois_QPSK=Nois_QPSK./RR1;
    [Demaped_QPSK] = QPSK_Demapper (Nois_QPSK);
    Nois_16QAM=Nois_16QAM./RR2;
    [Demaped_16QAM] = QAM_16_RX (Nois_16QAM);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CODED%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Nois_Coded_QPSK=Nois_Coded_QPSK./RR3;
    [Demaped_Coded_QPSK] = QPSK_Demapper (Nois_Coded_QPSK);
    Nois_Coded_16QAM=Nois_Coded_16QAM./RR4;
    [Demaped_Coded_16QAM] = QAM_16_RX (Nois_Coded_16QAM);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% CALCULATE "BER" SECTION %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%rearenge demaped coded bits 
[Coded_Bits_QPSK_R] = REARANGE_ARRAY(Bits,Demaped_Coded_QPSK);
[Coded_Bits_16QAM_R] = REARANGE_ARRAY(Bits,Demaped_Coded_16QAM);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%UNCODED%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    BER_QPSK(c)=CALCULATE_BER(Bits,Demaped_QPSK,1,range);%energy =1 for uncoded QPSK
    BER_16QAM(c)=CALCULATE_BER(Bits,Demaped_16QAM,2.5,range);%energy =2.5 for uncoded 16QAM
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CODED%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    BER_Coded_QPSK(c)=CALCULATE_BER(Bits,Coded_Bits_QPSK_R,(1/3),range);%energy =1/3 for coded QPSK
    BER_Coded_16QAM(c)=CALCULATE_BER(Bits,Coded_Bits_16QAM_R,(2.5/3),range);%energy =2.5/3 for coded 16QAM
    c=c+1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT SECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
semilogy(Axis,BER_QPSK,'r') 
grid on
legend('Simulated BER')
xlabel('Eb/No');
ylabel('BER');
title('QPSK_uncoded') 
hold off
figure(2)
semilogy(Axis,BER_16QAM,'b') 
grid on
title('16QAM_uncoded') 
xlabel('Eb/No');
ylabel('BER'); 
legend('Simulated BER')


figure(3)
semilogy(Axis,BER_Coded_QPSK,'r') 
grid on
legend('Simulated BER')
xlabel('Eb/No');
ylabel('BER');
title('QPSK_coded') 
hold off
figure(4)
semilogy(Axis,BER_Coded_16QAM,'b') 
grid on
title('16QAM_coded') 
xlabel('Eb/No');
ylabel('BER'); 
legend('Simulated BER')
figure(5)
semilogy(Axis,BER_Coded_16QAM,'b') 
hold on
semilogy(Axis,BER_16QAM,'r') 
grid on
title('16QAM') 
xlabel('Eb/No');
ylabel('BER'); 
legend('Simulated BER coded','Simulated BER') 
figure(6)
semilogy(Axis,BER_Coded_QPSK,'b') 
hold on
semilogy(Axis,BER_QPSK,'r') 
grid on
title('QPSK') 
xlabel('Eb/No');
ylabel('BER'); 
legend('Simulated BER coded','Simulated BER') 


