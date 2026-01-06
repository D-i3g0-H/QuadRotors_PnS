% Check MATLAB version
product_info =ver('MATLAB');
    
if strcmp(product_info.Release,'(R2025b)')
    disp('MATLAB version OK')
else
    disp('MATLAB version not OK')
end
disp(' ')

product_list = [{'Simulink Control Design'},{'Simscape Multibody'}];

for i = 1:length(product_list)
    if checkProduct(product_list{i})
        disp([product_list{i} ' and its dependencies are installed'])
    else
        disp([product_list{i} ' is not installed']);
        switch i
            case 1
                matlab.internal.addons.launchers.showExplorer('AO_MODEL_RP','identifier','SD') %Simulink Control Design (Control Systems Toolbox is a dependency)
            case 2
                matlab.internal.addons.launchers.showExplorer('AO_MODEL_RP','identifier','MS') %Simscape Multibody               
        end
        break
                %matlab.internal.addons.launchers.showExplorer('AO_MODEL_RP','identifier','PS') %Simscape electrical probably not needed?
    end
end
disp(' ')

% Check installed support packages
% checkHSP('HDL Coder Support Package for AMD FPGA and SoC Devices')
% checkHSP('HDL Verifier Support Package for AMD FPGA and SoC Devices')

clear i product_list product_info

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function isInstalled = checkProduct(productName)
    
    % Get a list of installed support packages
    installedProducts = ver;
    
    % Check if the specified package is installed
    isInstalled = any(strcmp({installedProducts.Name}, productName));

end

function checkHSP(packageName)

    % Get a list of installed support packages
    installedPackages = matlabshared.supportpkg.getInstalled();
    
    % Check if the specified package is installed
    isInstalled = any(strcmp({installedPackages.Name}, packageName));
    
    if isInstalled
        disp([packageName ' is installed']);
    else
        disp([packageName ' is not installed']);
    end

end
