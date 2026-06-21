# Apple Login Flow Documentation (Flutter + Backend)

## 1) High-level Flow

```
┌─────────────────────┐
│  EnterMobileScreen  │
│  (User taps Apple)  │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Apple Sign-In SDK  │
│  (sign_in_with_apple)│
└──────────┬──────────┘
           │ Returns: authorizationCode, identityToken, userIdentifier, email, name
           ▼
┌─────────────────────┐
│ POST /connector/api │
│ /auth/social-       │
│ customer-login      │
└──────────┬──────────┘
           │
     ┌─────┴─────┐
     │           │
     ▼           ▼
┌─────────┐ ┌──────────┐
│ Existing│ │  New     │
│  User   │ │  User    │
│ token   │ │is_new_user│
│  ✓      │ │   = true  │
└────┬────┘ └────┬─────┘
     │           │
     ▼           ▼
chooseCarScreen  SocialUpdateMobileScreen
                      │
                      ▼
           POST /update-social-mobile
                      │
              ┌────────┴────────┐
              │                 │
              ▼                 ▼
        Phone Available    Phone Already Linked
              │                 │
              ▼                 ▼
    SocialPhoneOtpScreen    Ownership Dialog
    (flow: verify_phone)    → OTP → Merge
```

## 2) Source of Truth in Code

| Component | File Path | Key Function/Class |
|-----------|-----------|-------------------|
| Apple Sign-In | `lib/modules/auth/presentation/screens/enter_mobile_screen.dart` | `signInWithApple()` |
| Social Auth Cubit | `lib/modules/auth/presentation/cubits/social_auth_cubit/social_auth_cubit.dart` | `socialLogin()`, `sendPhoneOtp()`, `verifyPhoneAndSetMobile()` |
| Backend Service | `lib/modules/auth/data/datasources/auth_remote_datasource.dart` | `socialCustomerLogin()`, `updateSocialMobile()`, `verifyAndMergeAccounts()` |
| Mobile Update Screen | `lib/modules/auth/presentation/screens/social_update_mobile_screen.dart` | Phone input + OTP flow initiation |
| OTP Screen | `lib/modules/auth/presentation/screens/social_phone_otp_screen.dart` | OTP verification (verify_phone / merge) |

## 3) Flutter: Apple Sign-In Implementation

### 3.1 Required Package
```yaml
dependencies:
  sign_in_with_apple: ^6.1.0
```

### 3.2 Import
```dart
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
```

### 3.3 Sign-In Method
```dart
Future<void> signInWithApple() async {
  try {
    showPrograssDelayDialog(context);
    _dialogShown = true;

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final identityToken = appleCredential.identityToken ?? '';
    final authorizationCode = appleCredential.authorizationCode;
    final userIdentifier = appleCredential.userIdentifier ?? '';
    final email = appleCredential.email ?? '';

    final fullName = <String?>[
      appleCredential.givenName,
      appleCredential.familyName,
    ].where((e) => (e ?? '').trim().isNotEmpty).join(' ').trim();

    // Validate required fields
    if (userIdentifier.trim().isEmpty || authorizationCode.trim().isEmpty) {
      throw Exception('Invalid Apple credential data');
    }

    // Call social login
    final socialCubit = SocialAuthCubit.get(context);
    await socialCubit.socialLogin(
      accessToken: '', // Apple doesn't use access token
      uniqueId: userIdentifier,
      email: email,
      medium: 'apple',
      name: fullName,
      identityToken: identityToken,
      authorizationCode: authorizationCode,
    );
  } on SignInWithAppleAuthorizationException catch (e) {
    if (e.code == AuthorizationErrorCode.canceled) {
      return; // User canceled
    }
    Toasters.show(e.toString());
  } catch (e) {
    Toasters.show(e.toString());
  } finally {
    if (_dialogShown) {
      Navigator.of(context, rootNavigator: true).maybePop();
      _dialogShown = false;
    }
  }
}
```

### 3.4 Apple Credential Fields

| Field | Type | Description | Length/Format |
|-------|------|-------------|---------------|
| `identityToken` | String | JWT from Apple | Variable (hundreds to thousands of chars) |
| `authorizationCode` | String | Code for server verification | Variable (tens to hundreds of chars) |
| `userIdentifier` | String | Unique Apple user ID | Variable |
| `email` | String | User email (only on first login) | Email format or empty |
| `givenName` | String | First name (only on first login) | Optional |
| `familyName` | String | Last name (only on first login) | Optional |

**Important**: `email` and `name` are only provided on the **first** Apple sign-in. After that, Apple returns null for these fields.

## 4) API: social-customer-login

### 4.1 Endpoint
```
POST {baseUrl}/connector/api/auth/social-customer-login
```

### 4.2 Headers
```http
Content-Type: application/json
Accept: application/json
```

### 4.3 Request Body (Apple)
```json
{
  "medium": "apple",
  "unique_id": "<APPLE_USER_IDENTIFIER>",
  "email": "<EMAIL_OR_EMPTY>",
  "name": "<OPTIONAL>",
  "authorization_code": "<AUTHORIZATION_CODE>",
  "identity_token": "<OPTIONAL_IF_PRESENT>"
}
```

### 4.4 Flutter Validation (Before Sending)
```dart
// Required fields
if (uniqueId.trim().isEmpty) {
  throw Exception('Required: unique_id');
}

if (medium.trim().isEmpty) {
  throw Exception('Required: medium');
}

// For Apple specifically
if (authorizationCode.trim().isEmpty) {
  throw Exception('Required: authorization_code for Apple');
}
```

### 4.5 Backend Validations (Expected)
- `medium` must not be empty
- `unique_id` must not be empty
- If `medium == 'apple'`: `authorization_code` must not be empty
- If `medium != 'apple'`: `token` must not be empty

## 5) Response from social-customer-login

### 5.1 Response Fields
```json
{
  "success": true,
  "status": true,
  "is_new_user": false,
  "phone_exist": true,
  "token": "<APP_ACCESS_TOKEN>",
  "user": {
    "id": 123,
    "name": "User Name",
    "email": "user@example.com"
  },
  "is_soft_deleted": false,
  "message": ""
}
```

### 5.2 Scenario A: Existing User (is_new_user = false)
**Conditions:**
- `success = true`
- `is_new_user = false`
- `token` must be present and non-empty
- `phone_exist = true`

**Flutter Action:**
```dart
AppConstants.token = res.token;
await CacheHelper.saveData(key: PrefKeys.kAccessToken, value: res.token);
await CacheHelper.removeData(key: PrefKeys.kIsGuestMode);

// Navigate to home
Navigator.pushNamedAndRemoveUntil(
  context,
  RoutesName.chooseCarScreen,
  (route) => false,
);
```

### 5.3 Scenario B: New User (is_new_user = true)
**Conditions:**
- `success = true`
- `is_new_user = true`
- `token` may be empty

**Flutter Action:**
```dart
Navigator.pushNamed(
  context,
  RoutesName.socialUpdateMobileScreen,
  arguments: <String, dynamic>{
    'email': email.isNotEmpty ? email : (res.user?.email ?? ''),
    'name': fullName.isNotEmpty ? fullName : (res.user?.name ?? ''),
    'medium': 'apple',
    'unique_id': uniqueId,
    'user_id': res.user?.id,
  },
);
```

### 5.4 Scenario C: Soft Deleted Account
**Conditions:**
- `is_soft_deleted = true`
- `user_id` present

**Flutter Action:**
Show restore dialog → Call `restoreDeletedAccount(userId)` → Retry login

## 6) API: update-social-mobile (After New User)

### 6.1 Endpoint
```
POST {baseUrl}/connector/api/auth/update-social-mobile
```

### 6.2 Request Body
```json
{
  "email": "<required>",
  "name": "<required>",
  "phone": "<required>",
  "medium": "apple",
  "unique_id": "<required>",
  "user_id": "<nullable>"
}
```

### 6.3 Response Scenarios

#### A) Phone Available (Not Linked)
```json
{
  "success": true,
  "token": "<token>",
  "phone_exist": false,
  "user": { ... }
}
```

**Flutter Action:** Navigate to OTP screen with `flow: verify_phone`

```dart
Navigator.pushNamed(
  context,
  RoutesName.socialPhoneOtpScreen,
  arguments: {
    'flow': 'verify_phone',
    'email': email,
    'name': name,
    'phone': phone,
    'medium': medium,
    'unique_id': uniqueId,
    'user_id': userId,
  },
);
```

#### B) Phone Already Linked
```json
{
  "success": false,
  "phone_already_linked": true,
  "action": "confirm_ownership",
  "existing_user": { "id": 123, "name": "...", "email": "..." },
  "pending_social_user": { ... },
  "message": "Phone already linked to another account"
}
```

**Flutter Action:**
1. Show ownership confirmation dialog
2. If confirmed: Call `sendOwnershipOtp`
3. Navigate to OTP screen with `flow: merge`

```dart
Navigator.pushNamed(
  context,
  RoutesName.socialPhoneOtpScreen,
  arguments: {
    'flow': 'merge',
    'existing_user_id': existingUserId,
    'email': email,
    'name': name,
    'phone': phone,
    'medium': medium,
    'unique_id': uniqueId,
  },
);
```

## 7) OTP Screens

### 7.1 API: verify-phone-and-set-mobile (flow: verify_phone)
```
POST {baseUrl}/connector/api/auth/verify-phone-and-set-mobile
```

**Body:**
```json
{
  "email": "...",
  "name": "...",
  "phone": "...",
  "medium": "apple",
  "unique_id": "...",
  "user_id": "<nullable>",
  "otp": "1234"
}
```

**Success Response:**
```json
{
  "success": true,
  "token": "<APP_TOKEN>",
  "phone_exist": true,
  "user": { ... }
}
```

### 7.2 API: verify-and-merge-accounts (flow: merge)
```
POST {baseUrl}/connector/api/auth/verify-and-merge-accounts
```

**Body:**
```json
{
  "existing_user_id": 123,
  "phone": "...",
  "otp": "1234",
  "social_email": "...",
  "medium": "apple",
  "unique_id": "..."
}
```

**Success Response:**
```json
{
  "success": true,
  "token": "<APP_TOKEN>",
  "user": { ... }
}
```

### 7.3 OTP Success Action
```dart
AppConstants.token = res.token;
await CacheHelper.saveData(key: PrefKeys.kAccessToken, value: res.token);

Navigator.pushNamedAndRemoveUntil(
  context,
  RoutesName.chooseCarScreen,
  (route) => false,
);
```

## 8) API: restore-deleted-account

### 8.1 Endpoint
```
POST {baseUrl}/connector/api/auth/restore-deleted-account
```

### 8.2 Body
```json
{
  "user_id": 123
}
```

### 8.3 Usage Flow
1. Detect `is_soft_deleted = true` in any response
2. Show restore confirmation dialog
3. Call `restoreDeletedAccount(userId)`
4. Retry the original operation (login or update-mobile)

## 9) Data Lengths & Constraints

| Field | Min Length | Max Length | Notes |
|-------|-----------|-----------|-------|
| `authorization_code` | 1 | - | Apple-provided string |
| `identity_token` | 1 | - | JWT, typically long |
| `unique_id` | 1 | - | Apple user identifier |
| `email` | 0 | 255 | Valid email format |
| `name` | 0 | 100 | Display name |
| `phone` | 10 | 15 | E.164 format recommended |
| `otp` | 4 | 6 | Numeric code |

## 10) Navigation Decision Table

| Condition | Action |
|-----------|--------|
| Apple Sign-In canceled | No navigation |
| Missing `authorizationCode` or `uniqueId` | Show error toast |
| `is_new_user = false` | Save token → `chooseCarScreen` |
| `is_new_user = true` | Navigate to `socialUpdateMobileScreen` |
| `phone_already_linked = true` | Show ownership dialog → OTP with `flow: merge` |
| Phone available | Navigate to OTP with `flow: verify_phone` |
| OTP verification success | Save token → `chooseCarScreen` |
| `is_soft_deleted = true` | Show restore dialog → restore → retry |

## 11) Error Handling

### 11.1 Apple-Specific Errors
```dart
catch (e) {
  if (e is SignInWithAppleAuthorizationException) {
    if (e.code == AuthorizationErrorCode.canceled) {
      // User canceled - no error shown
      return;
    }
  }
  // Show error
  Toasters.show(e.toString());
}
```

### 11.2 Backend Error Format
```json
{
  "success": false,
  "message": "Error description",
  "is_soft_deleted": false
}
```

## 12) iOS Platform-Specific

### 12.1 Only Show on iOS
```dart
if (Platform.isIOS) ...[
  const SizedBox(height: 12),
  AppleSignInButton(
    onPressed: signInWithApple,
  ),
],
```

### 12.2 Required iOS Setup
- Add "Sign in with Apple" capability in Xcode
- Configure Apple Developer account with App ID
- Add return URL for backend Apple verification

## 13) UI: Apple Sign-In Button

```dart
SizedBox(
  height: 52,
  child: ElevatedButton(
    onPressed: signInWithApple,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.apple), // Or Apple logo asset
        const SizedBox(width: 8),
        const Text('Continue with Apple'),
      ],
    ),
  ),
),
```

---

## Quick Reference: Endpoints Summary

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/auth/social-customer-login` | POST | Initial Apple login |
| `/auth/update-social-mobile` | POST | Add phone for new user |
| `/auth/verify-phone-and-set-mobile` | POST | Verify OTP for new user |
| `/auth/verify-and-merge-accounts` | POST | Merge with existing account |
| `/auth/send-ownership-otp` | POST | Send OTP for ownership confirmation |
| `/auth/restore-deleted-account` | POST | Restore soft-deleted account |

## Backend Requirements Checklist

- [ ] Accept `authorization_code` for Apple verification
- [ ] Exchange code with Apple servers (if using code-based auth)
- [ ] Verify `identity_token` JWT signature (if using token-based auth)
- [ ] Handle `is_new_user` flag correctly
- [ ] Implement `phone_already_linked` detection
- [ ] Support soft-delete restore flow
- [ ] Return consistent token format
