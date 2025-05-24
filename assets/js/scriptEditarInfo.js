// Verificar si el usuario estÃ¡ logueado al cargar la pÃ¡gina
document.addEventListener('DOMContentLoaded', function () {
    const user = JSON.parse(localStorage.getItem('currentUser'));

    if (!user) {
        alert('Debes iniciar sesiÃ³n para acceder a esta pÃ¡gina');
        window.location.href = 'login.html';
        return;
    }

    // Cargar informaciÃ³n adicional del usuario desde el servidor
    fetch('../api/users/get_user_info.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ user_id: user.id })
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Actualizar localStorage con la informaciÃ³n completa
                const updatedUser = {
                    ...user,
                    ...data.userInfo,
                    adoptanteInfo: data.adoptanteInfo
                };
                localStorage.setItem('currentUser', JSON.stringify(updatedUser));

                // Mostrar informaciÃ³n del usuario
                document.getElementById('user-name').textContent = updatedUser.name || updatedUser.nombre;
                document.getElementById('user-email').textContent = updatedUser.email;
                document.getElementById('user-phone').textContent = data.adoptanteInfo?.telefono || 'No registrado';
                document.getElementById('user-address').textContent = data.adoptanteInfo?.direccion || 'No registrada';
                document.getElementById('user-age').textContent = data.adoptanteInfo?.edad ? data.adoptanteInfo.edad + ' aÃ±os' : 'No registrada';
                document.getElementById('user-experience').textContent = data.adoptanteInfo?.experiencia_mascotas || 'No registrada';
                document.getElementById('user-register-date').textContent =
                    updatedUser.fecha_registro ? new Date(updatedUser.fecha_registro).toLocaleDateString() : 'No disponible';

                // Rellenar formulario de ediciÃ³n
                document.getElementById('edit-name').value = updatedUser.name || updatedUser.nombre;
                document.getElementById('edit-email').value = updatedUser.email;
                document.getElementById('edit-phone').value = data.adoptanteInfo?.telefono || '';
                document.getElementById('edit-address').value = data.adoptanteInfo?.direccion || '';
                document.getElementById('edit-age').value = data.adoptanteInfo?.edad || '';
                document.getElementById('edit-experience').value = data.adoptanteInfo?.experiencia_mascotas || '';
            }
        })
        .catch(error => {
            console.error('Error al cargar informaciÃ³n del usuario:', error);
            // Mostrar informaciÃ³n bÃ¡sica si falla la carga
            document.getElementById('user-name').textContent = user.name;
            document.getElementById('user-email').textContent = user.email;
            document.getElementById('user-register-date').textContent =
                user.registerDate ? new Date(user.registerDate).toLocaleDateString() : 'No disponible';

            // Rellenar formulario con informaciÃ³n bÃ¡sica
            document.getElementById('edit-name').value = user.name;
            document.getElementById('edit-email').value = user.email;
        });
});

function setActive(element) {
    // Remover clase active de todos los elementos
    document.querySelectorAll('.account-menu a').forEach(link => {
        link.classList.remove('active');
    });

    // Agregar clase active al elemento clickeado
    element.classList.add('active');
}

function showSection(sectionId) {
    // Ocultar todas las secciones
    document.querySelectorAll('.account-section').forEach(section => {
        section.style.display = 'none';
    });

    // Mostrar la secciÃ³n seleccionada
    document.getElementById(sectionId).style.display = 'block';
}

function showEditForm() {
    document.getElementById('edit-user-form').style.display = 'block';
    document.getElementById('current-password').value = ''; // Limpiar campo de contraseÃ±a
}

function hideEditForm() {
    document.getElementById('edit-user-form').style.display = 'none';
}

function logout() {
    const user = JSON.parse(localStorage.getItem('currentUser'));
    if (user) {
        // Limpiar datos especÃ­ficos del usuario
        sessionStorage.removeItem(`mascotaAdopcion_${user.id}`);
        sessionStorage.removeItem(`formularioAdopcionTemp_${user.id}`);
        localStorage.removeItem(`lastPetAdoption_${user.id}`);
    }

    // Limpiar datos genÃ©ricos
    sessionStorage.removeItem('mascotaAdopcion');
    sessionStorage.removeItem('formularioAdopcionTemp');
    localStorage.removeItem('lastPetAdoption');

    // Cerrar sesion en el servidor
    fetch('../api/auth/logout.php', {
        method: 'POST',
        credentials: 'include'
    }).then(() => {
        // Cerrar sesiÃ³n localmente
        localStorage.removeItem('currentUser');
        window.location.href = 'login.html';
    }).catch(() => {
        // Si falla la peticiÃ³n al servidor, igual cerrar sesiÃ³n localmente
        localStorage.removeItem('currentUser');
        window.location.href = 'login.html';
    });
}

// Manejar el envÃ­o del formulario de actualizaciÃ³n
document.getElementById('updateForm').addEventListener('submit', function (e) {
    e.preventDefault();

    const currentUser = JSON.parse(localStorage.getItem('currentUser'));
    const currentPassword = document.getElementById('current-password').value;
    const newPassword = document.getElementById('new-password').value;
    const confirmNewPassword = document.getElementById('confirm-new-password').value;
    const errorMessage = document.getElementById('update-error-message');
    const successMessage = document.getElementById('update-success-message');

    // Limpiar mensajes anteriores
    errorMessage.textContent = '';
    successMessage.textContent = '';

    // Validar nueva contraseÃ±a si se proporciona
    if (newPassword) {
        if (newPassword.length < 6) {
            errorMessage.textContent = 'La nueva contraseÃ±a debe tener al menos 6 caracteres';
            return;
        }
        if (newPassword !== confirmNewPassword) {
            errorMessage.textContent = 'Las contraseÃ±as nuevas no coinciden';
            return;
        }
    }

    // Preparar datos para enviar
    const updateData = {
        user_id: currentUser.id,
        nombre: document.getElementById('edit-name').value,
        email: document.getElementById('edit-email').value,
        telefono: document.getElementById('edit-phone').value,
        direccion: document.getElementById('edit-address').value,
        edad: document.getElementById('edit-age').value,
        experiencia_mascotas: document.getElementById('edit-experience').value,
        current_password: currentPassword,
        new_password: newPassword
    };

    // Enviar actualizacion al servidor
    fetch('../api/users/update_user.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(updateData)
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Actualizar informacion local
                const updatedUser = {
                    ...currentUser,
                    name: updateData.nombre,
                    nombre: updateData.nombre,
                    email: updateData.email,
                    adoptanteInfo: {
                        telefono: updateData.telefono,
                        direccion: updateData.direccion,
                        edad: updateData.edad,
                        experiencia_mascotas: updateData.experiencia_mascotas
                    }
                };

                localStorage.setItem('currentUser', JSON.stringify(updatedUser));

                // Actualizar la visualizaciÃ³n
                document.getElementById('user-name').textContent = updatedUser.name;
                document.getElementById('user-email').textContent = updatedUser.email;
                document.getElementById('user-phone').textContent = updateData.telefono || 'No registrado';
                document.getElementById('user-address').textContent = updateData.direccion || 'No registrada';
                document.getElementById('user-age').textContent = updateData.edad ? updateData.edad + ' aÃ±os' : 'No registrada';
                document.getElementById('user-experience').textContent = updateData.experiencia_mascotas || 'No registrada';

                // Limpiar campos de contraseÃ±a
                document.getElementById('current-password').value = '';
                document.getElementById('new-password').value = '';
                document.getElementById('confirm-new-password').value = '';

                successMessage.textContent = 'InformaciÃ³n actualizada correctamente';

                // Ocultar formulario despuÃ©s de 2 segundos
                setTimeout(() => {
                    hideEditForm();
                    successMessage.textContent = '';
                }, 2000);
            } else {
                errorMessage.textContent = data.message || 'Error al actualizar la informaciÃ³n';
            }
        })
        .catch(error => {
            console.error('Error:', error);
            errorMessage.textContent = 'Error de conexiÃ³n al actualizar la informaciÃ³n';
        });
});
