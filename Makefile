
clean_serve:
	flutter clean
	dart run build_runner build --delete-conflicting-outputs
	flutter build web
	cd build/web/ && python3 -m http.server
