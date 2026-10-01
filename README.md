# nKount - Nepali Accounting Software

[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-Live-brightgreen)](https://namunaone.github.io/nKount/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B.svg)](https://flutter.dev)
[![Riverpod](https://img.shields.io/badge/Riverpod-2.x-764ABC.svg)](https://riverpod.dev)
[![Hive](https://img.shields.io/badge/Hive-2.x-FF6B6B.svg)](https://docs.hivedb.dev)

**nKount** is a **simple, modern, and IRD-compliant** accounting software designed specifically for **Nepali businesses**. Built with **Flutter for Web**, it works **offline-first** using IndexedDB and features a beautiful **Claymorphism design**.

---

## ✨ Features

### 📊 Accounting
- ✅ **Contacts Management** - Customers, Suppliers, and Both
- ✅ **Product Inventory** - Stock tracking, pricing, categories
- ✅ **Transactions** - Sales, Purchases, Expenses, Income
- ✅ **Payments & Receipts** - Cash, Bank, Cheque, Online
- ✅ **Automatic Balances** - Contact and product balances
- ✅ **Tax Calculation** - 13% VAT (default), custom tax rates
- ✅ **Invoice Numbering** - Auto-generated invoice numbers

### 🏛️ IRD Compliance (Nepal)
- ✅ **13% VAT** as default tax rate
- ✅ **VAT Number** tracking
- ✅ **PAN Number** support
- ✅ **IRD Version 2081/82** compliant
- ✅ **Nepali Currency** (NPR, रू)

### 💾 Data Management
- ✅ **Offline-First** - Works without internet
- ✅ **IndexedDB Storage** - Persistent data in browser
- ✅ **Auto-Backup** - Export/import data
- ✅ **Sync Ready** - Architecture ready for cloud sync

### 🎨 Design
- ✅ **Claymorphism** - Modern 3D-like UI
- ✅ **Responsive** - Works on desktop, tablet, mobile
- ✅ **Nepali Font** - Noto Sans Devanagari
- ✅ **Dark/Light Mode** - Coming soon

### 📈 Reports
- ✅ **Dashboard** - Quick overview
- ✅ **Sales Report** - Revenue tracking
- ✅ **Purchase Report** - Expense tracking
- ✅ **Payment Report** - Cash flow
- ✅ **Balance Sheet** - Financial summary

---

## 🚀 Quick Start

### Option 1: Use Online (Recommended)

Visit the live demo:
👉 **[https://namunaone.github.io/nKount/](https://namunaone.github.io/nKount/)**

### Option 2: Run Locally

```bash
# Clone the repository
git clone https://github.com/namunaONE/nKount.git
cd nKount

# Get dependencies
flutter pub get

# Generate code (Freezed, JSON, Riverpod)
flutter pub run build_runner build

# Run web app
flutter run -d chrome
```

### Option 3: Build for Production

```bash
# Build for web
flutter build web --release

# Serve locally
cd build/web
python -m http.server 8000

# Or use any static server
npx serve -s build/web
```

---

## 📁 Project Structure

```
nKount/
├── lib/
│   ├── features/
│   │   ├── app/               # Main app router & theme
│   │   ├── dashboard/         # Dashboard screen
│   │   ├── contacts/          # Contacts CRUD
│   │   ├── products/          # Products CRUD
│   │   ├── transactions/      # Sales & Purchases
│   │   ├── payments/          # Payments tracking
│   │   ├── reports/           # Financial reports
│   │   └── settings/          # App settings
│   ├── core/
│   │   ├── models/            # Data models (14 models)
│   │   ├── database/          # Hive/IndexedDB service
│   │   ├── constants/         # App constants
│   │   ├── services/          # Sync, storage services
│   │   └── repositories/      # Data repositories
│   └── main.dart             # App entry point
├── packages/
│   ├── design-system/        # Claymorphism components
│   ├── shared/               # Shared utilities
│   └── database/             # Database utilities
├── web/
│   ├── index.html            # GitHub Pages ready
│   └── manifest.json         # PWA manifest
├── .github/workflows/
│   ├── deploy.yml            # Auto-deploy to GitHub Pages
│   ├── test.yml              # Run tests
│   └── codegen.yml           # Code generation
└── pubspec.yaml              # Dependencies
```

---

## 🛠️ Technologies Used

| Technology | Purpose | Version |
|------------|---------|---------|
| **Flutter** | Cross-platform UI framework | 3.x |
| **Riverpod** | State management | 2.x |
| **GoRouter** | Navigation | 13.x |
| **Hive** | Local database (IndexedDB) | 2.x |
| **Freezed** | Immutable models | 2.x |
| **JSON Serialization** | Model serialization | 6.x |
| **Claymorphism** | Modern UI design | Custom |

---

## 🎨 Claymorphism Design

nKount uses **Claymorphism** - a modern UI design trend that features:

- **Soft, clay-like** elements with depth
- **Subtle shadows** for 3D appearance
- **Pastel colors** with gentle gradients
- **Neumorphism evolution** with more realism

### Color Palette

```dart
ClayColors.primary    // #6C5CE7 (Purple)
ClayColors.secondary  // #A29BFE (Light Purple)
ClayColors.tertiary   // #FD79A8 (Pink)
ClayColors.success    // #00B894 (Green)
ClayColors.warning    // #FDCB6E (Yellow)
ClayColors.error      // #D63031 (Red)
ClayColors.info       // #0984E3 (Blue)
```

---

## 📊 Accounting Rules Implemented

### Contact Balances
```
Purchase:  Balance += Amount
Sale:     Balance -= Amount
Payment:  Balance -= Amount (to supplier)
Receipt:  Balance += Amount (from customer)
```

### Transaction Types
- **Sale** - Revenue, customer balance decreases
- **Purchase** - Expense, supplier balance increases
- **Expense** - Business expense
- **Income** - Other income

### Payment Status
- **Pending** - Not paid
- **Partial** - Partially paid
- **Paid** - Fully paid
- **Cancelled** - Cancelled

### Tax Calculation
```
VAT = (Subtotal - Discount) * VAT Rate / 100
Total = Subtotal - Discount + VAT
```

---

## 🏗️ Development Setup

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) 3.0+
- [Git](https://git-scm.com/downloads)
- [Node.js](https://nodejs.org/) (for web development)

### Installation

```bash
# Clone the repository
git clone https://github.com/namunaONE/nKount.git
cd nKount

# Get Flutter dependencies
flutter pub get

# Generate code (required for models)
flutter pub run build_runner build

# Run the app
flutter run
```

### Code Generation

Whenever you modify models in `lib/core/models/`, run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates:
- Freezed files (`*.freezed.dart`)
- JSON serialization (`*.g.dart`)
- Riverpod providers

---

## 🚀 Deployment

### GitHub Pages (Recommended)

1. **Build the app:**
   ```bash
   flutter build web --release
   ```

2. **Push to `gh-pages` branch:**
   ```bash
   cd build/web
   git init
   git add .
   git commit -m "Deploy nKount"
   git remote add origin https://github.com/namunaONE/nKount.git
   git push -u origin HEAD:gh-pages --force
   ```

3. **Enable GitHub Pages:**
   - Go to **Settings > Pages**
   - Select **gh-pages** branch
   - Select **/ (root)** folder
   - Save

4. **Access your app:**
   - `https://namunaone.github.io/nKount/`

### Netlify / Vercel / Firebase

The `build/web` folder can be deployed to any static hosting service.

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use **2 spaces** for indentation
- **80 characters** line length limit
- **Lower camel case** for variables and functions
- **Upper camel case** for classes and types

---

## 📜 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Flutter Team** - For the amazing framework
- **Riverpod** - For modern state management
- **Hive** - For simple local storage
- **namunaONE** - For the vision

---

## 📞 Support

For questions, issues, or feedback:

- **GitHub Issues**: [https://github.com/namunaONE/nKount/issues](https://github.com/namunaONE/nKount/issues)
- **Email**: info@namunaone.com.np
- **Website**: [https://namunaone.com.np](https://namunaone.com.np)

---

## 🎯 Roadmap

### ✅ Completed
- [x] Core accounting features
- [x] Claymorphism design system
- [x] Offline-first architecture
- [x] GitHub Pages deployment
- [x] IRD compliance

### 🚧 In Progress
- [ ] Nepali date picker (Bikram Sambat)
- [ ] PDF invoice generation
- [ ] Advanced reporting
- [ ] Multi-company support

### 📋 Planned
- [ ] Cloud sync (Firebase/Supabase)
- [ ] Authentication
- [ ] Mobile apps (Android/iOS)
- [ ] Barcode scanner
- [ ] Multi-currency support

---

**Made with ❤️ in Nepal**

*Simple Accounting for Nepali Businesses*
