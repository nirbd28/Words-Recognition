function frames_out=Windowing(frames)

[m,n]=size(frames);         
hamming_win=hamming(m);   
for i=1:n            
    cur_frame=frames(:,i);
    frames_out(:,i)=cur_frame.*hamming_win;
end

end