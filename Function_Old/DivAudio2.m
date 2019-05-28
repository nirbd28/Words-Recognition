function DivAudio(speech, fs, path, slide )

%%% split to frames
frame_time = 10e-3;
frame_lap = frame_time/2;
frame = FramesWithOverLap(speech, fs, frame_time, frame_lap  );
[m,n]=size(frame);% n- number of frames

%%% calculate STE
for i=1:n
    ste(i)=sum( frame(:,i).^2);
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
frame_class_slide = Slide(frame_class, slide );

%%% get frames start
[start_frame_arr ,sign_arr]=FramesGetStart(frame_class_slide);
clusters_num=length(start_frame_arr);

%%% get frames end 
for i=1:(clusters_num-1)
    end_frame_arr(i)=start_frame_arr(i+1)-1;
end
end_frame_arr(clusters_num)=n;

%%% get parts of audio
count=0;
file_name='z';
%file_name = input('Enter Name: ','s');
for i=1:clusters_num
  if sign_arr(i)==1
      count=count+1;
      
      start_frame=start_frame_arr(i);
      end_frame=end_frame_arr(i);
      part_speech = GetPartOfDivAudio(speech, fs, start_frame, end_frame, frame_time, frame_lap);
      
      sound(part_speech, fs)
            
      count_str = int2str(count);
      filename_final = strcat(path, file_name, count_str, '.wav');
      audiowrite(filename_final, part_speech, fs);
  end
    
end

function part_speech = GetPartOfDivAudio(speech, fs, start_frame, end_frame, frame_time, frame_lap)

start_time=FrameToTime_OverLap(start_frame, frame_time, frame_lap); 
end_time=FrameToTime_OverLap(end_frame, frame_time, frame_lap);

start_speech_index= TimeToIndex(start_time ,fs); 
end_speech_index= TimeToIndex(end_time ,fs); 

part_speech = GetArr(speech, start_speech_index, end_speech_index);

end

end