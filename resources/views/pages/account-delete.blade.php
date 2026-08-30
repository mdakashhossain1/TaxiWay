<!DOCTYPE html>
<html lang="{{ $locale }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{ $t['meta_title'] }} | {{ config('app.name') }}</title>
    <style>
        :root { color-scheme: light; }
        * { box-sizing: border-box; }
        body {
            margin: 0;
            padding: 24px 16px;
            background: #f8fafc;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Noto Sans Devanagari', 'Noto Sans Bengali', Helvetica, Arial, sans-serif;
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
        .reason-options { display: flex; flex-direction: column; gap: 8px; margin-bottom: 10px; }
        .reason-option {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            padding: 10px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            font-size: 13.5px;
            font-weight: 500;
            color: #334155;
            cursor: pointer;
            margin-bottom: 0;
        }
        .reason-option:has(input:checked) { border-color: #f97316; background: #fff7ed; }
        .reason-option input[type="radio"] { width: auto; flex: 0 0 auto; margin-top: 2px; }
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
                    <h1>{{ $t['success_heading'] }}</h1>
                    <p class="subtitle">{{ $t['success_body'] }}</p>
                </div>
            @elseif (session('confirmation_sent'))
                <div class="success">
                    <div class="success-icon" style="background:#fef3c7;">
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="none">
                            <path d="M3 6.5A1.5 1.5 0 0 1 4.5 5h15A1.5 1.5 0 0 1 21 6.5v11a1.5 1.5 0 0 1-1.5 1.5h-15A1.5 1.5 0 0 1 3 17.5v-11Z" stroke="#b45309" stroke-width="1.6"/>
                            <path d="M4 6.5l8 6.5 8-6.5" stroke="#b45309" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                    </div>
                    <h1>{{ $t['pending_heading'] }}</h1>
                    <p class="subtitle">{{ $t['pending_body'] }}</p>
                </div>
            @else
                <h1>{{ $t['title'] }}</h1>
                <p class="subtitle">{{ str_replace(':app', config('app.name'), $t['subtitle']) }}</p>

                <div class="warning">
                    <strong>{{ $t['warning_heading'] }}</strong>
                    <ul>
                        <li>{{ $t['warning_item_1'] }}</li>
                        <li>{{ $t['warning_item_2'] }}</li>
                        <li>{{ $t['warning_item_3'] }}</li>
                    </ul>
                </div>

                @if ($errors->any())
                    <div class="error-box">{{ $errors->first() }}</div>
                @endif

                <form method="POST" action="{{ route('account.delete.destroy') }}"
                      onsubmit="return confirm('{{ addslashes($t['confirm_prompt']) }}');">
                    @csrf

                    <div class="field">
                        <label for="phone">{{ $t['phone_label'] }}</label>
                        <div class="phone-row">
                            <div class="phone-prefix">+91</div>
                            <input type="tel" id="phone" name="phone" inputmode="numeric" maxlength="10"
                                   pattern="[0-9]{10}" placeholder="{{ $t['phone_placeholder'] }}"
                                   value="{{ old('phone') }}" required>
                        </div>
                    </div>

                    <div class="field">
                        <label for="email">{{ $t['email_label'] }}</label>
                        <input type="email" id="email" name="email" placeholder="{{ $t['email_placeholder'] }}"
                               value="{{ old('email') }}" required>
                    </div>

                    <div class="field">
                        <label>{{ $t['reason_label'] }}</label>
                        <div class="reason-options">
                            @foreach ($t['reason_options'] as $key => $label)
                                <label class="reason-option">
                                    <input type="radio" name="reason_option" value="{{ $key }}"
                                           {{ old('reason_option') === $key ? 'checked' : '' }}
                                           onchange="toggleReasonOther()" required>
                                    <span>{{ $label }}</span>
                                </label>
                            @endforeach
                        </div>
                        <textarea id="reason_other" name="reason_other" placeholder="{{ $t['reason_placeholder'] }}"
                                  style="{{ old('reason_option') === 'other' ? '' : 'display:none;' }}">{{ old('reason_other') }}</textarea>
                    </div>

                    <button type="submit" class="delete-btn">{{ $t['delete_button'] }}</button>
                    <p class="fine-print">{{ $t['fine_print'] }}</p>
                </form>

                <script>
                    function toggleReasonOther() {
                        var selected = document.querySelector('input[name="reason_option"]:checked');
                        var other = document.getElementById('reason_other');
                        var isOther = !!(selected && selected.value === 'other');
                        other.style.display = isOther ? 'block' : 'none';
                        other.required = isOther;
                        if (isOther) other.focus();
                    }
                    toggleReasonOther();
                </script>
            @endif
        </div>
    </div>
</body>
</html>
