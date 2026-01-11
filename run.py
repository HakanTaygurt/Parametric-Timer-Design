import os
import sys
from vunit import VUnit

# Windows veya Linux fark etmeksizin çalışması için GHDL yolunu
# elle vermiyoruz. VUnit (ve Docker) bunu PATH üzerinden bulur.

ui = VUnit.from_argv(compile_builtins=False)

# GHDL derleyicisi için ayarlar
try:
    # VUnit'in GHDL'i otomatik algılamasını sağlıyoruz
    ui.add_vhdl_builtins()
except Exception as e:
    print(f"⚠️ Uyarı: Builtin kütüphaneler eklenirken sorun oldu: {e}")

# Kütüphane ve dosyaları ekle
lib = ui.add_library("lib")
lib.add_source_files("src/*.vhd")
lib.add_source_files("tb/*.vhd")

# Test konfigürasyonları
tb = lib.test_bench("tb_timer")
tb.add_config(name="100MHz_10us", generics={"clk_freq_hz_g": 100000000, "delay_us_g": 10})
tb.add_config(name="10MHz_1ms", generics={"clk_freq_hz_g": 10000000, "delay_us_g": 1000})

if __name__ == "__main__":
    ui.main()