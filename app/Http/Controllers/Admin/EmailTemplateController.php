<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\EmailTemplate;
use App\Support\Locale;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class EmailTemplateController extends Controller
{
    /** Human-friendly labels for each system template key — extend this alongside new Mailables. */
    private const LABELS = [
        'driver_verified' => 'Driver Verified',
    ];

    public function index(): View
    {
        $templates = EmailTemplate::orderBy('key')->get();

        return view('pages.admin.email-templates.index', [
            'title' => 'Email Templates',
            'templates' => $templates,
            'labels' => self::LABELS,
        ]);
    }

    public function edit(EmailTemplate $emailTemplate): View
    {
        return view('pages.admin.email-templates.edit', [
            'title' => self::LABELS[$emailTemplate->key] ?? $emailTemplate->key,
            'template' => $emailTemplate,
        ]);
    }

    public function update(Request $request, EmailTemplate $emailTemplate): RedirectResponse
    {
        $data = $request->validate([
            'subject' => ['required', 'string', 'max:255'],
            'heading' => ['required', 'string', 'max:255'],
            'body' => ['required', 'string', 'max:5000'],
            'translations' => ['nullable', 'array'],
            'translations.*.subject' => ['nullable', 'string', 'max:255'],
            'translations.*.heading' => ['nullable', 'string', 'max:255'],
            'translations.*.body' => ['nullable', 'string', 'max:5000'],
        ]);

        $translations = [];
        foreach (Locale::SUPPORTED as $locale => $label) {
            if ($locale === 'en') {
                continue;
            }

            $fields = array_filter([
                'subject' => trim($data['translations'][$locale]['subject'] ?? ''),
                'heading' => trim($data['translations'][$locale]['heading'] ?? ''),
                'body' => trim($data['translations'][$locale]['body'] ?? ''),
            ], fn ($value) => $value !== '');

            if ($fields !== []) {
                $translations[$locale] = $fields;
            }
        }

        $emailTemplate->update([
            'subject' => $data['subject'],
            'heading' => $data['heading'],
            'body' => $data['body'],
            'translations' => $translations ?: null,
        ]);

        return redirect()->route('email-templates.index')->with('status', 'Email template updated.');
    }
}
