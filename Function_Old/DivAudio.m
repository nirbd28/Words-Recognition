function DivAudio(speech, fs, file_name, path, slide, silence_trsh)

%%% split to frames
frame_time = 20e-3;
frame_lap = frame_time/2;
frames = FramesWithOverLap(speech, fs, frame_time, frame_lap  );
[m,n]=size(frames);% n- number of frames

%%% calculate STE
for i=1:n
    ste(i)=sum( frames(:,i).^2);
end

%%% silence class
for i=1:n
    if ste(i) <= silence_trsh
       frame_class(i)=0; %silence
    else
        frame_class(i)=1;  
    end
end

%%% slide
frame_class_slide = Slide(frame_class, slide );

%%% get parts of audio
file_name_arr = strsplit(file_name,'.');
file_name=file_name_arr{1};
count=1;
frame_i=1;
step=floor(frame_lap*fs);

while frame_i<=n
    frames_current_i=1;
    flag_first=0; % past first iteration
    part_speech=[];
    flag_part=0;
    
    while frame_class_slide(frame_i)==1 % currently in voiced part
        flag_part=1; 
        frames_current=frames(:,frame_i);
        speech_current = CopyToArrFromIndex(frames_current, frames_current_i, length(frames_current));
        if flag_first==0
            frames_current_i=frames_current_i+step;
            flag_first=1;
        end
        part_speech = AppendArr(part_speech, speech_current);
        frame_i=frame_i+1;
       
        if frame_i>n
            break;
        end
    end % after while part_speech = voiced part
    
    %%% operations on parts
    if flag_part==1
        sound(part_speech, fs);         
        filename_final = strcat(path, file_name, int2str(count), '.wav');
        audiowrite(filename_final, part_speech, fs); 
        count=count+1;
    end
    %%%
    
    frame_i=frame_i+1;
end

end