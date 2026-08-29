@props(['id', 'label' => 'this record'])

<x-common.icon-button
    icon="delete"
    variant="danger"
    title="Delete"
    type="button"
    @click="$store.confirm.ask('Delete {{ addslashes($label) }}?', 'This cannot be undone.', () => {
        selected = ['{{ $id }}'];
        $nextTick(() => document.getElementById('bulk-delete-form').requestSubmit());
    })"
/>
