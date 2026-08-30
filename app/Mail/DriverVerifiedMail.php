<?php

namespace App\Mail;

use App\Models\Driver;
use App\Models\EmailTemplate;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class DriverVerifiedMail extends Mailable implements ShouldQueue
{
    use Queueable, SerializesModels;

    public function __construct(public Driver $driver)
    {
    }

    public function build(): self
    {
        $locale = $this->driver->preferred_locale ?? 'en';
        $template = EmailTemplate::where('key', 'driver_verified')->first();

        $values = ['driver_name' => $this->driver->name, 'app_name' => config('app.name')];

        if ($template) {
            $subject = EmailTemplate::applyPlaceholders($template->subjectFor($locale), $values);
            $heading = EmailTemplate::applyPlaceholders($template->headingFor($locale), $values);
            $body = EmailTemplate::applyPlaceholders($template->bodyFor($locale), $values);
        } else {
            // Falls back to sensible defaults if the driver_verified row was somehow removed.
            $subject = 'Your driver account is verified — start accepting rides';
            $heading = "You're verified, {$this->driver->name}!";
            $body = "Your account is now fully verified on {$values['app_name']}. You can open the driver app and start receiving ride requests right away.";
        }

        return $this->subject($subject)
            ->view('emails.driver-verified', compact('heading', 'body'));
    }
}
