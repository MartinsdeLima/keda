<?php

if ($_SERVER['REQUEST_URI'] === '/ping') {
    echo "pong";
    exit;
}

echo "Hello from PHP!";