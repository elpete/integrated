<section class="section">
    <div class="container is-fullwidth">
        <label class="label title is-1" for="docsearch">Search documentation</label>
        <br />
        <p class="control">
          <input id="docsearch" class="input is-fullwidth is-large" type="text" placeholder="Search documentation — powered by Algolia" autofocus>
        </p>
    </div>
</section>

@section('styles')
    <link rel="stylesheet" href="//cdn.jsdelivr.net/docsearch.js/1/docsearch.min.css" />
@endsection

@section('scripts')
    <script type="text/javascript" src="//cdn.jsdelivr.net/docsearch.js/1/docsearch.min.js"></script>
    <script type="text/javascript">
        docsearch({
            apiKey: '<YOUR_API_KEY>',
            indexName: '<YOUR_INDEX_NAME>',
            inputSelector: '#docsearch'
        });
    </script>
@endsection