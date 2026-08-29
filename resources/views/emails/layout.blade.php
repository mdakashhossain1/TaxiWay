<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ $subject ?? config('app.name') }}</title>
</head>
<body style="margin:0; padding:0; background-color:#f4f5f7; font-family:Helvetica,Arial,sans-serif;">
    <table width="100%" cellpadding="0" cellspacing="0" border="0" role="presentation">
        <tr>
            <td align="center" style="padding:40px 16px;">
                <table width="480" cellpadding="0" cellspacing="0" border="0" role="presentation" style="max-width:480px; width:100%; background-color:#ffffff; border-radius:12px; overflow:hidden;">
                    <tr>
                        <td style="padding:32px 32px 24px 32px;">
                            <img src="{{ config('app.url') }}/images/logo/logo.svg" width="120" alt="{{ config('app.name') }}" style="display:block; border:0;">
                        </td>
                    </tr>

                    <tr>
                        <td style="padding:0 32px;">
                            @yield('content')
                        </td>
                    </tr>

                    <tr>
                        <td style="padding:32px;">&nbsp;</td>
                    </tr>
                </table>

                <table width="480" cellpadding="0" cellspacing="0" border="0" role="presentation" style="max-width:480px; width:100%;">
                    <tr>
                        <td align="center" style="padding:24px 32px; font-family:Helvetica,Arial,sans-serif; font-size:12px; line-height:20px; color:#8a94a6;">
                            @if (config('mail.from.address'))
                                Need help? Write to <a href="mailto:{{ config('mail.from.address') }}" style="color:#465fff; text-decoration:none;">{{ config('mail.from.address') }}</a><br>
                            @endif
                            &copy; {{ now()->year }} {{ config('app.name') }}. All rights reserved.
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>
