<?php

namespace App\Mail;

use App\Models\EmailTemplate;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class AccountDeletedMail extends Mailable implements ShouldQueue
{
    use Queueable, SerializesModels;

    public function __construct(public string $customerName, public string $locale = 'en')
    {
    }

    public function build(): self
    {
        $template = EmailTemplate::where('key', 'account_deleted')->first();
        $values = ['customer_name' => $this->customerName, 'app_name' => config('app.name')];

        if ($template) {
            $subject = EmailTemplate::applyPlaceholders($template->subjectFor($this->locale), $values);
            $heading = EmailTemplate::applyPlaceholders($template->headingFor($this->locale), $values);
            $body = EmailTemplate::applyPlaceholders($template->bodyFor($this->locale), $values);
        } else {
            // Falls back to sensible defaults if the account_deleted row was somehow removed.
            $subject = "Your {$values['app_name']} account has been deleted";
            $heading = 'Your account has been deleted';
            $body = "Hi {$this->customerName},\n\nYour {$values['app_name']} account and all associated data — ride history, saved addresses, and reviews — have been permanently deleted, as you requested.\n\nIf you didn't request this, please contact our support team right away.";
        }

        return $this->subject($subject)
            ->view('emails.account-deleted', compact('heading', 'body'));
    }
}
