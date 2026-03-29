const API_BASE = 'http://localhost:8000/api/v1/';

async function fetchJSON(endpoint, options = {}) {
    try {
        const response = await fetch(API_BASE + endpoint, {
            headers: { 'Content-Type': 'application/json', ...options.headers },
            ...options,
        });
        if (!response.ok) throw new Error(`Error ${response.status}: ${response.statusText}`);
        return await response.json();
    } catch (error) {
        console.error('Error fetching API:', error);
        return null;
    }
}

async function loadStats() {
    const [usuarios, equipos, sesiones, plataformas] = await Promise.all([
        fetchJSON('usuarios/'),
        fetchJSON('equipos/'),
        fetchJSON('sesiones/'),
        fetchJSON('plataformas/')
    ]);

    if (usuarios) document.getElementById('total-atletas').textContent = usuarios.count || usuarios.length || 0;
    if (equipos) document.getElementById('total-equipos').textContent = equipos.count || equipos.length || 0;
    if (sesiones) document.getElementById('total-sesiones').textContent = sesiones.count || sesiones.length || 0;
    if (plataformas) document.getElementById('total-plataformas').textContent = plataformas.count || plataformas.length || 0;
}

async function loadSessions() {
    const sesionesData = await fetchJSON('sesiones/');
    const tbody = document.getElementById('sessions-table-body');
    
    if (!sesionesData) {
        tbody.innerHTML = '<tr><td colspan="6" class="text-center" style="color:var(--danger)">Error cargando sesiones. Verifica que el servidor Django esté corriendo e ignora CORS.</td></tr>';
        return;
    }

    const sesiones = sesionesData.results || sesionesData;
    
    if (sesiones.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" class="text-center">No hay sesiones agendadas.</td></tr>';
        return;
    }

    let rows = '';
    sesiones.forEach(s => {
        const stateClass = `badge-${s.estado.toLowerCase()}`;
        rows += `
            <tr>
                <td>#${s.id}</td>
                <td>Juego ${s.juego}</td>
                <td><span class="badge ${stateClass}">${s.estado}</span></td>
                <td>${s.fecha_agendamiento} ${s.hora_inicio} - ${s.hora_fin}</td>
                <td>${s.equipo ? `Equipo #${s.equipo}` : `Atleta #${s.atleta}`}</td>
                <td>
                    ${s.estado === 'agendada' || s.estado === 'activa' ? `
                        <button class="btn btn-outline" onclick="cancelarSesion(${s.id})" style="padding: 0.25rem 0.5rem; font-size: 0.75rem">Cancelar</button>
                    ` : ''}
                </td>
            </tr>
        `;
    });
    tbody.innerHTML = rows;
}

async function cancelarSesion(id) {
    if(confirm('¿Seguro que deseas cancelar esta sesión?')) {
        const res = await fetchJSON(`sesiones/${id}/cancelar/`, { method: 'POST' });
        if(res) {
            alert('Sesión cancelada correctamente');
            loadSessions();
        }
    }
}

document.addEventListener('DOMContentLoaded', () => {
    loadStats();
    loadSessions();
});
