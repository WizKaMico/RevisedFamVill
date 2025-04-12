<div class="app-sidebar sidebar-shadow">
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
                    <i class="fa fa-tachometer"></i>
                    Dashboard
                </a>
            </li>
            <li>
                <a href="?view=BUSINESS" class="<?= $current_view == 'BUSINESS' ? 'mm-active' : '' ?>" style="text-decoration:none;">
                    <i class="fa fa-child"></i>
                    Business Management
                </a>
            </li>
            <li>
                <a href="?view=SERVICE" class="<?= $current_view == 'SERVICE' ? 'mm-active' : '' ?>" style="text-decoration:none;">
                    <i class="fa fa-suitcase"></i>
                    Services
                </a>
            </li>
            <li>
                <a href="?view=INQUIRY" class="<?= $current_view == 'INQUIRY' ? 'mm-active' : '' ?>" style="text-decoration:none;">
                    <i class="fa fa-info-circle"></i>
                    Inquiry
                </a>
            </li>
        </ul>

        <ul class="vertical-nav-menu">
            <li class="app-sidebar__heading">Support</li>
            <li>
                <a href="?view=SUPPORT" class="<?= $current_view == 'SUPPORT' ? 'mm-active' : '' ?>" style="text-decoration:none;">
                    <i class="fa fa-commenting"></i>
                    Ticket
                </a>
            </li>
        </ul>
        </div>
    </div>
</div>