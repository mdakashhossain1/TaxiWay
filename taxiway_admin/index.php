<?php

// Shared-hosting entry point. Forwards every request to Laravel's real
// front controller in /public — needed when the host's document root can
// only be pointed at this folder, not at /public itself. All paths inside
// public/index.php are __DIR__-relative to that file, so requiring it from
// here resolves vendor/, bootstrap/, and storage/ correctly with no changes.
require __DIR__.'/public/index.php';
