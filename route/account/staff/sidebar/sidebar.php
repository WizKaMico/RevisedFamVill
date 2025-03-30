<div class="app-sidebar sidebar-shadow <?php echo $accountSidebar[0]['theme']; ?>">
    <div class="app-header__logo">
        <img src="logo/main.png" class="logo-src" />
        <div class="header__pane ml-auto">
            <div>
                <button type="button" class="hamburger close-sidebar-btn hamburger--elastic"
                    data-class="closed-sidebar">
                    <span class="hamburger-box">
                        <span class="hamburger-inner"></span>
                    </span>
                </button>
            </div>
        </div>
    </div>
    <div class="app-header__mobile-menu">
        <div>
            <button type="button" class="hamburger hamburger--elastic mobile-toggle-nav">
                <span class="hamburger-box">
                    <span class="hamburger-inner"></span>
                </span>
            </button>
        </div>
    </div>
    <div class="app-header__menu">
        <span>
            <button type="button" class="btn-icon btn-icon-only btn btn-primary btn-sm mobile-toggle-header-nav">
                <span class="btn-icon-wrapper">
                    <i class="fa fa-ellipsis-v fa-w-6"></i>
                </span>
            </button>
        </span>
    </div>
    <div class="scrollbar-sidebar">
        <div class="app-sidebar__inner">
            <ul class="vertical-nav-menu">
                <li class="app-sidebar__heading">Main</li>
                <li>
                    <a href="?view=HOME" class="mm-active"  style="text-decoration:none;">
                        <i class="fa fa-tachometer"></i>
                        Dashboard
                    </a>
                </li>
                <li>
                    <a href="?view=PATIENT"  style="text-decoration:none;">
                       <i class="fa fa-child"></i>
                        Patient Management
                    </a>
                </li>
            </ul>
        </div>
    </div>
</div>