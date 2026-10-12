function install_requirements(mode)
%INSTALL_REQUIREMENTS  One-click setup for YOLO26 Deployment Studio.
%
%   Open this file and press Run (or type install_requirements) to prepare
%   a computer for the app. The script:
%     1. Checks the MATLAB release.
%     2. Checks every required MathWorks toolbox / support package and opens
%        Add-On Explorer with all missing items listed (one click per item).
%     3. Checks the C++ compiler (MSVC) and, if missing, offers to install
%        Visual Studio 2022 Build Tools (C++ workload).
%     4. Checks the NVIDIA GPU and driver.
%     5. Finds Python 3. If none is found, downloads and installs
%        Python 3.11.9 for the current user (no admin rights needed).
%     6. Installs the Python packages used by the ONNX / PT2 export scripts.
%     7. Offers to install the YOLO26 Deployment Studio app (.mlappinstall).
%
%   install_requirements("CheckOnly") only reports the status and does not
%   download or install anything.
%
%   The script can be run any number of times; items that are already
%   installed are skipped.

    if nargin < 1; mode = "Install"; end
    checkOnly = strcmpi(string(mode), "CheckOnly");

    TESTED_RELEASE = "R2026a";
    PY_VERSION     = "3.11.9";
    PY_URL         = "https://www.python.org/ftp/python/3.11.9/python-3.11.9-amd64.exe";
    VS_URL         = "https://aka.ms/vs/17/release/vs_BuildTools.exe";
    PIP_PINNED     = "torch==2.8.0 torchvision==0.23.0 ultralytics==8.4.137 onnx==1.19.0";
    PIP_LATEST     = "torch torchvision ultralytics==8.4.137 onnx";
    APP_FILE       = "YOLO26 Deployment Studio.mlappinstall";

    rootDir = fileparts(mfilename('fullpath'));
    summary = strings(0, 3);   % [Item, Status, Detail]

    printHeader("YOLO26 Deployment Studio - Requirements Setup");
    if checkOnly; fprintf('Mode: CHECK ONLY (nothing will be installed)\n'); end

    %% 1) MATLAB release ----------------------------------------------------
    printSection("1/7  MATLAB release");
    rel = "R" + string(version('-release'));
    if rel == TESTED_RELEASE
        fprintf('  [OK]      MATLAB %s\n', rel);
        summary(end+1, :) = ["MATLAB release", "OK", rel];
    else
        fprintf('  [WARNING] MATLAB %s detected. The app was developed and tested on %s.\n', rel, TESTED_RELEASE);
        summary(end+1, :) = ["MATLAB release", "WARNING", rel + " (tested on " + TESTED_RELEASE + ")"];
    end

    %% 2) MathWorks toolboxes and support packages --------------------------
    printSection("2/7  MathWorks toolboxes and support packages");
    req = {
        'NN',                   'Deep Learning Toolbox',                                                     'Required'
        'ME',                   'MATLAB Coder',                                                              'Required'
        'GC',                   'GPU Coder',                                                                 'Required'
        'DM',                   'Parallel Computing Toolbox',                                                'Required'
        'VP',                   'Computer Vision Toolbox',                                                   'Required'
        'IP',                   'Image Processing Toolbox',                                                  'Required'
        'ONNXCONVERTER',        'Deep Learning Toolbox Converter for ONNX Model Format',                     'Required'
        'PYTORCHCONVERTER',     'Deep Learning Toolbox Converter for PyTorch Model Format',                  'Required'
        'MC_PYTORCH_LITERT',    'MATLAB Coder Support Package for PyTorch and LiteRT Models',                'Required'
        'GPU_DEEPLEARNING_LIB', 'GPU Coder Interface for Deep Learning',                                     'Required'
        'USBWEBCAM',            'MATLAB Support Package for USB Webcams',                                    'Required'
        'ML_DEEPLEARNING_LIB',  'MATLAB Coder Interface for Deep Learning',                                  'Recommended'
        'SL',                   'Simulink',                                                                  'Optional (Simulink)'
        'RT',                   'Simulink Coder',                                                            'Optional (Simulink)'
        'EC',                   'Embedded Coder',                                                            'Optional (Jetson)'
        'NVIDIA',               'MATLAB Coder Support Package for NVIDIA Jetson and NVIDIA DRIVE Platforms', 'Optional (Jetson)'
        };

    try
        inst = matlab.addons.installedAddons;
        instIds = string(inst.Identifier);
    catch
        instIds = strings(0, 1);
    end

    toOpen = {};
    for k = 1:size(req, 1)
        id = req{k, 1}; name = req{k, 2}; level = req{k, 3};
        if any(instIds == id)
            fprintf('  [OK]      %s\n', name);
            summary(end+1, :) = [string(name), "OK", string(level)]; %#ok<AGROW>
        else
            if startsWith(level, 'Optional')
                tag = "OPTIONAL";
            else
                tag = "MISSING";
                toOpen{end+1} = id; %#ok<AGROW>
            end
            fprintf('  [%-8s] %s  (%s)  <a href="matlab:matlab.internal.addons.showAddon(''%s'')">Install</a>\n', ...
                tag, name, level, id);
            summary(end+1, :) = [string(name), tag, string(level)]; %#ok<AGROW>
        end
    end

    if ~isempty(toOpen) && ~checkOnly
        fprintf('\n  Opening Add-On Explorer with %d missing item(s)...\n', numel(toOpen));
        fprintf('  MathWorks products are installed through Add-On Explorer: click "Install" on each item.\n');
        try
            matlab.addons.supportpackage.internal.explorer.showSupportPackages(toOpen, 'tripwire');
        catch
            try
                matlab.internal.addons.showAddon(toOpen{1});
            catch
                fprintf('  Could not open Add-On Explorer automatically. Use HOME > Add-Ons > Get Add-Ons.\n');
            end
        end
    end

    %% 3) C++ compiler -------------------------------------------------------
    printSection("3/7  C++ compiler (Microsoft Visual C++)");
    hasMSVC = false; selMSVC = false;
    try
        cc = mex.getCompilerConfigurations('C++', 'Installed');
        isMS = contains(string({cc.Name}), "Microsoft Visual C++");
        hasMSVC = any(isMS);
        sel = mex.getCompilerConfigurations('C++', 'Selected');
        selMSVC = ~isempty(sel) && contains(string(sel.Name), "Microsoft Visual C++");
    catch
    end

    if selMSVC
        fprintf('  [OK]      %s %s\n', sel.Name, sel.Version);
        summary(end+1, :) = ["C++ compiler", "OK", string(sel.Name) + " " + string(sel.Version)];
    elseif hasMSVC
        msIdx = find(isMS, 1, 'last');
        if checkOnly
            fprintf('  [WARNING] %s is installed but not selected. Run: mex -setup C++\n', cc(msIdx).Name);
            summary(end+1, :) = ["C++ compiler", "WARNING", "MSVC installed but not selected"];
        else
            fprintf('  Selecting %s for MEX / GPU Coder...\n', cc(msIdx).Name);
            try
                mex(['-setup:' cc(msIdx).MexOpt], 'C++');
                summary(end+1, :) = ["C++ compiler", "OK", string(cc(msIdx).Name) + " (selected)"];
            catch ex
                fprintf('  [ERROR]   %s\n', ex.message);
                summary(end+1, :) = ["C++ compiler", "MISSING", "Run: mex -setup C++"];
            end
        end
    else
        fprintf('  [MISSING] No Microsoft Visual C++ compiler found. GPU Coder requires MSVC (MinGW is not supported).\n');
        installed = false;
        if ~checkOnly
            choice = questdlg(['Microsoft Visual C++ was not found. GPU Coder needs it to compile CUDA code.' newline newline ...
                'Download and install Visual Studio 2022 Build Tools (C++ workload)?' newline ...
                'Download size is several GB and administrator rights are required.'], ...
                'C++ Compiler Missing', 'Install', 'Skip', 'Install');
            if strcmp(choice, 'Install')
                try
                    vsExe = fullfile(tempdir, 'vs_BuildTools.exe');
                    fprintf('  Downloading Visual Studio Build Tools installer...\n');
                    websave(vsExe, VS_URL);
                    fprintf('  Installing (a Windows permission prompt will appear, this can take a long time)...\n');
                    st = system(sprintf('"%s" --passive --wait --norestart --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended', vsExe));
                    installed = any(st == [0 3010]);
                    if installed
                        fprintf('  [OK]      Build Tools installed. Restart MATLAB, then run: mex -setup C++\n');
                    else
                        fprintf('  [ERROR]   Build Tools installer exited with code %d.\n', st);
                    end
                catch ex
                    fprintf('  [ERROR]   %s\n', ex.message);
                end
            end
        end
        if installed
            summary(end+1, :) = ["C++ compiler", "RESTART", "Restart MATLAB, then run: mex -setup C++"];
        else
            summary(end+1, :) = ["C++ compiler", "MISSING", "Install Visual Studio 2022 (Desktop development with C++)"];
        end
    end

    %% 4) NVIDIA GPU ---------------------------------------------------------
    printSection("4/7  NVIDIA GPU");
    try
        g = gpuDevice;
        cc_ = str2double(g.ComputeCapability);
        fprintf('  [OK]      %s  (Compute Capability %s, CUDA toolkit %.1f)\n', g.Name, g.ComputeCapability, g.ToolkitVersion);
        summary(end+1, :) = ["NVIDIA GPU", "OK", string(g.Name) + " (CC " + string(g.ComputeCapability) + ")"];
        if cc_ < 7.0
            fprintf('  [WARNING] No Tensor Cores (CC < 7.0): FP16 will not be faster than FP32.\n');
        end
        
        % Check NVIDIA TensorRT library for GPU Coder
        try
            if ~isempty(which('gpucoder.installTensorRT'))
                if gpucoder.internal.isTensorRTInstalled()
                    fprintf('  [OK]      NVIDIA TensorRT library for GPU Coder is installed.\n');
                    summary(end+1, :) = ["TensorRT library", "OK", "Installed"];
                else
                    fprintf('  [MISSING] NVIDIA TensorRT library for GPU Coder is not installed.\n');
                    if checkOnly
                        fprintf('            Run: gpucoder.installTensorRT\n');
                        summary(end+1, :) = ["TensorRT library", "MISSING", "Run: gpucoder.installTensorRT"];
                    else
                        fprintf('  Installing TensorRT library for GPU Coder (gpucoder.installTensorRT)...\n');
                        try
                            gpucoder.installTensorRT();
                            fprintf('  [OK]      TensorRT library installed successfully.\n');
                            summary(end+1, :) = ["TensorRT library", "OK", "Installed"];
                        catch exTrt
                            fprintf('  [ERROR]   TensorRT installation failed: %s\n', exTrt.message);
                            summary(end+1, :) = ["TensorRT library", "ERROR", exTrt.message];
                        end
                    end
                end
            end
        catch
        end
    catch ex
        fprintf('  [MISSING] No supported NVIDIA GPU / driver found: %s\n', ex.message);
        fprintf('            Install the latest NVIDIA driver from https://www.nvidia.com/Download/index.aspx\n');
        summary(end+1, :) = ["NVIDIA GPU", "MISSING", "Install an NVIDIA GPU driver"];
    end

    %% 5) Python -------------------------------------------------------------
    printSection("5/7  Python");
    pyExe = findPython();
    if strlength(pyExe) == 0 && ~checkOnly
        fprintf('  Python 3 was not found. Downloading Python %s...\n', PY_VERSION);
        try
            pyInst = fullfile(tempdir, "python-" + PY_VERSION + "-amd64.exe");
            websave(pyInst, PY_URL);
            fprintf('  Installing Python %s for the current user (silent)...\n', PY_VERSION);
            st = system(sprintf('"%s" /quiet InstallAllUsers=0 PrependPath=1 Include_launcher=1 InstallLauncherAllUsers=0 Include_test=0', pyInst));
            cand = string(fullfile(getenv('LOCALAPPDATA'), 'Programs', 'Python', 'Python311', 'python.exe'));
            if st == 0 && isfile(cand)
                pyExe = cand;
                fprintf('  [OK]      Python installed: %s\n', pyExe);
            else
                fprintf('  [ERROR]   Python installer exited with code %d.\n', st);
            end
        catch ex
            fprintf('  [ERROR]   %s\n', ex.message);
        end
    end

    pyOK = false; pyMinor = NaN;
    if strlength(pyExe) > 0
        % Make the interpreter visible to this MATLAB session and to the app
        pyDir = fileparts(pyExe);
        if ~contains(getenv('PATH'), pyDir, 'IgnoreCase', true)
            setenv('PATH', pyDir + ";" + fullfile(pyDir, "Scripts") + ";" + getenv('PATH'));
        end
        if ~checkOnly
            try
                pe = pyenv;
                if pe.Status == "NotLoaded" && ~strcmpi(string(pe.Executable), pyExe)
                    pyenv('Version', pyExe);
                end
            catch
            end
        end
        [~, vout] = system(sprintf('"%s" -c "import sys; print(sys.version_info[0], sys.version_info[1], sys.version.split()[0])"', pyExe));
        parts = split(strtrim(string(vout)));
        if numel(parts) >= 3 && parts(1) == "3"
            pyMinor = str2double(parts(2));
            pyOK = pyMinor >= 9;
            if pyOK
                fprintf('  [OK]      Python %s  (%s)\n', parts(3), pyExe);
                summary(end+1, :) = ["Python", "OK", parts(3) + " - " + pyExe];
            else
                fprintf('  [MISSING] Python %s is too old. Python 3.9 - 3.13 is required (3.11 recommended).\n', parts(3));
                summary(end+1, :) = ["Python", "MISSING", "Python " + parts(3) + " is too old (need 3.9+)"];
            end
        end
    end
    if strlength(pyExe) == 0
        fprintf('  [MISSING] Python 3 not found. Install Python %s from https://www.python.org (enable "Add python.exe to PATH").\n', PY_VERSION);
        summary(end+1, :) = ["Python", "MISSING", "Install Python " + PY_VERSION];
    end

    %% 6) Python packages ----------------------------------------------------
    printSection("6/7  Python packages (torch, ultralytics, onnx)");
    if pyOK
        checkCmd = sprintf('"%s" -c "import torch, ultralytics, onnx; print(torch.__version__, ultralytics.__version__, onnx.__version__)"', pyExe);
        [st, out] = system(checkCmd);
        if st ~= 0 && ~checkOnly
            if pyMinor <= 13
                pkgs = PIP_PINNED;     % versions the app was tested with
            else
                pkgs = PIP_LATEST;     % torch 2.8.0 has no wheels for this Python
            end
            fprintf('  Installing: %s\n  This downloads several hundred MB and can take a few minutes...\n\n', pkgs);
            system(sprintf('"%s" -m pip install --disable-pip-version-check %s', pyExe, pkgs), '-echo');
            [st, out] = system(checkCmd);
        end
        if st == 0
            v = split(strtrim(string(out)));
            v = v(end-2:end);
            fprintf('\n  [OK]      torch %s | ultralytics %s | onnx %s\n', v(1), v(2), v(3));
            summary(end+1, :) = ["Python packages", "OK", "torch " + v(1) + ", ultralytics " + v(2) + ", onnx " + v(3)];
        else
            fprintf('  [MISSING] Packages are not installed. Manual command:\n            "%s" -m pip install %s\n', pyExe, PIP_PINNED);
            summary(end+1, :) = ["Python packages", "MISSING", "pip install " + PIP_PINNED];
        end
    else
        fprintf('  [SKIPPED] Python is not available.\n');
        summary(end+1, :) = ["Python packages", "SKIPPED", "Python not available"];
    end

    %% 7) YOLO26 Deployment Studio app --------------------------------------
    printSection("7/7  YOLO26 Deployment Studio app");
    appInstalled = false;
    try
        info = matlab.apputil.getInstalledAppInfo;
        appInstalled = ~isempty(info) && any(contains(string({info.name}), "YOLO26", 'IgnoreCase', true));
    catch
    end
    appPath = fullfile(rootDir, APP_FILE);
    if appInstalled
        fprintf('  [OK]      App is installed (APPS tab).\n');
        summary(end+1, :) = ["YOLO26 Deployment Studio", "OK", "Installed"];
    elseif isfile(appPath) && ~checkOnly
        choice = questdlg('Install the YOLO26 Deployment Studio app into the MATLAB APPS gallery now?', ...
            'Install App', 'Install', 'Skip', 'Install');
        if strcmp(choice, 'Install')
            try
                matlab.apputil.install(appPath);
                fprintf('  [OK]      App installed. Open it from the APPS tab.\n');
                fprintf('            Note: do not launch it while the current folder contains YOLO26App_eng.m.\n');
                summary(end+1, :) = ["YOLO26 Deployment Studio", "OK", "Installed now"];
            catch ex
                fprintf('  [ERROR]   %s\n', ex.message);
                summary(end+1, :) = ["YOLO26 Deployment Studio", "MISSING", "Double-click " + APP_FILE];
            end
        else
            summary(end+1, :) = ["YOLO26 Deployment Studio", "SKIPPED", "Double-click " + APP_FILE];
        end
    else
        fprintf('  [INFO]    App not installed. Double-click "%s" to install it.\n', APP_FILE);
        summary(end+1, :) = ["YOLO26 Deployment Studio", "NOT INSTALLED", APP_FILE];
    end

    %% Summary ---------------------------------------------------------------
    printHeader("Summary");
    for k = 1:size(summary, 1)
        fprintf('  %-74s %-14s %s\n', summary(k, 1), summary(k, 2), summary(k, 3));
    end
    blocking = summary(:, 2) == "MISSING" | summary(:, 2) == "RESTART";
    fprintf('\n');
    if any(blocking)
        fprintf('  Some requirements still need attention (see MISSING / RESTART above).\n');
        fprintf('  Finish the Add-On Explorer installs, restart MATLAB if requested, then run install_requirements again.\n');
    else
        fprintf('  All required components are ready. Launch YOLO26 Deployment Studio from the APPS tab.\n');
    end
    fprintf('\n');
end

% ===========================================================================
function pyExe = findPython()
    % Locate a real Python 3 interpreter (no hardcoded paths).
    % Order: MATLAB pyenv -> Windows 'py' launcher -> python.exe on PATH.
    % Microsoft Store alias stubs (WindowsApps) are skipped.
    pyExe = "";
    isReal = @(p) strlength(p) > 0 && isfile(p) && ~contains(p, "WindowsApps", 'IgnoreCase', true);
    try
        cand = string(pyenv().Executable);
        if isReal(cand); pyExe = cand; return; end
    catch
    end
    [st, out] = system('py -3 -c "import sys; print(sys.executable)"');
    if st == 0
        lines = strtrim(splitlines(string(out)));
        lines = lines(strlength(lines) > 0);
        if ~isempty(lines) && isReal(lines(end)); pyExe = lines(end); return; end
    end
    [st, out] = system('where python');
    if st == 0
        lines = strtrim(splitlines(string(out)));
        for k = 1:numel(lines)
            if isReal(lines(k)); pyExe = lines(k); return; end
        end
    end
end

function printHeader(txt)
    fprintf('\n%s\n  %s\n%s\n', repmat('=', 1, 78), txt, repmat('=', 1, 78));
end

function printSection(txt)
    fprintf('\n--- %s %s\n', txt, repmat('-', 1, max(3, 72 - strlength(txt))));
end
