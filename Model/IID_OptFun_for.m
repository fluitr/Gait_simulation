function val = IID_OptFun_for(x)
%% This function runs the simulation for optimalisation
%% param
assignin('base','param',x);
t_end = 25; %Also Adjust in RunScripts

%%Dist List
dist_list = [128 -128];....      %Sag
    
% Init
val_list = nan(1,size(dist_list,2));

%% Simulating
%% Try to prevent stop after error
try
    for i_dist = 1:size(dist_list,2)
        %% Forward/backward/Side pert
        cur_dist = dist_list(:,i_dist); 

        assignin('base','opt_dist',cur_dist);
     
        simOut = sim('IID_nms_2Dmodel_for',...
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
        muscle_power = outputs.get('data').Values.muscle_power.Data';
        
        %% Loading data speed
        speed = BodyInfo(3,:);
        dist_tot_x = BodyInfo(2,end);
        
        %% Cost function, part 1:
        if t(1,end) < t_end
            val_list(i_dist) = 1000 - dist_tot_x;
        else
            
            %% Coordinates at HS Moments
            HS = find((stance(1,1:end-1) == 0 & stance(1,2:end) == 1) |...
                (stance(2,1:end-1) == 0 & stance(2,2:end) == 1));
            HSR = find(stance(2,1:end-1) == 0 & stance(2,2:end) == 1);
            joint_co = positions([1:3 7:12 19:24 31:33],:); %% Removing velocities and hips
            pos_HS = zeros(15,length(HS));  %PreAllocating
            
            %% Coverting to local axis
            for i_pos = 1:3:13
                pos_HS(i_pos:i_pos+2,:) = joint_co(i_pos:i_pos+2,HS) - joint_co(16:18,HS);
            end
            
            %% Mirroring right to left (each step is compared)
            for i_HS = 1:length(HS)
                if sum(HS(i_HS) == HSR) == 1
                    pos_HS(:,i_HS) = pos_HS([1:3 10:15 4:9],i_HS);
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
            
%             d_pre_ankles = mean(sum(sum_diff([2 5],t_steps>5 & t_steps<15)));
%             d_post_ankles = mean(sum(sum_diff([2 5],t_steps>15 & t_steps<20)));
            
            %% Cost part 2
            if d_pre > 0.03
                val_list(i_dist) = 1E2 + 100 * d_pre;
            else
                %% Cost part 3
                % Energy
                energy = sum(trapz(t,muscle_power,2)); %Muscle Power
                e_pm_pkg = energy/(t(end)*mean(speed)*80);
         
                %Normal
                vept = abs(mean(speed) - 0.65);
                
                % Cost function
                val_list(i_dist) = e_pm_pkg + 10 * vept + 30 * d_post;
            end
        end
    end   
    val = sum(val_list);    
catch ME
    val = NaN;
    disp(['Error in calculation: ',ME.identifier]);
end
end