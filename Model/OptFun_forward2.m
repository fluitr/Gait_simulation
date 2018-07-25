function val = OptFun_forward(x)
%% This function runs the simulation for optimalisation
%% param
model = 'nms_3Dmodel';
    
assignin('base','param',x);
%%Dist List
v_d = 1;
dist_list = [128 0 ;....      %Sag
             0 128];                    %Front
% dist_list = [0; 0];
% Init
val_list = nan(1,size(dist_list,2));
t_end = 15;
%% Simulating
%% Try to prevent stop after error
try
    for i_dist = 1:size(dist_list,2)
        %% Forward/backward/Side pert
        cur_dist = dist_list(:,i_dist); 
        assignin('base','opt_dist',cur_dist);
        simOut = sim(model,...
            'SimulationMode', 'accelerator',...  
            'SrcWorkspace','base',...
            'ExternalInput','param',...
            'ExternalInput','opt_dist',...
            'SaveOutput','on','OutputSaveName','yout',...
            'SaveFormat', 'Dataset');
        outputs = simOut.get('yout');
        t = simOut.get('tout')';
        BodyInfo = outputs.get('data').Values.body_info.Data';
        positions = outputs.get('data').Values.positions.Data';
        stance = outputs.get('data').Values.stance.Data';
        bodyrot = outputs.get('data').Values.bodyrot.Data';
        muscle_power = outputs.get('data').Values.muscle_power.Data';
        pas_tor = outputs.get('data').Values.passive_torques.Data';
        tor = outputs.get('data').Values.torques.Data';
        grfs = outputs.get('data').Values.GRFs.Data';
        ja = outputs.get('data').Values.Angles.Data';
%         close_system
        % keyboard
        %% Loading data speed
        speed = BodyInfo(3,:);
        dist_tot_x = BodyInfo(2,end);
        side_drift = positions(3,end);
%           keyboard
        %% Cost function, part 1:
        if t(end) < t_end
            vept = abs(mean(speed) - v_d);
            val_list(i_dist) = 1000 - dist_tot_x;
%             keyboard
        else
            
%             %% Coordinates at HS Moments
            HS = find((stance(1,1:end-1) == 0 & stance(1,2:end) == 1) |...
                (stance(2,1:end-1) == 0 & stance(2,2:end) == 1));
            HSR = find(stance(2,1:end-1) == 0 & stance(2,2:end) == 1);
            HSL = find(stance(1,1:end-1) == 0 & stance(1,2:end) == 1);
            TOR = find(stance(2,1:end-1) == 1 & stance(2,2:end) == 0);
            TOL = find(stance(1,1:end-1) == 1 & stance(1,2:end) == 0);
            joint_co = positions([1:3 7:15 19:27 31:33],:); %% Removing velocities
            pos_HS = zeros(21,length(HS));  %PreAllocating
            
            %% Coverting to local axis
            for i_pos = 1:3:19
                pos_HS(i_pos:i_pos+2,:)=TransMat(bodyrot(1:9,HS),joint_co(i_pos:i_pos+2,HS),joint_co(22:24,HS),bodyrot(10,HS));
            end
            
            %% Mirroring right to left (each step is compared)
            mirror = ones(21,1);
            mirror(6:3:end) = -1;
            for i_HS = 1:length(HS)
                if sum(HS(i_HS) == HSR) == 1
                    pos_HS(:,i_HS) = pos_HS([1:3 13:21 4:12],i_HS).*mirror;
                end
            end
            
            %% Calculating difference (cartesian) between consequence steps
            diff = (pos_HS(:,1:end-1)-pos_HS(:,2:end)).^2;
            sum_diff = (diff(1:3:end-2,:) + diff(2:3:end-1,:) + diff(3:3:end,:)).^0.5;
            
            %% Timings
            t_steps = t(HS(2:end));
            
            %% Stability measure
            d_pre = mean(sum(sum_diff(:,t_steps>5 & t_steps<15)));
            d_post = mean(sum(sum_diff(:,t_steps>15 & t_steps<20)));
%             
            d_pre_ankles = mean(sum(sum_diff([2 5],t_steps>5 & t_steps<15)));
% %             d_post_ankles = mean(sum(sum_diff([2 5],t_steps>15 & t_steps<20)));
%             
%             %% Cost part 2
%             if d_pre > 0.03
%                 val_list(i_dist) = 1E2 + 100 * d_pre;
%             else
            %% comparison with Winter data
            W_ang = xlsread('winter.xls', 'JAt snf', 'A4:U54');
            W_GRF = xlsread('winter.xls', 'Ft snf', 'A4:S54');
            W_tor = xlsread('winter.xls', 'JTt snf', 'A4:W54');
            nsamples = 51;
            
            lpFilt = designfilt('lowpassfir','PassbandFrequency',0.005, ...
            'StopbandFrequency',0.1, 'DesignMethod','kaiserwin');
            if v_d < 1.2
                gt = 0;
            elseif v_d >= 1.2 & v_d < 1.5
                gt = 1;
            elseif v_d >= 1.5
                gt = 2;
            end
 
%             %GRFs left and right
%             for i_HSL = 1:length(HSL)-1
%                 ts = HSL(i_HSL);
%                 te = HSL(i_HSL+1); %TOR(find(TOR > HSR(i_HSR), 1, 'first'));
%                 v = ts:te;
%                 vq = ts:(te-ts)/(nsamples-1):te;
%                 vGRFL(i_HSL, 1:nsamples) = interp1(v, filtfilt(lpFilt,grfs(2, ts:te)), vq);
%             end
%             cc(1) = corr(W_GRF(:,2), mean(vGRFL)'/80);
%             
%             for i_HSR = 1:length(HSR)-1
%                 ts = HSR(i_HSR);
%                 te = HSR(i_HSR+1); %TOR(find(TOR > HSR(i_HSR), 1, 'first'));
%                 v = ts:te;
%                 vq = ts:(te-ts)/(nsamples-1):te;
%                 vGRFR(i_HSR, 1:nsamples) = interp1(v, filtfilt(lpFilt,grfs(5, ts:te)), vq);
%             end
%             cc(2) = corr(W_GRF(:,2), mean(vGRFR)'/80);           
%   
   
            %kinematic left and right
            for i_HSL = 1:length(HSL)-1
                ts = HSL(i_HSL);
                te = HSL(i_HSL+1); %TOR(find(TOR > HSR(i_HSR), 1, 'first'));
                v = ts:te;
                vq = ts:(te-ts)/(nsamples-1):te;
                vGRFL(i_HSL, 1:nsamples) = interp1(v, filtfilt(lpFilt,grfs(2, ts:te)), vq)/80;
                faGRFL(i_HSL, 1:nsamples) = interp1(v, filtfilt(lpFilt,grfs(1, ts:te)), vq)/80;
                HFL(i_HSL, 1:nsamples) = interp1(v, filtfilt(lpFilt,(-ja(1,ts:te)+pi)*180/pi), vq);
                KFL(i_HSL, 1:nsamples) = interp1(v, filtfilt(lpFilt,((-ja(5,ts:te)'+pi)*180/pi)), vq);
                AFL(i_HSL, 1:nsamples) = interp1(v, filtfilt(lpFilt,(-ja(7,ts:te)'+pi/2)*180/pi), vq);
                HFML(i_HSL, 1:nsamples) = interp1(v, filtfilt(lpFilt,tor(1,ts:te)'), vq)/80;
                KFML(i_HSL, 1:nsamples) = interp1(v, filtfilt(lpFilt,tor(3,ts:te)'), vq)/80;
                AFML(i_HSL, 1:nsamples) = interp1(v, filtfilt(lpFilt,tor(4,ts:te)'), vq)/80;
            end
            ccl(1) = corr(W_GRF(:,2+gt*7), mean(vGRFL)');
            ccl(2) = corr(W_GRF(:,4+gt*7), mean(faGRFL)');
            ccl(3) = corr(W_ang(:,2+gt*7), mean(HFL)');
            ccl(4) = corr(W_ang(:,4+gt*7), mean(KFL)');
            ccl(5) = corr(W_ang(:,6+gt*7), mean(AFL)');
            ccl(6) = corr(W_tor(:,2+gt*7), mean(HFML)');
            ccl(7) = corr(W_tor(:,4+gt*7), mean(KFML)');
            ccl(8) = corr(W_tor(:,6+gt*7), mean(AFML)');
            RMSEl(1) = sqrt(sum((W_GRF(:,2+gt*7)- mean(vGRFL)').^2)/nsamples)*(1/max(W_GRF(:,2+gt*7)));
            RMSEl(2) = sqrt(sum((W_GRF(:,4+gt*7)- mean(faGRFL)').^2)/nsamples)*(1/(max(W_GRF(:,4+gt*7)-min(W_GRF(:,4+gt*7)))));
            RMSEl(3) = sqrt(sum((W_ang(:,2+gt*7)- mean(HFL)'  ).^2)/nsamples)*(1/(max(W_ang(:,2+gt*7)-min(W_ang(:,2+gt*7)))));
            RMSEl(3) = sqrt(sum((W_ang(:,4+gt*7)- mean(KFL)'  ).^2)/nsamples)*(1/(max(W_ang(:,4+gt*7)-min(W_ang(:,4+gt*7)))));
            RMSEl(4) = sqrt(sum((W_ang(:,6+gt*7)- mean(AFL)'  ).^2)/nsamples)*(1/(max(W_ang(:,6+gt*7)-min(W_ang(:,6+gt*7)))));
            
            for i_HSR = 1:length(HSR)-1
                ts = HSR(i_HSR);
                te = HSR(i_HSR+1); %TOR(find(TOR > HSR(i_HSR), 1, 'first'));
                v = ts:te;
                vq = ts:(te-ts)/(nsamples-1):te;
                vGRFR(i_HSR, 1:nsamples) = interp1(v, filtfilt(lpFilt,grfs(5, ts:te)), vq)/80;
                faGRFR(i_HSR, 1:nsamples) = interp1(v, filtfilt(lpFilt,grfs(4, ts:te)), vq)/80;
                HFR(i_HSR, 1:nsamples) = interp1(v, filtfilt(lpFilt,(-ja(9,ts:te)+pi)*180/pi), vq);
                KFR(i_HSR, 1:nsamples) = interp1(v, filtfilt(lpFilt,((-ja(13,ts:te)'+pi)*180/pi)), vq);
                AFR(i_HSR, 1:nsamples) = interp1(v, filtfilt(lpFilt,(-ja(15,ts:te)'+pi/2)*180/pi), vq);
                HFMR(i_HSR, 1:nsamples) = interp1(v, filtfilt(lpFilt,tor(5,ts:te)'), vq)/80;
                KFMR(i_HSR, 1:nsamples) = interp1(v, filtfilt(lpFilt,tor(7,ts:te)'), vq)/80;
                AFMR(i_HSR, 1:nsamples) = interp1(v, filtfilt(lpFilt,tor(8,ts:te)'), vq)/80;
                
            end
            ccr(1) = corr(W_GRF(:,2+gt*7), mean(vGRFR)');
            ccr(2) = corr(W_GRF(:,4+gt*7), mean(faGRFR)');
            ccr(3) = corr(W_ang(:,2+gt*7), mean(HFR)');
            ccr(4) = corr(W_ang(:,4+gt*7), mean(KFR)');
            ccr(5) = corr(W_ang(:,6+gt*7), mean(AFR)');
            ccr(6) = corr(W_tor(:,2+gt*7), mean(HFMR)');
            ccr(7) = corr(W_tor(:,4+gt*7), mean(KFMR)');
            ccr(8) = corr(W_tor(:,6+gt*7), mean(AFMR)');
            RMSEr(1) = sqrt(sum((W_GRF(:,2+gt*7)- mean(vGRFR)').^2)/nsamples)*(1/max(W_GRF(:,2+gt*7)));
            RMSEr(2) = sqrt(sum((W_GRF(:,4+gt*7)- mean(faGRFR)').^2)/nsamples)*(1/(max(W_GRF(:,4+gt*7)-min(W_GRF(:,4+gt*7)))));
            RMSEr(3) = sqrt(sum((W_ang(:,2+gt*7)- mean(HFR)'  ).^2)/nsamples)*(1/(max(W_ang(:,2+gt*7)-min(W_ang(:,2+gt*7)))));
            RMSEr(3) = sqrt(sum((W_ang(:,4+gt*7)- mean(KFR)'  ).^2)/nsamples)*(1/(max(W_ang(:,4+gt*7)-min(W_ang(:,4+gt*7)))));
            RMSEr(4) = sqrt(sum((W_ang(:,6+gt*7)- mean(AFR)'  ).^2)/nsamples)*(1/(max(W_ang(:,6+gt*7)-min(W_ang(:,6+gt*7)))));  
        
%             close all; clf; hold on
%       
%             subplot(2,4,1); hold on;
%             plot(W_ang(:,2), 'b')
%             plot(mean(HFR), 'r')
%             plot(mean(HFL), 'g')
%             
%             subplot(2,4,2); hold on;
%             plot(W_ang(:,4), 'b')
%             plot(mean(KFR), 'r')
%             plot(mean(KFL), 'g')
%                   
%             subplot(2,4,3); hold on;
%             plot(W_ang(:,6), 'b')
%             plot(mean(AFR), 'r')
%             plot(mean(AFL), 'g')
%             
%             subplot(2,4,4); hold on;
%             plot(W_GRF(:,2), 'b')
%             plot(mean(vGRFR), 'r')
%             plot(mean(vGRFL), 'g')
%             
%             subplot(2,4,5); hold on;
%             plot(W_GRF(:,4), 'b')
%             plot(mean(faGRFR), 'r')
%             plot(mean(faGRFL), 'g')
%             
%             subplot(2,4,6); hold on;
%             plot(W_tor(:,6), 'b')
%             plot(mean(AFMR), 'r')
%             plot(mean(AFML), 'g')
%             
%                 subplot(2,4,7); hold on;
%             plot(W_tor(:,4), 'b')
%             plot(mean(KFMR), 'r')
%             plot(mean(KFML), 'g')
%             
%                 subplot(2,4,8); hold on;
%             plot(W_tor(:,2), 'b')
%             plot(mean(HFMR), 'r')
%             plot(mean(HFML), 'g')

humanlike = sum((1-ccr).^2) + sum((1-ccl).^2) + 3*(sum(RMSEr)+sum(RMSEl));

%             data(i).meas(j).cycle(1).dat(k,1:nsamples) = interp1(Lv, (-dat.ans(2, Lidx_dat)+pi)*180/pi, Lvq);
%                         data(i).meas(j).cycle(7).dat(k,1:nsamples) = interp1(Lv, (dat.ans(4, Lidx_dat))*180/pi, Lvq);
%                         data(i).meas(j).cycle(3).dat(k,1:nsamples) = interp1(Lv, (-dat.ans(6, Lidx_dat)+pi)*180/pi, Lvq);
%                         data(i).meas(j).cycle(5).dat(k,1:nsamples) = interp1(Lv, (-dat.ans(8, Lidx_dat)+pi/2)*180/pi, Lvq);
%                         data(i).meas(j).cycle(9).dat(k,1:nsamples) = interp1(Rv, (-dat.ans(10, Ridx_dat)+pi)*180/pi, Rvq);
%                         data(i).meas(j).cycle(15).dat(k,1:nsamples) = interp1(Rv, (dat.ans(12, Ridx_dat))*180/pi, Rvq);
%                         data(i).meas(j).cycle(11).dat(k,1:nsamples) = interp1(Rv, (-dat.ans(14, Ridx_dat)+pi)*180/pi, Rvq);
%                         data(i).meas(j).cycle(13).dat(k,1:nsamples) = interp1(Rv, (-dat.ans(16, Ridx_dat)+pi/2)*180/pi, Rvq);

                %% Cost part 3
                % Energy
%                 energy = sum(trapz(t,Muscle_act,2)); %Muscle Act
                energy = sum(trapz(t,muscle_power,2)); %Muscle Power
                e_pm_pkg = energy/(t(end)*mean(speed)*80);
                
                % Speed 
%                 % Body sway cost
%                 v_d = 1;
                v_error = trapz(t,(speed - v_d).^2,2);
                vept = v_error/t(end); 
                
                %Normal
                vept = abs(mean(speed) - v_d);
                
                pt = sum(abs(trapz(t, pas_tor,2)))/80;
                
                % Cost function
%               keyboard
                val_list(i_dist) = 2*e_pm_pkg + 600*vept + 15*humanlike; % + 3 * d_post;
%                 val_list(i_dist) = ept + 10 * vept + 30*d_post;
%                 val_list(i_dist) = ept + 500 * vept + 30*d_post_ankles;
%             end
           
            
        end
    end   
    val = sum(val_list);
    disp(['Val: ', num2str(val)]);
catch ME
    val = NaN;
    disp(['Error in calculation: ',ME.identifier]);
%     keyboard
end
Simulink.sdi.clear; %clear temp files, large dump at C:\Users\FluitR\AppData\Local\Temp
end