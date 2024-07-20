#!/bin/sh

pdm build

cd example
pdm add --dev ../dist/*.whl
pdm install
pdm run orbie --help
# Expect 1 tangled module (src/example/example_shared/shared.py)
pdm run orbie src/example/example_a/example_a.py
# Expect 0 tangled modules after marking exception
pdm run orbie src/example/example_a/example_a.py --exception src/example/example_shared
# Expect 1 tangled modules (src/example/example_a/__init__.py)
pdm run orbie src/example/example_b/example_b.py
