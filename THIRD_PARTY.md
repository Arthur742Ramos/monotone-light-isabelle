# Third-party source

`tools/token_markup.scala` derives from
`linter_base/src/token_markup.scala` in
[isabelle-prover/isabelle-linter](https://github.com/isabelle-prover/isabelle-linter/blob/c9983adc5c51a6455f702bb58c9f960d425a2af3/linter_base/src/token_markup.scala),
revision `c9983adc5c51a6455f702bb58c9f960d425a2af3`.
The upstream author header credits Fabian Huch. The upstream copyright is
Copyright (c) 2022 Chair for Logic and Verification, TUM.
Its exact [MIT notice](tools/ISABELLE-LINTER-LICENSE) applies to this copied
and adapted file. The local change exposes command spans through transparent
Isabelle2025-2 `command_range` XML wrappers, preserving the enclosed text and
markup. The complete diff is [token_markup.patch](tools/token_markup.patch).

The formal entry remains under its BSD 2-Clause licence. The linter helper,
patch, third-party notice and validation tools are excluded from the AFP archive.
Pinned upstream downloads and checksums are in [tools/inputs.json](tools/inputs.json).
