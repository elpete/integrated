component {
    
    function index( event, rc, prc ) {
        event.renderData( type = "json", data = [
            { id = 1, name = "First Post!", body = "The body of my first post." },
            { id = 2, name = "Second Post!", body = "The body of my second post." }
        ] );
    }

}