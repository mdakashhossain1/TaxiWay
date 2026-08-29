<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Driver;
use App\Models\DriverDocument;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Symfony\Component\HttpFoundation\StreamedResponse;

class DriverDocumentController extends Controller
{
    /** Digitized KYC records are optional — admins may verify a driver without ever uploading one. */
    public function store(Request $request, Driver $driver): RedirectResponse
    {
        $data = $request->validate([
            'label' => ['required', 'string', 'max:255'],
            'file' => ['required', 'file', 'max:10240'],
        ]);

        $path = $request->file('file')->store("driver-documents/{$driver->id}", 'local');

        $driver->documents()->create([
            'label' => $data['label'],
            'path' => $path,
            'original_name' => $request->file('file')->getClientOriginalName(),
        ]);

        return back()->with('status', 'Document uploaded.');
    }

    public function download(Driver $driver, DriverDocument $document): StreamedResponse
    {
        abort_unless($document->driver_id === $driver->id, 404);

        return Storage::disk('local')->download($document->path, $document->original_name);
    }

    public function destroy(Driver $driver, DriverDocument $document): RedirectResponse
    {
        abort_unless($document->driver_id === $driver->id, 404);

        Storage::disk('local')->delete($document->path);
        $document->delete();

        return back()->with('status', 'Document removed.');
    }
}
