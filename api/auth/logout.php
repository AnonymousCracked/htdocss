<?php
session_start();

// Destruir todas las variables de sesiÃ³n
$_SESSION = array();

// Destruir la cookie de sesiÃ³n si existe
if (ini_get("session.use_cookies")) {
    $params = session_get_cookie_params();
    setcookie(session_name(), '', time() - 42000,
        $params["path"], $params["domain"],
        $params["secure"], $params["httponly"]
    );
}

// Destruir la sesiÃ³n
session_destroy();

// Responder con Ã©xito
header('Content-Type: application/json');
echo json_encode(['success' => true, 'message' => 'SesiÃ³n cerrada correctamente']);
?>
