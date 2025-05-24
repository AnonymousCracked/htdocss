﻿<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

include_once '../config/conexion.php';

// FunciÃ³n para verificar token
function verifyToken($token) {
    if (empty($token)) {
        return false;
    }
    
    try {
        $tokenParts = explode('.', $token);
        if (count($tokenParts) !== 3) {
            return false;
        }
        
        $payload = json_decode(base64_decode($tokenParts[1]), true);
        
        if (!$payload || !isset($payload['id'])) {
            return false;
        }
        
        if (isset($payload['exp']) && time() > $payload['exp']) {
            return false;
        }
        
        return $payload;
        
    } catch (Exception $e) {
        return false;
    }
}

try {
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        http_response_code(405);
        echo json_encode(["success" => false, "message" => "MÃ©todo no permitido"]);
        exit();
    }

    // Verificar token
    $headers = getallheaders();
    $authHeader = $headers['Authorization'] ?? '';
    $token = '';
    
    if (strpos($authHeader, 'Bearer ') === 0) {
        $token = substr($authHeader, 7);
    }
    
    $tokenData = verifyToken($token);
    if (!$tokenData) {
        http_response_code(401);
        echo json_encode(["success" => false, "message" => "Token no vÃ¡lido"]);
        exit();
    }

    // Obtener ID de la solicitud
    $requestId = $_GET['id'] ?? 0;
    
    if (!$requestId || !is_numeric($requestId)) {
        http_response_code(400);
        echo json_encode(["success" => false, "message" => "ID de solicitud invÃ¡lido"]);
        exit();
    }

    // Iniciar transacciÃ³n
    $conexion->begin_transaction();

    try {
        // PASO 1: Obtener el ID de la mascota asociada a la solicitud
        $query = "SELECT id_mascota FROM solicitudes_adopcion WHERE id = ?";
        $stmt = $conexion->prepare($query);
        $stmt->bind_param("i", $requestId);
        $stmt->execute();
        $result = $stmt->get_result();
        
        if ($result->num_rows === 0) {
            throw new Exception("Solicitud no encontrada");
        }
        
        $row = $result->fetch_assoc();
        $mascotaId = $row['id_mascota'];

        // PASO 2: Actualizar estado de la solicitud a "aprobada"
        $query = "UPDATE solicitudes_adopcion SET estado = 'aprobada' WHERE id = ?";
        $stmt = $conexion->prepare($query);
        $stmt->bind_param("i", $requestId);
        
        if (!$stmt->execute()) {
            throw new Exception("Error al actualizar la solicitud");
        }
        
        if ($stmt->affected_rows === 0) {
            throw new Exception("No se encontrÃ³ la solicitud o ya estaba aprobada");
        }

        // PASO 3: Eliminar la mascota de la tabla mascotas
        $query = "DELETE FROM mascotas WHERE id = ?";
        $stmt = $conexion->prepare($query);
        $stmt->bind_param("i", $mascotaId);
        
        if (!$stmt->execute()) {
            throw new Exception("Error al eliminar la mascota");
        }

        // Confirmar transacciÃ³n
        $conexion->commit();
        
        echo json_encode([
            "success" => true, 
            "message" => "Solicitud aprobada correctamente y mascota eliminada del sistema",
            "mascota_eliminada" => $mascotaId
        ]);
        
    } catch (Exception $e) {
        // Revertir transacciÃ³n en caso de error
        $conexion->rollback();
        throw $e;
    }
    
} catch (Exception $e) {
    error_log("Error en approve_request.php: " . $e->getMessage());
    http_response_code(500);
    echo json_encode([
        "success" => false, 
        "message" => $e->getMessage()
    ]);
} finally {
    if (isset($conexion)) {
        $conexion->close();
    }
}
?>
