<div align="center">

# YOLO26 Deployment Studio

**From YOLO26 weights to GPU code on your PC, NVIDIA Jetson or NVIDIA DRIVE — in one MATLAB app.**<br>
**YOLO26 ağırlıklarından PC'nizde, NVIDIA Jetson'da veya NVIDIA DRIVE'da çalışan GPU koduna — tek bir MATLAB uygulamasıyla.**

![MATLAB](https://img.shields.io/badge/MATLAB-R2026a-e16737)
![GPU Coder](https://img.shields.io/badge/GPU%20Coder-TensorRT%20%7C%20cuDNN-76b900)
![Targets](https://img.shields.io/badge/Targets-Windows%20%7C%20Jetson%20%7C%20DRIVE-0078d4)
![Platform](https://img.shields.io/badge/Platform-Windows%2064--bit-555)

**[English](#english)** · **[Türkçe](#türkçe)**

📖 **[User Manual (EN)](docs/USER_MANUAL.md)** · 📖 **[Kullanım Kılavuzu (TR)](docs/KULLANIM_KILAVUZU.md)** · ⬇️ **[Download / İndir (Releases)](https://github.com/dogukankilinc/YOLO26-MATLAB-Studio/releases)**

</div>

![YOLO26 Deployment Studio](docs/screenshots/01_startup.png)

---

## English

### What is YOLO26 Deployment Studio?

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

### What's in this repository

| File | Purpose |
|---|---|
| `README.md` | This page (English + Türkçe). |
| `install_requirements.m` | One-click environment setup and app installer (see [Installation](#installation)). |
| `docs/USER_MANUAL.md` | Complete illustrated user manual (English). |
| `docs/KULLANIM_KILAVUZU.md` | Complete illustrated user manual (Turkish). |
| **Releases →** `YOLO26 Deployment Studio.mlappinstall` | The app package (~400 MB, includes the pre-converted YOLO26 models). Download it from the [Releases](https://github.com/dogukankilinc/YOLO26-MATLAB-Studio/releases) page. |

### Requirements

**Host PC**

| Item | Requirement |
|---|---|
| Operating system | Windows 10 / 11, 64-bit |
| GPU | NVIDIA GPU with CUDA support (Tensor Cores, compute capability ≥ 7.0, recommended for FP16) |
| Driver | NVIDIA driver supporting the CUDA version of MATLAB R2026a |
| MATLAB | **R2026a** (tested with R2026a Update 4) |
| C/C++ compiler | **Microsoft Visual C++ 2019 / 2022** (required by GPU Coder; MinGW is not supported) |
| Python *(only for exporting new models)* | Python 3.10 – 3.12 with `torch`, `torchvision`, `ultralytics`, `onnx` — installed by `install_requirements.m` |

**MathWorks products**

| Product | Needed for |
|---|---|
| Deep Learning Toolbox, MATLAB Coder, GPU Coder, Parallel Computing Toolbox, Computer Vision Toolbox, Image Processing Toolbox | **Always** |
| GPU Coder Interface for Deep Learning | **Always** (TensorRT / cuDNN) |
| Deep Learning Toolbox Converter for ONNX Model Format | ONNX workflow |
| Deep Learning Toolbox Converter for PyTorch Model Format, MATLAB Coder Support Package for PyTorch and LiteRT Models | PT2 workflow |
| MATLAB Support Package for USB Webcams | Camera tests (otherwise simulation mode only) |
| Simulink, Simulink Coder | Simulink models |
| Embedded Coder, MATLAB Coder Support Package for NVIDIA Jetson and NVIDIA DRIVE Platforms | **Jetson / DRIVE** targets |

**NVIDIA Jetson / DRIVE board** *(only for embedded targets)*

| Item | Requirement |
|---|---|
| Board | NVIDIA Jetson (tested: **Jetson AGX Orin**) or NVIDIA DRIVE AGX |
| Software | JetPack / DRIVE OS supported by MATLAB R2026a, with CUDA, cuDNN and TensorRT |
| Simulink model | SDL 1.2 (`libsdl1.2-dev`) for the display block, a USB/CSI camera on `/dev/video0` |
| Environment | CUDA on `PATH` / `LD_LIBRARY_PATH` of the SSH user (e.g. `~/.bashrc`) |
| Network | Board and PC on the same network, SSH enabled (IP address, user name, password) |

### Installation

1. **Download** `YOLO26 Deployment Studio.mlappinstall` from the [Releases](https://github.com/dogukankilinc/YOLO26-MATLAB-Studio/releases) page and `install_requirements.m` from this repository, and put **both files in the same folder**.
2. **Run** `install_requirements.m` in MATLAB (open it and press **Run**). It works through seven steps and can be run again at any time — items already installed are skipped:

   | Step | What it does |
   |---|---|
   | 1 | Checks the MATLAB release (tested: R2026a). |
   | 2 | Checks all required toolboxes and support packages and opens **Add-On Explorer** with the missing ones (install each with one click). |
   | 3 | Checks the Microsoft Visual C++ compiler; selects it for MEX, or offers to install Visual Studio 2022 Build Tools. |
   | 4 | Checks the NVIDIA GPU and driver and installs GPU Coder's **TensorRT** library if it is missing. |
   | 5 | Finds Python 3; if none is found, installs Python 3.11 for the current user (no admin rights). |
   | 6 | Installs the Python packages (`torch`, `torchvision`, `ultralytics`, `onnx`). |
   | 7 | Offers to install **YOLO26 Deployment Studio** into the MATLAB **APPS** gallery. |

   Want only a status report? Run `install_requirements("CheckOnly")` — nothing is downloaded or installed.
3. **Restart MATLAB** if the script asks for it (e.g. after installing the compiler) and run it once more until the summary shows no *MISSING* items.
4. **Start** the app from **APPS → YOLO26 Deployment Studio**.

> [!TIP]
> You can also install the app alone by double-clicking the `.mlappinstall` file. Inside the app, **⚙ System Scan** checks the environment at any time.

### Quick start

| Goal | Steps |
|---|---|
| **GPU MEX on your PC** | Workflow **ONNX** → **ONNX** → **Validate Model** → *Host Windows*, *MEX*, *TensorRT*, *FP32* → **Start Build** → **Real-time Test → MEX Test** |
| **Jetson executable** | Load + validate → *NVIDIA Jetson* (enter IP / user / password) → *EXE*, *TensorRT*, *FP16* → **Start Build** |
| **Jetson / DRIVE Simulink model** | Connected Jetson → **Generate Jetson Simulink** → library, precision, **SoC / Board Family** (*Generic*, *Xavier* or *Drive*) → **Generate** |
| **Desktop Simulink model** | Validate → **Generate Simulink Model** |

Every screen is explained step by step in the **[User Manual](docs/USER_MANUAL.md)**.

### Performance (reference system)

RTX 4050 Laptop GPU · YOLO26n · TensorRT · FP32 · MEX: **25.2 FPS · 39.6 ms** per inference (build ≈ 5.5 min, first TensorRT run ≈ 3 min).

### Known limitations

* The ONNX workflow simplifies the attention part of the network for GPU Coder compatibility; accuracy can differ slightly from the original Ultralytics model.
* Fixed input size 640×640×3, batch 1. TensorRT engines are tied to the GPU they were built for.
* *Start Build* cross-compiles for NVIDIA Jetson (compute capability 8.7, Orin); NVIDIA DRIVE is supported through the generated Simulink model.
* Tested on Windows 11 with MATLAB R2026a.

---

## Türkçe

### YOLO26 Deployment Studio nedir?

Bir **Ultralytics YOLO26** nesne dedektörünü (n / s / m / l / x, COCO 80 sınıf) MATLAB GPU Coder ile **GPU koduna** dönüştüren bir MATLAB uygulamasıdır — **Windows PC'niz**, bir **NVIDIA Jetson** kartı veya bir **NVIDIA DRIVE** platformu için — yönlendirmeli ve doğrulanmış adımlarla, dağıtım kodu yazmadan.

| Ne yapmak istiyorsunuz? | Uygulama size ne sağlar? |
|---|---|
| **YOLO26'yı NVIDIA Jetson'da çalıştırmak** (robot, drone, akıllı kamera) | Karta SSH bağlantısı, çapraz derlenmiş CUDA/C++ (çalıştırılabilir dosya, paylaşımlı veya statik kütüphane) ve dağıtıma hazır **Jetson Simulink modeli** (kamera → YOLO26 → ekran). |
| **NVIDIA DRIVE'ı hedeflemek** (otonom araç bilgisayarı) | Aynı pencereden **NVIDIA DRIVE** donanım kartı için yapılandırılmış Simulink modeli. |
| **PC'de çıkarımı hızlandırmak** | MATLAB'den çağrılabilen **TensorRT** veya **cuDNN** MEX'i ve otomatik FPS / gecikme testi. |
| **Dedektörü kendi yazılımınıza gömmek** | C++, C#, Python vb. için üretilmiş C++ kaynaklarıyla **EXE / DLL / LIB** derlemeleri. |
| **Motorları ve hassasiyetleri karşılaştırmak** | Tek tıkla TensorRT ↔ cuDNN, FP32 ↔ FP16, C++ ↔ C ve otomatik uyumluluk kontrolü. |
| **Model tabanlı çalışmak** | Masaüstü simülasyonu ve Jetson / DRIVE dağıtımı için otomatik Simulink modelleri. |
| **Sonucu hemen görmek** | Webcam veya yerleşik simülasyon moduyla gerçek zamanlı test: canlı FPS, gecikme ve tespitler. |
| **GPU kod üretimini öğrenmek** | GPU Coder raporu tek tık uzağınızda; her seçeneğin *Basic* ve *Professional* açıklaması var. |

### Bu depoda neler var?

| Dosya | Amaç |
|---|---|
| `README.md` | Bu sayfa (English + Türkçe). |
| `install_requirements.m` | Tek tıkla ortam kurulumu ve uygulama yükleyicisi (bkz. [Kurulum](#kurulum)). |
| `docs/USER_MANUAL.md` | Resimli, eksiksiz kullanım kılavuzu (İngilizce). |
| `docs/KULLANIM_KILAVUZU.md` | Resimli, eksiksiz kullanım kılavuzu (Türkçe). |
| **Releases →** `YOLO26 Deployment Studio.mlappinstall` | Uygulama paketi (~400 MB, önceden dönüştürülmüş YOLO26 modellerini içerir). [Releases](https://github.com/dogukankilinc/YOLO26-MATLAB-Studio/releases) sayfasından indirin. |

### Gereksinimler

**Ana bilgisayar (PC)**

| Öğe | Gereksinim |
|---|---|
| İşletim sistemi | Windows 10 / 11, 64-bit |
| GPU | CUDA destekli NVIDIA GPU (FP16 için Tensor Core'lu, compute capability ≥ 7.0 önerilir) |
| Sürücü | MATLAB R2026a'nın CUDA sürümünü destekleyen NVIDIA sürücüsü |
| MATLAB | **R2026a** (R2026a Update 4 ile test edildi) |
| C/C++ derleyici | **Microsoft Visual C++ 2019 / 2022** (GPU Coder için zorunlu; MinGW desteklenmez) |
| Python *(yalnızca yeni model dışa aktarmak için)* | `torch`, `torchvision`, `ultralytics`, `onnx` paketleriyle Python 3.10 – 3.12 — `install_requirements.m` kurar |

**MathWorks ürünleri**

| Ürün | Ne için gerekli |
|---|---|
| Deep Learning Toolbox, MATLAB Coder, GPU Coder, Parallel Computing Toolbox, Computer Vision Toolbox, Image Processing Toolbox | **Her zaman** |
| GPU Coder Interface for Deep Learning | **Her zaman** (TensorRT / cuDNN) |
| Deep Learning Toolbox Converter for ONNX Model Format | ONNX iş akışı |
| Deep Learning Toolbox Converter for PyTorch Model Format, MATLAB Coder Support Package for PyTorch and LiteRT Models | PT2 iş akışı |
| MATLAB Support Package for USB Webcams | Kamera testleri (yoksa yalnızca simülasyon modu) |
| Simulink, Simulink Coder | Simulink modelleri |
| Embedded Coder, MATLAB Coder Support Package for NVIDIA Jetson and NVIDIA DRIVE Platforms | **Jetson / DRIVE** hedefleri |

**NVIDIA Jetson / DRIVE kartı** *(yalnızca gömülü hedefler için)*

| Öğe | Gereksinim |
|---|---|
| Kart | NVIDIA Jetson (test edilen: **Jetson AGX Orin**) veya NVIDIA DRIVE AGX |
| Yazılım | MATLAB R2026a'nın desteklediği JetPack / DRIVE OS; CUDA, cuDNN ve TensorRT ile |
| Simulink modeli | Ekran bloğu için SDL 1.2 (`libsdl1.2-dev`), `/dev/video0` üzerinde USB/CSI kamera |
| Ortam | SSH kullanıcısının `PATH` / `LD_LIBRARY_PATH` değişkenlerinde CUDA (ör. `~/.bashrc`) |
| Ağ | Kart ve PC aynı ağda, SSH açık (IP adresi, kullanıcı adı, parola) |

### Kurulum

1. [Releases](https://github.com/dogukankilinc/YOLO26-MATLAB-Studio/releases) sayfasından `YOLO26 Deployment Studio.mlappinstall` dosyasını, bu depodan da `install_requirements.m` dosyasını **indirin** ve **ikisini aynı klasöre** koyun.
2. MATLAB'de `install_requirements.m`'yi **çalıştırın** (açıp **Run**'a basın). Yedi adımda ilerler ve istediğiniz kadar tekrar çalıştırılabilir — kurulu olanlar atlanır:

   | Adım | Ne yapar? |
   |---|---|
   | 1 | MATLAB sürümünü kontrol eder (test edilen: R2026a). |
   | 2 | Gerekli tüm toolbox ve destek paketlerini kontrol eder, eksikleri **Add-On Explorer**'da açar (her biri tek tıkla kurulur). |
   | 3 | Microsoft Visual C++ derleyicisini kontrol eder; MEX için seçer veya Visual Studio 2022 Build Tools kurmayı önerir. |
   | 4 | NVIDIA GPU'yu ve sürücüyü kontrol eder, eksikse GPU Coder'ın **TensorRT** kütüphanesini kurar. |
   | 5 | Python 3'ü bulur; yoksa mevcut kullanıcı için Python 3.11 kurar (yönetici yetkisi gerekmez). |
   | 6 | Python paketlerini (`torch`, `torchvision`, `ultralytics`, `onnx`) kurar. |
   | 7 | **YOLO26 Deployment Studio**'yu MATLAB **APPS** galerisine kurmayı önerir. |

   Yalnızca durum raporu mu istiyorsunuz? `install_requirements("CheckOnly")` çalıştırın — hiçbir şey indirilmez ya da kurulmaz.
3. Betik isterse (ör. derleyici kurulumundan sonra) **MATLAB'i yeniden başlatın** ve özet ekranında *MISSING* kalmayana kadar tekrar çalıştırın.
4. Uygulamayı **APPS → YOLO26 Deployment Studio** ile **başlatın**.

> [!TIP]
> Uygulamayı tek başına kurmak için `.mlappinstall` dosyasına çift tıklamanız da yeterlidir. Uygulama içinde **⚙ System Scan** ortamı istediğiniz an kontrol eder.

### Hızlı başlangıç

| Hedef | Adımlar |
|---|---|
| **PC'de GPU MEX** | Workflow **ONNX** → **ONNX** → **Validate Model** → *Host Windows*, *MEX*, *TensorRT*, *FP32* → **Start Build** → **Real-time Test → MEX Test** |
| **Jetson çalıştırılabilir dosyası** | Yükle + doğrula → *NVIDIA Jetson* (IP / kullanıcı / parola) → *EXE*, *TensorRT*, *FP16* → **Start Build** |
| **Jetson / DRIVE Simulink modeli** | Bağlı Jetson → **Generate Jetson Simulink** → kütüphane, hassasiyet, **SoC / Board Family** (*Generic*, *Xavier* veya *Drive*) → **Generate** |
| **Masaüstü Simulink modeli** | Doğrula → **Generate Simulink Model** |

Her ekran **[Kullanım Kılavuzu](docs/KULLANIM_KILAVUZU.md)**'nda adım adım anlatılmıştır.

### Performans (referans sistem)

RTX 4050 Laptop GPU · YOLO26n · TensorRT · FP32 · MEX: çıkarım başına **25,2 FPS · 39,6 ms** (derleme ≈ 5,5 dk, ilk TensorRT çalıştırması ≈ 3 dk).

### Bilinen kısıtlar

* ONNX iş akışı, GPU Coder uyumluluğu için ağın dikkat (attention) kısmını sadeleştirir; doğruluk orijinal Ultralytics modelinden biraz farklı olabilir.
* Giriş boyutu 640×640×3, batch 1 olarak sabittir. TensorRT motorları üretildikleri GPU'ya bağlıdır.
* *Start Build* NVIDIA Jetson için çapraz derleme yapar (compute capability 8.7, Orin); NVIDIA DRIVE üretilen Simulink modeli üzerinden desteklenir.
* Windows 11 ve MATLAB R2026a üzerinde test edilmiştir.

---

<div align="center">

**Doğukan M. KILINÇ** — [LinkedIn](https://www.linkedin.com/in/dgkilinc/)

</div>
