# Copyright 2024 The OpenXLA Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""Lit runner configuration."""

import os
import sys
import lit.formats
from lit.llvm import llvm_config
import lit.util

# pylint: disable=undefined-variable

config.name = "XLA"
config.suffixes = [".cc", ".hlo", ".json", ".mlir", ".pbtxt", ".py"]

config.test_format = lit.formats.ShTest(execute_external=False)

# Passthrough XLA_FLAGS.
config.environment["XLA_FLAGS"] = os.environ.get("XLA_FLAGS", "")

# Use the most preferred temp directory.
config.test_exec_root = (
    os.environ.get("TEST_UNDECLARED_OUTPUTS_DIR")
    or os.environ.get("TEST_TMPDIR")
    or os.path.join(tempfile.gettempdir(), "lit")
)

# Adjusted the PATH to correctly detect the tools on Windows
if sys.platform == "win32":
  config.llvm_tools_dir = r"..\llvm-project\llvm"
  config.xla_translate_tools_dir = r"..\xla\xla\translate"
llvm_config.with_environment("PATH", config.llvm_tools_dir, append_path=True)
llvm_config.with_environment(
    "PATH", config.xla_translate_tools_dir, append_path=True
)

config.substitutions.extend([
    ("%PYTHON", os.getenv("PYTHON", sys.executable)),
])

# Include additional substitutions that may be defined via params
config.substitutions.extend(
    ("%%{%s}" % key, val) for key, val in lit_config.params.items()
)
