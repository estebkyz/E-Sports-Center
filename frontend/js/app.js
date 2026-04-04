const API_BASE_URL = 'http://localhost:8000/api/v1';

document.addEventListener('DOMContentLoaded', () => ['plataformas', 'juegos', 'equipos'].forEach(loadData));

function showSection(id) {
    document.querySelectorAll('.content-section, .nav-btn').forEach(el => el.classList.remove('active'));
    document.getElementById(id).classList.add('active');
    document.querySelector(`[onclick="showSection('${id}')"]`).classList.add('active');
    loadData(id);
}

// Muestra un aviso de error dentro de la sección activa y lo quita a los 5 segundos
function showError(message, sectionId = null) {
    const target = sectionId
        ? document.getElementById(sectionId)
        : document.querySelector('.content-section.active');
    if (!target) return;
    const existing = target.querySelector('.api-error-msg');
    if (existing) existing.remove();
    const div = document.createElement('div');
    div.className = 'api-error-msg';
    div.textContent = message;
    target.prepend(div);
    setTimeout(() => div.remove(), 5000);
}

// Convierte el código de estado HTTP en un texto que el usuario pueda entender
function httpErrorMessage(status) {
    if (status === 400) return '⚠️ Datos inválidos. Revisa los campos del formulario.';
    if (status === 404) return '🔍 El registro no fue encontrado.';
    if (status === 500) return '🔥 Error interno del servidor. Intenta más tarde.';
    if (status === 403) return '🔒 No tienes permiso para realizar esta acción.';
    return `❌ Error inesperado (código ${status}). Intenta nuevamente.`;
}

async function api(method, endpoint, body = null) {
    let res;
    try {
        const opts = { method, headers: { 'Content-Type': 'application/json' } };
        if (body) opts.body = JSON.stringify(body);
        res = await fetch(`${API_BASE_URL}/${endpoint}/`, opts);
    } catch (networkErr) {
        // Si el fetch falla es porque el servidor no está corriendo
        throw { friendly: '📡 No se pudo conectar con el servidor. Verifica que el backend esté activo.' };
    }
    if (!res.ok) {
        throw { status: res.status, friendly: httpErrorMessage(res.status) };
    }
    if (method === 'DELETE' || res.status === 204) return null;
    return res.json();
}

const UI = {
    plataformas: {
        render: el => `<td>${el.id}</td><td>${el.nombre}</td><td>${el.marca}</td>`,
        fill: el => {
            document.getElementById('plataforma-id').value = el.id;
            document.getElementById('plataforma-nombre').value = el.nombre;
            document.getElementById('plataforma-marca').value = el.marca;
        },
        data: () => ({
            nombre: document.getElementById('plataforma-nombre').value,
            marca: document.getElementById('plataforma-marca').value
        })
    },
    juegos: {
        render: el => `<td>${el.id}</td><td>${el.nombre}</td><td>${el.tipo}</td><td>${el.estudio}</td><td>${el.plataformas || ''}</td>`,
        fill: el => {
            document.getElementById('juego-id').value = el.id;
            document.getElementById('juego-nombre').value = el.nombre;
            document.getElementById('juego-esrb').value = el.calificacion_esrb;
            document.getElementById('juego-estudio').value = el.estudio;
            document.getElementById('juego-plataformas').value = el.plataformas ? el.plataformas.join(',') : '';
            document.getElementById('juego-jugadores').value = el.num_jugadores;
            document.getElementById('juego-tipo').value = el.tipo;
            document.getElementById('juego-existencias').value = el.existencias;
        },
        data: () => ({
            nombre: document.getElementById('juego-nombre').value,
            calificacion_esrb: document.getElementById('juego-esrb').value,
            estudio: document.getElementById('juego-estudio').value,
            plataformas: document.getElementById('juego-plataformas').value.split(',').map(Number).filter(n => !isNaN(n)),
            num_jugadores: Number(document.getElementById('juego-jugadores').value),
            tipo: document.getElementById('juego-tipo').value,
            existencias: Number(document.getElementById('juego-existencias').value)
        })
    },
    equipos: {
        render: el => `<td>${el.id}</td><td>${el.nombre}</td><td>${el.nivel}</td><td>${el.juego_nombre || el.juego}</td>`,
        fill: el => {
            document.getElementById('equipo-id').value = el.id;
            document.getElementById('equipo-nombre').value = el.nombre;
            document.getElementById('equipo-nivel').value = el.nivel;
            document.getElementById('equipo-horas').value = el.horas_juego;
            document.getElementById('equipo-juego-id').value = el.juego;
        },
        data: () => ({
            nombre: document.getElementById('equipo-nombre').value,
            nivel: document.getElementById('equipo-nivel').value,
            horas_juego: Number(document.getElementById('equipo-horas').value),
            juego: Number(document.getElementById('equipo-juego-id').value)
        })
    }
};

async function loadData(entity) {
    try {
        const data = await api('GET', entity);
        const items = data.results || data;
        const tbody = document.getElementById(`lista-${entity}`);
        if (items.length === 0) {
            tbody.innerHTML = `<tr><td colspan="10" style="text-align:center;opacity:.6">Sin registros</td></tr>`;
            return;
        }
        tbody.innerHTML = items.map(item => `
            <tr>
                ${UI[entity].render(item)}
                <td>
                    <button class="btn-edit" onclick='openModal("${entity}", ${JSON.stringify(item)})'>Editar</button>
                    <button class="btn-delete" onclick="deleteItem('${entity}', ${item.id})">Eliminar</button>
                </td>
            </tr>
        `).join('');
    } catch(err) {
        console.error(err);
        showError(err.friendly || '❌ Error al cargar los datos.');
    }
}

function openModal(entity, item = null) {
    const singular = entity.replace(/s$/, '');
    const modal = document.getElementById(`modal-${singular}`);
    modal.style.display = 'block';
    if (!item) modal.querySelector('form').reset(), document.getElementById(`${singular}-id`).value = '';
    else UI[entity].fill(item);
}

function closeModal(id) { document.getElementById(id).style.display = 'none'; }
window.onclick = e => { if (e.target.classList.contains('modal')) e.target.style.display = 'none'; };

['plataforma', 'juego', 'equipo'].forEach(name => {
    document.getElementById(`form-${name}`).addEventListener('submit', async e => {
        e.preventDefault();
        const entity = name + 's';
        const id = document.getElementById(`${name}-id`).value;
        try {
            await api(id ? 'PUT' : 'POST', id ? `${entity}/${id}` : entity, UI[entity].data());
            closeModal(`modal-${name}`);
            loadData(entity);
        } catch(err) {
            console.error(err);
            showError(err.friendly || '❌ Error al guardar el registro.');
        }
    });
});

async function deleteItem(entity, id) {
    if (!confirm('¿Eliminar registro?')) return;
    try {
        await api('DELETE', `${entity}/${id}`);
        loadData(entity);
    } catch(err) {
        console.error(err);
        showError(err.friendly || '❌ Error al eliminar el registro.');
    }
}