@extends('emails.layout')

@section('content')
    <h1 style="margin:0 0 16px; font-size:20px; line-height:28px; color:#1f2937;">{{ $heading }}</h1>
    <div style="font-size:14px; line-height:22px; color:#4b5563; white-space:pre-line;">{{ $body }}</div>
    <p style="margin:16px 0 24px;">
        <a href="{{ $confirmUrl }}" style="display:inline-block; background:#dc2626; color:#ffffff; text-decoration:none; padding:12px 24px; border-radius:8px; font-weight:600; font-size:14px;">
            Confirm Account Deletion
        </a>
    </p>
    <p style="margin:0; font-size:13px; color:#6b7280;">This link expires in 24 hours.</p>
@endsection
