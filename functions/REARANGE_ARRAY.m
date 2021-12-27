function [rearange_array] = REARANGE_ARRAY(orignial_bits_array,array)
j=1;
i=1;
for f = 1:(length(orignial_bits_array)-length(orignial_bits_array)/2)
    
    a=[array(j),array(j+2),array(j+4)];
    rearange_array(i)=mode(a);
    a=[array(j+1),array(j+3),array(j+5)];
    rearange_array(i+1)=mode(a);
    i=i+2;
    j=j+6;
    f=f+1;

end

end

