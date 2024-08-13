#!/bin/bash

set -euo pipefail

pdm build

cd example
pdm remove --dev orbie || true
pdm add --dev ../dist/*.whl
pdm install
pdm run orbie --help || true

FAILED=0

# Expect several tangled modules
if pdm run orbie src/example/example_a/example_a.py; then
  echo "FAIL: Unexpected success"
  FAILED=$((FAILED+1))
else
  echo "PASS: Failed as expected"
fi

# Expect 0 tangled modules after marking exception
if pdm run orbie src/example/example_a/example_a.py --exception src/example/example_shared --except-siblings --except-descendents; then
  echo "PASS: Success as expected"
else
  echo "FAIL: Unexpected failure"
  FAILED=$((FAILED+1))
fi

# Expect 0 tangled modules after marking exceptions explicitly
if pdm run orbie --debug src/example/example_a/example_a.py --exception src/example/example_shared/shared.py --except-siblings --except-descendents; then
  echo "PASS: Success as expected"
else
  echo "FAIL: Unexpected failure"
  FAILED=$((FAILED+1))
fi

# Test with ./ style relative paths
if pdm run orbie --debug src/example/example_a/example_a.py --exception ./src/example/example_shared/shared.py --except-siblings --except-descendents; then
  echo "PASS: Success as expected"
else
  echo "FAIL: Unexpected failure"
  FAILED=$((FAILED+1))
fi

# Expect 1 tangled modules
if pdm run orbie src/example/example_b/example_b.py; then
  echo "FAIL: Unexpected success"
  FAILED=$((FAILED+1))
else
  echo "PASS: Failed as expected"
fi

# Expect 0 tangled modules after marking exception
if pdm run orbie src/example/example_b/example_b.py --exception src/example/example_a; then
  echo "PASS: Success as expected"
else
  echo "FAIL: Unexpected failure"
  FAILED=$((FAILED+1))
fi

# Expect 1 tangled modules
if pdm run orbie src/example/example_c/example_c.py; then
  echo "FAIL: Unexpected success"
  FAILED=$((FAILED+1))
else
  echo "PASS: Failed as expected"
fi

# Expect 0 tangled modules after marking exception
if pdm run orbie src/example/example_c/example_c.py --except-descendents; then
  echo "PASS: Success as expected"
else
  echo "FAIL: Unexpected failure"
  FAILED=$((FAILED+1))
fi

# Expect 0 tangled modules
if pdm run orbie src/example/example_d/example_d.py; then
  echo "PASS: Success as expected"
else
  echo "FAIL: Unexpected failure"
  FAILED=$((FAILED+1))
fi

echo "${FAILED} failures in testsuite."
if [ ${FAILED} -ne 0 ]; then
  exit 1
fi
