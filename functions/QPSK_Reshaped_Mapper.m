
function [QPSK_Bits] = QPSK_Reshaped_Mapper (Bits)

for k=1:size(Bits,3)
for j=1:size(Bits,2)
for i=1:2:size(Bits,1)
if ([Bits(i,j,k),Bits(i+1,j,k)] == [1, 1] )
    QPSK_Bits((i+1)/2,j,k)=1+1i*1;
elseif ([Bits(i,j,k),Bits(i+1,j,k)] == [0, 1])
    QPSK_Bits((i+1)/2,j,k)=-1+1i*1;
elseif ([Bits(i,j,k),Bits(i+1,j,k)] == [0, 0])
    QPSK_Bits((i+1)/2,j,k)=-1+1i*(-1);
elseif ([Bits(i,j,k),Bits(i+1,j,k)] == [1, 0] )
    QPSK_Bits((i+1)/2,j,k)=1+1i*(-1);
   
end
end
end

end

