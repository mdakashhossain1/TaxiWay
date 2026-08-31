<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Third Party Services
    |--------------------------------------------------------------------------
    |
    | This file is for storing the credentials for third party services such
    | as Mailgun, Postmark, AWS and more. This file provides the de facto
    | location for this type of information, allowing packages to have
    | a conventional file to locate the various service credentials.
    |
    */

    'postmark' => [
        'token' => env('POSTMARK_TOKEN'),
    ],

    'resend' => [
        'key' => env('RESEND_KEY'),
    ],

    'ses' => [
        'key' => env('AWS_ACCESS_KEY_ID'),
        'secret' => env('AWS_SECRET_ACCESS_KEY'),
        'region' => env('AWS_DEFAULT_REGION', 'us-east-1'),
    ],

    'slack' => [
        'notifications' => [
            'bot_user_oauth_token' => env('SLACK_BOT_USER_OAUTH_TOKEN'),
            'channel' => env('SLACK_BOT_USER_DEFAULT_CHANNEL'),
        ],
    ],

    'firebase' => [
        'project_id' => env('FIREBASE_PROJECT_ID'),
        'web_api_key' => env('FIREBASE_WEB_API_KEY'),
    ],

    /* Shared secret for the /cron/run HTTP endpoint — see CronController. */
    'cron' => [
        'secret' => env('CRON_SECRET'),
    ],

    /*
    | SMS OTP gateway. When disabled, OtpService skips the HTTP call and the
    | generated code is instead returned straight in the API response so the
    | app can display it — no real SMS is sent (debug mode).
    |
    | Two independent gateway profiles are kept side by side: "otp" (a
    | provider's quick/non-DLT OTP route) and "dlt" (a TRAI DLT-registered
    | template route). `mode` picks which profile OtpService actually sends
    | through — the other stays configured so switching later doesn't lose
    | its settings.
    */
    'sms' => [
        'enabled' => env('SMS_GATEWAY_ENABLED', false),
        'mode' => env('SMS_GATEWAY_MODE', 'otp'), // 'otp' or 'dlt'
        'api_key' => env('SMS_GATEWAY_API_KEY'),

        // Fast2SMS's dedicated "Smart OTP" API — the only bulkV2/otp/dlt route
        // documented as JSON POST rather than GET-with-query-string. `otp` is
        // passed explicitly so the code texted to the user matches the one
        // OtpService already generated and cached — without it Fast2SMS
        // generates its own, unverifiable, code.
        'otp' => [
            'method' => env('SMS_GATEWAY_OTP_METHOD', 'post'), // 'get' or 'post'
            'payload_url' => env('SMS_GATEWAY_OTP_PAYLOAD_URL', 'https://www.fast2sms.com/dev/otp/send'),
            'template_id' => env('SMS_GATEWAY_OTP_TEMPLATE_ID'),
            'payload_template' => env('SMS_GATEWAY_OTP_PAYLOAD_TEMPLATE', '{"otp_id":"{template_id}","mobile":"{phone}","otp":"{otp}"}'),
        ],

        // Fast2SMS documents DLT SMS as a GET API (bulkV2?route=dlt&...) —
        // change 'method' to 'post' here only if your provider's DLT route
        // actually accepts a JSON body.
        'dlt' => [
            'method' => env('SMS_GATEWAY_DLT_METHOD', 'get'), // 'get' or 'post'
            'payload_url' => env('SMS_GATEWAY_DLT_PAYLOAD_URL', 'https://www.fast2sms.com/dev/bulkV2'),
            'template_id' => env('SMS_GATEWAY_DLT_TEMPLATE_ID'),
            'sender_id' => env('SMS_GATEWAY_DLT_SENDER_ID'),
            'entity_id' => env('SMS_GATEWAY_DLT_ENTITY_ID'),
            // "Customer|{otp}" default matches a template registered with two variables (name, code) —
            // change to just "{otp}" if your DLT template only has one variable.
            'payload_template' => env('SMS_GATEWAY_DLT_PAYLOAD_TEMPLATE', '{"route":"dlt","sender_id":"{sender_id}","message":"{template_id}","variables_values":"Customer|{otp}","numbers":"{phone}"}'),
        ],
    ],

    /*
    | Support phone number shown to riders/drivers in-app — fetched by
    | taxiway/taxiwaydriver via GET /api/app-config and dialed directly.
    */
    'support' => [
        'contact_number' => env('SUPPORT_CONTACT_NUMBER'),
    ],

];
