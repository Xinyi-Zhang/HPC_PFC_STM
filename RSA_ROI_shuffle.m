global_path = 'F:\';

%% shuffle
% permute for each sub, each session, each ROI, each condition
% get Bvalue, nvoxel*ntrial
% two sample functional ROI
% ROI_name = {'Rectus_inter','Rectus_vm','lPRC_-20_-4_-32','lOFC_-20_42_-10','rIFG_50_22_22','rMFG_36_52_10','rmSFG_18_42_46','lmSFG_-12_66_10','MCC_2_2_38'};
% one sample functional ROI
% ROI_name ={'rSTG_40_-42_2','rPHC_28_-32_-10','rMTC_60_-38_-8','rPrecuneus_12_-56_38','rSFC_24_66_-2'};
%final anatomical ROI
% ROI_name = {'rHPC_manual','rSFC_aal','rmSFC','rFrontal_mOrb','rMFC'};
% % ROI_name = {'arSFC','prSFC','arSFC2','prSFC2'};
% %supplementary ROI
%  ROI_name = {'lHPC','lmSFC','lFrontal_mOrb'};
% two sample anatomical ROI
% ROI_name = {'lRectus','rRectus','PRc','rMFC','rIFC_oper','rIFC_tri','lMCC','rMCC','rSMA','lSMA','lIOFC','lSOFC'};
% one sample anatomical ROI
%  ROI_name = {'rHPC_manual','PHc','rSFC_aal','rSTC','rMTC','rITC','rPrecuneus'};
ROI_name = {'lmSFC','lFrontal_mOrb','rMFC','lIOFC','rmSFC','rFrontal_mOrb'};

for nROI = 1:6
    perm_result = zeros(17,2,8,5000);
    for nsub = [2:5 7:10 12:17]
        for nsess = 1:2
            load([global_path,'fMRI\4-RSA_fixation_separate\result\ROI\',ROI_name{nROI},'\',num2str(nsub),'-',num2str(nsess),'-Bvalue_z2.mat']);
            Bvalue = Bvalue_z2;
            for nperm = 1:5000
                A = randperm(64);
                Bvalue_r = Bvalue(:,A);
                Similarity = corr(Bvalue_r);
                % Fisher'z transformation
                Similarity = 0.5 * (log((1+Similarity)./(1-Similarity)));
                
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
                inde = 0;
                fs = [];
                sf = [];
                inde_f = 0;
                inde_ss = 0;
                inde_sf = 0;
                inde_fs = 0;
                inde_i1 = 0;
                inde_i2 = 0;
                inde_l1 = 0;
                inde_l2 = 0;
                inde_c1 = 0;
                inde_c2 = 0;
                inde_b = 0;
                inde_s = 0;
                location11 = [];
            location22 = [];
            inde_l11 = 0;
            inde_l22 = 0;
            item11 = [];
            item22 = [];
            inde_i11 = 0;
            inde_i22 = 0;
                for row = 1:63
                    for col = 1+row:64
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
                            end
                        end
                        
                        if item_table(row,1)~=item_table(col,1)&&item_table(row,1)~=item_table(col,2)&&item_table(row,2)~=item_table(col,1)&&item_table(row,2)~=item_table(col,2)
                            if location(row,1)==location(col,1)||location(row,1)==location(col,2)||location(row,2)==location(col,1)||location(row,2)==location(col,2)
                                inde_l1 = inde_l1+1;
                                location1(inde_l1,1) =Similarity(row,col);
                            end
                        end
                        
                        if item_table(row,1)==item_table(col,1)&&item_table(row,2)~=item_table(col,2)
                            if location(row,1)==location(col,1)&&location(row,2)~=location(col,2)
                                inde_c1 = inde_c1+1;
                                combination1(inde_c1,1) = Similarity(row,col);
                            end
                        end
                        if item_table(row,1)==item_table(col,2)&&item_table(row,2)~=item_table(col,1)
                            if location(row,1)==location(col,2)&&location(row,2)~=location(col,1)
                                inde_c1 = inde_c1+1;
                                combination1(inde_c1,1) = Similarity(row,col);
                            end
                        end
                        if item_table(row,2)==item_table(col,1)&&item_table(row,1)~=item_table(col,2)
                            if location(row,2)==location(col,1)&&location(row,1)~=location(col,2)
                                inde_c1 = inde_c1+1;
                                combination1(inde_c1,1) = Similarity(row,col);
                            end
                        end
                        if item_table(row,2)==item_table(col,2)&&item_table(row,1)~=item_table(col,1)
                            if location(row,2)==location(col,2)&&location(row,1)~=location(col,1)
                                inde_c1 = inde_c1+1;
                                combination1(inde_c1,1) = Similarity(row,col);
                            end
                        end
                        
                        if output_table{row,2}==output_table{col,2}&&location(row,1)~=location(col,1)&&location(row,1)~=location(col,2)&&location(row,2)~=location(col,1)&&location(row,2)~=location(col,2)
                            inde_i2 = inde_i2+1;
                            item2(inde_i2,1) = Similarity(row,col);
                        end
                        
                        if item_table(row,1)~=item_table(col,1)&&item_table(row,1)~=item_table(col,2)&&item_table(row,2)~=item_table(col,1)&&item_table(row,2)~=item_table(col,2)&&output_table{row,3}==output_table{col,3}
                            inde_l2 = inde_l2+1;
                            location2(inde_l2,1) = Similarity(row,col);
                        end
                        
                        if output_table{row,2}==output_table{col,2}&&output_table{row,3}==output_table{col,3}
                            if item_table(col,1)==item_table(row,2)&&location(col,1)==location(row,2)
                                inde_c2 = inde_c2+1;
                                combination2(inde_c2,1) = Similarity(row,col);
                            elseif item_table(row,1)==item_table(col,2)&&location(row,1)==location(col,2)
                                inde_c2 = inde_c2+1;
                                combination2(inde_c2,1) = Similarity(row,col);
                            end
                            
                            if item_table(col,1)==item_table(row,1)&&location(col,1)~=location(row,1)
                                inde_s = inde_s+1;
                                similar(inde_s,1) = Similarity(row,col);
                            end
                            
                            if item_table(col,1)~=item_table(row,1)&&location(col,1)==location(row,1)
                                inde_s = inde_s+1;
                                similar(inde_s,1) = Similarity(row,col);
                            end
                        end
                        
                        if location(row,1)~=location(col,1)&&location(row,1)~=location(col,2)&&location(row,2)~=location(col,1)&&location(row,2)~=location(col,2)
                            if item_table(row,1)~=item_table(col,1)&&item_table(row,1)~=item_table(col,2)&&item_table(row,2)~=item_table(col,1)&&item_table(row,2)~=item_table(col,2)
                                inde_b = inde_b+1;
                                baseline(inde_b,1) = Similarity(row,col);
                            end
                        end
                        
                    end
                end
                
                perm_result(nsub,nsess,1,nperm) = mean(item1);
                perm_result(nsub,nsess,2,nperm) = mean(item2);
                perm_result(nsub,nsess,3,nperm) = mean(location1);
                perm_result(nsub,nsess,4,nperm) = mean(location2);
                perm_result(nsub,nsess,5,nperm) = mean(combination1);
                perm_result(nsub,nsess,6,nperm) = mean(combination2);
                perm_result(nsub,nsess,7,nperm) = mean(similar);
                perm_result(nsub,nsess,8,nperm) = mean(baseline);
                perm_result(nsub,nsess,9,nperm) = mean(first);
                perm_result(nsub,nsess,10,nperm) = mean(second);
                perm_result(nsub,nsess,11,nperm) = mean(fs);
                perm_result(nsub,nsess,12,nperm) = mean(sf);
                perm_result(nsub,nsess,13,nperm) = mean(item11);
                perm_result(nsub,nsess,14,nperm) = mean(item22);
                perm_result(nsub,nsess,15,nperm) = mean(location11);
                perm_result(nsub,nsess,16,nperm) = mean(location22);
                
                disp(nperm)
            end
        end
    end
    perm_baseline = mean(perm_result,4);
    save([global_path,'fMRI\4-RSA_fixation_separate\result\ROI\',ROI_name{nROI},'\perm_result_z.mat'],'perm_result');
end

% ROI_name = {'Rectus_inter','Rectus_vm','lPRC_-20_-4_-32','MCC_2_2_38','lOFC_-20_42_-10','rIFG_50_22_22','rMFG_36_52_10','rmSFG_18_42_46','lmSFG_-12_66_10'};
for nROI = 1:2
    load([global_path,'fMRI\4-RSA_fixation_separate\result\ROI\',ROI_name{nROI},'\perm_result_z.mat']);
    load([global_path,'fMRI\4-RSA_fixation_separate\result\ROI\model8 result\',ROI_name{nROI},'\r_z.mat']);
    r_z([1 6 11],:,:)=[];
    perm_baseline = mean(perm_result,4);
    perm_baseline([1 6 11],:,:)=[];
    r_z = mean(r_z,2);
    perm_baseline = mean(perm_baseline,2);
    r_z = reshape(r_z,14,16);
    perm_baseline = reshape(perm_baseline,14,16);
    r_BaseCorrected_z_allsub = r_z - perm_baseline;
    save([global_path,'fMRI\4-RSA_fixation_separate\result\ROI\model8 result\',ROI_name{nROI},'\r_BaseCorrected_z_allsub.mat'],'r_BaseCorrected_z_allsub');
end

% pvalue = zeros(8,9);
% for nROI = 1
%     load(['D:\documents\Naya lab\RSA_fixation_separate\ROI\model8 result\',ROI_name{nROI},'\r_BaseCorrected_z_allsub.mat']);
%     baseline = zeros(14,1);
%     for i = 1:8
%         [a b c] = ttest(r_BaseCorrected_z_allsub(:,i),baseline);
%         pvalue(i,nROI) = b;
%     end
% end


% sig = zeros(8,9);
% for a = 1:8
%     for b = 1:4
%         if pvalue(a,b)<0.05/4
%             sig(a,b) = 1;
%         end
%     end
% end

% pvalue = zeros(6,9);
% for nROI = 1:4
%     load([global_path,'fMRI\4-RSA_fixation_separate\result\ROI\model8 result\',ROI_name{nROI},'\r_BaseCorrected_z_allsub.mat']);
%     [a1 b1 c1 stats] = ttest(r_BaseCorrected_z_allsub(:,5),r_BaseCorrected_z_allsub(:,8));
%     pvalue(1,nROI) = b1;
%     [a2 b2 c2 stats] = ttest(r_BaseCorrected_z_allsub(:,1),r_BaseCorrected_z_allsub(:,8));
%     pvalue(2,nROI) = b2;
%     [a3, b3 c3 stats] = ttest(r_BaseCorrected_z_allsub(:,3),r_BaseCorrected_z_allsub(:,8));
%     pvalue(3,nROI) = b3;
%     [a4 b4 c4 stats] = ttest(r_BaseCorrected_z_allsub(:,4),r_BaseCorrected_z_allsub(:,8));
%     pvalue(4,nROI) = b4;
%     [a5 b5 c5] = ttest(r_BaseCorrected_z_allsub(:,5),r_BaseCorrected_z_allsub(:,8));
%     pvalue(5,nROI) = b5;
%     [a6 b6 c6 stats] = ttest(r_BaseCorrected_z_allsub(:,6),r_BaseCorrected_z_allsub(:,8));
%     pvalue(6,nROI) = b6;
%     [a7 b7 c7] = ttest(r_BaseCorrected_z_allsub(:,9),r_BaseCorrected_z_allsub(:,8));
%     pvalue(7,nROI) = b7;
%     [a8 b8 c8 stats] = ttest(r_BaseCorrected_z_allsub(:,10),r_BaseCorrected_z_allsub(:,8));
%     pvalue(8,nROI) = b8;
%     %     [a3 b3 c3] = ttest(r_BaseCorrected_z_allsub(:,5),r_BaseCorrected_z_allsub(:,8));
%     %     pvalue(9,nROI) = b3;
% end

% sig = zeros(6,9);
% for a = 1:7
%     for b = 1:7
%         if pvalue(a,b)<0.05/7
%             sig(a,b) = 1;
%         end
%     end
% end