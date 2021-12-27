function [Demapped_sig] = QAM_16_Reshaped_Demapper(Bits)
for k=1:size(Bits,3)
for j=1:size(Bits,2)
for i=1:size(Bits,1)
if (imag(Bits(i,j,k)) >0) %above y axis
if (real(Bits(i,j,k)) > 0) % 1st quad
if (real(Bits(i,j,k)) >= 2) %right half of right half plan
if (imag(Bits(i,j,k)) >= 2)%upper half in right half plan
Demapped_sig((4*i)-3,j,k) = 1 ;
Demapped_sig((4*i)-2,j,k) = 0 ;
Demapped_sig((4*i)-1,j,k) = 1 ;
Demapped_sig(4*i,j,k) = 0 ;
else
Demapped_sig((4*i)-3,j,k) = 1 ;
Demapped_sig((4*i)-2,j,k) = 0 ;
Demapped_sig((4*i)-1,j,k) = 1 ;
Demapped_sig(4*i,j,k) = 1 ;
end
else
if (imag(Bits(i,j,k)) >= 2)%upper half in right half plan
Demapped_sig((4*i)-3,j,k) = 1 ;
Demapped_sig((4*i)-2,j,k) = 1 ;
Demapped_sig((4*i)-1,j,k) = 1 ;
Demapped_sig(4*i,j,k) = 0 ;
else
Demapped_sig((4*i)-3,j,k) = 1 ;
Demapped_sig((4*i)-2,j,k) = 1 ;
Demapped_sig((4*i)-1,j,k) = 1 ;
Demapped_sig(4*i,j,k) = 1 ;
end
end
else % lower RHP 2nd quad
if (real(Bits(i,j,k)) <= -2) %right half of right half plan
if (imag(Bits(i,j,k)) >= 2)%down half in right half plan
Demapped_sig((4*i)-3,j,k) = 0 ;
Demapped_sig((4*i)-2,j,k) = 0 ;
Demapped_sig((4*i)-1,j,k) = 1 ;
Demapped_sig(4*i,j,k) = 0 ;
else
Demapped_sig((4*i)-3,j,k) = 0 ;
Demapped_sig((4*i)-2,j,k) = 0 ;
Demapped_sig((4*i)-1,j,k) = 1 ;
Demapped_sig(4*i,j,k) = 1 ;
end
else
if (imag(Bits(i,j,k)) >= 2)%upper half in right half plan
Demapped_sig((4*i)-3,j,k) = 0 ;
Demapped_sig((4*i)-2,j,k) = 1 ;
Demapped_sig((4*i)-1,j,k) = 1 ;
Demapped_sig(4*i,j,k) = 0 ;
else
Demapped_sig((4*i)-3,j,k) = 0 ;
Demapped_sig((4*i)-2,j,k) = 1 ;
Demapped_sig((4*i)-1,j,k) = 1 ;
Demapped_sig(4*i,j,k) = 1 ;
end
end
end
else %%lower part
if (real(Bits(i,j,k)) < 0 ) %third quad
if (real(Bits(i,j,k)) <= -2)
if (imag(Bits(i,j,k)) <= -2)
Demapped_sig((4*i)-3,j,k) = 0 ;
Demapped_sig((4*i)-2,j,k) = 0 ;
Demapped_sig((4*i)-1,j,k) = 0 ;
Demapped_sig(4*i,j,k) = 0 ;
else
Demapped_sig((4*i)-3,j,k) = 0 ;
Demapped_sig((4*i)-2,j,k) = 0 ;
Demapped_sig((4*i)-1,j,k) = 0 ;
Demapped_sig(4*i,j,k) = 1 ;
end
else
if (imag(Bits(i,j,k)) <= -2)%upper half in right half plan
Demapped_sig((4*i)-3,j,k) = 0 ;
Demapped_sig((4*i)-2,j,k) = 1 ;
Demapped_sig((4*i)-1,j,k) = 0 ;
Demapped_sig(4*i,j,k) = 0 ;
else
Demapped_sig((4*i)-3,j,k) = 0 ;
Demapped_sig((4*i)-2,j,k) = 1 ;
Demapped_sig((4*i)-1,j,k) = 0 ;
Demapped_sig(4*i,j,k) = 1 ;
end
end
else % fourth quad
if (real(Bits(i,j,k)) >= 2) %right half of right half plan
if (imag(Bits(i,j,k)) <= -2)%down half in right half plan
Demapped_sig((4*i)-3,j,k) = 1 ;
Demapped_sig((4*i)-2,j,k) = 0 ;
Demapped_sig((4*i)-1,j,k) = 0 ;
Demapped_sig(4*i,j,k) = 0 ;
else
Demapped_sig((4*i)-3,j,k) = 1 ;
Demapped_sig((4*i)-2,j,k) = 0 ;
Demapped_sig((4*i)-1,j,k) = 0 ;
Demapped_sig(4*i,j,k) = 1 ;
end
else
if (imag(Bits(i,j,k)) <= -2)%upper half in right half plan
Demapped_sig((4*i)-3,j,k) = 1 ;
Demapped_sig((4*i)-2,j,k) = 1 ;
Demapped_sig((4*i)-1,j,k) = 0 ;
Demapped_sig(4*i,j,k) = 0 ;
else
Demapped_sig((4*i)-3,j,k) = 1 ;
Demapped_sig((4*i)-2,j,k) = 1 ;
Demapped_sig((4*i)-1,j,k) = 0 ;
Demapped_sig(4*i,j,k) = 1 ;
end
end
end
end
end
end
end
end

