function speech_out=CorrectSpeechSize(speech) % correct speech size to optimal case - one row

[m,n]=size(speech);

if n==2
   flag=2;
   
elseif m>1
    flag=1;
    
elseif m==1
    flag=0;
end

switch flag
    case 0 % speech is one row - optimal case
        speech_out=speech;
        
    case 1 % speech is vector
        speech_out=transpose(speech);
        
    case 2 % speech is not mono
         speech_out = speech(:,1); 
         speech_out=transpose(speech_out);
end

end