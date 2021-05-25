function fmri_MTLinSTM2_NEW
%main experiment for fMRI
%1024 X 768 resolution
global SubNumber Item win x y
try
    %%participan information
    getsubinfo;
    
    %%时间参数，便于调试
    T_long_fixation=2;
    T_object=0.8;
    T_blank=0.2;
    T_fixation=1;
    T_probe_screen=3;
    T_confidence=6;
    
    %              T_long_fixation=0.1;
    %             T_object=0.5;
    %             T_blank=0.1;
    %             T_fixation=0.1;
    %             T_long_delay=0.1;
    %             T_probe_screen=0.1;
    %             T_ReactionTime=0.1;
    %             T_confidence=0.1;
    %              T_ITI=0.01;
    %
    
    %%define buttons
    KbName('UnifyKeyNames');
    startup=KbName('s');
    stop=KbName('q');
    escape = KbName('ESCAPE');
    Yes = KbName('y');
    No = KbName('n');
    One=KbName('1!');
    Two=KbName('2@');
    Three=KbName('3#');
    Four=KbName('4$');
    Up=KbName('u');
    Down=KbName('d');
    
    %%define color
    BackgroundColor=[232,239,245];
    DarkerColor=[120,120,120];
    LighterColor=[160,160,160];
    FixationColor=[0,0,0];
    
    
    %%initiated
    Screen('Preference', 'SkipSyncTests', 1);
    HideCursor;
    % InitializeMatlabOpenGL;
    [win,wrect]=Screen('OpenWindow',0,BackgroundColor);%打开窗口，调节颜色，全屏实验
    Screen('BlendFunction', win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);%%%%%%%%%%%%%%%%%%%%%%%
    Screen('TextFont',win,'Calibri');%设置字体
    Screen('TextSize',win,28);%设置字号
    %为了提高时间精度
    IFI=Screen('GetFlipInterval', win)/2;
    topPriorityLevel=MaxPriority(win);
    Priority(topPriorityLevel);
    
    %%define items
    ItemForMTL2(3)
    
    %     %%随机种子
    %     rng shuffle;
    %
    %%defien parameters
    x=wrect(3);
    y=wrect(4);
    dx=x/8;   %dx是项目距离中心点的横向距离
    dy=y/4; %dy是圆盘距离中心点的距离76
    Cy=y/2;
    RI=50;  %项目大小
    RC=40;  %圆的大小
    VerOrHor=mod(SubNumber,8); %1-4是竖直的，5-8是水平的
    DiskSetting=mod(SubNumber,4);
    
    %%define trial coditions
    ObjectSetting=ones(64,1);
    ObjectSetting(17:32,1)=2;
    ObjectSetting(33:48,1)=3;
    ObjectSetting(49:64,1)=4;
    LocationSetting=ones(16,1);
    LocationSetting(5:8,1)=2;
    LocationSetting(9:12,1)=3;
    LocationSetting(13:16,1)=4;
    %1-4列分别是，项目，位置，交换，时间
    TrialCondition=[ObjectSetting,repmat(LocationSetting,4,1),repmat([1;1;2;2],16,1),repmat([1;2],32,1)];
    TrialCondition=TrialCondition(randperm(size(TrialCondition,1)),:);
    MatchSetting=zeros(64,1);
    %10个object错误（1），10个location错误（2），12个exchange错误（3）
    MatchSetting(33:42,1)=1;
    MatchSetting(43:52,1)=2;
    MatchSetting(53:64,1)=3;
    MatchSetting=MatchSetting(randperm(size(MatchSetting,1)),:);
    TiltedOrNot=[3;-3;-1;1];
    TiltedOrNot=repmat(TiltedOrNot,16,1);
    TiltedOrNot=TiltedOrNot(randperm(size(TiltedOrNot,1)),:);
    TrialCondition=[TrialCondition,TiltedOrNot,MatchSetting];
    %第5列是倾斜不倾斜，完全随机，并且1-64和65-128完全一样
    %前64个是正确的，后64个不正确，这样正确和不正确就做好了counterbalance
    
    %设计按键
    ChoiceButton=repmat([1,2;2,1],32,1);
    
    %%test screen
    DrawFormattedText(win,'Please fixate on the cross','center',Cy+50,[0 0 0]);
    Screen('Flip',win);
    WaitSecs(1);
    Screen('DrawLine',win,FixationColor,x/2-10,Cy,x/2+10,Cy,2 );
    Screen('DrawLine',win,FixationColor,x/2,Cy-10,x/2,Cy+10,2 );
    Screen('Flip',win);
    while 1
        [KeyIsDown, secs, keyCode] = KbCheck;
        if keyCode(Up)
            Cy=Cy-5;
            Screen('DrawLine',win,FixationColor,x/2-10,Cy,x/2+10,Cy,2 );
            Screen('DrawLine',win,FixationColor,x/2,Cy-10,x/2,Cy+10,2 );
            Screen('Flip',win);
            WaitSecs(0.2);
        elseif keyCode(Down)
            Cy=Cy+5;
            Screen('DrawLine',win,FixationColor,x/2-10,Cy,x/2+10,Cy,2 );
            Screen('DrawLine',win,FixationColor,x/2,Cy-10,x/2,Cy+10,2 );
            Screen('Flip',win);
            WaitSecs(0.2);
        elseif keyCode(Yes)
            break;
        elseif keyCode(escape)
            sca
            return
        end
    end
    
    
    %位置矩阵，同时考虑，设置水平还是竖直
    if (0 <VerOrHor) &&(VerOrHor<5)
        Position=[x/2-dx,Cy-dy,x/2+dx,Cy-dy;...
            x/2-dx,Cy+dy,x/2+dx,Cy+dy;...
            x/2-dx,Cy-dy,x/2+dx,Cy+dy;...
            x/2-dx,Cy+dy,x/2+dx,Cy-dy];
    else
        Position=[x/2-dx,Cy-dy,x/2-dx,Cy+dy;...
            x/2+dx,Cy-dy,x/2+dx,Cy+dy;...
            x/2-dx,Cy-dy,x/2+dx,Cy+dy;...
            x/2-dx,Cy+dy,x/2+dx,Cy-dy];
    end
    %在这里确定被试间的圆盘设计
    %第一个被试，先上后下，先深后浅
    %第二个被试，先上后下，先浅后深
    %第三个被试，先下后上，先深后浅
    %第四个被试，先下后上，先浅后深
    if (0 < VerOrHor) &&(VerOrHor<5)
        if DiskSetting==1
            Disk1Color=DarkerColor;
            Disk1Rect=[x/2-RC,Cy-dy/2-RC,x/2+RC,Cy-dy/2+RC];
            Disk2Color=LighterColor;
            Disk2Rect=[x/2-RC,Cy+dy/2-RC,x/2+RC,Cy+dy/2+RC];
        elseif DiskSetting==2
            Disk1Color=LighterColor;
            Disk1Rect=[x/2-RC,Cy-dy/2-RC,x/2+RC,Cy-dy/2+RC];
            Disk2Color=DarkerColor;
            Disk2Rect=[x/2-RC,Cy+dy/2-RC,x/2+RC,Cy+dy/2+RC];
        elseif DiskSetting==3
            Disk1Color=DarkerColor;
            Disk1Rect=[x/2-RC,Cy+dy/2-RC,x/2+RC,Cy+dy/2+RC];
            Disk2Color=LighterColor;
            Disk2Rect=[x/2-RC,Cy-dy/2-RC,x/2+RC,Cy-dy/2+RC];
        else
            Disk1Color=LighterColor;
            Disk1Rect=[x/2-RC,Cy+dy/2-RC,x/2+RC,Cy+dy/2+RC];
            Disk2Color=DarkerColor;
            Disk2Rect=[x/2-RC,Cy-dy/2-RC,x/2+RC,Cy-dy/2+RC];
        end
    else
        if DiskSetting==1
            Disk1Color=DarkerColor;
            Disk1Rect=[x/2-dx/2-RC,Cy-RC,x/2-dx/2+RC,Cy+RC];
            Disk2Color=LighterColor;
            Disk2Rect=[x/2+dx/2-RC,Cy-RC,x/2+dx/2+RC,Cy+RC];
        elseif DiskSetting==2
            Disk1Color=LighterColor;
            Disk1Rect=[x/2-dx/2-RC,Cy-RC,x/2-dx/2+RC,Cy+RC];
            Disk2Color=DarkerColor;
            Disk2Rect=[x/2+dx/2-RC,Cy-RC,x/2+dx/2+RC,Cy+RC];
        elseif DiskSetting==3
            Disk1Color=DarkerColor;
            Disk1Rect=[x/2+dx/2-RC,Cy-RC,x/2+dx/2+RC,Cy+RC];
            Disk2Color=LighterColor;
            Disk2Rect=[x/2-dx/2-RC,Cy-RC,x/2-dx/2+RC,Cy+RC];
        else
            Disk1Color=LighterColor;
            Disk1Rect=[x/2+dx/2-RC,Cy-RC,x/2+dx/2+RC,Cy+RC];
            Disk2Color=DarkerColor;
            Disk2Rect=[x/2-dx/2-RC,Cy-RC,x/2-dx/2+RC,Cy+RC];
        end
    end
    
    
    
    
    
    
    %% Eyelink-STEP 1
    % Initialization of the connection with the Eyelink Gazetracker.
    % exit program if this fails.
    initializedummy=0;
    if initializedummy~=1 %
        if Eyelink('initialize') ~= 0 %%%%%%%%%%%%%%%等于0的时候正常初始化
            fprintf('error in connecting to the eye tracker');
            return;
        end
    else
        Eyelink('initializedummy');   %%%%%%%%%%%%%%%%%将眼动仪设成哑模式，在不调用眼动的情况下调试实验程序
    end
    edfFile=ForEyelink;
    
    
    
    
    
    %%get start
    for SessionN=1:2
        T_ITI=8;
        if SessionN==2%%%休息
            DrawFormattedText(win,'Now you can take a rest\n\npress 1 to continue','center',Cy,[0 0 0]);
            Screen('Flip',win);
            while 1
                [KeyIsDown, secs, keyCode] = KbCheck;
                if keyCode(One)
                    break;
                elseif keyCode(escape)
                    sca
                    return
                end
            end
            
            %re calibration
            DrawFormattedText(win,'Please wait for calibration','center',Cy,[0 0 0]);
            Screen('Flip',win);
            while 1
                [ K, a, keyCode] = KbCheck;
                if keyCode(Yes)
                    ForEyelink;
                    break
                elseif keyCode(No)
                    break
                end
            end
        end
        
        %不同session打乱trial顺序
        TrialCondition=TrialCondition(randperm(size(TrialCondition,1)),:);
        ChoiceButton=ChoiceButton(randperm(size(ChoiceButton,1)),:);
        
        %%还没有开记录结果的矩阵和记录时间的矩阵
        Result=(-1)*ones(65,13);
        TimePoint=zeros(65,10);
        
        DrawFormattedText(win,'Please get prepared','center',Cy,[0 0 0]);
        Screen('Flip',win);
        while 1
            [keyIsDown, secs1, keyCode] = KbCheck;
            
            if keyCode(startup) % 's'键触发
                Onset=secs1; %计时起点
                TimePoint(1,1)=Onset;
                break;
            elseif keyCode(stop)==1
                Screen('CloseAll');
            end
            
        end
        
        %加一个8秒的空白
        
        t_ITI=Screen('Flip',win);
        TimePoint(1,2)= t_ITI-Onset;
        
        %%开始实验
        for m=1:64
            %% STEP 7.3 Start recording in a trial-by-trial manner.
            % start recording eye position (preceded by a short pause so that
            % the tracker can finish the mode transition)
            % The paramerters for the 'StartRecording' call controls the
            % file_samples, file_events, link_samples, link_events availability
            
            Eyelink('Command', 'set_idle_mode');
            
            Eyelink('StartRecording', 1, 1, 1, 1);
            % record a few samples before we actually start displaying
            % otherwise you may lose a few msec of data
            
            ItemSet=TrialCondition(m,1);%选定要用的项目行
            TemporalOrder=TrialCondition(m,4);
            PlaceSet=TrialCondition(m,2);
            LocationExchange=TrialCondition(m,3);
            Tilted=TrialCondition(m,5);
            MatchOrNot=TrialCondition(m,6);
            if LocationExchange==1%如果不交换，项目1在位置1，项目2在位置2；如果交换，项目1在位置2，项目2在位置1.
                %所以再考虑过location-exchange之后，项目和位置点就已经绑定了
                Rectx1=Position(PlaceSet,1);
                Recty1=Position(PlaceSet,2);
                Rectx2=Position(PlaceSet,3);
                Recty2=Position(PlaceSet,4);
            else
                Rectx1=Position(PlaceSet,3);
                Recty1=Position(PlaceSet,4);
                Rectx2=Position(PlaceSet,1);
                Recty2=Position(PlaceSet,2);
            end
            
            %开始呈现
            %第一幕，注视点
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%注视点的坐标后面再改
            Screen('DrawLine',win,FixationColor,x/2-10,Cy,x/2+10,Cy,2 );
            Screen('DrawLine',win,FixationColor,x/2,Cy-10,x/2,Cy+10,2 );
            t_fixation1=Screen('Flip',win,t_ITI+T_ITI-IFI);
            TimePoint(m+1,1)=t_fixation1-Onset;
            %
            Eyelink('Message', ['trial_' num2str(m) '_fix1_onset']);
            %
            
            %第二幕，呈现红色圆盘
            Screen('FillOval',win,Disk1Color,Disk1Rect);
            t_disk1=Screen('Flip',win,t_fixation1+T_long_fixation-IFI);
            TimePoint(m+1,2)= t_disk1-Onset;
            %
            Eyelink('Message', ['trial_' num2str(m) '_disk1_onset']);
            %
            
            %空白屏
            
            t_blank1=Screen('Flip',win,t_disk1+T_object-IFI);
            %
            Eyelink('Message', ['trial_' num2str(m) '_blank1_onset']);
            %
            
            TimePoint(m+1,3)=t_blank1-Onset;
            %注视点
            Screen('DrawLine',win,FixationColor,x/2-10,Cy,x/2+10,Cy,2 );
            Screen('DrawLine',win,FixationColor,x/2,Cy-10,x/2,Cy+10,2 );
            t_fixation2=Screen('Flip',win,t_blank1+T_blank-IFI);
            TimePoint(m+1,4)=t_fixation2-Onset;
            %
            Eyelink('Message', ['trial_' num2str(m) '_fixation2_onset']);
            %
            
            %第三幕，呈现第一个物体,
            %如果Temporal=1，就先呈现项目1
            if TemporalOrder==1
                Screen('DrawTexture',win,Item{ItemSet,1},[],[Rectx1-RI,Recty1-RI,Rectx1+RI,Recty1+RI]);
            else
                Screen('DrawTexture',win,Item{ItemSet,2},[],[Rectx2-RI,Recty2-RI,Rectx2+RI,Recty2+RI]);
            end
            t_item1=Screen('Flip',win,t_fixation2+T_fixation-IFI);
            TimePoint(m+1,5)=t_item1-Onset;
            %
            Eyelink('Message', ['trial_' num2str(m) '_item1_onset']);
            %
            
            %空白屏
            
            t_blank2=Screen('Flip',win,t_item1+T_object-IFI);
            TimePoint(m+1,6)=t_blank2-Onset;
            %
            Eyelink('Message', ['trial_' num2str(m) '_blank2_onset']);
            %
            
            %注视点
            Screen('DrawLine',win,FixationColor,x/2-10,Cy,x/2+10,Cy,2 );
            Screen('DrawLine',win,FixationColor,x/2,Cy-10,x/2,Cy+10,2 );
            t_fixation3=Screen('Flip',win,t_blank2+T_blank-IFI);
            TimePoint(m+1,7)=t_fixation3-Onset;
            %
            Eyelink('Message', ['trial_' num2str(m) '_fixation3_onset']);
            %
            
            %呈现第二个物体
            if TemporalOrder==1
                Screen('DrawTexture',win,Item{ItemSet,2},[],[Rectx2-RI,Recty2-RI,Rectx2+RI,Recty2+RI]);
            else
                Screen('DrawTexture',win,Item{ItemSet,1},[],[Rectx1-RI,Recty1-RI,Rectx1+RI,Recty1+RI]);
            end
            t_item2=Screen('Flip',win,t_fixation3+T_fixation-IFI);
            TimePoint(m+1,8)=t_item2-Onset;
            %
            Eyelink('Message', ['trial_' num2str(m) '_item2_onset']);
            %
            
            %空白屏
            
            t_blank3=Screen('Flip',win,t_item2+T_object-IFI);
            TimePoint(m+1,9)=t_blank3-Onset;
            %
            Eyelink('Message', ['trial_' num2str(m) '_blank3_onset']);
            %
            
            %注视点
            Screen('DrawLine',win,FixationColor,x/2-10,Cy,x/2+10,Cy,2 );
            Screen('DrawLine',win,FixationColor,x/2,Cy-10,x/2,Cy+10,2 );
            t_fixation4=Screen('Flip',win,t_blank3+T_blank-IFI);
            TimePoint(m+1,10)=t_fixation4-Onset;
            %
            Eyelink('Message', ['trial_' num2str(m) '_fixation4_onset']);
            %
            
            %白色圆盘
            Screen('FillOval',win,Disk2Color,Disk2Rect);
            t_disk2=Screen('Flip',win,t_fixation4+T_fixation-IFI);
            TimePoint(m+1,11)=t_disk2-Onset;
            %
            Eyelink('Message', ['trial_' num2str(m) '_disk2_onset']);
            %
            
            %空白屏
            
            t_blank4=Screen('Flip',win,t_disk2+T_object-IFI);
            TimePoint(m+1,12)=t_blank4-Onset;
            %
            Eyelink('Message', ['trial_' num2str(m) '_blank4_onset']);
            %
            
            %注视点
            Screen('DrawLine',win,FixationColor,x/2-10,Cy,x/2+10,Cy,2 );
            Screen('DrawLine',win,FixationColor,x/2,Cy-10,x/2,Cy+10,2 );
            t_fixation5=Screen('Flip',win,t_blank4+T_blank-IFI);
            TimePoint(m+1,13)=t_fixation5-Onset;
            %
            Eyelink('Message', ['trial_' num2str(m) '_fixation5_onset']);
            %
            
            %最后一个长间隔
            %空白屏
            T_long_delay=4+2*rand;
            t_delay_blank=Screen('Flip',win,t_fixation5+T_fixation-IFI);
            TimePoint(m+1,14)=t_delay_blank-Onset;
            %
            Eyelink('Message', ['trial_' num2str(m) '_delay_blank_onset']);
            %
            
            %注视点
            Screen('DrawLine',win,FixationColor,x/2-10,Cy,x/2+10,Cy,2 );
            Screen('DrawLine',win,FixationColor,x/2,Cy-10,x/2,Cy+10,2 );
            t_delay_fixation=Screen('Flip',win,t_delay_blank+T_long_delay-IFI);
            %
            Eyelink('Message', ['trial_' num2str(m) '_delay_fixation_onset']);
            %
            TimePoint(m+1,15)=t_delay_fixation-Onset;
            
            %%呈现probe screen
            if MatchOrNot==1
                while 1
                    WrongItemSet=randi([1,4]);
                    if WrongItemSet~=ItemSet
                        break
                    end
                end
                ItemSet=WrongItemSet;
            elseif MatchOrNot==2
                while 1
                    WrongPlaceSet=randi([1,4]);
                    if WrongPlaceSet~=PlaceSet
                        break
                    end
                end
                PlaceSet=WrongPlaceSet;
                Rectx1=Position(PlaceSet,1);
                Recty1=Position(PlaceSet,2);
            elseif MatchOrNot==3
                if LocationExchange==2%如果不交换，项目1在位置1，项目2在位置2；如果交换，项目1在位置2，项目2在位置1.
                    %所以再考虑过location-exchange之后，项目和位置点就已经绑定了
                    Rectx1=Position(PlaceSet,1);
                    Recty1=Position(PlaceSet,2);
                else
                    Rectx1=Position(PlaceSet,3);
                    Recty1=Position(PlaceSet,4);
                end
            end
            Rotation=30*Tilted;
            %%设置probe screen
            %两个圆盘的坐标
            if (0 < VerOrHor) &&(VerOrHor<5)
                R2=((Rectx1-x/2)^2+(Recty1-Cy)^2)^0.5;
                R1=dy/2;
                RedRectx=x/2+R1*sind(Rotation);
                RedRecty=Cy-R1*cosd(Rotation);
                WhiteRectx=x/2-R1*sind(Rotation);
                WhiteRecty=Cy+R1*cosd(Rotation);
            else
                R1=dx/2;
                R2=((Rectx1-x/2)^2+(Recty1-Cy)^2)^0.5;
                RedRectx=x/2-R1*cosd(Rotation);
                RedRecty=Cy-R1*sind(Rotation);
                WhiteRectx=x/2+R1*cosd(Rotation);
                WhiteRecty=Cy+R1*sind(Rotation);
            end
            %其实这里还是应该用disk1和disk2，不过既然同时呈现，已经没有区分的必要了，
            %所以就用red和white代替了,red是上面那个或者左边那个，white是下面那个或者右边那个
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5%以y/2为参照点的那几个位置计算全部都得改
            if (0 < VerOrHor) &&(VerOrHor<5)
                if PlaceSet==4
                    if Rectx1>x/2
                        Beta=asind((Rectx1-x/2)/R2);
                        NewRectx1=x/2+R2*sind(Rotation+Beta);
                        NewRecty1=Cy-R2*cosd(Rotation+Beta);
                        NewRectx2=x/2-R2*sind(Rotation+Beta);
                        NewRecty2=Cy+R2*cosd(Rotation+Beta);
                    else
                        Beta=asind((x/2-Rectx1)/R2);
                        NewRectx2=x/2+R2*sind(Rotation+Beta);
                        NewRecty2=Cy-R2*cosd(Rotation+Beta);
                        NewRectx1=x/2-R2*sind(Rotation+Beta);
                        NewRecty1=Cy+R2*cosd(Rotation+Beta);
                    end
                elseif PlaceSet==3
                    if Rectx1<x/2
                        Beta=asind((x/2-Rectx1)/R2);
                        NewRectx1=x/2-R2*sind(Beta-Rotation);
                        NewRecty1=Cy-R2*cosd(Beta-Rotation);
                        NewRectx2=x/2+R2*sind(Beta-Rotation);
                        NewRecty2=Cy+R2*cosd(Beta-Rotation);
                    else
                        Beta=asind((Rectx1-x/2)/R2);
                        NewRectx2=x/2-R2*sind(Beta-Rotation);
                        NewRecty2=Cy-R2*cosd(Beta-Rotation);
                        NewRectx1=x/2+R2*sind(Beta-Rotation);
                        NewRecty1=Cy+R2*cosd(Beta-Rotation);
                    end
                elseif  PlaceSet==2
                    if Rectx1 > x/2
                        Beta=asind((Rectx1-x/2)/R2);
                        NewRectx2=x/2-R2*sind(Beta+Rotation);
                        NewRecty2=Cy+R2*cosd(Beta+Rotation);
                        NewRectx1=x/2+R2*sind(Beta-Rotation);
                        NewRecty1=Cy+R2*cosd(Beta-Rotation);
                    else
                        Beta=asind((x/2-Rectx1)/R2);
                        NewRectx1=x/2-R2*sind(Beta+Rotation);
                        NewRecty1=Cy+R2*cosd(Beta+Rotation);
                        NewRectx2=x/2+R2*sind(Beta-Rotation);
                        NewRecty2=Cy+R2*cosd(Beta-Rotation);
                    end
                    
                    
                elseif PlaceSet==1
                    if Rectx1 > x/2
                        Beta=asind((Rectx1-x/2)/R2);
                        NewRectx2=x/2-R2*sind(Beta-Rotation);
                        NewRecty2=Cy-R2*cosd(Beta-Rotation);
                        NewRectx1=x/2+R2*sind(Beta+Rotation);
                        NewRecty1=Cy-R2*cosd(Beta+Rotation);
                    else
                        Beta=asind((x/2-Rectx1)/R2);
                        NewRectx1=x/2-R2*sind(Beta+Rotation);
                        NewRecty1=Cy+R2*cosd(Beta+Rotation);
                        NewRectx2=x/2+R2*sind(Beta-Rotation);
                        NewRecty2=Cy+R2*cosd(Beta-Rotation);
                    end
                end
            else
                if PlaceSet==4
                    if Rectx1>x/2
                        Beta=asind((Rectx1-x/2)/R2);
                        NewRectx1=x/2+R2*sind(Rotation+Beta);
                        NewRecty1=Cy-R2*cosd(Rotation+Beta);
                        NewRectx2=x/2-R2*sind(Rotation+Beta);
                        NewRecty2=Cy+R2*cosd(Rotation+Beta);
                    else
                        Beta=asind((x/2-Rectx1)/R2);
                        NewRectx2=x/2+R2*sind(Rotation+Beta);
                        NewRecty2=Cy-R2*cosd(Rotation+Beta);
                        NewRectx1=x/2-R2*sind(Rotation+Beta);
                        NewRecty1=Cy+R2*cosd(Rotation+Beta);
                    end
                elseif PlaceSet==3
                    if Rectx1<x/2
                        Beta=asind((x/2-Rectx1)/R2);
                        NewRectx1=x/2-R2*sind(Beta-Rotation);
                        NewRecty1=Cy-R2*cosd(Beta-Rotation);
                        NewRectx2=x/2+R2*sind(Beta-Rotation);
                        NewRecty2=Cy+R2*cosd(Beta-Rotation);
                    else
                        Beta=asind((Rectx1-x/2)/R2);
                        NewRectx2=x/2-R2*sind(Beta-Rotation);
                        NewRecty2=Cy-R2*cosd(Beta-Rotation);
                        NewRectx1=x/2+R2*sind(Beta-Rotation);
                        NewRecty1=Cy+R2*cosd(Beta-Rotation);
                    end
                elseif  PlaceSet==2
                    if Recty1 < Cy
                        Beta=acosd((Rectx1-x/2)/R2);
                        NewRectx1=x/2+R2*cosd(Beta-Rotation);
                        NewRecty1=Cy-R2*sind(Beta-Rotation);
                        NewRectx2=x/2+R2*cosd(Beta+Rotation);
                        NewRecty2=Cy+R2*sind(Beta+Rotation);
                    else
                        Beta=acosd((Rectx1-x/2)/R2);
                        NewRectx2=x/2+R2*cosd(Beta-Rotation);
                        NewRecty2=Cy-R2*sind(Beta-Rotation);
                        NewRectx1=x/2+R2*cosd(Beta+Rotation);
                        NewRecty1=Cy+R2*sind(Beta+Rotation);
                    end
                elseif PlaceSet==1
                    if Recty1 < Cy
                        Beta=asind((Cy-Recty1)/R2);
                        NewRectx1=x/2-R2*cosd(Beta+Rotation);
                        NewRecty1=Cy-R2*sind(Beta+Rotation);
                        NewRectx2=x/2-R2*cosd(Beta-Rotation);
                        NewRecty2=Cy+R2*sind(Beta-Rotation);
                    else
                        Beta=asind((Recty1-Cy)/R2);
                        NewRectx2=x/2-R2*cosd(Beta+Rotation);
                        NewRecty2=Cy-R2*sind(Beta+Rotation);
                        NewRectx1=x/2-R2*cosd(Beta-Rotation);
                        NewRecty1=Cy+R2*sind(Beta-Rotation);
                    end
                end
            end
            
            if DiskSetting==1
                Screen('FillOval',win,DarkerColor,[RedRectx-RC,RedRecty-RC,RedRectx+RC,RedRecty+RC]);
                Screen('FillOval',win,LighterColor,[WhiteRectx-RC,WhiteRecty-RC,WhiteRectx+RC,WhiteRecty+RC]);
            elseif DiskSetting==0
                Screen('FillOval',win,DarkerColor,[RedRectx-RC,RedRecty-RC,RedRectx+RC,RedRecty+RC]);
                Screen('FillOval',win,LighterColor,[WhiteRectx-RC,WhiteRecty-RC,WhiteRectx+RC,WhiteRecty+RC]);
            elseif DiskSetting==2||3
                Screen('FillOval',win,LighterColor,[RedRectx-RC,RedRecty-RC,RedRectx+RC,RedRecty+RC]);
                Screen('FillOval',win,DarkerColor,[WhiteRectx-RC,WhiteRecty-RC,WhiteRectx+RC,WhiteRecty+RC]);
            end
            Screen('DrawTexture',win,Item{ItemSet,1},[],[NewRectx1-RI,NewRecty1-RI,NewRectx1+RI,NewRecty1+RI]);
            Screen('DrawTexture',win,Item{ItemSet,2},[],[NewRectx2-RI,NewRecty2-RI,NewRectx2+RI,NewRecty2+RI]);
            %      Answer=sprintf('%d',MatchOrNot);
            %      DrawFormattedText(win,Answer,10,10,[255 255 255]);
            t_ProbeScreen=Screen('Flip',win,t_delay_fixation+T_long_fixation-IFI);
            TimePoint(m+1,16)=t_ProbeScreen-Onset;
            %
            Eyelink('Message', ['trial_' num2str(m) '_ProbeScreen_onset']);
            %
            
            %%设置choice screen
            Choice=sprintf('Yes  %d\n\nNo  %d',ChoiceButton(m,1),ChoiceButton(m,2));
            DrawFormattedText(win,Choice,'center',Cy,[0 0 0]);
            t_ChoiceScreen=Screen('Flip',win,t_ProbeScreen+T_probe_screen-IFI);
            TimePoint(m+1,17)=t_ChoiceScreen-Onset;
            %
            Eyelink('Message', ['trial_' num2str(m) '_ChoiceScreen_onset']);
            %
            T_A=GetSecs;
            T_ReactionTime=4;
            while GetSecs-T_A<=4
                [a,secs,KC]= KbCheck;
                %                 secs=4*rand;
                %                 TimePoint(m+1,18)=GetSecs-Onset;
                %                  WaitSecs(secs);
                %                 Result(m,12)=randi([1,2]);
                %                 if Result(m,12)==1
                %                     KC(One)=1;
                %                 else
                %                     KC(Two)=1;
                %                 end
                TimePoint(m+1,18)=secs-Onset;
                
                if KC (One)
                    Result(m,12)=1;
                    if ChoiceButton(m,1)==1
                        if MatchOrNot==0
                            Result(m,8)=1;
                        else
                            Result(m,8)=0;
                        end
                    else
                        if MatchOrNot==0
                            Result(m,8)=0;
                        else
                            Result(m,8)=1;
                        end
                        
                    end
                    T_ReactionTime=GetSecs-T_A;
                    break
                end
                if KC (Two)
                    Result(m,12)=2;
                    if ChoiceButton(m,1)==1
                        if MatchOrNot==0
                            Result(m,8)=0;
                        else
                            Result(m,8)=1;
                        end
                    else
                        if MatchOrNot==0
                            Result(m,8)=1;
                        else
                            Result(m,8)=0;
                        end
                        
                    end
                    T_ReactionTime=GetSecs-T_A;
                    break
                end
                if KC(escape)
                    Eyelink('Command', 'set_idle_mode');
                    WaitSecs(0.1);% ######################################################
                    Eyelink('CloseFile'); % ? where to put ?
                    %close the eye tracker.
                    Eyelink('ShutDown');
                    %
                    sca
                    return;
                end
            end
            %
            Eyelink('Message', ['trial_' num2str(m) '_MakeChoice_onset']);
            %
            %
            %confidence level
            Confidence=sprintf('Please choose how confidence you are\n\n1-very unconfident      4-very confident');
            DrawFormattedText(win,Confidence,'center',Cy,[0 0 0]);
            t_ConfidenceLevel=Screen('Flip',win);
            TimePoint(m+1,19)= t_ConfidenceLevel-Onset;
            WaitSecs(0.3);
            %
            Eyelink('Message', ['trial_' num2str(m) '_ConfidenceScreen_onset']);
            %
            T_B=GetSecs;
            while GetSecs-T_B<=T_confidence
                [A,secs,KC]= KbCheck;
                %                 secs=6*rand;
                %                 TimePoint(m+1,20)=GetSecs-Onset;
                %                 WaitSecs(secs);
                %                 Result(m,13)=randi([1,4]);
                %                                 if Result(m,13)==1
                %                                     KC(One)=1;
                %                                 elseif Result(m,13)==2
                %                                     KC(Two)=1;
                %                                 elseif Result(m,13)==3
                %                                     KC(Three)=1;
                %                                 else
                %                                     KC(Four)=1;
                %                                 end
                TimePoint(m+1,20)=secs-Onset;
                if KC (One)
                    Result(m,10)=1;
                    break
                elseif KC (Two)
                    Result(m,10)=2;
                    break
                elseif KC(Three)
                    Result(m,10)=3;
                    break
                elseif KC(Four)
                    Result(m,10)=4;
                    break
                end
            end
            %
            Eyelink('Message', ['trial_' num2str(m) '_ChoiceConfidence_onset']);
            %
            %
            %%录入这个试次的数据
            %结果矩阵result，1-object,2-location,3-exchange,4-temporal,5-tilted,6-match
            %or not,7-rotation,8-performance,9-reaction time
            Result(m,1:6)=TrialCondition(m,1:6);
            Result(m,7)=Rotation;
            Result(m,9)=T_ReactionTime;
            Result(m,11)=ChoiceButton(m,1);
            %%performance
            Result(65,1)=mean(Result(1:m,8));  %performance
            Result(65,2)=mean(Result(1:m,9));  %反应时
            Result(65,3)=std(Result(1:m,9));  %反应时的标准差
            save(['result_for_Sub' num2str(SubNumber) '_session',num2str(SessionN),'.mat'],'Result');
            
            %%ITI
            imgArray=255*rand(y,x); % 生存雪花噪音纹理
            texid=Screen('MakeTexture',win,imgArray);
            Screen('DrawTexture',win,texid);
            t_ITI=Screen('Flip',win);
            TimePoint(m+1,21)=t_ITI-Onset;
            tic
            save(['timepoint_for_Sub' num2str(SubNumber) '_session',num2str(SessionN),'.mat'],'TimePoint');
            
            %
            Eyelink('Message', ['trial_' num2str(m) '_ITI_onset']);
            Eyelink('StopRecording');
            %
            T_ITI=4+2*rand;
            %    T_ITI=0.01;
            while toc<T_ITI
                [a,O,KC]= KbCheck;
                if KC(escape)
                    Eyelink('Command', 'set_idle_mode');
                    WaitSecs(0.1);% ######################################################
                    Eyelink('CloseFile'); % ? where to put ?
                    %close the eye tracker.
                    Eyelink('ShutDown');
                    %
                    sca
                    return;
                end
            end
        end
    end
    
    %这是结束部分`
    %% STEP 8
    % End of Experiment; close the file first
    % close graphics window, close data file and shut down tracker
    
    
    %眼动结束
    % End of Experiment; close the file first, close graphics window, close data file and shut down tracker
    Eyelink('Command', 'set_idle_mode');
    WaitSecs(0.5);
    Eyelink('CloseFile');
    
    % download data file
    try
        fprintf('Receiving data file ''%s''\n', edfFile );
        status=Eyelink('ReceiveFile');
        if status > 0
            fprintf('ReceiveFile status %d\n', status);%status 为文件大小，这句将返回文件大小，0表示传输过程被取消，负值表示错误代码
        end
        if 2==exist(edfFile, 'file')
            fprintf('Data file ''%s'' can be found in ''%s''\n', edfFile, pwd );
        end
    catch
        fprintf('Problem receiving data file ''%s''\n', edfFile );
    end
    
    
    Direction=sprintf('Experiment is over.\n\nPlease stay still and wait.');
    DrawFormattedText(win,Direction,'center','center',[0 0 0]);
    Screen('Flip',win);
    while 1
        [a,O,KC]= KbCheck;
        if KC(stop)
            break
        end
    end
    
    
    ShowCursor;
    Priority(0);
    sca
catch
    Screen('CloseAll');
    rethrow(lasterror)
end
