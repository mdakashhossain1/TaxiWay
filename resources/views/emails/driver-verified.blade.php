@extends('emails.layout')

@section('content')
    <h1 style="margin:0 0 16px; font-size:20px; line-height:28px; color:#1f2937;">{{ $heading }}</h1>
    <div style="font-size:14px; line-height:22px; color:#4b5563; white-space:pre-line;">{{ $body }}</div>
@endsection
