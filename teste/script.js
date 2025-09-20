// Main JavaScript file for AgendaFácil Mobile App
class AgendaFacilApp {
    constructor() {
        this.currentDate = new Date();
        this.appointments = this.loadAppointments();
        this.currentTab = 'dashboard';
        
        this.init();
    }

    init() {
        this.setupEventListeners();
        this.renderCalendar();
        this.renderAppointments();
        this.renderTodayAppointments();
        this.setupDarkMode();
    }

    setupEventListeners() {
        // Bottom navigation
        document.querySelectorAll('.nav-item').forEach(item => {
            item.addEventListener('click', (e) => {
                const tab = e.currentTarget.dataset.tab;
                this.switchTab(tab);
            });
        });

        // Calendar navigation
        document.getElementById('prev-month').addEventListener('click', () => {
            this.currentDate.setMonth(this.currentDate.getMonth() - 1);
            this.renderCalendar();
        });

        document.getElementById('next-month').addEventListener('click', () => {
            this.currentDate.setMonth(this.currentDate.getMonth() + 1);
            this.renderCalendar();
        });

        // Add appointment button
        document.getElementById('add-appointment').addEventListener('click', () => {
            this.openAppointmentModal();
        });

        // Modal controls
        document.getElementById('close-modal').addEventListener('click', () => {
            this.closeAppointmentModal();
        });

        document.getElementById('appointment-modal').addEventListener('click', (e) => {
            if (e.target.id === 'appointment-modal') {
                this.closeAppointmentModal();
            }
        });

        // Appointment form
        document.getElementById('appointment-form').addEventListener('submit', (e) => {
            e.preventDefault();
            this.addAppointment();
        });

        // Dark mode toggle
        document.getElementById('dark-mode-toggle').addEventListener('change', (e) => {
            this.toggleDarkMode(e.target.checked);
        });
    }

    switchTab(tabName) {
        // Update navigation
        document.querySelectorAll('.nav-item').forEach(item => {
            item.classList.remove('active');
        });
        document.querySelector(`[data-tab="${tabName}"]`).classList.add('active');

        // Update content
        document.querySelectorAll('.tab-content').forEach(content => {
            content.classList.remove('active');
        });
        document.getElementById(`${tabName}-tab`).classList.add('active');

        this.currentTab = tabName;
    }

    renderCalendar() {
        const year = this.currentDate.getFullYear();
        const month = this.currentDate.getMonth();
        
        // Update calendar title
        const monthNames = [
            'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
            'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
        ];
        document.getElementById('calendar-title').textContent = `${monthNames[month]} ${year}`;

        // Calculate calendar days
        const firstDay = new Date(year, month, 1);
        const lastDay = new Date(year, month + 1, 0);
        const daysInMonth = lastDay.getDate();
        const startingDayOfWeek = firstDay.getDay();

        const calendarDays = document.getElementById('calendar-days');
        calendarDays.innerHTML = '';

        // Previous month's trailing days
        const prevMonth = new Date(year, month - 1, 0);
        for (let i = startingDayOfWeek - 1; i >= 0; i--) {
            const day = prevMonth.getDate() - i;
            const dayElement = this.createCalendarDay(day, true, new Date(year, month - 1, day));
            calendarDays.appendChild(dayElement);
        }

        // Current month's days
        for (let day = 1; day <= daysInMonth; day++) {
            const dayElement = this.createCalendarDay(day, false, new Date(year, month, day));
            calendarDays.appendChild(dayElement);
        }

        // Next month's leading days
        const totalCells = calendarDays.children.length;
        const remainingCells = 42 - totalCells; // 6 weeks * 7 days
        for (let day = 1; day <= remainingCells; day++) {
            const dayElement = this.createCalendarDay(day, true, new Date(year, month + 1, day));
            calendarDays.appendChild(dayElement);
        }
    }

    createCalendarDay(day, isOtherMonth, date) {
        const dayElement = document.createElement('div');
        dayElement.className = 'calendar-day';
        dayElement.textContent = day;

        if (isOtherMonth) {
            dayElement.classList.add('other-month');
        }

        // Check if it's today
        const today = new Date();
        if (date.toDateString() === today.toDateString()) {
            dayElement.classList.add('today');
        }

        // Check if there are appointments on this day
        const dateString = date.toISOString().split('T')[0];
        const hasAppointment = this.appointments.some(apt => apt.date === dateString);
        if (hasAppointment) {
            dayElement.classList.add('has-appointment');
        }

        return dayElement;
    }

    renderAppointments() {
        const container = document.getElementById('all-appointments');
        
        if (this.appointments.length === 0) {
            container.innerHTML = `
                <div class="empty-state">
                    <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2" stroke="currentColor" stroke-width="2"/>
                        <line x1="16" y1="2" x2="16" y2="6" stroke="currentColor" stroke-width="2"/>
                        <line x1="8" y1="2" x2="8" y2="6" stroke="currentColor" stroke-width="2"/>
                        <line x1="3" y1="10" x2="21" y2="10" stroke="currentColor" stroke-width="2"/>
                    </svg>
                    <h3>Nenhum agendamento</h3>
                    <p>Você ainda não tem agendamentos marcados</p>
                </div>
            `;
            return;
        }

        const sortedAppointments = [...this.appointments].sort((a, b) => 
            new Date(a.date + 'T' + a.time) - new Date(b.date + 'T' + b.time)
        );

        container.innerHTML = sortedAppointments.map(appointment => 
            this.createAppointmentCard(appointment)
        ).join('');
    }

    renderTodayAppointments() {
        const container = document.getElementById('today-appointments');
        const today = new Date().toISOString().split('T')[0];
        const todayAppointments = this.appointments.filter(apt => apt.date === today);

        if (todayAppointments.length === 0) {
            container.innerHTML = `
                <div class="empty-state">
                    <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2"/>
                        <polyline points="12,6 12,12 16,14" stroke="currentColor" stroke-width="2"/>
                    </svg>
                    <h3>Nenhum agendamento hoje</h3>
                    <p>Você não tem compromissos para hoje</p>
                </div>
            `;
            return;
        }

        const sortedTodayAppointments = todayAppointments.sort((a, b) => 
            a.time.localeCompare(b.time)
        );

        container.innerHTML = sortedTodayAppointments.map(appointment => 
            this.createAppointmentCard(appointment)
        ).join('');
    }

    createAppointmentCard(appointment) {
        const date = new Date(appointment.date);
        const formattedDate = date.toLocaleDateString('pt-BR');
        const formattedTime = appointment.time;

        return `
            <div class="appointment-card">
                <div class="appointment-header">
                    <h4 class="appointment-title">${appointment.service}</h4>
                    <span class="appointment-status ${appointment.status}">${this.getStatusText(appointment.status)}</span>
                </div>
                <div class="appointment-info">
                    <div class="appointment-detail">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2" stroke="currentColor" stroke-width="2"/>
                            <line x1="16" y1="2" x2="16" y2="6" stroke="currentColor" stroke-width="2"/>
                            <line x1="8" y1="2" x2="8" y2="6" stroke="currentColor" stroke-width="2"/>
                            <line x1="3" y1="10" x2="21" y2="10" stroke="currentColor" stroke-width="2"/>
                        </svg>
                        <span>${formattedDate}</span>
                    </div>
                    <div class="appointment-detail">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2"/>
                            <polyline points="12,6 12,12 16,14" stroke="currentColor" stroke-width="2"/>
                        </svg>
                        <span>${formattedTime}</span>
                    </div>
                    ${appointment.notes ? `
                        <div class="appointment-detail">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" stroke="currentColor" stroke-width="2"/>
                                <polyline points="14,2 14,8 20,8" stroke="currentColor" stroke-width="2"/>
                                <line x1="16" y1="13" x2="8" y2="13" stroke="currentColor" stroke-width="2"/>
                                <line x1="16" y1="17" x2="8" y2="17" stroke="currentColor" stroke-width="2"/>
                                <polyline points="10,9 9,9 8,9" stroke="currentColor" stroke-width="2"/>
                            </svg>
                            <span>${appointment.notes}</span>
                        </div>
                    ` : ''}
                </div>
            </div>
        `;
    }

    getStatusText(status) {
        const statusMap = {
            'confirmed': 'Confirmado',
            'pending': 'Pendente',
            'cancelled': 'Cancelado'
        };
        return statusMap[status] || status;
    }

    openAppointmentModal() {
        const modal = document.getElementById('appointment-modal');
        modal.classList.add('active');
        
        // Set default date to today
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('date').value = today;
    }

    closeAppointmentModal() {
        const modal = document.getElementById('appointment-modal');
        modal.classList.remove('active');
        document.getElementById('appointment-form').reset();
    }

    addAppointment() {
        const form = document.getElementById('appointment-form');
        const formData = new FormData(form);
        
        const appointment = {
            id: Date.now().toString(),
            service: formData.get('service') || document.getElementById('service').value,
            date: formData.get('date') || document.getElementById('date').value,
            time: formData.get('time') || document.getElementById('time').value,
            notes: formData.get('notes') || document.getElementById('notes').value,
            status: 'confirmed',
            createdAt: new Date().toISOString()
        };

        // Get service name from select option
        const serviceSelect = document.getElementById('service');
        const selectedOption = serviceSelect.options[serviceSelect.selectedIndex];
        appointment.service = selectedOption.text;

        this.appointments.push(appointment);
        this.saveAppointments();
        
        this.renderCalendar();
        this.renderAppointments();
        this.renderTodayAppointments();
        this.closeAppointmentModal();

        // Show success message (you could implement a toast notification here)
        this.showNotification('Agendamento criado com sucesso!', 'success');
    }

    showNotification(message, type = 'info') {
        // Simple notification implementation
        const notification = document.createElement('div');
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: ${type === 'success' ? '#10B981' : '#4F46E5'};
            color: white;
            padding: 1rem 1.5rem;
            border-radius: 8px;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            z-index: 3000;
            animation: slideIn 0.3s ease-in-out;
        `;
        notification.textContent = message;
        
        document.body.appendChild(notification);
        
        setTimeout(() => {
            notification.remove();
        }, 3000);
    }

    setupDarkMode() {
        const darkModeToggle = document.getElementById('dark-mode-toggle');
        const savedTheme = localStorage.getItem('theme');
        
        if (savedTheme === 'dark') {
            document.documentElement.setAttribute('data-theme', 'dark');
            darkModeToggle.checked = true;
        }
    }

    toggleDarkMode(enabled) {
        if (enabled) {
            document.documentElement.setAttribute('data-theme', 'dark');
            localStorage.setItem('theme', 'dark');
        } else {
            document.documentElement.removeAttribute('data-theme');
            localStorage.setItem('theme', 'light');
        }
    }

    loadAppointments() {
        const saved = localStorage.getItem('appointments');
        if (saved) {
            return JSON.parse(saved);
        }
        
        // Return sample appointments for demo
        return [
            {
                id: '1',
                service: 'Consulta Médica',
                date: new Date().toISOString().split('T')[0],
                time: '14:30',
                notes: 'Consulta de rotina',
                status: 'confirmed',
                createdAt: new Date().toISOString()
            },
            {
                id: '2',
                service: 'Exame de Sangue',
                date: new Date(Date.now() + 86400000).toISOString().split('T')[0], // Tomorrow
                time: '09:00',
                notes: 'Jejum de 12 horas',
                status: 'pending',
                createdAt: new Date().toISOString()
            },
            {
                id: '3',
                service: 'Retorno',
                date: new Date(Date.now() + 7 * 86400000).toISOString().split('T')[0], // Next week
                time: '16:00',
                notes: '',
                status: 'confirmed',
                createdAt: new Date().toISOString()
            }
        ];
    }

    saveAppointments() {
        localStorage.setItem('appointments', JSON.stringify(this.appointments));
    }
}

// Initialize app when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    new AgendaFacilApp();
});

// Add CSS animation for notifications
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from {
            opacity: 0;
            transform: translateX(100%);
        }
        to {
            opacity: 1;
            transform: translateX(0);
        }
    }
`;
document.head.appendChild(style);

// Service Worker registration for PWA capabilities (optional)
if ('serviceWorker' in navigator) {
    window.addEventListener('load', () => {
        // You can register a service worker here for offline capabilities
        console.log('PWA capabilities available');
    });
}

// Handle viewport height for mobile browsers
function setViewportHeight() {
    const vh = window.innerHeight * 0.01;
    document.documentElement.style.setProperty('--vh', `${vh}px`);
}

setViewportHeight();
window.addEventListener('resize', setViewportHeight);
window.addEventListener('orientationchange', setViewportHeight);