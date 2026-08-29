<?php

namespace App\Support;

class Locale
{
    /** The 3 priority locales already shipped in taxiwaydriver/taxiway's .arb translation files. */
    public const SUPPORTED = ['en' => 'English', 'hi' => 'Hindi', 'bn' => 'Bengali'];

    /** Reads the first subtag of an Accept-Language header (e.g. "hi-IN" -> "hi"), falling back to English. */
    public static function resolve(?string $acceptLanguageHeader): string
    {
        $code = strtolower(substr((string) $acceptLanguageHeader, 0, 2));

        return array_key_exists($code, self::SUPPORTED) ? $code : 'en';
    }
}
