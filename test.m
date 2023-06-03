% for i = 1:35
%     x = (i-1)*8+1:8*i;
%     y = X(i,:);
%     plot(x,y,'.r')
%     hold on
% end
% 
% for i = 36:350
%     x = (i-1)*8+1:8*i;
%     y = X(i,:);
%     plot(x,y,'.b')
%     hold on
% end


     X = randn(10,1000);
     Y = datasample(X,5,2,'Replace',false)