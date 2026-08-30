<?php

namespace App\Models;

use App\Support\Locale;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Support\Facades\Storage;

class VehicleCategory extends Model
{
    public const SUPPORTED_LOCALES = Locale::SUPPORTED;

    protected $fillable = ['name', 'description', 'translations', 'image_path', 'seats', 'ac', 'base_fare', 'per_km_rate', 'per_min_rate'];

    protected $appends = ['image_url'];

    protected function casts(): array
    {
        return [
            'translations' => 'array',
            'ac' => 'boolean',
            'base_fare' => 'decimal:2',
            'per_km_rate' => 'decimal:2',
            'per_min_rate' => 'decimal:2',
        ];
    }

    public function vehicles(): HasMany
    {
        return $this->hasMany(Vehicle::class);
    }

    public function estimateFare(float $distanceKm, int $etaMinutes): float
    {
        return round(
            (float) $this->base_fare
            + ((float) $this->per_km_rate * $distanceKm)
            + ((float) $this->per_min_rate * $etaMinutes),
            2
        );
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

    /** Bakes the requested locale's name/description into the model's attributes for serialization, hiding internal fields. */
    public function localizeFor(string $locale): self
    {
        $this->setAttribute('name', $this->nameFor($locale));
        $this->setAttribute('description', $this->descriptionFor($locale));
        $this->makeHidden(['translations', 'image_path']);

        return $this;
    }

    public function getImageUrlAttribute(): ?string
    {
        return $this->image_path ? Storage::disk('public')->url($this->image_path) : null;
    }
}
