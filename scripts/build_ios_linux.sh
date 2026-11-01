#!/usr/bin/env bash
set -euo pipefail
app=$(cd "$(dirname "$0")/.." && pwd)
: "${SHEEPLINK_IOS_TOOLCHAIN:?Set the path to the prepared omarchy-apple-dev checkout}"
if [ -n "${LLVM_BINDIR:-}" ]; then export PATH="$LLVM_BINDIR:$PATH"; fi
python3 "$app/scripts/check_ios_configuration.py"
"$SHEEPLINK_IOS_TOOLCHAIN/flutter/build.sh" "$app"
# The upstream wrapper currently omits app-level Copy Bundle Resources files.
python3 "$app/scripts/prepare_ios_linux_bundle.py" "$app/build/ios-linux/Payload/Runner.app"
rm -f "$app/build/ios-linux/Runner.ipa"
(cd "$app/build/ios-linux" && zip -qry Runner.ipa Payload)
echo "SheepLink Linux IPA: $app/build/ios-linux/Runner.ipa (unsigned)"
