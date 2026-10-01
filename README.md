# nKount - Nepali Accounting Software

A **production-ready**, **IRD-compliant** accounting software for Nepali businesses built with **Flutter** and **Riverpod**. Designed for small and medium enterprises (SMEs) in Nepal.

## 🚀 Features

### ✅ Core Accounting
- **Contacts Management** - Customers & Suppliers with balance tracking
- **Product Inventory** - Track stock levels, prices, and categories
- **Purchase Records** - Record purchases with VAT support
- **Sales Records** - Create invoices with automatic calculations
- **Payment Tracking** - Record payments and receipts (Cash, Bank, Cheque, Online)

### ✅ Compliance
- **IRD Compliant** - Follows Nepal Financial Reporting Standards (NFRS)
- **VAT Support** - 13% VAT calculation and reporting
- **Nepali Localization** - NPR currency, Nepali date formats
- **Tax Reporting** - Generate IRD-compliant reports

### ✅ Modern Web App
- **Responsive Design** - Works on desktop, tablet, and mobile
- **Persistent Storage** - Data saved locally using Hive (IndexedDB for web)
- **Real-time Updates** - Instant UI updates with Riverpod state management
- **Production Ready** - Optimized for GitHub Pages deployment

## 📊 Screens

| Screen | Description |
|--------|-------------|
| Dashboard | Financial overview, quick actions, recent activity |
| Contacts | Manage customers and suppliers |
| Products | Manage inventory items |
| Sales | Create and track sales invoices |
| Purchases | Record purchase transactions |
| Payments | Track payments and receipts |

## 🛠️ Tech Stack

| Component | Technology |
|-----------|------------|
| **Framework** | Flutter 3.19+ |
| **State Management** | Riverpod 2.4+ |
| **Persistence** | Hive (with IndexedDB for web) |
| **Routing** | GoRouter |
| **Forms** | Flutter Form Builder |
| **Localization** | flutter_localizations + intl |
| **Styling** | Material Design 3 |
| **Deployment** | GitHub Pages + GitHub Actions |

## 📦 Installation

### Prerequisites
- Flutter SDK 3.0+
- Dart 3.0+
- Git

### Setup

```bash
# Clone the repository
git clone https://github.com/namunaONE/nKount.git
cd nKount

# Install dependencies
flutter pub get

# Run the app (web)
flutter run -d chrome

# Build for production
flutter build web --base-href /nKount/ --release
```

## 🚀 Deployment to GitHub Pages

### Automatic Deployment
The repository is configured with GitHub Actions for automatic deployment:

1. Push to `main` branch
2. GitHub Actions will automatically:
   - Build the Flutter web app
   - Deploy to GitHub Pages

### Manual Deployment

```bash
# Build the web app
flutter build web --base-href /nKount/ --release

# Deploy to GitHub Pages
cd build/web
git init
git add .
git commit -m "Deploy to GitHub Pages"
git remote add origin https://github.com/namunaONE/nKount.git
git push -u origin main:gh-pages
```

### Access the App
After deployment, the app will be available at:
```
https://namunaone.github.io/nKount/
```

## 📁 Project Structure

```
nKount/
├── lib/
│   ├── core/
│   │   ├── constants/          # App constants and Nepali-specific config
│   │   ├── models/             # Data models (Contact, Product, Transaction, Payment)
│   │   ├── providers/          # Riverpod providers and state management
│   │   ├── repositories/       # Data repositories
│   │   ├── services/           # Services (storage, etc.)
│   │   └── utils/              # Utilities (theme, helpers, etc.)
│   ├── features/
│   │   ├── contacts/           # Contacts feature
│   │   ├── purchases/          # Purchases feature
│   │   ├── sales/              # Sales feature
│   │   ├── payments/           # Payments feature
│   │   └── dashboard/          # Dashboard feature
│   └── app.dart                # Main app entry point
├── web/
│   └── index.html             # Web entry point with GitHub Pages config
├── .github/
│   └── workflows/
│       └── deploy.yml         # GitHub Actions workflow
├── pubspec.yaml              # Dependencies
└── README.md                 # Documentation
```

## 💰 Nepali Accounting Standards

This software follows:

### NFRS (Nepal Financial Reporting Standards)
- Based on IFRS (International Financial Reporting Standards)
- Mandatory for all public interest entities and medium/large enterprises
- Principles-based framework

### IRD Compliance
- **E-Billing** - Electronic billing system support
- **VAT Reporting** - 13% VAT calculation and reporting
- **Invoice Requirements** - IRD-compliant invoice format
- **Record Keeping** - Maintains proper accounting records

### Key Features for Nepal
- **Currency**: Nepali Rupees (NPR / रू)
- **Date Format**: Gregorian (AD) with option for Nepali (BS)
- **Tax Rates**: Configurable VAT rate (default 13%)
- **Language**: English and Nepali support

## 🎯 Usage

### First Time Setup
1. **Create Company Profile**
   - Set up your business information
   - Configure VAT/PAN numbers
   - Set default settings

2. **Add Contacts**
   - Add customers and suppliers
   - Set opening balances if any

3. **Add Products**
   - Create your product catalog
   - Set purchase and sale prices
   - Configure inventory tracking

4. **Record Transactions**
   - Create sales invoices
   - Record purchases
   - Track payments

### Daily Workflow
1. Create new sales invoices for customers
2. Record purchases from suppliers
3. Track payments received and made
4. Monitor outstanding receivables and payables
5. Generate reports for decision making

## 📊 Data Models

### Contact
- Name, Phone, Mobile, Email, Address
- Type (Customer/Supplier/Both)
- VAT Number, PAN Number
- Opening Balance, Current Balance
- Total Purchases, Total Sales

### Product
- Name, Code, Barcode
- Category, Brand, Unit
- Purchase Price, Sale Price, Cost Price
- Quantity, Minimum Quantity
- Taxable, Tax Rate

### Transaction (Purchase/Sale)
- Type, Invoice Number
- Contact ID
- Items (Product, Quantity, Price)
- Subtotal, Discount, Tax, Total
- Payment Status (Pending/Partial/Paid)
- Date, Due Date, Notes

### Payment
- Type (Payment/Receipt)
- Transaction ID, Invoice Number
- Contact ID
- Amount, Method
- Reference Number, Bank, Cheque Details
- Date, Status (Cleared/Pending)

## 🎨 UI/UX Features

- **Material Design 3** - Modern, clean interface
- **Responsive Layout** - Works on all screen sizes
- **Dark Mode** - Optional dark theme
- **Nepali Styling** - Custom colors and fonts for Nepali users
- **Accessibility** - Follows Flutter accessibility guidelines

## 🔧 Configuration

### Environment Variables
Create a `.env` file for local development:

```env
# App Configuration
APP_NAME=nKount
APP_VERSION=1.0.0

# IRD Configuration
IRD_VERSION=2081/82
DEFAULT_VAT_RATE=13.0

# Database
HIVE_BOX_PREFIX=nkount_
```

### Settings
Configure app settings through the Settings screen:
- Company Information
- Default VAT Rate
- Invoice Prefix and Numbering
- Currency and Date Formats
- Nepali Date (BS) Support

## 📈 Reporting

### Available Reports
- **Sales Report** - Daily, Monthly, Yearly sales
- **Purchase Report** - Supplier-wise purchases
- **Payment Report** - Payment and receipt history
- **Outstanding Report** - Receivables and payables
- **Inventory Report** - Stock levels and valuation
- **Profit & Loss** - Financial performance
- **Balance Sheet** - Financial position

### IRD Reports
- **VAT Report** - VAT calculation and summary
- **Invoice Report** - All invoices with IRD format
- **Tax Report** - Tax liabilities

## 🔒 Data Security

### Local Storage
- **Hive** - Encrypted local storage
- **IndexedDB** - Web browser storage
- **No Cloud Sync** - Data stays on your device (for now)

### Backup & Restore
- Export all data to JSON
- Import from JSON backup
- Manual backup recommended

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines
- Follow Flutter best practices
- Use Riverpod for state management
- Keep widgets small and reusable
- Add tests for new features
- Update documentation

## 📝 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter** - Amazing cross-platform framework
- **Riverpod** - Powerful state management
- **Hive** - Fast and secure local storage
- **IRD Nepal** - For accounting standards and guidelines
- **Nepali Developers Community** - Support and inspiration

## 📞 Support

For support, questions, or feedback:

- **Email**: support@namunaone.com.np
- **Website**: https://namunaone.com.np
- **GitHub Issues**: https://github.com/namunaONE/nKount/issues

---

**Made with ❤️ in Nepal**

*Simple Accounting for Nepali Businesses*
