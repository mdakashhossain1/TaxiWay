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

    /*
    | SMS OTP gateway. When disabled, OtpService skips the HTTP call and the
    | generated code is instead returned straight in the API response so the
    | app can display it — no real SMS is sent (debug mode).
    */
    'sms' => [
        'enabled' => env('SMS_GATEWAY_ENABLED', false),
        'api_key' => env('SMS_GATEWAY_API_KEY'),
        'payload_url' => env('SMS_GATEWAY_PAYLOAD_URL'),
        'template_id' => env('SMS_GATEWAY_TEMPLATE_ID'),
        'payload_template' => env('SMS_GATEWAY_PAYLOAD_TEMPLATE', '{"mobile":"{phone}","otp_id":"{template_id}","otp":"{otp}"}'),
    ],

    /*
    | Support phone number shown to riders/drivers in-app — fetched by
    | taxiway/taxiwaydriver via GET /api/app-config and dialed directly.
    */
    'support' => [
        'contact_number' => env('SUPPORT_CONTACT_NUMBER'),
    ],

];
