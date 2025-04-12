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
        <?php $current_view = isset($_GET['view']) ? $_GET['view'] : 'HOME'; ?>
        <ul class="vertical-nav-menu">
                <li class="app-sidebar__heading">Main</li>
                <li>
                    <a href="?view=HOME" class="<?= $current_view == 'HOME' ? 'mm-active' : '' ?>" style="text-decoration:none;">
                        <i class="fa fa-user-md"></i>
                        Dashboard
                    </a>
                </li>
                <li>
                    <a href="?view=HISTORY" class="<?= $current_view == 'HISTORY' ? 'mm-active' : '' ?>" style="text-decoration:none;">
                        <i class="fa fa-book"></i>
                        Appointment History
                    </a>
                </li>
                <li>
                    <a href="?view=BOOK" class="<?= $current_view == 'BOOK' ? 'mm-active' : '' ?>" style="text-decoration:none;">
                        <i class="fa fa-calendar"></i>
                        Book Appointment
                    </a>
                </li>
            </ul>
        </div>
    </div>
</div>