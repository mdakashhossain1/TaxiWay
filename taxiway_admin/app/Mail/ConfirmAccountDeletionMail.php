<?php

namespace App\Mail;

use App\Models\EmailTemplate;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

/**
 * Sent when an account has no email on file yet, so the deletion request
 * can't be cross-checked against a stored email. Deletion only happens
 * once this link is clicked — closes the "phone number alone" gap without
 * requiring an OTP code.
 *
 * The confirm button's URL is always code-controlled (never sourced from
 * admin-edited template text) so an edited template can't break the link —
 * only the surrounding heading/body copy is editable via EmailTemplate.
 */
class ConfirmAccountDeletionMail extends Mailable implements ShouldQueue
{
    use Queueable, SerializesModels;

    public function __construct(public string $customerName, public string $confirmUrl, public string $locale = 'en')
    {
    }

    public function build(): self
    {
        $template = EmailTemplate::where('key', 'account_deletion_confirm')->first();
        $values = ['customer_name' => $this->customerName, 'app_name' => config('app.name')];

        if ($template) {
            $subject = EmailTemplate::applyPlaceholders($template->subjectFor($this->locale), $values);
            $heading = EmailTemplate::applyPlaceholders($template->headingFor($this->locale), $values);
            $body = EmailTemplate::applyPlaceholders($template->bodyFor($this->locale), $values);
        } else {
            // Falls back to sensible defaults if the account_deletion_confirm row was somehow removed.
            $subject = "Confirm deletion of your {$values['app_name']} account";
            $heading = 'Confirm account deletion';
            $body = "Hi {$this->customerName},\n\nWe received a request to permanently delete your {$values['app_name']} account, including your ride history, saved addresses, and reviews. To confirm, click the button below.\n\nIf you didn't request this, you can safely ignore this email — your account will not be deleted.";
        }

        return $this->subject($subject)
            ->view('emails.confirm-account-deletion', [
                'heading' => $heading,
                'body' => $body,
                'confirmUrl' => $this->confirmUrl,
            ]);
    }
}
