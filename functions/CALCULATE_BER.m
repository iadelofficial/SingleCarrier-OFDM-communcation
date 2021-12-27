function [ProbQPSK_Error] = CALCULATE_BER(Orginal_Bits,Demaped,Energy,range)
No=Energy/(10.^(range/10));
Pe=0.5*erfc(sqrt(1/No));
[NoQPSK_Error,ProbQPSK_Error]=biterr(Demaped,Orginal_Bits);

end

