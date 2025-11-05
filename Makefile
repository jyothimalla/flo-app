# One-time setup for this machine/project
setup:
	flutter config --enable-macos-desktop
	flutter create .
	flutter pub add intl:^0.20.2
	flutter pub get

# Normal dev run (macOS)
macos:
	flutter pub get
	flutter run -d macos

# Normal dev run (Chrome)
chrome:
	flutter pub get
	flutter run -d chrome

# Fix weird build issues
fix:
	flutter clean
	flutter pub get

# Upgrade Flutter toolchain (occasionally)
upgrade:
	flutter upgrade
