function speech_out = CutSilence_StartEnd2(speech, fs)

%%% split to frames
frame_time = 20e-3;
frame_lap = frame_time/2;
frames = FramesWithOverLap(speech, fs, frame_time, frame_lap);
[m,n]=size(frames);% n- number of frames

%%% calculate STE
for i=1:n
    ste(i)=sum( frames(:,i).^2);
end

%%% silence class
silence_trsh=0.03;
for i=1:n
    if ste(i) <= silence_trsh
       frame_class(i)=0; %silence
    else
        frame_class(i)=1;  
    end
end

%%% slide
slide=3;
frame_class_slide = Slide(frame_class, slide);

%%% get frames start 
[start_frame_arr ,sign_arr]=FramesGetStart(frame_class_slide);
clusters_num=length(start_frame_arr);

%%% get frames end 
for i=1:(clusters_num-1)
    end_frame_arr(i)=start_frame_arr(i+1)-1;
end
end_frame_arr(clusters_num)=n;
 
%%% convert to time
for i=1:clusters_num
   start_time_arr(i)=FrameToTime_OverLap(start_frame_arr(i), frame_time, frame_lap);     
   end_time_arr(i)=FrameToTime_OverLap(end_frame_arr(i), frame_time, frame_lap);     
end

%%% convert to speech index
for i=1:clusters_num
   start_speech_index_arr(i)= TimeToIndex(start_time_arr(i), fs);     
   end_speech_index_arr(i)= TimeToIndex(end_time_arr(i), fs); 
end

%%% cut silience from start/end

% find start
if sign_arr(1)==0
    start_speech_index=start_speech_index_arr(2);
else
    start_speech_index=start_speech_index_arr(1);
end

% find end
if sign_arr(clusters_num)==0
    end_speech_index=end_speech_index_arr(clusters_num-1);
else
    end_speech_index=end_speech_index_arr(clusters_num);
end

speech_out = GetArr(speech ,start_speech_index, end_speech_index);

end