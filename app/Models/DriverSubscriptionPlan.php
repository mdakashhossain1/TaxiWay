<?php

namespace App\Models;

use App\Support\Locale;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class DriverSubscriptionPlan extends Model
{
    public const SUPPORTED_LOCALES = Locale::SUPPORTED;

    protected $fillable = ['name', 'price_per_month', 'rides_included', 'validity_days', 'description', 'translations', 'is_active'];

    protected function casts(): array
    {
        return [
            'price_per_month' => 'decimal:2',
            'translations' => 'array',
            'is_active' => 'boolean',
        ];
    }

    public function subscriptions(): HasMany
    {
        return $this->hasMany(DriverSubscription::class);
    }

    /** English (`name`/`description`) is the base record; other locales fall back to it when untranslated. */
    public function nameFor(string $locale): string
    {
        return $this->translations[$locale]['name'] ?? $this->name;
    }

    public function descriptionFor(string $locale): ?string
    {
        return $this->translations[$locale]['description'] ?? $this->description;
    }

    public static function resolveLocale(?string $acceptLanguageHeader): string
    {
        return Locale::resolve($acceptLanguageHeader);
    }

    /** Bakes the requested locale's name/description into the model's attributes for serialization, hiding the raw translations blob. */
    public function localizeFor(string $locale): self
    {
        $this->setAttribute('name', $this->nameFor($locale));
        $this->setAttribute('description', $this->descriptionFor($locale));
        $this->makeHidden('translations');

        return $this;
    }
}
