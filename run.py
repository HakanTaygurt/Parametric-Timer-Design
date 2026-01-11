import os
import sys
from vunit import VUnit

GHDL_ROOT = r"C:\GHDL"
GHDL_BIN  = os.path.join(GHDL_ROOT, "bin")
GHDL_EXE  = os.path.join(GHDL_BIN, "ghdl.exe")

if not os.path.exists(GHDL_EXE):
    print(f"❌ HATA: GHDL dosyasi bulunamadi: {GHDL_EXE}")
    sys.exit(1)

os.environ["PATH"] = GHDL_BIN + os.pathsep + os.environ["PATH"]
os.environ["VUNIT_GHDL_PATH"] = GHDL_BIN

ui = VUnit.from_argv(compile_builtins=False)

try:
    from vunit.sim_if import ghdl
    class WindowsGHDL(ghdl.GHDLInterface):
        executable = "ghdl.exe"
        @classmethod
        def determine_backend(cls, prefix):
            return "mcode"
    ui._simulator_class = WindowsGHDL
except ImportError:
    print("❌ VUnit yuklenemedi.")
    sys.exit(1)

ui.add_vhdl_builtins()

lib = ui.add_library("lib")
lib.add_source_files("src/*.vhd")
lib.add_source_files("tb/*.vhd")

tb = lib.test_bench("tb_timer")
tb.add_config(name="100MHz_10us", generics={"clk_freq_hz_g": 100000000, "delay_us_g": 10})
tb.add_config(name="10MHz_1ms", generics={"clk_freq_hz_g": 10000000, "delay_us_g": 1000})

if __name__ == "__main__":
    ui.main()