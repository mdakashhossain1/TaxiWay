<?php

namespace App\Services;

class OtpCooldownException extends \RuntimeException
{
    public function __construct(public readonly int $retryAfterSeconds)
    {
        parent::__construct("OTP resend cooldown active, retry after {$retryAfterSeconds}s.");
    }
}
