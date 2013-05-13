<?php
define( 'APP_PROFILE', 'sbb' );
define( 'APP_ROOT', dirname(__FILE__) . '/../feed/app/' );
include(APP_ROOT . 'inc/init.php');

if (isset($_GET['hms'])) {
    $hms = $_GET['hms'];
} else {
    $hms = date('H:i:s');
}

$vehicle_name = @$_GET['vehicle_name'];
$vehicle = Vehicles::vehicle_position_by_name_get($vehicle_name, $hms);

if ($vehicle) {
    $params = array(
        'vehicle_id' => $vehicle['id'],
        'x' => $vehicle['position']['x'],
        'y' => $vehicle['position']['y'],
        'hms' => $hms,
    );
    
    $extra_params_allowed = array('view_mode');
    foreach ($extra_params_allowed as $key) {
        if (isset($_GET[$key])) {
            $params[$key] = $_GET[$key];
        }
    }
} else {
    die($hms . ' Vehicle ' . $vehicle_name . ' is not running. Use hms=hh:mm:ss parameter if you want to force a given time.');
}

$url = $_SERVER['SCRIPT_NAME'];
$url = str_replace('/routes/vehicle.php', '/', $url);
$url .= '?' . http_build_query($params);
header('Location: ' . $url);