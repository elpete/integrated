<section class="section">
    <div class="container is-fullwidth">
        <label class="label title is-1" for="docsearch">Search documentation</label>
        <br />
        <p class="control">
          <input id="docsearch" class="input is-fullwidth is-large" type="text" placeholder="Search documentation — powered by Algolia" autofocus>
        </p>
    </div>
</section>

@section('scripts')
    <script type="text/javascript" src="https://cdn.jsdelivr.net/docsearch.js/2/docsearch.min.js"></script>
    <script type="text/javascript">
    docsearch({
      apiKey: '673e68d2a8d2ef74ea88683b1328684d',
      indexName: 'integrated',
      inputSelector: '#docsearch',
      debug: true
    });
    </script>
@endsection