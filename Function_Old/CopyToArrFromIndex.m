function arr_out = CopyToArrFromIndex(arr_in, start_i, end_i)
% arr_out = arr_in - from index start - to index end

index=1;
for i=start_i:end_i
    arr_out(index)=arr_in(i);
    index=index+1;
end

end