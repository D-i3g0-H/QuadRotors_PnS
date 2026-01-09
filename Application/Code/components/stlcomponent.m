classdef stlcomponent

    properties
        pos
        angles
        filename
        flag
        trace
        plt
        Fb
        V
    end

    methods
        function obj=stlcomponent(axs, position, angle, filename, color, flag)
            % fullstates is 1x12xt state vector of the drone
            % (x,y,z,xdot,ydot,zdot,roll, pitch, yaw,roll_dot, pitch_dot, yaw_dot)
            % extract pos and angles
            obj.pos= position;
            obj.angles = angle;
            obj.flag=flag;


            % obj.pos=pos.Data;
            % obj.trafo=trafo.Data;
            obj.filename=filename;
            
            [obj.Fb,obj.V]=stlimport(filename);

            Vb=rpy2rot(obj.angles(1,1),obj.angles(1,2),obj.angles(1,3))*obj.V';
            
            %Vb=obj.trafo(:,:,1)*obj.V'*100;
            obj.plt=patch(axs,'Faces',obj.Fb,'Vertices',Vb'+ obj.pos(1,:),'FaceColor',color,'EdgeColor','none');
            if obj.flag
                obj.trace=plot3(axs,obj.pos(1,1),obj.pos(1,2),obj.pos(1,3));
            end
            
        end

        function update(obj, n)
            obj.plt.Vertices=(rpy2rot(obj.angles(n,1),obj.angles(n,2),obj.angles(n,3))*obj.V')'+ obj.pos(n,:);
            if obj.flag
                obj.trace.XData=obj.pos(1:n,1);
                obj.trace.YData=obj.pos(1:n,2);
                obj.trace.ZData=obj.pos(1:n,3);
            end
        end
    end
end

