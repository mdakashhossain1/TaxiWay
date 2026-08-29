<?php
// TEMPORARY — visit this file once in your browser, then DELETE it.
// Forces PHP to drop any cached (stale) compiled bytecode of your app's
// files. This is different from `php artisan route:clear` / `view:clear`,
// which only clear Laravel's own cache — not PHP's OPcache. If re-uploading
// files and clearing Laravel's cache hasn't fixed a "still shows the old
// code" issue, OPcache is almost always why.

if (function_exists('opcache_reset')) {
    opcache_reset();
    echo 'OPcache cleared. Delete this file now, then reload your site.';
} else {
    echo 'OPcache is not enabled on this server — this was not the issue.';
}
