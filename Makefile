
clean:
	flutter clean
	find . -name "*.g.dart" -type f -delete
	find . -name "*.freezed.dart" -type f -delete

serve:
	cd build/web/ && python3 -m http.server

build:
	dart run build_runner build --delete-conflicting-outputs
	flutter build web
