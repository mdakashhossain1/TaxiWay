<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class EmailTemplate extends Model
{
    protected $fillable = ['key', 'subject', 'heading', 'body', 'translations'];

    protected function casts(): array
    {
        return [
            'translations' => 'array',
        ];
    }

    public function subjectFor(string $locale): string
    {
        return $this->translations[$locale]['subject'] ?? $this->subject;
    }

    public function headingFor(string $locale): string
    {
        return $this->translations[$locale]['heading'] ?? $this->heading;
    }

    public function bodyFor(string $locale): string
    {
        return $this->translations[$locale]['body'] ?? $this->body;
    }

    /** Replaces {placeholder} tokens (e.g. {driver_name}, {app_name}) with the given values. */
    public static function applyPlaceholders(string $text, array $values): string
    {
        $replacements = [];
        foreach ($values as $key => $value) {
            $replacements['{'.$key.'}'] = $value;
        }

        return strtr($text, $replacements);
    }
}
