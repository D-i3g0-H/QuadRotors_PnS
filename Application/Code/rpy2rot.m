        function R = rpy2rot(roll, pitch, yaw)
            % R = rpy2rot(roll, pitch, yaw)
            % roll, pitch, yaw are scalars (radians).
            cr = cos(roll);  sr = sin(roll);
            cp = cos(pitch); sp = sin(pitch);
            cy = cos(yaw);   sy = sin(yaw);
            
            R = [cy*cp, cy*sp*sr - sy*cr, cy*sp*cr + sy*sr; sy*cp, sy*sp*sr + cy*cr, sy*sp*cr - cy*sr; -sp, cp*sr, cp*cr];
        end