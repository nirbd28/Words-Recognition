function frame_class_slide = Slide(frame_class ,slide) % maximum error in sequence is slide

n = length(frame_class);
i=1;
check_sign=frame_class(1);
while i~=n
    if frame_class(i)~=check_sign;
         [flag , index] = CheckAhead(frame_class, i, slide, check_sign);
         switch flag
         case -1
            break;
         case 0 % series ended
            check_sign=frame_class(i);
         case 1 % series continues
              for j=i:index
                  frame_class(j)=check_sign; 
              end
         end          
    end
    i=i+1;
end     

frame_class_slide=frame_class;

%%% fix start 
check_sign=frame_class(1);
start_flag=0;
for i=1:slide
    if frame_class_slide(i)~=check_sign;
       start_sign=frame_class_slide(i);
       start_i=i;
       start_flag=1;
       break;
    end   
end
if start_flag==1
    for i=1:start_i
        frame_class_slide(i)=start_sign;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [flag, index]=CheckAhead(frame_class ,index , slide, check_sign)

for k=index:(index+slide)
    if k==n
        flag=-1;% reached the end
        break;
    end
    
    if frame_class(k)==check_sign
        flag=1;% there is someone ahead with the same sign within the slide range (series not ended)
        index=k;
        break;
    else
        flag=0;% different sign series began
    end
     
end  

end

end

