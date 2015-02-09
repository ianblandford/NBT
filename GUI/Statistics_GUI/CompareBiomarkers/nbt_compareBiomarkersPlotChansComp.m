function nbt_compareBiomarkersPlotChansComp(d1,d2,B_values1,B_values2,bioms1,bioms2,biomindex,BottomGroups,splitType,splitValue,Pvalues)
global rsq
pos_cursor_unitfig = get(gca,'currentpoint');
if strcmp(bioms1{1},'rsq.Answers') == 1
    question = round(pos_cursor_unitfig(1,2));
        chan_or_reg = round(pos_cursor_unitfig(1,1));
        
%         pval = Pvalues(question,chan_or_reg);
%         pval = sprintf('%.4f',pval);
        if question>0 && question<=size(B_values1,1) && chan_or_reg>0 && chan_or_reg<=size(B_values2,1)
            B = B_values2(chan_or_reg,:,biomindex);
            B_Ans = B_values1(question,:);
            %-----
            if strcmp(bioms2{1},'rsq.Answers') == 1
            
             figure('Name',['Least-squares fit for Question ' num2str(question) '. ''' rsq.Questions{question} ''' and Question ' num2str(chan_or_reg)  '. ''' rsq.Questions{chan_or_reg} ''' of ' regexprep(bioms1{biomindex},'_',' ')],'NumberTitle','off')
            set(gcf,'position',[10          80       450      700])
            else
                 figure('Name',['Least-squares fit for Question ' num2str(question) '. ''' rsq.Questions{question} ''' and Channel ' num2str(chan_or_reg) ' of ' regexprep(bioms1{biomindex},'_',' ')],'NumberTitle','off')
            set(gcf,'position',[10          80       450      700])
            end
            [rho,PSpear] = corr(B_Ans',B','type','Spearman');
            plot(B_Ans,B,'.')
            lsline
            xlabel(['Answers to Question ' num2str(question) '. ''' rsq.Questions{question} ''''])
            if strcmp(bioms2{1},'rsq.Answers') == 1
                 ylabel([regexprep(bioms1{biomindex},'_',' ') ' for Answers to Question ' num2str(chan_or_reg) '. ''' rsq.Questions{chan_or_reg} ''''])
            title({['Least-squares fit for Question ' num2str(question) '.'],['''' rsq.Questions{question} ''''],['for Question ' num2str(chan_or_reg) '.'],...
                ['''' rsq.Questions{chan_or_reg} ''' of  '] ,...
                [ regexprep(bioms1{biomindex},'_',' '), '(p = ',sprintf('%.4f',PSpear),', rho = ',sprintf('%.3f',rho) ,')']},'fontweight','bold')
            else
            
            ylabel([regexprep(bioms1{biomindex},'_',' ') ' for Channel ' num2str(chan_or_reg)])
            title({['Least-squares fit for Question ' num2str(question) '.'],['''' rsq.Questions{question} ''''],[' and Channel ' num2str(chan_or_reg) ' of '],...
                [ regexprep(bioms1{biomindex},'_',' '), '(p = ',sprintf('%.4f',PSpear),', rho = ',sprintf('%.3f',rho) ,')']},'fontweight','bold')
            end
            
            
            %----
            
            if splitType == 1
                %split on %
                nns = nnz(isnan(B_values2(chan_or_reg,:)));
                if nns > 0
                    quarts = floor((splitValue/100)*(size(B_values2,2)- nns));
                    [nofill,inds] = sort(B_values2(chan_or_reg,:));
                    Group2 = inds(1:quarts);
                    Group1 = inds(1+end-quarts-nns:end-nns);
                else
                    quarts = floor((splitValue/100)*size(B_values2,2));
                    [nofill,inds] = sort(B_values2(chan_or_reg,:));
                    Group2 = inds(1:quarts);
                    Group1 = inds(1+end-quarts:end);
                end
                
                B1 = B_values1(question,Group1); % biomarker for Top group
                B2 = B_values1(question,Group2); % biomarker for Bottom group
            else
                %split on value
                Group1 = find(B_values2(chan_or_reg,:)>splitValue);% Top
                Group2 = find(B_values2(chan_or_reg,:)<splitValue);% Bottom
                
                B1 = B_values1(question,Group1); % biomarker for Top group
                B2 = B_values1(question,Group2); % biomarker for Bottom group
            end
            
            [h,p,c] = ttest2(B1,B2);
            diffmean = mean(B2)-mean(B1);
            if strcmp(bioms2{1},'rsq.Answers') == 1
            
             figure('Name',['Boxplot of the Top and Bottom group for Question ' num2str(question) '. ''' rsq.Questions{question} ''' and Question ' num2str(chan_or_reg)  '. ''' rsq.Questions{chan_or_reg} ''''],'NumberTitle','off')
            set(gcf,'position',[10          80       450      700])
            else
            figure('Name',['Boxplot of the Top and Bottom group for Question ' num2str(question) '. ''' rsq.Questions{question} ''' and Channel ' num2str(chan_or_reg)],'NumberTitle','off')
            set(gcf,'position',[10          80      450      700])
            end
            
            z = [B1 B2];
            g = [zeros(length(B1),1); ones(length(B2),1)];
            boxplot(z,g);
            hold on
            plot(1,mean(B1),'s','Markerfacecolor','k')
            plot(2,mean(B2),'s','Markerfacecolor','k')
            text(1.02,mean(B1),'Mean','fontsize',8)
            text(2.02,mean(B2),'Mean','fontsize',8)
%             bar([mean(B1) mean(B2)])
             if strcmp(bioms2{1},'rsq.Answers') == 1
                 ylabel(['Boxplot ' regexprep(bioms1{biomindex},'_',' ') ' for Question ' num2str(chan_or_reg)  '. ''' rsq.Questions{chan_or_reg} ''''])
            xlim([0 3])
             else 
            ylabel(['Boxplot ' regexprep(bioms1{biomindex},'_',' ') ' for Channel ' num2str(chan_or_reg)])
            xlim([0 3])
             end
            set(gca,'xtick',[0 1 2 3 ],'Xticklabel',{''; ['"Top" Group (n = ' num2str(length(B1)) ')']; ['"Bottom" Group (n = ' num2str(length(B2)) ')'];''},'fontsize',8,'fontweight','bold')
             
            title({['Boxplot of the Top and Bottom group for Question ' num2str(question) '.'],['''' rsq.Questions{question} ''''],[' and Channel ' num2str(chan_or_reg) ' of '],...
                 [ regexprep(bioms1{biomindex},'_',' '), '(p = ',sprintf('%.4f',p),')']},'fontweight','bold')
%          
            
        end
    
    
    
else
    if strcmp(bioms2{1},'rsq.Answers') == 1
        question = round(pos_cursor_unitfig(1,1));
        chan_or_reg = round(pos_cursor_unitfig(1,2));
      
%         pval = Pvalues(question,chan_or_reg);
        if question>0 && question<=size(B_values2,1) && chan_or_reg>0 && chan_or_reg<=size(B_values1,1)
            B = B_values1(chan_or_reg,:,biomindex);
            B_Ans = B_values2(question,:);
            %-----
            figure('Name',['Least-squares fit for Question ' num2str(question) '. ''' rsq.Questions{question} ''' and Channel ' num2str(chan_or_reg) ' of ' regexprep(bioms1{biomindex},'_',' ')],'NumberTitle','off')
            set(gcf,'position',[10          80       450      700])
            plot(B_Ans,B,'.')
            lsline
            [rho,PSpear] = corr(B_Ans',B','type','Spearman');

            xlabel(['Answers to Question ' num2str(question) '. ''' rsq.Questions{question} ''''])
            ylabel([regexprep(bioms1{biomindex},'_',' ') ' for Channel ' num2str(chan_or_reg)])
            title({['Least-squares fit for Question ' num2str(question) '.'],['''' rsq.Questions{question} ''''],[' and Channel ' num2str(chan_or_reg) ' of '],...
                [ regexprep(bioms1{biomindex},'_',' '), '(p = ', sprintf('%.4f',PSpear) ,', rho = ',sprintf('%.3f',rho) ,')']},'fontweight','bold')
%                textThis = sprintf(['Least-squares fit for Question ' num2str(question) '. ''' rsq.Questions{question} ''' and Channel ' num2str(chan_or_reg) ' of ' regexprep(bioms1{biomindex},'_',' ')]);
%             puttitley = get(gca,'ylim');
%             puttitlex = get(gca,'xlim');
%             
%             nbt_split_title([abs(puttitlex(1)-puttitlex(2))/2 puttitley(2)],textThis,50,11);
            %----
            
            if splitType == 1
                %split on %
                nns = nnz(isnan(B_values2(question,:)));
                if nns > 0
                    quarts = floor((splitValue/100)*(size(B_values2,2)- nns));
                    [nofill,inds] = sort(B_values2(question,:));
                    Group2 = inds(1:quarts);
                    Group1 = inds(1+end-quarts-nns:end-nns);
                else
                    quarts = floor((splitValue/100)*size(B_values2,2));
                    [nofill,inds] = sort(B_values2(question,:));
                    Group2 = inds(1:quarts);
                    Group1 = inds(1+end-quarts:end);
                end
                
                B1 = B_values1(chan_or_reg,Group1); % biomarker for Top group
                B2 = B_values1(chan_or_reg,Group2); % biomarker for Bottom group
            else
                %split on value
                Group1 = find(B_values2(question,:)>splitValue);% Top
                Group2 = find(B_values2(question,:)<splitValue);% Bottom
                
                B1 = B_values1(chan_or_reg,Group1); % biomarker for Top group
                B2 = B_values1(chan_or_reg,Group2); % biomarker for Bottom group
            end
            
            
            
            [h,p,c] = ttest2(B1,B2);
            diffmean = mean(B2)-mean(B1);
            figure('Name',['BoxPlot of the Top and Bottom group for Question ' num2str(question) '. ''' rsq.Questions{question} ''' and Channel ' num2str(chan_or_reg)],'NumberTitle','off')
            set(gcf,'position',[10          80      450      700])
            
            z = [B1 B2];
            g = [zeros(length(B1),1); ones(length(B2),1)];
            boxplot(z,g);
            hold on
            plot(1,mean(B1),'s','Markerfacecolor','k')
            plot(2,mean(B2),'s','Markerfacecolor','k')
            text(1.02,mean(B1),'Mean','fontsize',8)
            text(2.02,mean(B2),'Mean','fontsize',8)
%             bar([mean(B1) mean(B2)])
            ylabel(['BoxPlot ' regexprep(bioms1{biomindex},'_',' ') ' in Channel ' num2str(chan_or_reg)])
            xlim([0 3])
            set(gca,'xtick',[0 1 2 3 ],'Xticklabel',{''; ['"Top" Group (n = ' num2str(length(B1)) ')']; ['"Bottom" Group (n = ' num2str(length(B2)) ')'];''},'fontsize',8,'fontweight','bold')
             title({['Mean of the Top and Bottom group for Question ' num2str(question) '.'],['''' rsq.Questions{question} ''''],[' and Channel ' num2str(chan_or_reg) ' of '],...
                 [ regexprep(bioms1{biomindex},'_',' '), '(p = ',sprintf('%.4f',p),')']},'fontweight','bold')
%          
%             textThis = sprintf(['Mean of the Top and Bottom group for Question ' num2str(question) '. ''' rsq.Questions{question} ''' and Channel ' num2str(chan_or_reg)]);
%             puttitley = get(gca,'ylim');
%             puttitlex = get(gca,'xlim');
%             nbt_split_title([abs(puttitlex(1)-puttitlex(2))/2 puttitley(2)],textThis,50,11);
        end
    else
        disp('ERROR: Bottomt implemented yet')
    end
end



end