stage { 'first':
    before => Stage['main'],
}

node default {

    class { 'system':
        stage => first
    }

    class { 'database':
        stage => main
    }

    class { 'backend':
        stage => main
    }
    ->
    class { 'webserver':
        stage => main
    }
    ->
    class { 'frontend':
        stage => main
    }
}
