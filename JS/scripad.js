document.addEventListener('DOMContentLoaded', function() {
    const botonesAdopcion = document.querySelectorAll('a.btn[href="formadop.html"]');
    
    botonesAdopcion.forEach(boton => {
        boton.addEventListener('click', function(e) {
            e.preventDefault();
            
            const mascota = this.closest('.mascota');
            if (!mascota) {
                console.error('Elemento mascota no encontrado');
                return;
            }
            
            // Datos esenciales de la mascota
            const mascotaData = {
                id: mascota.getAttribute('data-id'),
                nombre: mascota.querySelector('h3').textContent.trim(),
                edad: mascota.querySelector('p:nth-of-type(1)').textContent.replace('Edad: ', '').trim(),
                raza_especie: mascota.querySelector('p:nth-of-type(2)').textContent
                              .replace(mascota.dataset.especie === 'ave' ? 'Especie: ' : 'Raza: ', '').trim(),
                especie: mascota.dataset.especie || 'perro'
            };
            
            // Verificar autenticación
            const user = JSON.parse(localStorage.getItem('currentUser'));
            
            if (user) {
                // Guardar datos específicos del usuario
                sessionStorage.setItem(`mascotaAdopcion_${user.id}`, JSON.stringify(mascotaData));
                localStorage.setItem(`lastPetAdoption_${user.id}`, JSON.stringify(mascotaData));
                
                // Confirmar adopción
                if (confirm(`¿Quieres adoptar a ${mascotaData.nombre}?`)) {
                    window.location.href = 'formadop.html';
                }
            } else {
                // Guardar datos genéricos (para redirigir después del login)
                sessionStorage.setItem('mascotaAdopcion', JSON.stringify(mascotaData));
                localStorage.setItem('lastPetAdoption', JSON.stringify(mascotaData));
                
                alert('Por favor inicia sesión para continuar con la adopción');
                window.location.href = `login.html?redirect=adopcion&from=${encodeURIComponent(window.location.href)}`;
            }
        });
    });
});