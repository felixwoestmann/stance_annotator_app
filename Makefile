
clean:
	flutter clean
	find . -name "*.g.dart" -type f -delete
	find . -name "*.freezed.dart" -type f -delete

clean_serve:
	flutter clean
	dart run build_runner build --delete-conflicting-outputs
	flutter build web
	cd build/web/ && python3 -m http.server
