% gird-search for c&g

% addpath('C:\Documents and Settings\hp\桌面\benke\svm');
indian_pines_corrected_svm=indian_pines_corrected;
sample_rate = 0.1;
[sample_gt,~] = Random_I(sample_rate);

test_pos=1;
train_pos=1;

indian_pines_corrected_svm = normalizing(indian_pines_corrected, 0, 1);



for k=1:145
    for kk=1:145
        if(sample_gt(k,kk)==1)  %是选中的样本，作为train
            trainlabels(train_pos)=indian_pines_gt(k,kk);
            traindata(train_pos,:)=indian_pines_corrected_svm(k,kk,:);
            train_pos=train_pos+1;
        else
            if(indian_pines_gt(k,kk)~=0)  %作为test,背景
                testlabels(test_pos)=indian_pines_gt(k,kk);
                testdata(test_pos,:)=indian_pines_corrected_svm(k,kk,:);
                test_pos=test_pos+1;
            end
        end
    end

end

disp('svm ready');


% for k=11:20
%     for kk=11:20
%         testlabels((k-10)*(kk-10))=indian_pines_gt(k,kk);
%         testdata((k-10)*(kk-10),:)=indian_pines_corrected(k,kk,:);
%     end
% end
% testlabels=testlabels';




% bestacc = 0;    % 存放最佳识别率
% for cc = 5:10
%     for gg = -5:5
%         acc = svmtrain(trainlabels, traindata,'-h 0');   % 5折交叉验证 c的取值范围[2^5--2^10] g的取值范围[2^(-5)--2^5]
%         if acc > bestacc
%             bestacc = acc;
%             bestc = cc;      % 存储最佳c
%             bestg = gg;      % 存储最佳g
%         end
%         disp(gg);
%     end
% end

% acc = svmtrain(trainlabels, traindata, ['-c ', num2str(2^5), ' -g ',  num2str(2^5),' -v 5']);   % 5折交叉验证 c的取值范围[2^5--2^10] g的取值范围[2^(-5)--2^5]
% if acc > bestacc
%     bestacc = acc;
%     bestc = 5;      % 存储最佳c
%     bestg = 5;
%     % train with best c and g
% end
bestc = 1000;
bestg = 0.01;
    
%model = svmtrain(trainlabels, traindata);
model = svmtrain(trainlabels', traindata, ['-c ', num2str(2^bestc), ' -g ',  num2str(2^bestg)]);
[result, ~, ~] = svmpredict(testlabels', testdata, model);
accuracy = sum(result==testlabels')/length(result);