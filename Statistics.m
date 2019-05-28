function [count_out, count_success_out, success_rate, recognition]=Statistics(recognized_word, selected_word, count, count_success)

count=count+1;

if strcmp(selected_word, recognized_word)
    count_success=count_success+1;
    recognition=1;
else
    recognition=0;
end
success_rate = (count_success/count) *100;

count_out=count;
count_success_out=count_success;
end