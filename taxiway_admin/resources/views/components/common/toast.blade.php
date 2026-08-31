@if (session('status'))
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            Toastify({
                text: @json(session('status')),
                duration: 4000,
                close: true,
                gravity: 'top',
                position: 'right',
                stopOnFocus: true,
                style: {
                    background: '#12B76A',
                    borderRadius: '0.75rem',
                    boxShadow: '0 8px 16px -4px rgba(16, 24, 40, 0.15)',
                },
            }).showToast();
        });
    </script>
@endif

@if (session('error'))
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            Toastify({
                text: @json(session('error')),
                duration: 5000,
                close: true,
                gravity: 'top',
                position: 'right',
                stopOnFocus: true,
                style: {
                    background: '#F04438',
                    borderRadius: '0.75rem',
                    boxShadow: '0 8px 16px -4px rgba(16, 24, 40, 0.15)',
                },
            }).showToast();
        });
    </script>
@endif
