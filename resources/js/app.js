import './bootstrap';
import Alpine from 'alpinejs';

// FullCalendar
import { Calendar } from '@fullcalendar/core';

// Toasts
import Toastify from 'toastify-js';
import 'toastify-js/src/toastify.css';

window.Alpine = Alpine;
window.FullCalendar = Calendar;
window.Toastify = Toastify;

Alpine.start();

// Initialize components on DOM ready
document.addEventListener('DOMContentLoaded', () => {
    // Calendar init
    if (document.querySelector('#calendar')) {
        import('./components/calendar-init').then(module => module.calendarInit());
    }

    // Dashboard charts
    if (document.querySelector('#chartBookingsTrend')) {
        import('./components/dashboard-charts').then(module => module.dashboardChartsInit());
    }
});
