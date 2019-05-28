function [start_frame_arr, sign_arr, clusters_num]=FramesGetStart(frame_class_slide)
% get start of each cluster in frames
% cluster - 0/1 class

n = length(frame_class_slide);

i=1;% index for frame_class
start_frame_i=2;% index for Start_Frame_Index, sign_arr
start_frame_arr(1)=1;
sign_arr(1)=frame_class_slide(1);

while i~=n 
    sign=frame_class_slide(i);
    while sign==frame_class_slide(i)% carry on until a different sign is found
        i=i+1; 
        if i==n% reached the end
            break;
        end
    end
    if i==n
        break;
    end
    start_frame_arr(start_frame_i)=i;
    sign_arr(start_frame_i)=frame_class_slide(i);
    start_frame_i=start_frame_i+1;
end

clusters_num = length(start_frame_arr);

end