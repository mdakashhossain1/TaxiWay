<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Delete Your Account | {{ config('app.name') }}</title>
    <style>
        :root { color-scheme: light; }
        * { box-sizing: border-box; }
        body {
            margin: 0;
            padding: 24px 16px;
            background: #f8fafc;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            color: #0f172a;
        }
        .wrap { max-width: 480px; margin: 0 auto; }
        .logo { display: block; height: 32px; margin: 0 auto 20px; }
        .card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 28px 24px;
            box-shadow: 0 4px 16px rgba(15, 23, 42, 0.06);
        }
        h1 { font-size: 20px; margin: 0 0 6px; color: #0f172a; }
        .subtitle { font-size: 14px; color: #64748b; margin: 0 0 20px; line-height: 20px; }
        .warning {
            background: #fef3c7;
            border: 1px solid #fde68a;
            border-radius: 10px;
            padding: 14px 16px;
            margin-bottom: 22px;
        }
        .warning strong { display: block; font-size: 13.5px; color: #92400e; margin-bottom: 6px; }
        .warning ul { margin: 0; padding-left: 18px; color: #92400e; font-size: 13px; line-height: 20px; }
        .field { margin-bottom: 16px; }
        label { display: block; font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 6px; }
        .phone-row { display: flex; gap: 8px; }
        .phone-prefix {
            flex: 0 0 52px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid #cbd5e1;
            border-radius: 10px;
            background: #f1f5f9;
            font-size: 14px;
            color: #334155;
        }
        input, textarea {
            width: 100%;
            border: 1px solid #cbd5e1;
            border-radius: 10px;
            padding: 11px 13px;
            font-size: 14px;
            color: #0f172a;
            font-family: inherit;
        }
        input:focus, textarea:focus {
            outline: none;
            border-color: #f97316;
            box-shadow: 0 0 0 3px rgba(249, 115, 22, 0.12);
        }
        textarea { resize: vertical; min-height: 90px; }
        .error-box {
            background: #fee2e2;
            border: 1px solid #fecaca;
            color: #b91c1c;
            border-radius: 10px;
            padding: 12px 14px;
            font-size: 13.5px;
            margin-bottom: 18px;
        }
        button.delete-btn {
            width: 100%;
            border: none;
            border-radius: 10px;
            padding: 14px;
            background: #dc2626;
            color: #fff;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            margin-top: 6px;
        }
        button.delete-btn:hover { background: #b91c1c; }
        .fine-print { font-size: 12px; color: #94a3b8; text-align: center; margin-top: 14px; line-height: 18px; }
        .success-icon {
            width: 56px; height: 56px; border-radius: 50%;
            background: #dcfce7; display: flex; align-items: center; justify-content: center;
            margin: 0 auto 16px;
        }
        .success h1 { text-align: center; }
        .success .subtitle { text-align: center; }
    </style>
</head>
<body>
    <div class="wrap">
        <img class="logo" src="{{ asset('images/logo/logo.svg') }}" alt="{{ config('app.name') }}">

        <div class="card">
            @if (session('account_deleted'))
                <div class="success">
                    <div class="success-icon">
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none">
                            <path d="M20 6L9 17l-5-5" stroke="#16a34a" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                    </div>
                    <h1>Your account has been deleted</h1>
                    <p class="subtitle">
                        Your profile, ride history, saved addresses, and reviews have all been permanently
                        removed from our systems. A confirmation email is on its way to the address you provided.
                    </p>
                </div>
            @else
                <h1>Delete Your Account</h1>
                <p class="subtitle">This permanently removes your {{ config('app.name') }} account. No OTP is needed — just confirm the details below.</p>

                <div class="warning">
                    <strong>Deleting your account will permanently erase:</strong>
                    <ul>
                        <li>Your profile and saved details</li>
                        <li>Your entire ride and bulk-booking history</li>
                        <li>Reviews you've written and support tickets you've raised</li>
                    </ul>
                </div>

                @if ($errors->any())
                    <div class="error-box">{{ $errors->first() }}</div>
                @endif

                <form method="POST" action="{{ route('account.delete.destroy') }}"
                      onsubmit="return confirm('This will permanently delete your account and all your data. This cannot be undone. Continue?');">
                    @csrf

                    <div class="field">
                        <label for="phone">Phone Number</label>
                        <div class="phone-row">
                            <div class="phone-prefix">+91</div>
                            <input type="tel" id="phone" name="phone" inputmode="numeric" maxlength="10"
                                   pattern="[0-9]{10}" placeholder="10-digit mobile number"
                                   value="{{ old('phone') }}" required>
                        </div>
                    </div>

                    <div class="field">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" name="email" placeholder="you@example.com"
                               value="{{ old('email') }}" required>
                    </div>

                    <div class="field">
                        <label for="reason">Reason for leaving</label>
                        <textarea id="reason" name="reason" placeholder="Tell us why you're deleting your account..." required>{{ old('reason') }}</textarea>
                    </div>

                    <button type="submit" class="delete-btn">Delete My Account</button>
                    <p class="fine-print">This action is immediate and cannot be undone.</p>
                </form>
            @endif
        </div>
    </div>
</body>
</html>
