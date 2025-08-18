# expenses

A simple expenses app.

## Getting Started To run the project

Run the following commands

1. `flutter pub get`
2. create the api key to the `.env` file with the name `API_KEY`
3. `flutter pub run build_runner build --delete-conflicting-outputs` for generating the build files
4. `flutter run`

## I've used envied to handle the API-KEY to not be exposed in the project files & to auto encrypt the API-KEY

## I've used hydrated_bloc to cash data to display the last cached data when the application opens without internet connection

## I've used request_inspector to debug network calls

## To see the result install the apk attached apk file with the repo

Finished features marked with [x]:

- [x] You should handle the internet connection state.
- [x] If the user gives access to location , the API should be called and fetches the current expenses information with a button to call the API again to refresh data.
- [x] You should encrypt the API-KEY to not be exposed in the project files.
- [x] If the location access is denied, a button should be shown to request location access again.
- [x] Require Location Access when the application is first opened.
- [x] You should implement a network layer for API calls.
- [x] You should use clean-architecture for this feature.
- [x] You should use Cubit as State Management.
- [x] You should use DIO for API calls with an interceptor for logging .
- [x] You are free to use any UI you want.
- [x] Add your code to a github repo and send us the link.

Bonus (Recommended)

- [ ] Add widget-test and integration test for this feature.
- [x] Cache the API response to display the last cached data when the application opens without internet connection.

## Main Features screenshots
![alt text](<Simulator Screenshot - iPhone 16 Pro Max - 2025-07-21 at 09.16.10.png>) ![alt text](<Simulator Screenshot - iPhone 16 Pro Max - 2025-07-21 at 09.16.28.png>) ![alt text](<Simulator Screenshot - iPhone 16 Pro Max - 2025-07-21 at 09.13.58.png>) ![alt text](<Simulator Screenshot - iPhone 16 Pro Max - 2025-07-21 at 09.14.22.png>)