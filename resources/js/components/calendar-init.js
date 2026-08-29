import { Calendar } from "@fullcalendar/core";
import dayGridPlugin from "@fullcalendar/daygrid";
import listPlugin from "@fullcalendar/list";
import timeGridPlugin from "@fullcalendar/timegrid";

export function calendarInit() {
  const calendarEl = document.querySelector("#calendar");
  if (!calendarEl) return;

  const data = window.calendarData || { events: [], currentMonth: null };

  const calendar = new Calendar(calendarEl, {
    plugins: [dayGridPlugin, timeGridPlugin, listPlugin],
    initialView: "dayGridMonth",
    initialDate: data.currentMonth ? `${data.currentMonth}-01` : undefined,
    headerToolbar: {
      left: "prevMonth,nextMonth",
      center: "title",
      right: "dayGridMonth,timeGridWeek,listMonth",
    },
    customButtons: {
      prevMonth: {
        text: "‹",
        click: () => {
          if (data.prevMonthUrl) window.location.href = data.prevMonthUrl;
        },
      },
      nextMonth: {
        text: "›",
        click: () => {
          if (data.nextMonthUrl) window.location.href = data.nextMonthUrl;
        },
      },
    },
    events: data.events,
    displayEventTime: false,
    eventDidMount(info) {
      const props = info.event.extendedProps;
      const parts = [props.type, props.status];
      if (props.driver) parts.push(`Driver: ${props.driver}`);
      info.el.setAttribute("title", parts.filter(Boolean).join(" · "));
    },
    eventContent(eventInfo) {
      const colorClass = `fc-bg-${(eventInfo.event.extendedProps.calendar || "primary").toLowerCase()}`;
      return {
        html: `
          <div class="event-fc-color flex fc-event-main ${colorClass} p-1 rounded-sm">
            <div class="fc-daygrid-event-dot"></div>
            <div class="fc-event-title">${eventInfo.event.title}</div>
          </div>
        `,
      };
    },
  });

  calendar.render();
}

export default calendarInit;
