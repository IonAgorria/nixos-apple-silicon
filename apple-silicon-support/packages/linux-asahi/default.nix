{
  lib,
  callPackage,
  linuxPackagesFor,
  _kernelPatches ? [ ],
}@args:

let
  extraArgs = lib.removeAttrs args [
    "lib"
    "callPackage"
    "linuxPackagesFor"
    "_kernelPatches"
  ];

  linux-asahi-pkg =
    {
      stdenv,
      lib,
      fetchFromGitHub,
      buildLinux,
      ...
    }:
    buildLinux (
      lib.recursiveUpdate rec {
        inherit stdenv lib;

        pname = "linux-asahi";
        version = "7.2.14";
        modDirVersion = version;
        extraMeta.branch = "7.2";

        src = fetchFromGitHub {
          owner = "AsahiLinux";
          repo = "linux";
          rev = "ad2ca9b65c1b2594588d08cb86d77cbf0ef4b80e"; #fairydust
          hash = "sha256-K7JbQQe0rYIgKE7golf4jU2ljlSzYKAkrLMlMp44NBc=";
        };

        kernelPatches = [
          {
            name = "Asahi config";
            patch = null;
            structuredExtraConfig = with lib.kernel; {
ARM64_ACTLR_STATE = yes;
ARCH_APPLE = yes;
ARM64_16K_PAGES = yes;
ARM64_MEMORY_MODEL_CONTROL = yes;
ARM_APPLE_CPUIDLE = yes;
ARM_APPLE_SOC_CPUFREQ = module;
BT_BRCMEXT = yes;
BT_HCIBCM4377 = module;
PCIE_APPLE = module;
NVME_APPLE = module;
BRCMFMAC = module;
BRCMFMAC_PCIE = yes;
TOUCHSCREEN_APPLE_Z2 = module;
INPUT_MACSMC_INPUT = module;
I2C_APPLE = module;
SPI_APPLE = module;
SPMI_APPLE = module;
PINCTRL_APPLE_GPIO = module;
GPIO_MACSMC = module;
POWER_RESET_MACSMC = module;
MACSMC_POWER = module;
SENSORS_MACSMC_HWMON = module;
APPLE_WATCHDOG = module;
VIDEO_APPLE_AVD = module;
VIDEO_APPLE_ISP = module;
DRM = yes;
DRM_ASAHI = module;
DRM_ADP = module;
DRM_APPLE = module;
DRM_APPLE_AUDIO = yes;
SND_SOC_APPLE_AOP_AUDIO = module;
SND_SOC_APPLE_MCA = module;
SND_SOC_APPLE_MACAUDIO = module;
SND_SOC_CS42L83 = module;
SND_SOC_CS42L84 = module;
SND_SOC_TAS2764 = module;
SND_SOC_TAS2770 = module;
HID_APPLE = module;
HID_MAGICMOUSE = module;
SERIAL_SAMSUNG = yes;
SERIAL_SAMSUNG_CONSOLE = yes;
HID_DOCKCHANNEL = module;
SPI_HID_APPLE_OF = module;
SPI_HID_APPLE_CORE = module;
USB_DWC3_APPLE = module;
USB_XHCI_PCI_ASMEDIA = yes;
RTC_DRV_MACSMC = module;
APPLE_ADMAC = module;
APPLE_SIO = module;
MFD_MACSMC = module;
COMMON_CLK_APPLE_NCO = module;
APPLE_DART = module;
APPLE_DOCKCHANNEL = module;
APPLE_MAILBOX = yes;
APPLE_PMGR_MISC = yes;
APPLE_RTKIT = yes;
APPLE_RTKIT_HELPER = module;
APPLE_SART = module;
RUST_APPLE_RTKIT = yes;
APPLE_AOP = module;
APPLE_SEP = module;
APPLE_PMGR_PWRSTATE = yes;
APPLE_PMP = module;
APPLE_PMP_REPORT = yes;
IIO_AOP_SENSOR_LAS = module;
IIO_AOP_SENSOR_ALS = module;
RUST_FW_LOADER_ABSTRACTIONS = yes;
PWM_APPLE = module;
APPLE_AIC = yes;
PHY_APPLE_ATC = module;
PHY_APPLE_DPTX = module;
APPLE_M1_CPU_PMU = yes;
NVMEM_APPLE_EFUSES = module;
NVMEM_APPLE_SPMI = module;
MUX_APPLE_DPXBAR = module;
TYPEC_TPS6598X = module;
TYPEC_SN201202X = module;
RESET_APPLE_CIO = module;
USB4 = module;
USB4_APPLE_SOC = module;
            };
            features.rust = true;
          }
        ]
        ++ _kernelPatches;
      } extraArgs
    );

  linux-asahi = callPackage linux-asahi-pkg { };
in
lib.recurseIntoAttrs (linuxPackagesFor linux-asahi)
