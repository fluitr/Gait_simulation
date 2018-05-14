clear; close all;

%% Settings
if exist('FullResultRun.mat','file')~=0
    load('FullResultRun');
else
    % For ground options, check setGroundPar
    distList = -128:64:128;
    directionList = {'sag','front'};
    paramName = 'Records';      % Set to paramName or 'Records'
    IID_Model = 0; 
    saveOn = 1;
    allViewsOn = 1;
    
    % Extra Settings
    framerate = 30;
    
    % Viewset
    viewSet = [39.04,21.52]; %3D; 
%     viewSet = [0.0219*180/pi,0];    %Side
%     viewSet = [0,0];    %Side
end

%% Reset of standard settings if 2D model is used or Records folder
if IID_Model == 1
    viewSet = [0,0];    %Side
    allViewsOn = 0;
    directionList = {'sag'};
end

if strcmp(paramName,'Records')
    distList = 0;
    directionList = {'sag'};
end

%% Set map to global
map = cd; 
if strcmp(map(end-12:end),'PostFunctions')
     cd .. % Go up to main folder
elseif ~strcmp(map(end-4:end),'Model')
    disp('Wrong main folder')
    return
end

%% Floor Function
if IID_Model == 1
    IID_setGroundPar;
else
    setGroundPar;
end
if GroundFunction == 1
    HeightFunctionMovie = ['Z =',HeightFunction,' ;'];
    RotFunctionMovie = ['X =',RotFunction,' ;'];
elseif GroundFunction == 2
    HeightFunctionMovie = 'Z = 0;';
else
    disp('GroundFunction not known')
    return
end

for i_dir = 1:length(directionList)
    direction = directionList{i_dir};      %sag/front
        
    for i_dist = 1:length(distList)
        dist = distList(i_dist);
         
        %% Setting Load location:
        if strcmp(paramName,'Records')
            loadLocation = 'Records';
            saveLocation = 'Figures/Current';
            disp('Loading from Records folder')
        else
            loadLocation = ['RecordsFolder/',paramName,'/Records_',direction,'_',num2str(dist)];
            saveLocation = ['Figures/',paramName,'/',direction];
        end
        
        if saveOn > 0 && exist(saveLocation,'dir') == 0
            mkdir(saveLocation);
        end
        
        close all
        
        load([loadLocation,'/BodyInfo.mat'])
        t = ans(1,:);
        Pos = ans(18:74,:);
        
        load([loadLocation,'/Disturbance.mat'])
        if IID_Model == 1
            Dist = [ans(2,:);zeros(1,length(ans))];
        else
            Dist = ans(2:3,:);
        end
        
        t_new = linspace(0,t(end),t(end)*framerate);
        Pos = interp1(t,Pos',t_new)';
        Dist = diag([1,-1])*interp1(t,Dist',t_new)';
        
        %% Body
        xyzHAT = diag([1,-1,1])*Pos([1 3 2],:);
        xyzLAnkle = diag([1,-1,1])*Pos([7 9 8],:);
        xyzLKnee = diag([1,-1,1])*Pos([10 12 11],:);
        xyzLHip = diag([1,-1,1])*Pos([13 15 14],:);
        xyzRAnkle = diag([1,-1,1])*Pos([7 9 8]+12,:);
        xyzRKnee = diag([1,-1,1])*Pos([10 12 11]+12,:);
        xyzRHip = diag([1,-1,1])*Pos([13 15 14]+12,:);
        xyzTrunk = diag([1,-1,1])*Pos([31 33 32],:);
        
        xyzTop = (xyzHAT-xyzTrunk)*2.5 + xyzTrunk;
        
        %% Foot
        xyzLLHeel = diag([1,-1,1])*Pos([34 36 35],:);
        xyzLMHeel = diag([1,-1,1])*Pos([34 36 35]+3,:);
        xyzLLBall = diag([1,-1,1])*Pos([34 36 35]+6,:);
        xyzLMBall = diag([1,-1,1])*Pos([34 36 35]+9,:);
        xyzRLHeel = diag([1,-1,1])*Pos([34 36 35]+12,:);
        xyzRMHeel = diag([1,-1,1])*Pos([34 36 35]+15,:);
        xyzRLBall = diag([1,-1,1])*Pos([34 36 35]+18,:);
        xyzRMBall = diag([1,-1,1])*Pos([34 36 35]+21,:);
        
        if saveOn == 1
            %% Set up the movie.
            writerObj = VideoWriter([saveLocation,'/Movie_3DView_',num2str(dist),'.avi']); % Name it.
            writerObj.FrameRate = framerate; % How many frames per second.
            open(writerObj);
            
            if allViewsOn == 1
                writerObj2 = VideoWriter([saveLocation,'/Movie_AllViews_',num2str(dist),'.avi']); % Name it.
                writerObj2.FrameRate = framerate; % How many frames per second.
                open(writerObj2);
            end
        end
        
        h1.fig = figure(1);
        
        if allViewsOn == 1
            h2.fig = figure(2);set(h2.fig,'units','points','position',[50,100,1000,400])
        end
        
        for i_t = 1:length(Pos)
            figure(h1.fig); clf;
            %% Body
            x = [xyzLAnkle(:,i_t) xyzLKnee(:,i_t) xyzLHip(:,i_t)...
                xyzTop(:,i_t) xyzRHip(:,i_t) xyzLHip(:,i_t)...
                xyzRHip(:,i_t) xyzRKnee(:,i_t) xyzRAnkle(:,i_t)];
            h_body = animatedline(x(1,:),x(2,:),x(3,:),'LineWidth',2); hold on
            
            % Upper body
            P = [xyzTop(:,i_t)'; xyzRHip(:,i_t)'; xyzLHip(:,i_t)'];
            ind = [1 2 3];h_upper = patch(P(ind, 1), P(ind, 2), P(ind, 3), 'k');
            
            %% Feet
            % Left foot
            P = [xyzLLHeel(:,i_t)'; xyzLMHeel(:,i_t)'; xyzLMBall(:,i_t)'; xyzLLBall(:,i_t)';  xyzLAnkle(:,i_t)'];
            ind = [1 2 5]; patch(P(ind, 1), P(ind, 2), P(ind, 3), 'r');
            ind = [2 3 5]; patch(P(ind, 1), P(ind, 2), P(ind, 3), 'r')
            ind = [3 4 5]; patch(P(ind, 1), P(ind, 2), P(ind, 3), 'r')
            ind = [4 1 5]; patch(P(ind, 1), P(ind, 2), P(ind, 3), 'r')
            ind = [4 1 5]; patch(P(ind, 1), P(ind, 2), P(ind, 3), 'r')
            ind = 1:4;  patch(P(ind, 1), P(ind, 2), P(ind, 3), 'r')
            
            % Shadow
            OnGround = (P(ind, 3) ~= 0);
            ind = 1:4;  patch(P(ind, 1), P(ind, 2), ones(1,4).*OnGround'.*0.0001, 'r','FaceAlpha',0.5)
            
            % Right foot
            P = [xyzRLHeel(:,i_t)'; xyzRMHeel(:,i_t)'; xyzRMBall(:,i_t)'; xyzRLBall(:,i_t)'; xyzRAnkle(:,i_t)'];
            ind = [1 2 5]; patch(P(ind, 1), P(ind, 2), P(ind, 3), 'r')
            ind = [2 3 5]; patch(P(ind, 1), P(ind, 2), P(ind, 3), 'r')
            ind = [3 4 5]; patch(P(ind, 1), P(ind, 2), P(ind, 3), 'r')
            ind = [4 1 5]; patch(P(ind, 1), P(ind, 2), P(ind, 3), 'r')
            ind = 1:4;  patch(P(ind, 1), P(ind, 2), P(ind, 3), 'r')
            
            % Shadow
            OnGround = (P(ind, 3) ~= 0);
            ind = 1:4;  patch(P(ind, 1), P(ind, 2), ones(1,4).*OnGround'.*0.0001, 'r','FaceAlpha',0.5)
            
            %% Joints
            JointMarkerSize = 20;
            plot3(xyzLKnee(1,i_t),xyzLKnee(2,i_t),xyzLKnee(3,i_t),'r.','MarkerSize',JointMarkerSize)
            plot3(xyzLHip(1,i_t),xyzLHip(2,i_t),xyzLHip(3,i_t),'r.','MarkerSize',JointMarkerSize)
            plot3(xyzRKnee(1,i_t),xyzRKnee(2,i_t),xyzRKnee(3,i_t),'r.','MarkerSize',JointMarkerSize)
            plot3(xyzRHip(1,i_t),xyzRHip(2,i_t),xyzRHip(3,i_t),'r.','MarkerSize',JointMarkerSize)
            plot3(xyzHAT(1,i_t),xyzHAT(2,i_t),xyzHAT(3,i_t),'r.','MarkerSize',JointMarkerSize)
            
            %% Plot options
            grid on; axis square equal
            zlimPlot = zlim; xlimPlot = xlim; ylimPlot = ylim; 
            view(viewSet(1),viewSet(2)) %3D
            
            if GroundFunction == 2
                % Ground
                patch([xlimPlot(1) xlimPlot(1) xlimPlot(2) xlimPlot(2) xlimPlot(1)]...
                    ,[ylimPlot(1) ylimPlot(2) ylimPlot(2) ylimPlot(1) ylimPlot(1)]...
                    ,[0 0 0 0 0])
                
                % Ground lines
                xLines = [ceil(xlimPlot(1)*2)/2:0.5:floor(xlimPlot(2)*2)/2];
                yLines = [ceil(ylimPlot(1)*2)/2:0.5:floor(ylimPlot(2)*2)/2];
                line([xLines(:) xLines(:)],[ones(length(xLines),1).*ylimPlot(1) ones(length(xLines),1).*ylimPlot(2)],[0 0],'Color','k')
                line([ones(length(yLines),1).*xlimPlot(1) ones(length(yLines),1).*xlimPlot(2)],[yLines(:) yLines(:)],[0 0],'Color','k')
            else
                x_grid = linspace(xlimPlot(1),xlimPlot(2),20);
                
                % Small grid needed in 2D model
                if IID_Model ==1
                    y_grid = linspace(ylimPlot(1),ylimPlot(2),2);
                else 
                    y_grid = linspace(ylimPlot(1),ylimPlot(2),20);
                end
                
                z_grid = zeros(length(x_grid),length(y_grid));
                for i_x = 1:length(x_grid)
                    for i_y = 1: length(y_grid)
                        u(1) = x_grid(i_x); u(3) = y_grid(i_y);
                        eval(RotFunctionMovie);
                        u(1) = X; 
                        eval(HeightFunctionMovie);
                        z_grid(i_x,i_y) = Z;
                    end
                end
                
                [X,Y] = meshgrid(x_grid,y_grid);
                surf(X,Y,z_grid')
            end
            
            xlabel('x (m)')
            ylabel('y (m)')
            zlabel('z (m)')
            text(0.1,0.8,['Time: t = ',num2str(round(t_new(i_t),2)),' s'],'Units','normalized')
            
            %% Disturbance
            if i_t-round(framerate*0.35)>0 & sum(sum(Dist(:,i_t-round(framerate*0.35):i_t)))~=0
                [r,c] = (find((Dist)~=0,1));
                dist_size = Dist(:,c);
                x_dist = [xyzTrunk(:,i_t) xyzTrunk(:,i_t)+[dist_size(1);dist_size(2);0]/200];
                animatedline(x_dist(1,:),x_dist(2,:),x_dist(3,:),'Color','r','LineWidth',2);
                xlim(xlimPlot); ylim(ylimPlot);zlim(zlimPlot);
            end
            
            if allViewsOn == 1
                %% Create subplots
                h1.ax = gca;
                
                figure(h2.fig);
                h2.ax = gobjects(2);
                
                for ii = 1:3
                    h2.ax(ii) = subplot(1,3,ii);
                end
                
                h2.ax = h2.ax';
                h2.ax2 = gobjects(size(h2.ax));
                
                h2.ax2(1) = copyobj(h1.ax, h2.fig);
                h2.ax2(2) = copyobj(h1.ax, h2.fig);
                h2.ax2(3) = copyobj(h1.ax, h2.fig);
                
                for ii = 1:3
                    h2.ax2(ii).Position = h2.ax(ii).Position;
                end
                
                % Set viewpoint
                subplot(h2.ax2(1)); view(39.04,21.52);
                subplot(h2.ax2(2)); view(0,5) %Side
                subplot(h2.ax2(3)); view(90,5) %Front
                delete(h2.ax);
            end
            
            if saveOn == 1
                %% Make movie
                % normal
                frame = getframe(h1.fig); % 'gcf' can handle if you zoom in to take a movie.
                writeVideo(writerObj, frame);
                
                if allViewsOn == 1
                    % Views
                    frame = getframe(h2.fig); % 'gcf' can handle if you zoom in to take a movie.
                    writeVideo(writerObj2, frame);
                end
            else
                drawnow
            end
        end
        if saveOn == 1
            close(writerObj); % Saves the movie.
            if allViewsOn == 1
                close(writerObj2); % Saves the movie.
            end
        end
    end
end