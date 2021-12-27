function [QAM_16_Bits] = QAM_16_Reshaped_Mapper(Bits)
for k=1:size(Bits,3)
    for j=1:size(Bits,2)
        for i=1:4:size(Bits,1)
            place =(i+3)/4;
            if ([Bits(i,j,k),Bits(i+1,j,k),Bits(i+2,j,k),Bits(i+3,j,k)] == [0 , 0 , 0 ,0])
            QAM_16_Bits(place,j,k) = -3+ -3*1i ;
            elseif([Bits(i,j,k),Bits(i+1,j,k),Bits(i+2,j,k),Bits(i+3,j,k)]== [1 , 0 , 0 ,0])
            QAM_16_Bits(place,j,k) = 3+ -3* 1i ;
            elseif([Bits(i,j,k),Bits(i+1,j,k),Bits(i+2,j,k),Bits(i+3,j,k)] == [0 , 1 , 0 ,0])
            QAM_16_Bits(place,j,k) = -1- 3* 1i ;
            elseif([Bits(i,j,k),Bits(i+1,j,k),Bits(i+2,j,k),Bits(i+3,j,k)] == [1 , 1 , 0 ,0])
            QAM_16_Bits(place,j,k) = 1- 3* 1i ;
            elseif([Bits(i,j,k),Bits(i+1,j,k),Bits(i+2,j,k),Bits(i+3,j,k)] == [0 , 0 , 1 ,0])
            QAM_16_Bits(place,j,k) = -3+ 3* 1i;
            elseif([Bits(i,j,k),Bits(i+1,j,k),Bits(i+2,j,k),Bits(i+3,j,k)] == [1 , 0 , 1 ,0])
            QAM_16_Bits(place,j,k) = 3+ 3* 1i ;
            elseif([Bits(i,j,k),Bits(i+1,j,k),Bits(i+2,j,k),Bits(i+3,j,k)] == [0 , 1 , 1 ,0])
            QAM_16_Bits(place,j,k) = -1+ 3* 1i;
            elseif([Bits(i,j,k),Bits(i+1,j,k),Bits(i+2,j,k),Bits(i+3,j,k)] == [1 , 1 , 1 ,0])
            QAM_16_Bits(place,j,k) = 1+ 3* 1i ;
            elseif ([Bits(i,j,k),Bits(i+1,j,k),Bits(i+2,j,k),Bits(i+3,j,k)] == [0 , 0 , 0 ,1])
            QAM_16_Bits(place,j,k) = -3- 1* 1i ;
            elseif([Bits(i,j,k),Bits(i+1,j,k),Bits(i+2,j,k),Bits(i+3,j,k)] == [1, 0 , 0 ,1])
            QAM_16_Bits(place,j,k) = 3- 1* 1i ;
            elseif([Bits(i,j,k),Bits(i+1,j,k),Bits(i+2,j,k),Bits(i+3,j,k)] == [0 , 1 , 0 ,1])
            QAM_16_Bits(place,j,k) = -1- 1* 1i ;
            elseif([Bits(i,j,k),Bits(i+1,j,k),Bits(i+2,j,k),Bits(i+3,j,k)] == [1 , 1 , 0 ,1])
            QAM_16_Bits(place,j,k) = 1- 1* 1i;
            elseif([Bits(i,j,k),Bits(i+1,j,k),Bits(i+2,j,k),Bits(i+3,j,k)] == [0 , 0 , 1 ,1])
            QAM_16_Bits(place,j,k) = -3 +1* 1i ;
            elseif([Bits(i,j,k),Bits(i+1,j,k),Bits(i+2,j,k),Bits(i+3,j,k)] == [1 , 0 , 1 ,1])
            QAM_16_Bits(place,j,k) = 3+ 1* 1i ;
            elseif([Bits(i,j,k),Bits(i+1,j,k),Bits(i+2,j,k),Bits(i+3,j,k)] == [0 , 1 , 1 ,1])
            QAM_16_Bits(place,j,k) = -1+ 1* 1i ;
            elseif([Bits(i,j,k),Bits(i+1,j,k),Bits(i+2,j,k),Bits(i+3,j,k)] == [1 , 1 , 1 ,1])
            QAM_16_Bits(place,j,k) = 1+ 1* 1i ;
            end
            
        end
        
    end
end

end

