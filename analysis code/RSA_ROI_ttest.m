global_path = 'F:\';

% two sample functional ROI
% ROI_name = {'Rectus_inter','Rectus_vm','lPRC_-20_-4_-32','lOFC_-20_42_-10','rIFG_50_22_22','rMFG_36_52_10','rmSFG_18_42_46','lmSFG_-12_66_10','MCC_2_2_38'};
% one sample functional ROI
% ROI_name ={'rSTG_40_-42_2','rPHC_28_-32_-10','rMTC_60_-38_-8','rPrecuneus_12_-56_38','rSFC_24_66_-2'};
%final anatomical ROI
ROI_name = {'rHPC_manual','rSFC_aal','rmSFC','rFrontal_mOrb'};
% ROI_name = {'arSFC','prSFC','arSFC2','prSFC2'};
%supplementary ROI
% ROI_name = {'lHPC','lmSFC','lFrontal_mOrb'};
% two sample anatomical ROI
% ROI_name = {'lRectus','rRectus','PRc','rMFC','rIFC_oper','rIFC_tri','lMCC','rMCC','rSMA','lSMA','lIOFC','lSOFC'};
% one sample anatomical ROI
% ROI_name = {'rHPC','PHc','rSFC_aal','rSTC','rMTC','rITC','rPrecuneus'};
% ROI_name = {'anterior_rHPC','posterior_rHPC'};


pvalue = zeros(5,5);
for nROI = 2
    r_pho = zeros(17,2,5);
    %     stats1_p = zeros(17,2);
    %     stats2_p = zeros(17,2);
    for nsub = [2:5 7:10 12:17]
        for nsess = 1:2
            load([global_path,'fMRI\4-RSA_fixation_separate\result\ROI\',ROI_name{nROI},'\',num2str(nsub),'-',num2str(nsess),'-Similarity_z2.mat']);
            %             if nROI ==5 || nROI == 6
            %                 load(['D:\documents\Naya lab\RSA_fixation_separate\ROI\',ROI_name{nROI},'\',num2str(nsub),'-',num2str(nsess),'-Similarity_new.mat']);
            %             end
            Similarity = Similarity_z2;
            output_table=RSA_get_result_table_2nd(nsub,nsess);
            location = Get_location(output_table,nsub);
            item_table = Get_item_table(output_table);
            %             item_table([14 58],:)=[];
            %             location([14 58],:)=[];
            
            Y = [];
            item1 = [];
            item2 = [];
            location1 = [];
            location2 = [];
            combination1 = [];
            combination2 = [];
            baseline = [];
            similar = [];
            first = [];
            second = [];
            fs = [];
            sf = [];
            location11 = [];
            location22 = [];
            inde_l11 = 0;
            inde_l22 = 0;
            item11 = [];
            item22 = [];
            inde_i11 = 0;
            inde_i22 = 0;
            inde_f = 0;
            inde_ss = 0;
            inde_sf = 0;
            inde_fs = 0;
            Z = [];
            inde = 0;
            inde_i1 = 0;
            inde_i2 = 0;
            inde_l1 = 0;
            inde_l2 = 0;
            inde_c1 = 0;
            inde_c2 = 0;
            inde_b = 0;
            inde_s = 0;
            
            inde_z = 0;
            for row = 1:63
                for col = 1+row:64
                    flag = 0;
                    
                    inde = inde+1;
                    Y(inde,1) = Similarity(row,col);
                    
                    if location(row,1)==location(col,1)&&location(row,2)~=location(col,2)&&item_table(row,1)~=item_table(col,1)&&item_table(row,2)~=item_table(col,2)
                        inde_l11 = inde_l11+1;
                        location11(inde_l11,1) = Similarity(row,col);
                    end
                    
                    if location(row,2)==location(col,2)&&location(row,1)~=location(col,1)&&item_table(row,1)~=item_table(col,1)&&item_table(row,2)~=item_table(col,2)
                        inde_l22 = inde_l22+1;
                        location22(inde_l22,1) = Similarity(row,col);
                    end
                    
                    if location(row,1)~=location(col,1)&&location(row,2)~=location(col,2)&&item_table(row,1)==item_table(col,1)&&item_table(row,2)~=item_table(col,2)
                        inde_i11 = inde_i11+1;
                        item11(inde_i11,1) = Similarity(row,col);
                    end
                    
                    if location(row,2)~=location(col,2)&&location(row,1)~=location(col,1)&&item_table(row,1)~=item_table(col,1)&&item_table(row,2)==item_table(col,2)
                        inde_i22 = inde_i22+1;
                        item22(inde_i22,1) = Similarity(row,col);
                    end
                    
                   
                    
                    
                    if location(row,1)==location(col,1)&&location(row,2)~=location(col,2)&&item_table(row,1)==item_table(col,1)&&item_table(row,2)~=item_table(col,2)
                        inde_f = inde_f+1;
                        first(inde_f,1) = Similarity(row,col);
                    end
                    if location(row,2)==location(col,2)&&location(row,1)~=location(col,1)&&item_table(row,2)==item_table(col,2)&&item_table(row,1)~=item_table(col,1)
                        inde_ss = inde_ss+1;
                        second(inde_ss,1) = Similarity(row,col);
                    end
                    
                    if location(row,2)==location(col,1)&&location(row,1)~=location(col,2)&&item_table(row,2)==item_table(col,1)&&item_table(row,1)~=item_table(col,2)
                        inde_sf = inde_sf+1;
                        sf(inde_sf,1) = Similarity(row,col);
                    end
                    
                    if location(row,1)==location(col,2)&&location(row,2)~=location(col,1)&&item_table(row,1)==item_table(col,2)&&item_table(row,2)~=item_table(col,1)
                        inde_fs = inde_fs+1;
                        fs(inde_fs,1) = Similarity(row,col);
                    end
                    
                    if location(row,1)~=location(col,1)&&location(row,1)~=location(col,2)&&location(row,2)~=location(col,1)&&location(row,2)~=location(col,2)
                        if item_table(row,1)==item_table(col,1)||item_table(row,1)==item_table(col,2)||item_table(row,2)==item_table(col,1)||item_table(row,2)==item_table(col,2)
                            inde_i1 = inde_i1+1;
                            item1(inde_i1,1) = Similarity(row,col);
                            flag =1;
                        end
                    end
                    
                    if item_table(row,1)~=item_table(col,1)&&item_table(row,1)~=item_table(col,2)&&item_table(row,2)~=item_table(col,1)&&item_table(row,2)~=item_table(col,2)
                        if location(row,1)==location(col,1)||location(row,1)==location(col,2)||location(row,2)==location(col,1)||location(row,2)==location(col,2)
                            inde_l1 = inde_l1+1;
                            location1(inde_l1,1) =Similarity(row,col);
                            flag =1;
                        end
                    end
                    
                    if item_table(row,1)==item_table(col,1)&&item_table(row,2)~=item_table(col,2)
                        if location(row,1)==location(col,1)&&location(row,2)~=location(col,2)
                            inde_c1 = inde_c1+1;
                            combination1(inde_c1,1) = Similarity(row,col);
                            flag =1;
                        end
                    end
                    if item_table(row,1)==item_table(col,2)&&item_table(row,2)~=item_table(col,1)
                        if location(row,1)==location(col,2)&&location(row,2)~=location(col,1)
                            inde_c1 = inde_c1+1;
                            combination1(inde_c1,1) = Similarity(row,col);
                            flag =1;
                        end
                    end
                    if item_table(row,2)==item_table(col,1)&&item_table(row,1)~=item_table(col,2)
                        if location(row,2)==location(col,1)&&location(row,1)~=location(col,2)
                            inde_c1 = inde_c1+1;
                            combination1(inde_c1,1) = Similarity(row,col);
                            flag =1;
                        end
                    end
                    if item_table(row,2)==item_table(col,2)&&item_table(row,1)~=item_table(col,1)
                        if location(row,2)==location(col,2)&&location(row,1)~=location(col,1)
                            inde_c1 = inde_c1+1;
                            combination1(inde_c1,1) = Similarity(row,col);
                            flag =1;
                        end
                    end
                    
                    if output_table{row,2}==output_table{col,2}&&location(row,1)~=location(col,1)&&location(row,1)~=location(col,2)&&location(row,2)~=location(col,1)&&location(row,2)~=location(col,2)
                        inde_i2 = inde_i2+1;
                        item2(inde_i2,1) = Similarity(row,col);
                        flag =1;
                    end
                    
                    if item_table(row,1)~=item_table(col,1)&&item_table(row,1)~=item_table(col,2)&&item_table(row,2)~=item_table(col,1)&&item_table(row,2)~=item_table(col,2)&&output_table{row,3}==output_table{col,3}
                        inde_l2 = inde_l2+1;
                        location2(inde_l2,1) = Similarity(row,col);
                        flag =1;
                    end
                    
                    if output_table{row,2}==output_table{col,2}&&output_table{row,3}==output_table{col,3}
                        if item_table(col,1)==item_table(row,2)&&location(col,1)==location(row,2)
                            inde_c2 = inde_c2+1;
                            combination2(inde_c2,1) = Similarity(row,col);
                            flag =1;
                            %                             if combination2(inde_c2)<-0.1
                            %                                 disp(row)
                            %                                 disp(col)
                            %                             end
                        elseif item_table(row,1)==item_table(col,2)&&location(row,1)==location(col,2)
                            inde_c2 = inde_c2+1;
                            combination2(inde_c2,1) = Similarity(row,col);
                            flag =1;
                            %                             if combination2(inde_c2)<-0.1
                            %                                 disp(row)
                            %                                 disp(col)
                            %                             end
                        end
                        
                        if item_table(col,1)==item_table(row,1)&&location(col,1)~=location(row,1)
                            inde_s = inde_s+1;
                            similar(inde_s,1) = Similarity(row,col);
                            flag =1;
                        end
                        
                        if item_table(col,1)~=item_table(row,1)&&location(col,1)==location(row,1)
                            inde_s = inde_s+1;
                            similar(inde_s,1) = Similarity(row,col);
                            flag =1;
                        end
                    end
                    
                    if location(row,1)~=location(col,1)&&location(row,1)~=location(col,2)&&location(row,2)~=location(col,1)&&location(row,2)~=location(col,2)
                        if item_table(row,1)~=item_table(col,1)&&item_table(row,1)~=item_table(col,2)&&item_table(row,2)~=item_table(col,1)&&item_table(row,2)~=item_table(col,2)
                            inde_b = inde_b+1;
                            baseline(inde_b,1) = Similarity(row,col);
                            flag =1;
                        end
                    end
                    
                    if flag == 0
                        inde_z = inde_z+1;
                        Z(inde_z,1) = Similarity(row,col);
                    end
                    
                    
                    
                end
            end
            %             One = ones(inde,1);
            
            %                                             %% remove outlier
            %                                             mean_S = mean(Y);
            %                                             std_S = std(Y);
            %                                             max = mean_S+2*std_S;
            %                                             min = mean_S-2*std_S;
            %             %                                 Similarity([max;min],:)=[];
            %             %                                 One([max;min],:)=[];
            %                                             item1(find(item1(:,1)>max),:)=[];
            %                                             item2(find(item2(:,1)>max),:)=[];
            %                                             location1(find(location1(:,1)>max),:)=[];
            %                                             location2(find(location2(:,1)>max),:)=[];
            %                                             combination1(find(combination1(:,1)>max),:)=[];
            %                                             combination2(find(combination2(:,1)>max),:)=[];
            %                                             similar(find(similar(:,1)>max),:)=[];
            %                                             baseline(find(baseline(:,1)>max),:)=[];
            %
            %                                              item1(find(item1(:,1)<min),:)=[];
            %                                             item2(find(item2(:,1)<min),:)=[];
            %                                             location1(find(location1(:,1)<min),:)=[];
            %                                             location2(find(location2(:,1)<min),:)=[];
            %                                             combination1(find(combination1(:,1)<min),:)=[];
            %                                             combination2(find(combination2(:,1)<min),:)=[];
            %                                             similar(find(similar(:,1)<min),:)=[];
            %                                             baseline(find(baseline(:,1)<min),:)=[];
            %
            
            
            r_pho(nsub,nsess,1) = mean(item1);
            r_pho(nsub,nsess,2) = mean(item2);
            r_pho(nsub,nsess,3) = mean(location1);
            r_pho(nsub,nsess,4) = mean(location2);
            r_pho(nsub,nsess,5) = mean(combination1);
            r_pho(nsub,nsess,6) = mean(combination2);
            r_pho(nsub,nsess,7) = mean(similar);
            r_pho(nsub,nsess,8) = mean(baseline);
            r_pho(nsub,nsess,9) = mean(first);
            r_pho(nsub,nsess,10) = mean(second);
            r_pho(nsub,nsess,11) = mean(fs);
            r_pho(nsub,nsess,12) = mean(sf);
            r_pho(nsub,nsess,13) = mean(item11);
            r_pho(nsub,nsess,14) = mean(item22);
            r_pho(nsub,nsess,15) = mean(location11);
            r_pho(nsub,nsess,16) = mean(location22);
        end
    end
%     r_z = r_pho;
%     mkdir([global_path,'fMRI\RSA_fixation_separate\result\ROI\model8 result\',ROI_name{nROI},'\']);
%     save([global_path,'fMRI\RSA_fixation_separate\result\ROI\model8 result\',ROI_name{nROI},'\r_z.mat'],'r_z');
%     %     save(['D:\documents\Naya lab\RSA_fixation_separate\ROI\model8 result\',ROI_name{nROI},'\stats1_p.mat'],'stats1_p');
%     %     save(['D:\documents\Naya lab\RSA_fixation_separate\ROI\model8 result\',ROI_name{nROI},'\stats2_p.mat'],'stats2_p');
%     r_z([1 6 11],:,:)=[];
%     r_z = mean(r_z,2);
%     %         r_z = reshape(r_z,14,8);
%     
%     [a1 b1 c1] = ttest(r_z(:,1,13),r_z(:,1,8));
%     pvalue(3,nROI) = b1;
%     [a2 b2 c2] = ttest(r_z(:,1,14),r_z(:,1,8));
%     pvalue(4,nROI) = b2;
%     [a3 b3 c3] = ttest(r_z(:,1,15),r_z(:,1,8));
%     pvalue(5,nROI) = b3;
%     [a4 b4 c4] = ttest(r_z(:,1,16),r_z(:,1,8));
%     pvalue(6,nROI) = b4;
%     [a5 b5 c5] = ttest(r_z(:,1,5),r_z(:,1,8));
%     pvalue(7,nROI) = b5;
%     
 end
% 
% % pvalue([1:5 7:10],:)=[];
% % P = zeros(45,3);
% % for i = 1:9
% %     for m = ((i-1)*5+1):(i*5)
% %         P(m,1) = pvalue(m-(i-1)*5,i);
% %         P(m,2) = i;
% %         P(m,3) = m-(i-1)*5;
% %     end
% % end
% % save(['D:\documents\Naya lab\RSA_fixation_separate\ROI\model8 result\pvalue.mat'],'pvalue');
% % save(['D:\documents\Naya lab\RSA_fixation_separate\ROI\model8 result\P.mat'],'P');
% 
% % save(['D:\documents\Naya lab\RSA_fixation_separate\ROI\model8 result\FDR_P.mat'],'FDR_P');
% 
% % % pvalue = pvalue*9;
% % for i = 1:5
% %     for m = 1:9
% %         if pvalue(m,i)<0.05/5
% %             sig(m,i) = 1;
% %         else
% %             sig(m,i) = 0;
% %         end
% %     end
% % end
% 






