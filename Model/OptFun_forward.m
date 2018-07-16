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
% keyboard
        %% Loading data speed
        speed = BodyInfo(3,:);
        dist_tot_x = BodyInfo(2,end);
%           keyboard
        %% Cost function, part 1:
        if t(end) < t_end
            vept = abs(mean(speed) - v_d);
            val_list(i_dist) = 1000 - dist_tot_x;
        else
            
%             %% Coordinates at HS Moments
            HS = find((stance(1,1:end-1) == 0 & stance(1,2:end) == 1) |...
                (stance(2,1:end-1) == 0 & stance(2,2:end) == 1));
            HSR = find(stance(2,1:end-1) == 0 & stance(2,2:end) == 1);
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
% %             d_pre_ankles = mean(sum(sum_diff([2 5],t_steps>5 & t_steps<15)));
% %             d_post_ankles = mean(sum(sum_diff([2 5],t_steps>15 & t_steps<20)));
%             
%             %% Cost part 2
%             if d_pre > 0.03
%                 val_list(i_dist) = 1E2 + 100 * d_pre;
%             else
                %% Cost part 3
                % Energy
%                 energy = sum(trapz(t,Muscle_act,2)); %Muscle Act
                energy = sum(trapz(t,muscle_power,2)); %Muscle Power
                e_pm_pkg = energy/(t(end)*mean(speed)*80);
                
                % Speed 
%                 % Body sway cost
                v_d = 1;
                v_error = trapz(t,(speed - v_d).^2,2);
                vept = v_error/t(end); 
                
                %Normal
                vept = abs(mean(speed) - v_d);
                
                pt = sum(abs(trapz(t, pas_tor,2)))/80;
                
                % Cost function
              
                val_list(i_dist) = e_pm_pkg*(1/20) + 8*vept +d_pre + pt*(2/3); % + 3 * d_post;
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
end
Simulink.sdi.clear; %clear temp files, large dump at C:\Users\FluitR\AppData\Local\Temp
end