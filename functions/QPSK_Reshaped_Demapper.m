function [Demapped_sig] = QPSK_Reshaped_Demapper(Bits)

for i=1:size(Bits,3)
for j=1:size(Bits,2)
for k=1:size(Bits,1)
if (angle(Bits(k,j,i)) >= (-pi/2) && angle(Bits(k,j,i)) < 0)
Demapped_sig(2*k,j,i) = 0 ;
Demapped_sig((2*k)-1,j,i) = 1 ;
elseif (angle(Bits(k,j,i)) >= 0 && angle(Bits(k,j,i)) < (pi/2))
Demapped_sig(2*k,j,i) = 1 ;
Demapped_sig((2*k)-1,j,i) = 1 ;
elseif (angle(Bits(k,j,i)) >= (pi/2) && angle(Bits(k,j,i)) < (pi))
Demapped_sig(2*k,j,i) = 1 ;
Demapped_sig((2*k)-1,j,i) = 0 ;
elseif (angle(Bits(k,j,i)) >= -(pi) && angle(Bits(k,j,i)) < -(pi/2))
Demapped_sig(2*k,j,i) = 0 ;
Demapped_sig((2*k)-1,j,i) = 0 ;
end
end
end
end



    
end

