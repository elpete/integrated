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
                    <p class="menu-label">Interaction Methods</p>
                    <ul class="menu-list">
                        <li><a href="/visit" class="{{ $page == '/visit' ? 'is-active' : '' }}">visit</a></li></li>
                        <li><a href="/visitEvent" class="{{ $page == '/visitEvent' ? 'is-active' : '' }}">visitEvent</a></li></li>
                    </ul>
                </aside>
            </div>
        </div>

        <div class="column">
            @yield('content')
        </div>
    </div>
</section>