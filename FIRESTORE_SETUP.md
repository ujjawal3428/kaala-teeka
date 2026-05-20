# Firestore Testing Setup

## What I Added to Your App

✅ **Firebase Firestore import** in `landing_page.dart`
✅ **`_testFirestore()` method** that sends test data
✅ **"Test DB" button** in the app bar (green button)

When you click "Test DB", it will:
1. Send a document with your test data to Firestore collection `test_users`
2. Show a ✅ green success message or ❌ red error message

---

## Step 1: Update Firestore Security Rules

Firestore currently **blocks all access** by default. You need to temporarily allow read/write for testing.

### Go to Firebase Console:
1. Open [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **Kaala Teeka**
3. Go to **Firestore Database** → **Rules** tab
4. Replace the existing rules with this **TEMPORARY DEV RULE**:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // ⚠️ TEMPORARY - Allow all read/write for testing only
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

5. Click **Publish**

⚠️ **IMPORTANT**: These are **INSECURE** rules. After testing, replace with proper security rules!

---

## Step 2: Test the Connection

1. Run your app: `flutter run`
2. Click the green **"Test DB"** button in the app bar
3. You should see ✅ **"Firestore test successful!"**

If you see ❌ error, check:
- Firebase is initialized (check console logs)
- Firestore rules are published
- Your app has internet connection
- Firebase/Firestore dependencies are installed

---

## Step 3: Verify Data in Firebase

1. Go to Firebase Console → Firestore Database → **Data** tab
2. Look for collection **`test_users`**
3. You should see a document with:
   ```
   name: "Ujjawal"
   age: 21
   timestamp: [current time]
   ```

---

## Production Security Rules

After testing, replace the temporary rules with **proper security**:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // Orders - authenticated users can create
    match /orders/{document=**} {
      allow create: if request.auth != null;
      allow read: if request.auth != null && request.auth.uid == resource.data.userId;
    }
  }
}
```

---

## Troubleshooting

### Error: "Permission denied"
→ Update Firestore rules (step above)

### Error: "Firebase not initialized"
→ Check `main.dart` Firebase initialization is running first

### No error but data not appearing
→ Check if collection `test_users` was created in Firestore → Data tab

### App crashes
→ Make sure `cloud_firestore: ^6.4.1` is in `pubspec.yaml` (already added)
