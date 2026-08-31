<?php

namespace App\Mail;

use App\Models\Booking;
use App\Models\EmailTemplate;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class ScheduledRideConfirmedMail extends Mailable implements ShouldQueue
{
    use Queueable, SerializesModels;

    public function __construct(public string $customerName, public Booking $booking)
    {
    }

    public function build(): self
    {
        $template = EmailTemplate::where('key', 'scheduled_ride_confirmed')->first();

        $values = [
            'customer_name' => $this->customerName,
            'app_name' => config('app.name'),
            'pickup' => $this->booking->pickup_address,
            'destination' => $this->booking->destination_address,
            'scheduled_at' => $this->booking->scheduled_at?->format('d M Y, h:i A') ?? '',
        ];

        if ($template) {
            $subject = EmailTemplate::applyPlaceholders($template->subjectFor('en'), $values);
            $heading = EmailTemplate::applyPlaceholders($template->headingFor('en'), $values);
            $body = EmailTemplate::applyPlaceholders($template->bodyFor('en'), $values);
        } else {
            // Falls back to sensible defaults if the scheduled_ride_confirmed row was somehow removed.
            $subject = "Your ride is scheduled — {$values['app_name']}";
            $heading = 'Your ride is scheduled';
            $body = "Hi {$this->customerName},\n\nYour ride from {$values['pickup']} to {$values['destination']} is scheduled for {$values['scheduled_at']}.\n\nWe're notifying nearby drivers now — you'll get a notification as soon as one accepts. You can check the status any time from the {$values['app_name']} app.";
        }

        return $this->subject($subject)
            ->view('emails.scheduled-ride-confirmed', compact('heading', 'body'));
    }
}
