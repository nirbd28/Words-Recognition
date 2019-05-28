function [speech_out, start_time, end_time] = CutSilence_StartEnd(speech, fs, frame_time, frame_lap, silence_trsh, slide)

%%% split to frames
frames = FramesWithOverLap(speech, fs, frame_time, frame_lap);
[~,n]=size(frames);% n- number of frames

%%% calculate STE
for frames_current_i=1:n
    ste(frames_current_i)=sum( frames(:,frames_current_i).^2);
end

%%% silence class
for frames_current_i=1:n
    if ste(frames_current_i) <= silence_trsh
       frame_class(frames_current_i)=0; %silence
    else
        frame_class(frames_current_i)=1;  
    end
end

%%% slide
frame_class_slide = Slide(frame_class, slide);

%%% get frames start 
[start_frame_arr, sign_arr, clusters_num]=FramesGetStart(frame_class_slide);

%%% find start frame
if sign_arr(1)==0
    start_frame=start_frame_arr(2);
else
    start_frame=1;
end

%%% find end frame
if sign_arr(clusters_num)==0
    end_frame=start_frame_arr(clusters_num);
else
    end_frame=n;
end

%%% find times
start_time = FrameToTime_OverLap(start_frame ,frame_time, frame_lap);
end_time = FrameToTime_OverLap(end_frame+1 ,frame_time, frame_lap);

%%% cut silience from start/end
frame_i=start_frame;
step=floor(frame_lap*fs);
frames_current_i=1;
flag_first=0; %past first iteration
speech_out=[];
while frame_i<=end_frame
    
    frames_current=frames(:,frame_i);
    speech_current = CopyToArrFromIndex(frames_current, frames_current_i, length(frames_current));
    if flag_first==0
        frames_current_i=frames_current_i+step;
        flag_first=1;
    end
    speech_out = [speech_out speech_current];
    frame_i=frame_i+1;
end

end