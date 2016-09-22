<section class="section">
    <div class="columns">
        <div class="column is-3">
            <div class="column is-11">
                <aside class="menu">
                    <p class="menu-label">Assertion Methods</p>
                    <ul class="menu-list">
                        <li><a href="/see" class="{{ $page == '/see' ? 'is-active' : '' }}">see</a></li>
                        <li><a href="/dontSee" class="{{ $page == '/dontSee' ? 'is-active' : '' }}">dontSee</a></li>
                    </ul>
                </aside>
            </div>
        </div>

        <div class="column">
            @yield('content')
        </div>
    </div>
</section>