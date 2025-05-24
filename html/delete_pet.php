<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Manejar preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

include_once 'conexion.php';

function verifyToken($token) {
    // Implementa tu verificación de token aquí
    return !empty($token);
}

$method = $_SERVER['REQUEST_METHOD'];
$headers = getallheaders();
$token = isset($headers['Authorization']) ? str_replace('Bearer ', '', $headers['Authorization']) : '';

if (!verifyToken($token)) {
    http_response_code(401);
    echo json_encode(array("message" => "Token no válido"));
    exit();
}

if ($method !== 'DELETE') {
    http_response_code(405);
    echo json_encode(array("message" => "Método no permitido"));
    exit();
}

$petId = $_GET['id'] ?? 0;

if (!$petId) {
    http_response_code(400);
    echo json_encode(array("message" => "ID de mascota requerido"));
    exit();
}

try {
    // Verificar que la mascota existe y obtener su información
    $checkQuery = "SELECT id, nombre, imagen FROM mascotas WHERE id = ?";
    $checkStmt = $conexion->prepare($checkQuery);
    $checkStmt->bind_param("i", $petId);
    $checkStmt->execute();
    $checkResult = $checkStmt->get_result();

    if ($checkResult->num_rows === 0) {
        http_response_code(404);
        echo json_encode(array("message" => "Mascota no encontrada"));
        exit();
    }

    $pet = $checkResult->fetch_assoc();
    $checkStmt->close();

    // Verificar si hay solicitudes de adopción pendientes para esta mascota
    $adoptionCheckQuery = "SELECT COUNT(*) as count FROM solicitudes_adopcion WHERE id_mascota = ? AND estado = 'pendiente'";
    $adoptionCheckStmt = $conexion->prepare($adoptionCheckQuery);
    $adoptionCheckStmt->bind_param("i", $petId);
    $adoptionCheckStmt->execute();
    $adoptionCheckResult = $adoptionCheckStmt->get_result();
    $pendingAdoptions = $adoptionCheckResult->fetch_assoc()['count'];
    $adoptionCheckStmt->close();

    if ($pendingAdoptions > 0) {
        http_response_code(400);
        echo json_encode(array(
            "message" => "No se puede eliminar la mascota porque tiene solicitudes de adopción pendientes",
            "pending_requests" => $pendingAdoptions
        ));
        exit();
    }

    // Iniciar transacción
    $conexion->autocommit(FALSE);

    // Eliminar solicitudes de adopción relacionadas (rechazadas/aprobadas)
    $deleteSolicitudesQuery = "DELETE FROM solicitudes_adopcion WHERE id_mascota = ?";
    $deleteSolicitudesStmt = $conexion->prepare($deleteSolicitudesQuery);
    $deleteSolicitudesStmt->bind_param("i", $petId);
    $deleteSolicitudesStmt->execute();
    $deleteSolicitudesStmt->close();

    // Eliminar la mascota
    $deletePetQuery = "DELETE FROM mascotas WHERE id = ?";
    $deletePetStmt = $conexion->prepare($deletePetQuery);
    $deletePetStmt->bind_param("i", $petId);
    $result = $deletePetStmt->execute();
    $affectedRows = $deletePetStmt->affected_rows;
    $deletePetStmt->close();

    if ($result && $affectedRows > 0) {
        // Eliminar imagen del servidor si existe y no es la imagen por defecto
        if ($pet['imagen'] && 
            $pet['imagen'] !== 'default-pet.png' &&
            file_exists('../img/' . $pet['imagen'])) {
            unlink('../img/' . $pet['imagen']);
        }

        // Confirmar transacción
        $conexion->commit();
        $conexion->autocommit(TRUE);

        http_response_code(200);
        echo json_encode(array(
            "message" => "Mascota eliminada correctamente",
            "success" => true,
            "deleted_pet" => $pet['nombre']
        ));
    } else {
        $conexion->rollback();
        $conexion->autocommit(TRUE);
        http_response_code(500);
        echo json_encode(array("message" => "Error al eliminar la mascota"));
    }

} catch (Exception $e) {
    // Rollback en caso de error
    if (isset($conexion)) {
        $conexion->rollback();
        $conexion->autocommit(TRUE);
    }
    
    http_response_code(500);
    echo json_encode(array(
        "message" => "Error interno del servidor",
        "error" => $e->getMessage()
    ));
}
?>