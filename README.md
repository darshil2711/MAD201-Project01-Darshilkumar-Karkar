Smart Budget Tracker Lite
A simple, cross-platform budget tracking application built with Flutter. This app allows users to record their daily income and expenses, view their transaction history, and see a summary of their current balance.

This project was built for the MAD201 (Cross-Platform) course.

🚀 Features
Add, Edit, & Delete income or expense transactions.

View a Home Dashboard with total income, total expenses, and current balance.

See a complete Transaction History list, color-coded by type.

Get a simple Report summarizing spending by category.

Settings page to set currency preferences and toggle Light/Dark mode.

Fetches a live (USD to CAD) currency conversion rate from an API.

Web Compatible: Uses SharedPreferences as a JSON database, so it runs in Chrome.

🛠️ Tech Stack
Flutter & Dart

State Management: provider (for theme)

Local Storage: shared_preferences (used as a JSON-based database)

API: http package (for exchangerate-api.com)

Formatting: intl package

🏁 How to Run
Clone the repository:

Bash

git clone https://github.com/darshil2711/MAD201-Project01-Darshilkumar-Karkar.git
Navigate into the project folder and get packages:

Bash

cd MAD201-Project01-Darshilkumar-Karkar/smart_budget_tracker
flutter pub get
IMPORTANT: Add API Key

Get a free API key from https://www.exchangerate-api.com.

Open the file lib/services/api_service.dart.

Paste your API key in place of YOUR_API_KEY.

Run the app:

Bash

flutter run
