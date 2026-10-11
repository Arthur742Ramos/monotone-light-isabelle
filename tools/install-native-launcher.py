"""Install isabelle-native into the current virtual environment only."""
from pathlib import Path
import sys
import sysconfig
from pip._vendor.distlib.scripts import ScriptMaker

if sys.prefix == sys.base_prefix:
    raise SystemExit("Run this installer with your Blueprint virtual-environment Python")
script = Path(__file__).with_name("isabelle-native-bridge.py").resolve()
module = Path(sysconfig.get_path("purelib")) / "blueprint_native_bridge.py"
module.write_text("import runpy\ndef main():\n    runpy.run_path(" + repr(str(script)) + ", run_name='__main__')\n", encoding="utf-8")
maker = ScriptMaker(None, sysconfig.get_path("scripts"))
maker.executable = sys.executable
maker.variants = {""}
print(maker.make("isabelle-native = blueprint_native_bridge:main"))
