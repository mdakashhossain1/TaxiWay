import ApexCharts from "apexcharts";

const brand = "#465FFF";
const success = "#12B76A";
const warning = "#F79009";
const error = "#F04438";

export function dashboardChartsInit() {
  const data = window.dashboardChartsData;
  if (!data) return;

  const bookingsTrendEl = document.querySelector("#chartBookingsTrend");
  if (bookingsTrendEl) {
    new ApexCharts(bookingsTrendEl, {
      chart: { type: "area", height: 220, toolbar: { show: false }, fontFamily: "Outfit, sans-serif" },
      series: [{ name: "Bookings", data: data.bookingsTrend }],
      xaxis: { categories: data.chartLabels, labels: { style: { fontSize: "11px" } } },
      colors: [brand],
      fill: { type: "gradient", gradient: { opacityFrom: 0.35, opacityTo: 0 } },
      dataLabels: { enabled: false },
      stroke: { curve: "smooth", width: 2 },
      grid: { strokeDashArray: 4 },
    }).render();
  }

  const revenueTrendEl = document.querySelector("#chartRevenueTrend");
  if (revenueTrendEl) {
    new ApexCharts(revenueTrendEl, {
      chart: { type: "area", height: 220, toolbar: { show: false }, fontFamily: "Outfit, sans-serif" },
      series: [{ name: "Revenue", data: data.revenueTrend }],
      xaxis: { categories: data.chartLabels, labels: { style: { fontSize: "11px" } } },
      yaxis: { labels: { formatter: (v) => "₹" + Math.round(v) } },
      colors: [success],
      fill: { type: "gradient", gradient: { opacityFrom: 0.35, opacityTo: 0 } },
      dataLabels: { enabled: false },
      stroke: { curve: "smooth", width: 2 },
      grid: { strokeDashArray: 4 },
      tooltip: { y: { formatter: (v) => "₹" + v.toFixed(2) } },
    }).render();
  }

  const statusEl = document.querySelector("#chartStatusBreakdown");
  if (statusEl && data.statusLabels.length) {
    new ApexCharts(statusEl, {
      chart: { type: "donut", height: 280, fontFamily: "Outfit, sans-serif" },
      series: data.statusCounts,
      labels: data.statusLabels,
      colors: [brand, warning, success, error, "#7A5AF8", "#0BA5EC"],
      legend: { position: "bottom", fontSize: "12px" },
      dataLabels: { enabled: false },
    }).render();
  }

  const categoryEl = document.querySelector("#chartCategoryBreakdown");
  if (categoryEl && data.categoryLabels.length) {
    new ApexCharts(categoryEl, {
      chart: { type: "bar", height: 280, toolbar: { show: false }, fontFamily: "Outfit, sans-serif" },
      series: [{ name: "Bookings", data: data.categoryCounts }],
      xaxis: { categories: data.categoryLabels },
      colors: [brand],
      plotOptions: { bar: { borderRadius: 4, columnWidth: "45%" } },
      dataLabels: { enabled: false },
      grid: { strokeDashArray: 4 },
    }).render();
  }
}

export default dashboardChartsInit;
