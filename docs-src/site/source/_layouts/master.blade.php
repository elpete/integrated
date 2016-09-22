<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta http-equiv="x-ua-compatible" content="ie=edge">

        <title>{{ isset($title) ? "Integrated — $title" : "Integrated" }}</title>

        @yield('styles')

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.5.1/themes/prism.min.css">
        <link rel="stylesheet" href="/css/main.css">
    </head>
    <body>
        <div class="container">
            @include('_partials.nav')

            @include('_partials.search')

            @include('_partials.menu', [ $page = isset($page) ? $page : '/' ])
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.5.1/prism.min.js"></script>
        @yield('scripts')
    </body>
</html>
