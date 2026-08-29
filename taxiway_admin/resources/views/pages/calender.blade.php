@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb pageTitle="Calendar" />
    <x-calender-area
        :events="$events"
        :current-month="$currentMonth"
        :month-label="$monthLabel"
        :prev-month="$prevMonth"
        :next-month="$nextMonth"
        :bookings-total="$bookingsTotal"
        :bookings-completed="$bookingsCompleted"
        :bulk-total="$bulkTotal"
        :bulk-confirmed="$bulkConfirmed"
    />
@endsection
