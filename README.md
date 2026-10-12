<div align="center">

# YOLO26 Deployment Studio

**From YOLO26 weights to GPU code on your PC, NVIDIA Jetson or NVIDIA DRIVE — in one MATLAB app.**

![MATLAB](https://img.shields.io/badge/MATLAB-R2026a-e16737)
![GPU Coder](https://img.shields.io/badge/GPU%20Coder-TensorRT%20%7C%20cuDNN-76b900)
![Targets](https://img.shields.io/badge/Targets-Windows%20%7C%20Jetson%20%7C%20DRIVE-0078d4)
![Platform](https://img.shields.io/badge/Platform-Windows%2064--bit-555)

📖 **[User Manual (EN)](docs/USER_MANUAL.md)** · 📖 **[Kullanım Kılavuzu (TR)](docs/KULLANIM_KILAVUZU.md)** · ⬇️ **[Download App (Releases)](https://github.com/dogukankilinc/YOLO26-MATLAB-Studio/releases)**

</div>

![YOLO26 Deployment Studio](docs/screenshots/01_startup.png)

---

## What is YOLO26 Deployment Studio?

A MATLAB app that takes an **Ultralytics YOLO26** object detector (n / s / m / l / x, COCO 80 classes) and turns it into **GPU code** with MATLAB GPU Coder — for your **Windows PC**, an **NVIDIA Jetson** board or an **NVIDIA DRIVE** platform — through guided, validated steps and without writing deployment code.

| You want to… | The app gives you… |
|---|---|
| **Run YOLO26 on an NVIDIA Jetson** (robot, drone, smart camera) | SSH connection to the board, cross-compiled CUDA/C++ (executable, shared or static library) and a ready-to-deploy **Jetson Simulink model** (camera → YOLO26 → display). |
| **Target NVIDIA DRIVE** (autonomous-vehicle compute) | A Simulink model configured for the **NVIDIA DRIVE** hardware board from the same dialog. |
| **Speed up inference on your PC** | A **TensorRT** or **cuDNN** MEX callable from MATLAB, with an automatic FPS / latency test. |
| **Embed the detector in your own software** | **EXE / DLL / LIB** builds with generated C++ sources for C++, C#, Python, … |
| **Compare engines and precisions** | One-click TensorRT ↔ cuDNN, FP32 ↔ FP16, C++ ↔ C with automatic compatibility checks. |
| **Work model-based** | Auto-generated Simulink models for desktop simulation and for Jetson / DRIVE deployment. |
| **See it working right away** | Real-time test with a webcam or a built-in simulation mode: live FPS, latency and detections. |
| **Learn GPU code generation** | The GPU Coder report is one click away; every option has a *Basic* and a *Professional* explanation. |

| Host Windows build | NVIDIA Jetson connected | Jetson / DRIVE Simulink |
|---|---|---|
| ![Build](docs/screenshots/14_build_done.png) | ![Jetson](docs/screenshots/26_jetson_connected.png) | ![Board family](docs/screenshots/32_soc_family_list.png) |

---

## What's in this repository

| File | Purpose |
|---|---|
| `README.md` | This page. |
| `install_requirements.m` | One-click environment setup and app installer (see [Installation](#installation)). |
| `docs/USER_MANUAL.md` | Complete illustrated user manual (English). |
| `docs/KULLANIM_KILAVUZU.md` | Complete illustrated user manual (Turkish). |
| **Releases →** `YOLO26 Deployment Studio.mlappinstall` | The standalone app package (~382 MB, includes pre-converted YOLO26 models). Download it from the [Releases](https://github.com/dogukankilinc/YOLO26-MATLAB-Studio/releases) page. |

---

## Requirements

### Host PC

| Item | Requirement |
|---|---|
| Operating system | Windows 10 / 11, 64-bit |
| GPU | NVIDIA GPU with CUDA support (Tensor Cores, compute capability ≥ 7.0, recommended for FP16) |
| Driver | NVIDIA driver supporting the CUDA version of MATLAB R2026a |
| MATLAB | **R2026a** (tested with R2026a Update 4) |
| C/C++ compiler | **Microsoft Visual C++ 2019 / 2022** (required by GPU Coder; MinGW is not supported) |
| Python *(only for exporting new models)* | Python 3.10 – 3.12 with `torch`, `torchvision`, `ultralytics`, `onnx` — installed by `install_requirements.m` |

### MathWorks products

| Product | Needed for |
|---|---|
| Deep Learning Toolbox, MATLAB Coder, GPU Coder, Parallel Computing Toolbox, Computer Vision Toolbox, Image Processing Toolbox | **Always** |
| GPU Coder Interface for Deep Learning | **Always** (TensorRT / cuDNN) |
| Deep Learning Toolbox Converter for ONNX Model Format | ONNX workflow |
| Deep Learning Toolbox Converter for PyTorch Model Format, MATLAB Coder Support Package for PyTorch and LiteRT Models | PT2 workflow |
| MATLAB Support Package for USB Webcams | Camera tests (otherwise simulation mode only) |
| Simulink, Simulink Coder | Simulink models |
| Embedded Coder, MATLAB Coder Support Package for NVIDIA Jetson and NVIDIA DRIVE Platforms | **Jetson / DRIVE** targets |

### NVIDIA Jetson / DRIVE board *(only for embedded targets)*

| Item | Requirement |
|---|---|
| Board | NVIDIA Jetson (tested: **Jetson AGX Orin**) or NVIDIA DRIVE AGX |
| Software | JetPack / DRIVE OS supported by MATLAB R2026a, with CUDA, cuDNN and TensorRT |
| Simulink model | SDL 1.2 (`libsdl1.2-dev`) for the display block, a USB/CSI camera on `/dev/video0` |
| Environment | CUDA on `PATH` / `LD_LIBRARY_PATH` of the SSH user (e.g. `~/.bashrc`) |
| Network | Board and PC on the same network, SSH enabled (IP address, user name, password) |

---

## Installation

1. **Download** `YOLO26 Deployment Studio.mlappinstall` from the [Releases](https://github.com/dogukankilinc/YOLO26-MATLAB-Studio/releases) page and `install_requirements.m` from this repository.
2. Put **both files in the same folder**.
3. **Run** `install_requirements.m` in MATLAB (open it and click **Run**). It works through seven automated steps:

   | Step | What it does |
   |---|---|
   | 1 | Checks the MATLAB release (tested: R2026a). |
   | 2 | Checks all required toolboxes and support packages; opens **Add-On Explorer** for missing items. |
   | 3 | Checks Microsoft Visual C++; selects it for MEX or offers to install Visual Studio Build Tools. |
   | 4 | Checks the NVIDIA GPU and driver; installs GPU Coder's **TensorRT** library if missing. |
   | 5 | Finds Python 3; if none is found, installs Python 3.11 for current user (no admin rights required). |
   | 6 | Installs required Python packages (`torch`, `torchvision`, `ultralytics`, `onnx`). |
   | 7 | Automatically installs **YOLO26 Deployment Studio** into the MATLAB **APPS** gallery. |

   > [!NOTE]
   > Want only a status report? Run `install_requirements("CheckOnly")` — nothing is downloaded or modified.

4. **Restart MATLAB** if prompted (e.g. after compiler installation).
5. **Launch** the app from **APPS → YOLO26 Deployment Studio** (or type `YOLO26App` in the MATLAB Command Window).

> [!TIP]
> You can also install the app directly by double-clicking the `.mlappinstall` file. Inside the app, **⚙ System Scan** can verify your environment at any time.

---

## Quick Start

| Goal | Steps |
|---|---|
| **GPU MEX on your PC** | Workflow **ONNX** → **ONNX** → **Validate Model** → *Host Windows*, *MEX*, *TensorRT*, *FP32* → **Start Build** → **Real-time Test → MEX Test** |
| **Jetson executable** | Load + validate → *NVIDIA Jetson* (enter IP / user / password) → *EXE*, *TensorRT*, *FP16* → **Start Build** |
| **Jetson / DRIVE Simulink model** | Connected Jetson → **Generate Jetson Simulink** → library, precision, **SoC / Board Family** (*Generic*, *Xavier* or *Drive*) → **Generate** |
| **Desktop Simulink model** | Validate → **Generate Simulink Model** |

Every screen is explained step by step in the **[User Manual](docs/USER_MANUAL.md)** (or in the **[Kullanım Kılavuzu](docs/KULLANIM_KILAVUZU.md)** for Turkish).

---

## Performance (Reference System)

RTX 4050 Laptop GPU · YOLO26n · TensorRT · FP32 · MEX: **25.2 FPS · 39.6 ms** per inference (build ≈ 5.5 min, first TensorRT warmup ≈ 3 min).

---

## Known Limitations

* The ONNX workflow simplifies the attention part of the network for GPU Coder compatibility; accuracy can differ slightly from the original Ultralytics model.
* Fixed input size 640×640×3, batch 1. TensorRT engines are tied to the specific GPU architecture they were compiled on.
* *Start Build* cross-compiles for NVIDIA Jetson (compute capability 8.7, Orin); NVIDIA DRIVE is supported through the generated Simulink model.
* Tested on Windows 11 with MATLAB R2026a.

---

<div align="center">

**Doğukan M. KILINÇ** — [LinkedIn](https://www.linkedin.com/in/dgkilinc/)

</div>
