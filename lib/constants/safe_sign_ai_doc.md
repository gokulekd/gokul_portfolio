Project Document: SafeSign AI (Flutter Mobile)
1. App Idea & Vision
SafeSign AI is a "Legal Risk Detective" designed for the everyday consumer. It uses Vision AI to scan physical or digital contracts (Leases, Gym Memberships, Employment Offers, NDAs) and identifies predatory clauses, hidden costs, and auto-renewal traps before the user signs. The goal is to provide "Legal Clarity in Seconds."

2. Detailed Explanations
The Problem: Most people sign contracts without reading them because they are too long or full of legalese. This results in "Memory Debt" (forgetting about auto-renewals) or "Financial Traps" (unfair exit fees).

The Solution: A mobile app that converts dense legal text into a scannable dashboard with a risk score.

Target Audience: High-priority on iOS users (professionals, freelancers, and renters) followed by Android users.

3. Visual Theme & UI (iOS Focus)
Style: "Apple Professional" – Clean, minimalist, and high-trust.

Colors: * Primary: Deep Navy (#0A192F) for authority.

Accent: Safety Orange (#FF8C00) for risks.

Background: Off-White (#F5F5F7) for readability.

Typography: San Francisco (System UI).

Key Animation: A "Scanning Laser" overlay when the AI is processing the document.

4. Architecture & State Management
Architecture: Clean Architecture (Data, Domain, and Presentation layers).

State Management: Riverpod (Essential for handling async AI streams and state persistence).

Navigation: go_router for deep-linking support.

5. Modules & Data Management
Onboarding: Auth via Firebase (Sign in with Apple is mandatory for iOS).

Scanner: Camera integration + google_ml_kit for on-device OCR.

Analysis Engine: Displays Risk Score (1-10), Red Flags, and Negotiation Scripts.

Archive/History: Local storage of previous scans for user privacy.

Data Management: * Local: Isar or Hive (encrypted).

Remote: Firebase Firestore (for user metadata and subscription status only).

6. AI Integration Strategy
OCR: google_ml_kit (Text Recognition) extracts raw text locally on the device to save costs and increase speed.

Processing: Text is sent to Gemini 1.5 Pro via a Firebase Cloud Function (to protect API keys).

System Prompt: Instructs the AI to return a structured JSON object containing: risk_score, red_flags, hidden_fees, and negotiation_tips.

7. Subscription & Payment Gateway
Integration: RevenueCat (Easiest for cross-platform IAP).

Model: * Free: 1 "Basic" scan (Risk score only).

Pro ($4.99/mo): Unlimited scans, PDF Export, and AI Negotiation Scripts.

8. Data Handling & Privacy
Privacy Policy: Must state that raw contract text is processed but not stored permanently on servers.

GDPR/CCPA: Users must have a "Delete All Data" button in settings.

Terms of Service: Must include a legal disclaimer: "SafeSign AI provides information, not legal advice."

9. Security Features
PII Redaction: AI should be instructed to ignore/redact Sensitive Personal Information (SSNs, Bank Account Numbers).

SSL Pinning: Prevent intercepting data between the app and AI server.

Biometric Lock: Option to lock the app behind FaceID/TouchID for sensitive contracts.

10. Required Packages (pubspec.yaml)
YAML
dependencies:
  flutter_riverpod: ^2.5.1
  google_ml_kit: ^0.16.0
  google_generative_ai: ^0.4.0
  revenuecat_flutter: ^5.0.0
  firebase_core: ^3.0.0
  firebase_auth: ^5.0.0
  go_router: ^13.0.0
  isar: ^3.1.0
  flutter_animate: ^4.5.0
  share_plus: ^7.1.0
11. Expansion Possibility Study
Browser Extension: Analyze web-based ToS (Terms of Service) instantly.

B2B: Corporate version for HR/Recruitment to audit thousands of offer letters.

Legal Referral: Partner with law firms for a "Talk to a Human" button (Lead generation revenue).

12. Minimum Requirements
iOS: 15.0+ (Latest SDKs for Vision/Neural Engine).

Android: API 24+ (Nougat).

Backend: Firebase Blaze (Pay-as-you-go).

Instructions for Agent:
Initialize a Flutter project using Clean Architecture.

Setup Riverpod for state management.

Create a ScannerService using google_ml_kit.

Build a GeminiService class to handle the contract analysis via JSON response.

Implement the UI focusing on a Premium iOS look and feel.