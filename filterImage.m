function output = filterImage(out) 

for f=21:-2:1
    for i=1+f:size(out,1)-f
        for j=1+f:size(out,2)-f
            %temp = out(i-f:i+f,j-f:j+f);
            sum = (255-out(i-f,j+f:j+f)) + (255-out(i+f,j-f:j+f)) + (255-out(i-f:i+f,j-f)) + (255-out(i-f:i+f,j+f));
            if sum==0
                out(i-f:i+f,j-f:j+f) = 255;
            end
        end
    end
end
output = out;